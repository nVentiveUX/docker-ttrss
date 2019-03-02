#!/bin/sh
set -e

PATH="/bin:/sbin:/usr/bin:/usr/sbin"

# Configure TT-RSS database and schema migrations
php /configure-db.php || exit 1
su nginx -s /bin/sh -c "php /srv/ttrss/update.php --update-schema" || exit 1

# Configure mail sending
envsubst < /var/tmp/msmtprc.tpl > /etc/msmtprc

# Relay to supervisord
exec supervisord -c /supervisord.conf
