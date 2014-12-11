# Giftwrap Wrapper

## About

Giftwrap Wrapper is a docker based build factory for openstack packages.   It uses [Giftwrap](https://github.com/blueboxgroup/giftwrap) to build a collection packages or docker images for your selected platforms.


## General Usage

To try and keep it simple everything is handled by the included `Makefile` ( boy I don't miss the days of having to write makefiles ).

Making a Package is a two step process, first you have to make the Docker factory for your chosen platform ( It is likely we'll put prebuilt factories up on the docker hub) and then you make the packages themselves.   Really basic example use would be `make platform && make image`.

The Makefile can accept the following arguments in the form of `make <action> [arg=value]`:

* platform=precise
* pkg=/non/relative/path/where/you/want/packages/to/appear
* manifest=/none/relative/path/to/manifest-file.yml

These can also be altered, but shouldn't need to be:

* DOCKER=docker  ( your docker command and any base options e.g. --tls )
* DOCKER_OPTS=  ( any options to pass to the docker command.  e.g. --no-cache )
* REPO=bluebox ( the base docker repo to build with.  result would be bluebox/giftwrapper_centos6 )
* SUBDIRS=giftwrapper_centos6 giftwrapper_precise giftwrapper_trusty ( list of dirs containing platform Dockerfiles to build out the factories)

### Platform

Platform attempts to create a docker based build system for your chosen platform.  You invoke it by running `make platform platform=[precise|trusty|centos6]` or by running `make platforms` to create build systems for all supported platforms.   Platform will default to `precise` if not specified.

### Packages

You need a `giftwrap` style manifest file as well as docker images built by the `make platform` commands.  You can find an example manifest at `./manifest-package.yml` this tells giftwrap what openstack projects you wish to be packaged.

you can run `make packages manifest=/path/to/manifest.yml` to make packages for all platforms, or you can specify with `make package platform=[precise|trusty|centos6] manifest=/path/to/manifest.yml`. The packages will be saved int `./pkg` unless you set the `pkg=/path/to/packages` argument.

### Images

You can make docker images by running `make image`.   This will run docker and mount in the host's docker socket so that the resultant image is available on the host system and the factory can be destroyed.


## Examples

### Ubuntu Precise Package

The following will launch a vagrant environment with docker installed and will create an installable .deb package in `pkg/` from the example giftwrap manifest provided in this repo for Ubuntu Precise:

```
$ vagrant up
$ cd /vagrant
$ make platform platform=precise
docker build --rm -t giftwrapper/precise precise
Sending build context to Docker daemon 3.072 kB
Sending build context to Docker daemon
...
...
 ---> Using cache
 ---> 1a6197ce2712
Successfully built 1a6197ce2712
$ make package platform=precise manifest=/vagrant/manifest-package.yml
docker run -t --rm -v /vagrant/manifest-package.yml:/tmp/manifest-package.yml -v /vagrant/pkg:/pkg giftwrapper/precise giftwrap build -m /tmp/manifest-package.yml
2014-12-11 05:16:56 giftwrap.builders.package_builder INFO: Beginning to build 'python-glanceclient'
...
...
glanceclient-1.0 -v 1.0  opt/giftwrap/openstack-1.0/python-glanceclient'
$ ls pkg/
openstack-python-glanceclient-1.0_1.0_amd64.deb
```

### Docker Image

The following will create a docker image for the example giftwrap manifest ( manifest-image.yml ) provided in this repo:

```
$ make image  manifest=/vagrant/manifest-image.yml
docker run  --rm -t -v /var/run/docker.sock:/var/run/docker.sock -v /vagrant/manifest-image.yml:/tmp/manifest-image.yml  bluebox/giftwrap giftwrap build -m /tmp/manifest-image.yml
2014-12-11 16:43:11 giftwrap.builders.docker_builder INFO: {"status":"The image you are pulling has been verified","id":"ubuntu:12.04"}


```

## Credits
This was inspired by @lusis' [Omnibus Build Lab](https://github.com/dcm-oss/docker-omnibus-templates) which was inspired by the [Flapjack project which said they got the toolchain idea from @lusis so who knows.](http://flapjack.io/docs/1.0/development/Omnibus-In-Your-Docker/)
