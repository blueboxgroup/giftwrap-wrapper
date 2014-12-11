SUBDIRS = centos6 precise trusty
REPO = giftwrapper
DOCKER = docker
DOCKER_BUILD = $(DOCKER) build --rm -t $(REPO)/

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

platform = precise
pkg = $(current_dir)/pkg
manifest = $(current_dir)/manifest-example.yml

manifest_file = $(notdir $(manifest))


.PHONY: subdirs $(SUBDIRS)
subdirs: $(SUBDIRS)

.PHONY: platforms
platforms:
		for dir in $(SUBDIRS); do \
		 $(DOCKER_BUILD)$$dir $$dir; \
		done

.PHONY: platform
platform:
	$(DOCKER_BUILD)$(platform) $(platform)

.PHONY: packages
packages:
		for dir in $(SUBDIRS); do \
		$(DOCKER) run -t --rm -v $(manifest):/tmp/$(manifest_file) -v $(pkg):/pkg $(REPO)/$$dir giftwrap build -m /tmp/$(manifest_file)
		 $(DOCKER_BUILD)$$dir $$dir; \
		done

.PHONY: package
package:
	$(DOCKER) run -t --rm -v $(manifest):/tmp/$(manifest_file) -v $(pkg):/pkg $(REPO)/$(platform) giftwrap build -m /tmp/$(manifest_file)
