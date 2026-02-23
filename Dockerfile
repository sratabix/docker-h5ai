FROM debian:stable-slim AS build

ENV PHP_VERSION=8.5
ENV H5AI_VERSION=0.30.0

RUN set -xe \
    && apt update -yqq \
    && apt upgrade -yqq \
    && apt install -yqq --no-install-recommends \
        curl \
        unzip \
        ca-certificates \
        nginx \
        apache2-utils \
    # install php
    && curl -sSL https://packages.sury.org/php/README.txt | bash -x \
    && apt update -yqq \
    && apt install -yqq --no-install-recommends \
        php${PHP_VERSION}-fpm \
    && ln -s /run/php/php${PHP_VERSION}-fpm.sock /run/php/php-fpm.sock \
    # install h5ai
    && curl -fsSL -o /tmp/h5ai.zip https://github.com/lrsjng/h5ai/releases/download/v${H5AI_VERSION}/h5ai-${H5AI_VERSION}.zip \
    && unzip -q /tmp/h5ai.zip -d /tmp/ \
    && mkdir -p /app \
    && mv /tmp/_h5ai /app \
    && chown -R www-data:www-data /app \
    # cleanup
    && rm -rf /tmp/* \
    && apt purge -yqq --auto-remove curl unzip ca-certificates

# start fresh
FROM scratch AS runtime
COPY --from=build / /
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]