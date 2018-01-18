#!/bin/sh
set -e

PATH="/bin:/sbin:/usr/bin:/usr/sbin"

until [ -e "/srv/ttrss/config.php" ]
do
  echo "Unable to start feed fetcher daemon as TTRSS is not configured yet. \
Retrying in 30 secs."
  sleep 30
done

php /srv/ttrss/update_daemon2.php
