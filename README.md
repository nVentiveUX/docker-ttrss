# Tiny Tiny RSS docker image

Host [Tiny Tiny RSS](https://tt-rss.org/) instance in a docker container supporting x86_64 / RaspberryPi (ARM32v6) architectures.

## Available tags

* *latest* ([Dockerfile](Dockerfile))
* *latest-arm32v6* ([Dockerfile.arm32v6](Dockerfile))

## Usage

Create a **postgres** database:

```shell
# x86_64
$ docker run \
    -d \
    --name ttrss_database \
    -v ttrss_db_vol:/var/lib/postgresql/data
    -p 5432:5432 \
    -e POSTGRES_USER=ttrss \
    -e POSTGRES_PASSWORD=ttrss postgres:10.1

# ARM (eg. Raspberry Pi)
$ docker run \
    -d \
    --name ttrss_database \
    -v ttrss_db_vol:/var/lib/postgresql/data
    -p 5432:5432 \
    -e POSTGRES_USER=ttrss \
    -e POSTGRES_PASSWORD=ttrss arm32v6/postgres:10.1-alpine
```

Run **ttrss** instance:

```shell
# x86_64
$ docker run -d --name ttrss -p 8000:443 bigbrozer/ttrss

# ARM (eg. Raspberry Pi)
$ docker run -d --name ttrss -p 8000:443 bigbrozer/ttrss:latest-arm32v6
```

Open browser to https://localhost:8000/install/. You will be prompted to give database credentials:

* **Database host**: localhost
* **Database port**: 5432
* **Database user**: ttrss
* **Database password**: ttrss

## Tests and development

Tweak `Dockerfile.template` to your convenience, then:

```shell
$ make all
```

Bring it up using:

```shell
$ docker-compose up --build
```

Open browser to https://localhost:8000/install/

## Maintenance

### Restoring a database dump

```shell
$ docker exec -i ttrss_database_1 pg_restore --no-acl --no-owner -U ttrss -d ttrss < <pgdump_filename>
```
