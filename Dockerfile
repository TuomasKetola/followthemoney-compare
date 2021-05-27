FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive

# build-essential 
RUN apt-get -qq -y update \
    && apt-get -qq -y install \
        locales \
        ca-certificates \
        curl \
        python3-pip \
        pkgconf \
        libicu-dev \
        libffi-dev \
        jq \
    && apt-get -qq -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && groupadd -g 1000 -r app \
    && useradd -m -u 1000 -s /bin/false -g app app

ENV LANG='en_US.UTF-8'

RUN pip3 install -q --no-cache-dir -U pip setuptools six psycopg2-binary gsutil
COPY . /opt/followthemoney-compare
RUN pip3 install -q --no-cache-dir -e /opt/followthemoney-compare
WORKDIR /opt/followthemoney-compare

CMD followthemoney-compare
