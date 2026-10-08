PHP 7.4 / FPM container image
=============================================

PHP 7.4 FPM on the official `php:7.4-fpm-alpine3.16` image, for amd64 and arm64: `xpbl4/php74-fpm:alpine`.

PHP extensions:
**apcu,
calendar,
curl,
exif,
ffi,
gd,
gettext,
imagick,
intl,
mbstring,
memcache,
mysqli,
opcache,
pcntl,
pdo_mysql,
shmop,
sockets,
sysvmsg, sysvsem, sysvshm,
xsl,
zip**

Extras:
**Cron (cronie), ImageMagick tools (`magick`, `convert`, `montage`, `mogrify`), bash, GNU sed, tzdata**

The paths are the ones of the Ubuntu packages, so the projects mount the same files:

* `/usr/sbin/php-fpm7.4`, `/usr/bin/php`, `/usr/sbin/cron`;
* ini files in `/etc/php/7.4/fpm/conf.d` (FPM) and `/etc/php/7.4/cli/conf.d` (CLI), extra pool files in `/etc/php/7.4/fpm/pool.d`;
* `www-data` with uid/gid 33, so the files written by the projects keep their owner;
* `php.ini` is `php.ini-production`.

*Crontab:* cronie reads `/etc/cron.d` files with a user column, like Debian cron.
`0 15 * * * root /app/daily-backup.sh >> /var/log/daily-backup.log 2>&1`

*Note on logging:* configure your application to stream logs into `php://stdout`. The startup script removes FPM's `[pool www] child xxx said into stderr` decoration.

Differences from the earlier Ubuntu image to keep in mind:

* no FFmpeg, pdftk, GhostScript, Python with pypdf, git or `locales-all`; the ASSE projects that need them use `asse/php74-fpm`;
* musl has no locale data: `setlocale()` works, but `strftime('%b')` and other localized names come out in English;
* ImageMagick is version 7 (Ubuntu ships 6): the `magick` command, `convert` still works.

Build for this machine:

```sh
docker build -t xpbl4/php74-fpm:alpine .
```

Publishing
=============================================

GitHub Actions (`.github/workflows/docker.yml`) lints the Dockerfile and builds the image for every pull request. A push to `master` publishes `xpbl4/php74-fpm:alpine` and `:alpine-<sha>` for amd64 and arm64 (arm64 is built under QEMU and takes longer).

`xpbl4/php74-fpm:latest` is still the last Ubuntu build, which the ASSE projects pull. Once they run on `asse/php74-fpm`, `:latest` becomes the Alpine build.

The repository needs the `DOCKERHUB_TOKEN` secret (a Docker Hub access token) and the `DOCKERHUB_USERNAME` variable (defaults to `xpbl4`).
