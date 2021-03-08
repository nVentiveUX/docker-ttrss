# msmtp configuration

defaults

auth on
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
tls_starttls off

account ttrss
host ${TTRSS_SMTP_SERVER}
port ${TTRSS_SMTP_PORT}
from ${TTRSS_SMTP_FROM_ADDRESS}
user ${TTRSS_SMTP_LOGIN}
password ${TTRSS_SMTP_PASSWORD}

account default : ttrss
