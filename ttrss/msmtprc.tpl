# msmtp configuration

defaults

auth on
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
tls_starttls off

account ttrss
host ${TTRSS_CONF_SMTP_SERVER}
port ${TTRSS_CONF_SMTP_PORT}
from ${TTRSS_CONF_SMTP_FROM_ADDRESS}
user ${TTRSS_CONF_SMTP_LOGIN}
password ${TTRSS_CONF_SMTP_PASSWORD}

account default : ttrss
