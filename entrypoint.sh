#!/bin/sh
set -e

PATH="/bin:/sbin:/usr/bin:/usr/sbin"

# Configure TT-RSS database and schema migrations
php /configure-db.php || exit 1
su nginx -s /bin/sh -c "php /srv/ttrss/update.php --update-schema" || exit 1

# Generate SSL self-signed certs
if [ ! -e "/etc/nginx/ssl/ttrss.crt" ]
then
  openssl req \
    -subj "/CN=${TTRSS_SELF_CERT_CN}/O=${TTRSS_SELF_CERT_ORG}/C=${TTRSS_SELF_CERT_COUNTRY}" \
    -new \
    -newkey rsa:2048 \
    -days 1825 \
    -nodes \
    -x509 \
    -keyout /etc/nginx/ssl/ttrss.key \
    -out /etc/nginx/ssl/ttrss.crt
fi

# Relay to supervisord
exec supervisord -c /supervisord.conf
