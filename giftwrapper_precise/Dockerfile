FROM ubuntu:precise
MAINTAINER Paul Czarkowski

VOLUME /pkg
RUN apt-get update && apt-get install -y \
    git \
    curl \
    vim \
    build-essential \
    ruby1.9.1-full \
    libffi-dev \
    libxslt-dev \
    libxml2-dev \
    python-dev \
    python-pip \
    libmysqlclient-dev \
    libpq-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git config --global user.email "packager@myco" && \
    git config --global user.name "Omnibus Packager"

RUN gem install fpm --no-ri --no-rdoc

RUN pip install virtualenv

RUN git clone https://github.com/blueboxgroup/giftwrap.git /giftwrap && cd /giftwrap && python setup.py install

WORKDIR /pkg

CMD giftwrap build -m /tmp/manifest.yml
