FROM centos:centos6
MAINTAINER Paul Czarkowski

VOLUME /pkg

RUN rpm -ivh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum install -y centos-release-SCL

RUN yum install -y \
    git \
    curl \
    vim \
    rpm-build \
    autoconf gcc gcc-c++ make \
    ruby-devel \
    rubygems \
    libffi-devel \
    libxslt-devel \
    libxml2-devel \
    python-devel \
    python-pip \
    mysql-devel mysql-libs \
    postgresql-libs postgresql-devel && \
    yum clean all

RUN git config --global user.email "packager@myco" && \
    git config --global user.name "Omnibus Packager"

RUN gem install fpm --no-ri --no-rdoc

RUN pip install virtualenv

RUN git clone https://github.com/blueboxgroup/giftwrap.git /giftwrap && cd /giftwrap && python setup.py install

WORKDIR /pkg

CMD giftwrap build -m /tmp/manifest.yml
