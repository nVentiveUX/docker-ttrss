# Tiny Tiny RSS docker image

[![Release](https://github.com/nVentiveUX/docker-ttrss/actions/workflows/release.yaml/badge.svg)](https://github.com/nVentiveUX/docker-ttrss/actions/workflows/release.yaml)

Host [Tiny Tiny RSS](https://tt-rss.org/) instance in a docker container supporting amd64, arm64 and arm architectures (RaspberryPi).

## Available images and tags

The following multi-architecture image is available:

* **[nventiveux/ttrss](https://hub.docker.com/r/nventiveux/ttrss)**
  * *master*, *latest* ([Dockerfile](https://github.com/nVentiveUX/docker-ttrss/blob/master/Dockerfile))
  * [See all tags](https://hub.docker.com/r/nventiveux/ttrss/tags?page=1&ordering=last_updated)

**Hint**: tags following [calver versionning](https://calver.org/) are also available if you want to stick to a particular version. Tags starting with `master-YYYY.MM.DD` are the stable versions while `develop-YYYY.MM.DD` are the unstable ones.

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

### Environment variables

We are now using configuration through environment variables from upstream project. Refer to [this documentation](https://tt-rss.org/wiki/GlobalConfig).

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
