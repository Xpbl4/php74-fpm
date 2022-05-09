PHP 7.4 / FPM container image
=============================================

Ubuntu 16.04 PHP 7.4 FPM image based on container for [PHPDocker.io](http://phpdocker.io) projects. Packages are provided by [Ondřej Surý](https://deb.sury.org/).

Smaller in size than PHP's official container (170MB vs 501MB) plus you don't need to install any build dependencies let alone compile anything, Dotdeb already ship binaries for the vast majority, if not all, of PHP extensions available on PHP7.

PHP extensions:
**php-apcu,
php7.4-curl,
php7.4-gd,
php7.4-imagick,
php7.4-intl,
php7.4-json,
php7.4-mbstring,
php7.4-mysqli,
php7.4-opcache,
php7.4-readline**

Extras:
**Composer, Cron**

*Crontab:* you can use `/etc/cron.d/crontab` for cron jobs.
You can also direct the output of the individual cronjobs to their own logs for better readability, you will just need to append the output of date somewhere.
`0 15 * * * root /app/daily-backup.sh >> /var/log/daily-backup.log 2>&1`

*Note on logging:* configure your application to stream logs into `php://stdout`. That's it. We do some trickery to remove FPM's `[pool www] child xxx said into stderr` messages from stdout when an app outputs to it. 
