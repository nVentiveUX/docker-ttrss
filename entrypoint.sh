#!/bin/sh
set -e

PATH="/bin:/sbin:/usr/bin:/usr/sbin"

# Wait for database to start
until nc -zw 5 "${TTRSS_DB_HOST}" "${TTRSS_DB_PORT}"
do
    echo "Unable to connect on database host ${TTRSS_DB_HOST}:${TTRSS_DB_PORT} in 5 seconds. Retrying..."
    sleep 1
done

# Run migrations
su nginx -s /bin/sh -c "/usr/bin/php82 /srv/ttrss/update.php --update-schema=force-yes" || exit 1

# Configure mail sending
touch /etc/msmtprc
chown nginx:nginx /etc/msmtprc
chmod 0400 /etc/msmtprc
envsubst < /var/tmp/msmtprc.tpl > /etc/msmtprc

# Relay to supervisord
exec supervisord -n -c /supervisord.conf
