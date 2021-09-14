# Tiny Tiny RSS docker image

[![Release AMD64](https://github.com/nVentiveUX/docker-ttrss/actions/workflows/release-amd64.yaml/badge.svg)](https://github.com/nVentiveUX/docker-ttrss/actions/workflows/release-amd64.yaml) [![Release ARM32V6](https://github.com/nVentiveUX/docker-ttrss/actions/workflows/release-arm32v6.yaml/badge.svg)](https://github.com/nVentiveUX/docker-ttrss/actions/workflows/release-arm32v6.yaml)

Host [Tiny Tiny RSS](https://tt-rss.org/) instance in a docker container supporting x86_64 / RaspberryPi (ARM32v6) architectures.

## Available images and tags

* **[nventiveux/ttrss](https://hub.docker.com/r/nventiveux/ttrss)** (x86_64)
  * *master*, *latest* ([Dockerfile.amd64](https://github.com/nVentiveUX/docker-ttrss/blob/master/Dockerfile.amd64))
  * [See all tags](https://hub.docker.com/r/nventiveux/ttrss/tags?page=1&ordering=last_updated)

* **[nventiveux/ttrss-arm32v6](https://hub.docker.com/r/nventiveux/ttrss-arm32v6)** (Raspberry Pi 2 / 3)
  * *master*, *latest* ([Dockerfile.arm32v6](https://github.com/nVentiveUX/docker-ttrss/blob/master/Dockerfile.arm32v6))
  * [See all tags](https://hub.docker.com/r/nventiveux/ttrss-arm32v6/tags?page=1&ordering=last_updated)

**Hint**: tags following [calver versionning](https://calver.org/) are also available if you want to stick to a particular version. Tags starting with `master-YYYY.MM.DD` are the stable versions while `develop-YYYY.MM.DD` are the unstable ones.

## Usage

Create a network:

```shell
docker network create ttrss_net
```

### Prepare the database

You have 2 choices: **postgresql** or **mysql** database.

To create a **postgresql** database:

```shell
# x86_64
docker run \
  -d \
  --name ttrss_database \
  -v ttrss_db_vol:/var/lib/postgresql/data \
  -e POSTGRES_USER=ttrss \
  -e POSTGRES_PASSWORD=ttrss \
  --network ttrss_net \
  postgres:12.6-alpine

# ARM (eg. Raspberry Pi)
docker run \
  -d \
  --name ttrss_database \
  -v ttrss_db_vol:/var/lib/postgresql/data \
  -e POSTGRES_USER=ttrss \
  -e POSTGRES_PASSWORD=ttrss \
  --network ttrss_net \
  arm32v6/postgres:12.6-alpine
```

Create a **mysql** database:

```shell
# x86_64
docker run \
  -d \
  --name ttrss_database \
  -v ttrss_db_vol:/var/lib/mysql \
  -e MYSQL_DATABASE=ttrss \
  -e MYSQL_USER=ttrss \
  -e MYSQL_PASSWORD=ttrss \
  -e MYSQL_ROOT_PASSWORD=ttrssroot \
  --network ttrss_net \
  mysql:8.0.23

# ARM (eg. Raspberry Pi)
docker run \
  -d \
  --name ttrss_database \
  -v ttrss_db_vol:/config \
  -e MYSQL_DATABASE=ttrss \
  -e MYSQL_USER=ttrss \
  -e MYSQL_PASSWORD=ttrss \
  -e MYSQL_ROOT_PASSWORD=ttrssroot \
  --network ttrss_net \
  linuxserver/mariadb:arm32v7-version-110.4.18mariabionic
```

### Run TTRSS instance

Run **ttrss** instance (adapt `TTRSS_DB_TYPE` to `mysql` if database is MySQL / MariaDB):

```shell
# x86_64
docker run \
  -d \
  --name ttrss \
  -e TTRSS_DB_HOST="ttrss_database" \
  -e TTRSS_DB_TYPE="pgsql" \
  -p 8000:80 \
  --network ttrss_net \
  nventiveux/ttrss:latest

# ARM (eg. Raspberry Pi)
docker run \
  -d \
  --name ttrss \
  -e TTRSS_DB_HOST="ttrss_database" \
  -e TTRSS_DB_TYPE="pgsql" \
  -p 8000:80 \
  --network ttrss_net \
  nventiveux/ttrss-arm32v6:latest
```

Open browser to [http://localhost:8000/](http://localhost:8000/). Login as **admin** with password **password**.

### Environment variables

We are now using configuration through environment variables from upstream project. Refer to [this documentation](https://tt-rss.org/wiki/GlobalConfig).

## Tests and development

Requirements:

* [Python >=3.7](https://www.python.org/)
* [Pipenv](https://pypi.org/project/pipenv/)

Install dependencies:

```shell
make install
```

Tweak `Dockerfile.j2` to your convenience, then:

```shell
make
```

Bring it up using:

```shell
# PostgresSQL
cd tests/ttrss-pgsql && docker-compose up --build

# MySQL
cd tests/ttrss-mysql && docker-compose up --build
```

Open browser to [http://localhost:8000/](http://localhost:8000/). Login as **admin** with password **password**.

## Maintenance

### Restoring a PostgreSQL database

```shell
# Using docker
docker exec -i <database_container_id> \
  pg_restore \
    --no-acl \
    --no-owner \
    -U ttrss \
    -d ttrss < <pgdump_filename>

# Using docker-compose
docker-compose exec -T database \
  pg_restore \
    --no-acl \
    --no-owner \
    -U ttrss \
    -d ttrss < /home/vbesancon/tmp/db_ttrss_1615503601.pgdump
```
