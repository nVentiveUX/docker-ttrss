# Tiny Tiny RSS docker image

> [!IMPORTANT]
> TT-RSS's author announced [a shutdown of all the infrastructure](https://community.tt-rss.org/t/the-end-of-tt-rss-org/7164) related to the project.
>
> Since a couple of years now I have switched to [FreshRSS](https://github.com/FreshRSS/FreshRSS) which **I highly recommend**.
>
> **This project is now discontinued and archived**. Thanks to all the feedbacks and contributors I had over time :heart:

[![Release](https://github.com/nVentiveUX/docker-ttrss/actions/workflows/release.yaml/badge.svg)](https://github.com/nVentiveUX/docker-ttrss/actions/workflows/release.yaml)

Host [Tiny Tiny RSS](https://tt-rss.org/) instance in a docker container supporting amd64, arm64 and arm architectures (RaspberryPi).

* [Available images and tags](#available-images-and-tags)
* [Features](#features)
* [Configuration](#configuration)
* [Usage](#usage)
  * [Prepare the database](#prepare-the-database)
  * [Run TTRSS instance](#run-ttrss-instance)
* [Tests and development](#tests-and-development)
* [Maintenance](#maintenance)
  * [Restoring a PostgreSQL database](#restoring-a-postgresql-database)

## Available images and tags

The following multi-architecture image is available:

* **[nventiveux/ttrss](https://hub.docker.com/r/nventiveux/ttrss)**
  * *latest* ([Dockerfile](https://github.com/nVentiveUX/docker-ttrss/blob/master/Dockerfile))
  * [See all tags](https://hub.docker.com/r/nventiveux/ttrss/tags?page=1&ordering=last_updated)

**Hint**: tags are following [calver versionning](https://calver.org/) with pattern `vYYYY.MM.DD`.

## Features

Some additionnals features are added to the base installation of TT-RSS:

* [Feedly](https://github.com/levito/tt-rss-feedly-theme) theme.
* [Mercury Fulltext](https://github.com/HenryQW/mercury_fulltext) plugin installed (you need to [configure and enable it](https://github.com/HenryQW/mercury_fulltext#installation) before).

## Configuration

We are now using configuration through environment variables from upstream project. Refer to [this documentation](https://tt-rss.org/wiki/GlobalConfig).

## Usage

Create a network:

```sh
docker network create ttrss_net
```

### Prepare the database

You have 2 choices: **postgresql** or **mysql** database.

Create a **postgresql** database:

```sh
docker run \
  -d \
  --name ttrss_database \
  -v ttrss_db_vol:/var/lib/postgresql/data \
  -e POSTGRES_USER=ttrss \
  -e POSTGRES_PASSWORD=ttrss \
  --network ttrss_net \
  postgres:12.6-alpine
```

Create a **mysql** database:

```sh
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
```

### Run TTRSS instance

Run **ttrss** instance (adapt `TTRSS_DB_TYPE` to `mysql` if database is MySQL / MariaDB):

```sh
docker run \
  -d \
  --name ttrss \
  -e TTRSS_DB_HOST="ttrss_database" \
  -e TTRSS_DB_TYPE="pgsql" \
  -p 8000:80 \
  --network ttrss_net \
  nventiveux/ttrss:latest
```

Open browser to [http://localhost:8000/](http://localhost:8000/). Login as **admin** with password **password**.

## Tests and development

Adapt the `Dockerfile` to your needs.

Then test the image locally:

```sh
# PostgresSQL
cd tests/ttrss-pgsql && docker-compose up --build

# MySQL
cd tests/ttrss-mysql && docker-compose up --build
```

Open browser to [http://localhost:8000/](http://localhost:8000/). Login as **admin** with password **password**.

## Maintenance

### Restoring a PostgreSQL database

```sh
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
