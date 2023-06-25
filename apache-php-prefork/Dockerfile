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
    dpkg-reconfigure locales && \
    a2enmod rewrite headers && \
    a2disconf serve-cgi-bin && \

# TODO: revisar si las configs de apache se pueden reducir (para no tener que copiar lo que pone en docker-base)

# ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
COPY --from=mlocati/php-extension-installer:2.1.30 /usr/bin/install-php-extensions /usr/local/bin/

COPY docker/common/conf-available/* /etc/apache2/conf-available/
COPY docker/common/mods-available/* /etc/apache2/mods-available/

COPY [  "docker/common/entrypoint.sh", \
        "docker/common/common_entrypoint_extension.sh", \
        "docker/common/apache2/sites-available/000-default.conf.template", \
        "docker/common/php.ini.template", \
        "/inoro/common/"]

RUN chgrp -R 0 /inoro && \
    chmod -R g=u /inoro
    
ENTRYPOINT [ "/inoro/common/entrypoint.sh" ]

### PROD #######################################################################
FROM common AS prod
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY docker/prod/entrypoint_extension.sh /inoro/entrypoint_extension.sh
COPY --from=composer-builder /app /var/www/html

### DEV ########################################################################
FROM common AS dev
COPY docker/dev/entrypoint_extension.sh /inoro/entrypoint_extension.sh
VOLUME /var/www/html
