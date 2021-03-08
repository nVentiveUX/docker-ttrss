#!/bin/sh
set -e

PATH="/bin:/sbin:/usr/bin:/usr/sbin"

su nginx -s /bin/sh -c "php /srv/ttrss/update.php --update-schema=force-yes" || exit 1

# Configure mail sending
touch /etc/msmtprc
chown nginx:nginx /etc/msmtprc
chmod 0400 /etc/msmtprc
envsubst < /var/tmp/msmtprc.tpl > /etc/msmtprc

# Relay to supervisord
exec supervisord -c /supervisord.conf
