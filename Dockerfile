####################################
# PHPDocker.io PHP 7.4 / FPM image #
####################################

FROM phpdockerio/php74-fpm

# Install FPM
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
    cron \
    unzip \
    git-core \
    ffmpeg \
    pdftk \
    imagemagick \
    ghostscript \
    php7.4-mysqli \
    php7.4-intl \
    php7.4-gd \
    php7.4-imagick \
    php7.4-memcache \
    && apt-get install -y locales locales-all \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

#    php-imagick \
# PHP-FPM packages need a nudge to make them docker-friendly
COPY overrides.conf /etc/php/7.4/fpm/pool.d/z-overrides.conf

# PHP-FPM has really dirty logs, certainly not good for dockerising
# The following startup script contains some magic to clean these up
COPY php-fpm-startup /usr/bin/php-fpm
CMD /usr/bin/php-fpm

# Open up fcgi port
EXPOSE 9000
