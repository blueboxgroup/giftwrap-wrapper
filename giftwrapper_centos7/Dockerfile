FROM centos:centos7
MAINTAINER Paul Czarkowski

VOLUME /pkg

RUN rpm -ivh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm && \
        rpm --import http://mirror.pnl.gov/epel/RPM-GPG-KEY-EPEL-7 && \
        yum makecache && \
        rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

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

RUN git config --global user.email "factory@giftwrap" && \
    git config --global user.name "Giftwrapper"

RUN gem install fpm --no-ri --no-rdoc

RUN pip install virtualenv

RUN git clone https://github.com/blueboxgroup/giftwrap.git /giftwrap && cd /giftwrap && python setup.py install

WORKDIR /pkg

CMD giftwrap build -m /tmp/manifest.yml
