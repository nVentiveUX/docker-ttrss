# Tiny Tiny RSS docker image

[![Build Status](https://travis-ci.org/nVentiveUX/docker-ttrss.svg?branch=master)](https://travis-ci.org/nVentiveUX/docker-ttrss)

Host [Tiny Tiny RSS](https://tt-rss.org/) instance in a docker container supporting x86_64 / RaspberryPi (ARM32v6) architectures.

## Available images and tags

* **nventiveux/ttrss**
  * *latest* ([Dockerfile.amd64](https://github.com/nVentiveUX/docker-ttrss/blob/master/Dockerfile.amd64))

* **nventiveux/ttrss-arm32v6** (Raspberry Pi 2 / 3)
  * *latest* ([Dockerfile.arm32v6](https://github.com/nVentiveUX/docker-ttrss/blob/master/Dockerfile.arm32v6))

## Usage

Create a network:

```shell
$ docker network create ttrss_net
```

Create a **postgres** database:

```shell
# x86_64
$ docker run \
    -d \
    --name ttrss_database \
    -v ttrss_db_vol:/var/lib/postgresql/data \
    -e POSTGRES_USER=ttrss \
    -e POSTGRES_PASSWORD=ttrss \
    --network ttrss_net \
    postgres:10.1

# ARM (eg. Raspberry Pi)
$ docker run \
    -d \
    --name ttrss_database \
    -v ttrss_db_vol:/var/lib/postgresql/data \
    -e POSTGRES_USER=ttrss \
    -e POSTGRES_PASSWORD=ttrss \
    --network ttrss_net \
    arm32v6/postgres:10.1-alpine
```

Run **ttrss** instance:

```shell
# x86_64
$ docker run \
    -d \
    --name ttrss \
    -e TTRSS_DB_HOST="ttrss_database" \
    -p 8000:443 \
    --network ttrss_net \
    nventiveux/ttrss:latest

# ARM (eg. Raspberry Pi)
$ docker run \
    -d \
    --name ttrss \
    -e TTRSS_DB_HOST="ttrss_database" \
    -p 8000:443 \
    --network ttrss_net \
    nventiveux/ttrss-arm32v6:latest
```

Open browser to https://localhost:8000/. Login as **admin** with password **password**.

### Environment variables

| Variables | Description |
|----|----|
| `TTRSS_DB_ADAPTER="pgsql"` | The database adapter, could be 'pgsql' or 'mysql' |
| `TTRSS_DB_HOST="database"` | The database host name / ip address |
| `TTRSS_DB_NAME="ttrss"` | Default database name |
| `TTRSS_DB_USER="ttrss"` | Default database user name |
| `TTRSS_DB_PASSWORD="ttrss"` | Default database user password |
| `TTRSS_DB_PORT="5432"` | Default database port, 5432 for pgsql, 3306 for mysql |
| `TTRSS_SELF_CERT_CN="localhost"` | Default CN in SSL certificate, use server host name |
| `TTRSS_SELF_CERT_ORG="Grenouille Inc."` | Set Organization in SSL certificate |
| `TTRSS_SELF_CERT_COUNTRY="FR"` | Set Country in SSL certificate |
| `TTRSS_CONF_SELF_URL_PATH="https://localhost:8000/"` | The URL to access the TT-RSS instance |
| `TTRSS_CONF_REG_NOTIFY_ADDRESS="me@mydomain.com"` | Email address where should be send notifications about feeds updates |
| `TTRSS_CONF_SMTP_FROM_NAME="TT-RSS Feeds"` | The From: field for email sending |
| `TTRSS_CONF_SMTP_FROM_ADDRESS="noreply@mydomain.com"` | Email where to reploy to notifications |
| `TTRSS_CONF_DIGEST_SUBJECT="[rss] News headlines on last 24 hours"` | The email notification subject |
| `TTRSS_CONF_SMTP_SERVER=""` | The SMTP server to use for email notifications |
| `TTRSS_CONF_PLUGINS="auth_internal,note,import_export"` | Default list of [PLUGINS](https://git.tt-rss.org/fox/tt-rss/wiki/Plugins) enabled by default. |

## Tests and development

Tweak `Dockerfile.template` to your convenience, then:

```shell
$ make all
```

Bring it up using:

```shell
$ docker-compose up --build
```

Open browser to https://localhost:8000/. Login as **admin** with password **password**.

## Maintenance

### Restoring a database dump

```shell
$ docker exec -i <database_container_id> pg_restore --no-acl --no-owner -U ttrss -d ttrss < <pgdump_filename>
```
