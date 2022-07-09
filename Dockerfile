FROM alpine:3.14

LABEL maintainers="Vincent BESANCON <besancon.vincent@gmail.com>"

# TTRSS upstream commit reference
ARG TTRSS_COMMIT="f8fe5e0"

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Database connection
ENV \
    TTRSS_COMMIT=${TTRSS_COMMIT} \
    TTRSS_DB_HOST="database" \
    TTRSS_DB_NAME="ttrss" \
    TTRSS_DB_PASS="ttrss" \
    TTRSS_DB_PORT="5432" \
    TTRSS_DB_TYPE="pgsql" \
    TTRSS_DB_USER="ttrss" \
    TTRSS_DIGEST_SUBJECT="[rss] News headlines on last 24 hours" \
    TTRSS_PLUGINS="auth_internal,note,import_export" \
    TTRSS_SELF_URL_PATH="http://localhost:8000/" \
    TTRSS_SMTP_FROM_ADDRESS="noreply@mydomain.com" \
    TTRSS_SMTP_FROM_NAME="TT-RSS Feeds" \
    TTRSS_SMTP_LOGIN="" \
    TTRSS_SMTP_PASSWORD="" \
    TTRSS_SMTP_PORT="" \
    TTRSS_SMTP_SECURE="" \
    TTRSS_SMTP_SERVER=""

# Install directories
RUN mkdir -p /srv/ttrss /etc/nginx/ssl

# Install packages
RUN apk --update --no-cache add \
      ca-certificates~=20211220 \
      curl~=7 \
      gettext~=0.21 \
      git~=2.32 \
      libxslt~=1.1 \
      msmtp~=1.8 \
      netcat-openbsd~=1.130 \
      nginx~=1.20 \
      openssl~=1.1 \
      php8~=8.0 \
      php8-curl~=8.0 \
      php8-dom~=8.0 \
      php8-fileinfo~=8.0 \
      php8-fpm~=8.0 \
      php8-gd~=8.0 \
      php8-iconv~=8.0 \
      php8-intl~=8.0 \
      php8-mbstring~=8.0 \
      php8-mysqlnd~=8.0 \
      php8-opcache~=8.0 \
      php8-openssl~=8.0 \
      php8-pcntl~=8.0 \
      php8-pdo_mysql~=8.0 \
      php8-pdo_pgsql~=8.0 \
      php8-pgsql~=8.0 \
      php8-posix~=8.0 \
      php8-session~=8.0 \
      php8-tokenizer~=8.0 \
      php8-xsl~=8.0 \
      supervisor~=4.2 \
    && ln -sv /usr/bin/php8 /usr/bin/php \
    && git clone --branch master --depth 1 https://git.tt-rss.org/fox/tt-rss.git/ /srv/ttrss \
    && rm -rf /srv/ttrss/.git \
    && curl -SL \
        https://github.com/levito/tt-rss-feedly-theme/archive/master.tar.gz \
        | tar xzC /tmp \
          && cp -r /tmp/tt-rss-feedly-theme-master/feedly* /srv/ttrss/themes.local \
          && rm -rf /tmp/tt-rss-feedly-theme-master

# Install TT-RSS configuration
COPY ttrss/config.php /srv/ttrss/config.php

# Install msmtp client configuration template
COPY ttrss/msmtprc.tpl /var/tmp/msmtprc.tpl

# Fix permissions
RUN chown nginx:nginx -R /srv/ttrss

# Nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d/ttrss.conf /etc/nginx/http.d/ttrss.conf
RUN rm /etc/nginx/http.d/default.conf

# PHP / PHP-FPM configuration
COPY php8/php-fpm.d/*.conf /etc/php8/php-fpm.d/
COPY php8/conf.d/*.ini /etc/php8/conf.d/

# Listening ports
EXPOSE 80

# Persist data
VOLUME /srv/ttrss/cache /srv/ttrss/feed-icons

# Setup init
COPY supervisord.conf /supervisord.conf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
