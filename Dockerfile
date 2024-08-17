FROM alpine:3.18

LABEL maintainers="Vincent BESANCON <besancon.vincent@gmail.com>"

# TTRSS upstream commit reference
ARG TTRSS_COMMIT="b8cbb16"

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
    TTRSS_PHP_EXECUTABLE="/usr/bin/php82" \
    TTRSS_PLUGINS="auth_internal,note,import_export" \
    TTRSS_SELF_URL_PATH="http://localhost:8000/" \
    TTRSS_SMTP_FROM_ADDRESS="noreply@mydomain.com" \
    TTRSS_SMTP_FROM_NAME="TT-RSS Feeds" \
    TTRSS_SMTP_LOGIN="" \
    TTRSS_SMTP_PASSWORD="" \
    TTRSS_SMTP_PORT="" \
    TTRSS_SMTP_SECURE="" \
    TTRSS_SMTP_SERVER=""

# As there is a weekly auto-update, we do not pin packages here to reduce
# maintenance overhead.
# hadolint ignore=DL3018
RUN echo "➔ Installing system packages..." \
    && apk --update --no-cache add \
      ca-certificates \
      curl \
      gettext \
      git \
      libxslt \
      msmtp \
      netcat-openbsd \
      nginx \
      openssl \
      php82 \
      php82-ctype \
      php82-curl \
      php82-dom \
      php82-fileinfo \
      php82-fpm \
      php82-gd \
      php82-iconv \
      php82-intl \
      php82-mbstring \
      php82-mysqlnd \
      php82-opcache \
      php82-openssl \
      php82-pcntl \
      php82-pdo_mysql \
      php82-pdo_pgsql \
      php82-pgsql \
      php82-posix \
      php82-session \
      php82-tokenizer \
      php82-xsl \
      supervisor \
    && echo "✔️ Successfully installed system packages. Done."

ARG _tmp_dir="/tmp/ttrss"

RUN echo "➔ Creating important directories..." \
    && mkdir -v "${_tmp_dir}" \
    && mkdir -p /srv/ttrss /etc/nginx/ssl \
    && echo "✔️ Successfully created important directories. Done." \
    \
    && echo "➔ Installing TT-RSS..." \
    && git clone --branch master --depth 1 https://git.tt-rss.org/fox/tt-rss.git/ /srv/ttrss \
    && rm -rf /srv/ttrss/.git \
    && echo "✔️ Successfully installed TT-RSS. Done." \
    \
    && echo "➔ Installing Feedly theme..." \
    && _local_theme_dir="/srv/ttrss/themes" \
    && curl -SL \
      https://github.com/levito/tt-rss-feedly-theme/archive/master.tar.gz \
      | tar xzC "${_tmp_dir}" \
        && cp -r "${_tmp_dir}"/tt-rss-feedly-theme-master/feedly* "${_local_theme_dir}" \
    && echo "✔️ Successfully installed Feedly theme. Done." \
    \
    && echo "➔ Installing Mercury plugin..." \
    && _mercury_fulltext_dir="/srv/ttrss/plugins/mercury_fulltext" \
    && mkdir -v "${_mercury_fulltext_dir}" \
    && curl -SL \
        https://github.com/HenryQW/mercury_fulltext/archive/master.tar.gz \
        | tar xzC "${_tmp_dir}" \
          && cp -r "${_tmp_dir}"/mercury_fulltext-master/init.* "${_mercury_fulltext_dir}" \
    && echo "✔️ Successfully installed Mercury plugin. Done." \
    \
    && echo "➔ Cleaning temporary files..." \
    && rm -rf "${_tmp_dir}" \
    && echo "✔️ Successfully cleaned temporary files. Done."

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
COPY php82/php-fpm.d/*.conf /etc/php82/php-fpm.d/
COPY php82/conf.d/*.ini /etc/php82/conf.d/

# Listening ports
EXPOSE 80

# Persist data
VOLUME ["/srv/ttrss/cache", "/srv/ttrss/feed-icons", "/srv/ttrss/plugins.local", "/srv/ttrss/themes.local"]

# Setup init
COPY supervisord.conf /supervisord.conf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
