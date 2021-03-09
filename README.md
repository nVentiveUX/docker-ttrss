# Tiny Tiny RSS docker image

[![Release AMD64](https://github.com/nVentiveUX/docker-ttrss/actions/workflows/release-amd64.yaml/badge.svg)](https://github.com/nVentiveUX/docker-ttrss/actions/workflows/release-amd64.yaml) [![Release ARM32V6](https://github.com/nVentiveUX/docker-ttrss/actions/workflows/release-arm32v6.yaml/badge.svg)](https://github.com/nVentiveUX/docker-ttrss/actions/workflows/release-arm32v6.yaml)

Host [Tiny Tiny RSS](https://tt-rss.org/) instance in a docker container supporting x86_64 / RaspberryPi (ARM32v6) architectures.

## Available images and tags

* **nventiveux/ttrss**
  * *latest* ([Dockerfile.amd64](https://github.com/nVentiveUX/docker-ttrss/blob/master/Dockerfile.amd64))

* **nventiveux/ttrss-arm32v6** (Raspberry Pi 2 / 3)
  * *latest* ([Dockerfile.arm32v6](https://github.com/nVentiveUX/docker-ttrss/blob/master/Dockerfile.arm32v6))

## Usage

Create a network:

```shell
docker network create ttrss_net
```

Create a **postgres** database:

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

Run **ttrss** instance:

```shell
# x86_64
docker run \
  -d \
  --name ttrss \
  -e TTRSS_DB_HOST="ttrss_database" \
  -p 8000:80 \
  --network ttrss_net \
  nventiveux/ttrss:latest

# ARM (eg. Raspberry Pi)
docker run \
  -d \
  --name ttrss \
  -e TTRSS_DB_HOST="ttrss_database" \
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
docker-compose up --build
```

Open browser to [http://localhost:8000/](http://localhost:8000/). Login as **admin** with password **password**.

## Maintenance

### Restoring a database dump

```shell
docker exec \
  -i <database_container_id> \
  pg_restore --no-acl --no-owner -U ttrss -d ttrss < <pgdump_filename>
```
