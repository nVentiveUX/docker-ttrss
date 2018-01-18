FROM alpine:3.7

LABEL maintainers="Vincent BESANCON <besancon.vincent@gmail.com>"

# TTRSS upstream commit reference
ARG TTRSS_COMMIT="master"

# SSL self-signed certificate
ENV TTRSS_SELF_CERT_CN="localhost"
ENV TTRSS_SELF_CERT_ORG="Grenouille Inc."
ENV TTRSS_SELF_CERT_COUNTRY="FR"

# Install directories
RUN mkdir -p /srv/ttrss /etc/nginx/ssl

# Dependencies
RUN set -x \
      && apk --no-cache add \
        ca-certificates \
        supervisor      \
        git             \
        curl            \
        nginx           \
        openssl         \
        php7            \
        php7-curl       \
        php7-dom        \
        php7-fileinfo   \
        php7-fpm        \
        php7-gd         \
        php7-iconv      \
        php7-intl       \
        php7-json       \
        php7-mbstring   \
        php7-pcntl      \
        php7-pdo_pgsql  \
        php7-pgsql      \
        php7-posix      \
        php7-session    \
      && curl -SL \
            https://git.tt-rss.org/git/tt-rss/archive/${TTRSS_COMMIT}.tar.gz \
            | tar xzC /srv/ttrss --strip-components 1

# Fix permissions
RUN chown nginx:nginx -R /srv/ttrss

# Nginx configuration
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/conf.d/ttrss.conf /etc/nginx/conf.d/ttrss.conf
RUN rm /etc/nginx/conf.d/default.conf

# PHP-FPM configuration
ADD php7/php-fpm.d/www.conf /etc/php7/php-fpm.d/www.conf

# Listening ports
EXPOSE 443

# Persist data
VOLUME /srv/ttrss/cache /srv/ttrss/feed-icons

# Setup init
ADD supervisord.conf /supervisord.conf
ADD entrypoint.sh /entrypoint.sh
ADD ttrss-update-daemon.sh /usr/local/sbin/ttrss-update-daemon.sh
RUN set -x && chmod +x /usr/local/sbin/ttrss-update-daemon.sh

ENTRYPOINT ["/entrypoint.sh"]
