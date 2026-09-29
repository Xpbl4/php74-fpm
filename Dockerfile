FROM ubuntu:22.04

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        software-properties-common \
    && LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        cron \
        unzip \
        git-core \
        ffmpeg \
        pdftk \
        imagemagick \
        ghostscript \
        locales \
        locales-all \
        python3 \
        python3-pip \
        php7.4-fpm \
        php7.4-cli \
        php7.4-common \
        php7.4-mysql \
        php7.4-intl \
        php7.4-gd \
        php7.4-imagick \
        php7.4-memcache \
        php7.4-curl \
        php7.4-mbstring \
        php7.4-xml \
        php7.4-zip \
    && python3 -m pip install --no-cache-dir pypdf==5.9.0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

COPY overrides.conf /etc/php/7.4/fpm/pool.d/z-overrides.conf
COPY php-fpm-startup /usr/bin/php-fpm

CMD ["/usr/bin/php-fpm"]

EXPOSE 9000