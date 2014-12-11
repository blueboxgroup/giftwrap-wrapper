# Giftwrap Wrapper

## About

There are two steps in building packages:

### Platform

Platform attempts to create a docker based build system for your chosen platform.  You invoke it by running `make platform platform=[precise|trusty|centos6]` or by running `make platforms` to create build systems for all supported platforms.   Platform will default to `precise` if not specified.

### Packages

You need a `giftwrap` style manifest file as well as docker images built by the `make platform` commands.  You can find an example manifest at `./manifest-example.yml` this tells giftwrap what openstack projects you wish to be packaged.

you can run `make packages manifest=/path/to/manifest.yml` to make packages for all platforms, or you can specify with `make package platform=[precise|trusty|centos6] manifest=/path/to/manifest.yml`. The packages will be saved int `./pkg` unless you set the `pkg=/path/to/packages` argument.


## Usage

The following will launch a vagrant environment with docker installed and will create an installable debian package in `pkg/` from the example giftwrap manifest provided in this repo for Ubuntu Precise:

```
$ vagrant up
$ cd /vagrant
$ make platform
docker build --rm -t giftwrapper/precise precise
Sending build context to Docker daemon 3.072 kB
Sending build context to Docker daemon
Step 0 : FROM ubuntu:precise
 ---> 58c0a77963ea
Step 1 : MAINTAINER Paul Czarkowski
 ---> Using cache
 ---> 39d3b8d8831c
Step 2 : VOLUME /pkg
 ---> Using cache
 ---> 6713a193f668
Step 3 : RUN apt-get update && apt-get install -y     git     curl     vim     build-essential     ruby1.9.1-full     libffi-dev     libxslt-dev     libxml2-dev     python-dev     python-pip     libmysqlclient-dev     libpq-dev &&     apt-get clean &&     rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
 ---> Using cache
 ---> 73ac4af3cc6b
Step 4 : RUN git config --global user.email "packager@myco" &&     git config --global user.name "Omnibus Packager"
 ---> Using cache
 ---> 5537e3533804
Step 5 : RUN gem install fpm --no-ri --no-rdoc
 ---> Using cache
 ---> 73d27590769d
Step 6 : RUN pip install virtualenv
 ---> Using cache
 ---> 2fde297e021e
Step 7 : RUN git clone https://github.com/blueboxgroup/giftwrap.git /giftwrap && cd /giftwrap && python setup.py install
 ---> Using cache
 ---> 4aa890a8a7c3
Step 8 : WORKDIR /pkg
 ---> Using cache
 ---> e844dc61763c
Step 9 : CMD giftwrap build -m /tmp/manifest.yml
 ---> Using cache
 ---> 1a6197ce2712
Successfully built 1a6197ce2712
$ make package
docker run -t --rm -v /vagrant/manifest-example.yml:/tmp/manifest-example.yml -v /vagrant/pkg:/pkg giftwrapper/precise giftwrap build -m /tmp/manifest-example.yml
2014-12-11 05:16:56 giftwrap.builders.package_builder INFO: Beginning to build 'python-glanceclient'
2014-12-11 05:16:56 giftwrap.builders.package_builder INFO: Fetching source code for 'python-glanceclient'
2014-12-11 05:16:58 giftwrap.builders.package_builder INFO: Creating the virtualenv for 'python-glanceclient'
2014-12-11 05:16:58 giftwrap.util INFO: Running: 'virtualenv .'
2014-12-11 05:16:59 giftwrap.builders.package_builder INFO: Installing 'python-glanceclient' to the virtualenv
2014-12-11 05:16:59 giftwrap.util INFO: Running: '/tmp/giftwrap5MRum0/build/opt/giftwrap/openstack-1.0/python-glanceclient/bin/pip install '
2014-12-11 05:16:59 giftwrap.builders.package_builder INFO: Installing 'python-glanceclient' pip dependencies to the virtualenv
2014-12-11 05:16:59 requests.packages.urllib3.connectionpool INFO: Starting new HTTPS connection (1): review.openstack.org
2014-12-11 05:17:00 requests.packages.urllib3.connectionpool INFO: Starting new HTTP connection (1): logs.openstack.org
2014-12-11 05:17:00 requests.packages.urllib3.connectionpool INFO: Starting new HTTP connection (1): logs.openstack.org
2014-12-11 05:17:00 giftwrap.util INFO: Running: './bin/pip install Babel==1.3 Jinja2==2.7.3 MarkupSafe==0.23 Pygments==2.0.1 Sphinx==1.2.3 argparse==1.2.1 cffi==0.8.6 coverage==3.7.1 cryptography==0.6.1 discover==0.4.0 docutils==0.12 extras==0.0.3 fixtures==1.0.0 flake8==2.0 hacking==0.8.1 iso8601==0.1.10 jsonpatch==1.9 jsonpointer==1.6 jsonschema==2.4.0 mccabe==0.2.1 mock==1.0.1 mox3==0.7.0 netaddr==0.7.12 netifaces==0.10.4 oslosphinx==2.3.0 pbr==0.10.0 pep8==1.4.5 prettytable==0.7.2 pyOpenSSL==0.14 pycparser==2.10 pyflakes==0.7.3 python-keystoneclient==0.11.2 python-mimeparse==0.1.4 python-subunit==1.0.0 pytz==2014.10 requests==2.5.0 six==1.8.0 stevedore==1.1.0 testrepository==0.0.20 testtools==1.5.0 unittest2==0.8.0 warlock==1.1.0 wsgiref==0.1.2'
2014-12-11 05:18:03 giftwrap.util INFO: Running: '/tmp/giftwrap5MRum0/build/opt/giftwrap/openstack-1.0/python-glanceclient/bin/python setup.py install'
2014-12-11 05:18:04 giftwrap.util INFO: Running: '/tmp/giftwrap5MRum0/build/opt/giftwrap/openstack-1.0/python-glanceclient/bin/pip install pbr'
2014-12-11 05:18:04 giftwrap.util INFO: Running: 'fpm  -s dir -t deb -n openstack-python-glanceclient-1.0 -v 1.0  opt/giftwrap/openstack-1.0/python-glanceclient'
```

## Credits
This was inspired by @lusis' [Omnibus Build Lab](https://github.com/dcm-oss/docker-omnibus-templates) which was inspired by the [Flapjack project which said they got the toolchain idea from @lusis so who knows.](http://flapjack.io/docs/1.0/development/Omnibus-In-Your-Docker/)
