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
php7.4-memcache,
php7.4-opcache,
php7.4-readline**

Extras:
**Composer, Cron, FFmpeg, GhostScript**

*Crontab:* you can use `/etc/cron.d/crontab` for cron jobs.
You can also direct the output of the individual cronjobs to their own logs for better readability, you will just need to append the output of date somewhere.
`0 15 * * * root /app/daily-backup.sh >> /var/log/daily-backup.log 2>&1`

*Note on logging:* configure your application to stream logs into `php://stdout`. That's it. We do some trickery to remove FPM's `[pool www] child xxx said into stderr` messages from stdout when an app outputs to it. 

Alpine variant: `xpbl4/php74-fpm:alpine`
=============================================

`Dockerfile.alpine` builds the same PHP 7.4 FPM on the official `php:7.4-fpm-alpine3.16` image, for amd64 and arm64. It has the same PHP modules as the Ubuntu image, and the projects can switch to it without changes:

* the Ubuntu paths: `/usr/sbin/php-fpm7.4`, `/usr/bin/php`, `/usr/sbin/cron`, ini files mounted into `/etc/php/7.4/fpm/conf.d` (FPM) and `/etc/php/7.4/cli/conf.d` (CLI), extra pool files in `/etc/php/7.4/fpm/pool.d`;
* `www-data` with uid/gid 33, as in Ubuntu, so the files written by the projects keep their owner;
* cron is cronie: it reads `/etc/cron.d` files with a user column, like Debian cron;
* bash, GNU sed, tzdata and the ImageMagick tools (`magick`, `convert`); the same startup script and FPM overrides;
* `php.ini` is `php.ini-production`, as in the Ubuntu packages.

Not included: FFmpeg, pdftk, GhostScript, Python with pypdf, git, unzip and `locales-all`; projects that need them stay on `:latest`. Differences to keep in mind:

* musl has no locale data: `setlocale()` works, but `strftime('%b')` and other localized names come out in English;
* ImageMagick is version 7 (Ubuntu ships 6): the `magick` command, `convert` still works; without GhostScript ImageMagick cannot read PDF or PostScript.

Build for this machine:

```sh
docker build -f Dockerfile.alpine -t xpbl4/php74-fpm:alpine .
```

Publishing
=============================================

GitHub Actions (`.github/workflows/docker.yml`) lints both Dockerfiles and builds both images for every pull request. A push to `master` publishes them to Docker Hub:

* `xpbl4/php74-fpm:latest` and `:ubuntu-<sha>` from `Dockerfile`, amd64 only, as before;
* `xpbl4/php74-fpm:alpine` and `:alpine-<sha>` from `Dockerfile.alpine`, for amd64 and arm64 (arm64 is built under QEMU and takes longer).

The repository needs the `DOCKERHUB_TOKEN` secret (a Docker Hub access token); `DOCKERHUB_USERNAME` is optional and defaults to `xpbl4`.
