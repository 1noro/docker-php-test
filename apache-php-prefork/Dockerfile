### BASE #######################################################################
FROM php:8.1-apache-bookworm AS base
ENV HOLA=true

### MULTISTAGE-UTILS ###########################################################
FROM composer:2.5 AS composer-builder
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_MIRROR_PATH_REPOS=1
COPY app /app
RUN composer install \
        --no-ansi \
        --no-dev \
        --no-interaction \
        --no-progress \
        --no-scripts \
        --classmap-authoritative && \
    chgrp -R 0 /app && \
    chmod -R g=u /app

### COMMON #####################################################################
FROM base AS common
ENV LANG=en_US.UTF-8

RUN apt update && \
    apt install -y --no-install-recommends \
        curl \
        locales && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales

# ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
COPY --from=mlocati/php-extension-installer:2.1.30 /usr/bin/install-php-extensions /usr/local/bin/

# COPY docker/common/apache2/conf-available/* /etc/apache2/conf-available/
# COPY docker/common/apache2/mods-available/* /etc/apache2/mods-available/
# COPY docker/common/apache2/sites-available/* /etc/apache2/sites-available/
COPY docker/common/apache2/ /etc/apache2/

COPY [  "docker/common/entrypoint.sh", \
        "docker/common/common_entrypoint_extension.sh", \
        "/inoro/common/"]

RUN a2enmod rewrite headers && \
    a2disconf serve-cgi-bin && \
    a2enconf inoro-security && \
    chgrp -R 0 /inoro && \
    chmod -R g=u /inoro

# HEALTHCHECK --interval=5s --timeout=3s --start-period=5s --retries=3 \
#     CMD curl -f http://localhost/ || exit 1

ENTRYPOINT [ "/inoro/common/entrypoint.sh" ]

### PROD #######################################################################
FROM common AS prod
COPY docker/prod/entrypoint_extension.sh /inoro/entrypoint_extension.sh
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY --from=composer-builder /app /var/www/html

### DEV ########################################################################
FROM common AS dev
COPY docker/dev/entrypoint_extension.sh /inoro/entrypoint_extension.sh
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
VOLUME /var/www/html
