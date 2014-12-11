mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

# You shouldn't need to override these, but you can:
SUBDIRS = giftwrapper_centos6 giftwrapper_precise giftwrapper_trusty
REPO = bluebox
DOCKER = docker
DOCKER_OPTS =

# You probably want to override these:
platform = precise
pkg = $(current_dir)/pkg
manifest = $(current_dir)/manifest-package.yml
manifest_file = $(notdir $(manifest))


.PHONY: subdirs $(SUBDIRS)
subdirs: $(SUBDIRS)

.PHONY: platforms
platforms:
	for dir in $(SUBDIRS); do \
	  $(DOCKER) build $(DOCKER_OPTS) --rm -t $(REPO)/$$dir $$dir; \
	done

.PHONY: platform
platform:
	$(DOCKER) build $(DOCKER_OPTS) --rm -t $(REPO)/giftwrapper_$(platform) giftwrapper_$(platform)

.PHONY: packages
packages:
	for dir in $(SUBDIRS); do \
		$(DOCKER) run $(DOCKER_OPTS) -t --rm -v $(manifest):/tmp/$(manifest_file) -v $(pkg):/pkg $(REPO)/$$dir giftwrap build -m /tmp/$(manifest_file)
	done

.PHONY: package
package:
	$(DOCKER) run $(DOCKER_OPTS) -t --rm -v $(manifest):/tmp/$(manifest_file) -v $(pkg):/pkg $(REPO)/giftwrapper_$(platform) giftwrap build -m /tmp/$(manifest_file)

.PHONY: image
image:
	$(DOCKER) run $(DOCKER_OPTS) --rm -t -v /var/run/docker.sock:/var/run/docker.sock -v $(manifest):/tmp/$(manifest_file)  bluebox/giftwrap giftwrap build -m /tmp/$(manifest_file)

.PHONY: all
all:
	platforms
	images
