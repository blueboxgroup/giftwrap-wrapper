FROM ubuntu:trusty
MAINTAINER Paul Czarkowski

VOLUME /pkg
RUN apt-get update && apt-get install -y \
    git \
    curl \
    vim \
    build-essential \
    ruby-dev \
    libffi-dev \
    libxslt-dev \
    libxml2-dev \
    python-dev \
    python-pip \
    libmysqlclient-dev \
    libpq-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git config --global user.email "packager@giftwrap" && \
    git config --global user.name "Giftwrapper"

RUN gem install fpm --no-ri --no-rdoc

RUN pip install virtualenv

RUN git clone https://github.com/blueboxgroup/giftwrap.git /giftwrap && cd /giftwrap && python setup.py install

WORKDIR /pkg

CMD giftwrap build -m /giftwrap/manifest.yml
