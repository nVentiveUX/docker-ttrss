SHELL=/bin/bash
DOCKERFILES=Dockerfile.amd64 Dockerfile.arm32v6

.PHONY: \
	all \
	backup \
	restore

# Tasks
#
default:

backup: ttrss-latest.pgdump

restore: ttrss-latest.pgdump
ifeq ($(TTRSS_DB_CONTAINER_ID),)
	@echo "Please set TTRSS_DB_CONTAINER_ID." && exit 1
endif

	docker exec -i \
		$(TTRSS_DB_CONTAINER_ID) dropdb -U ttrss ttrss

	docker exec -i \
		$(TTRSS_DB_CONTAINER_ID) createdb -U ttrss -O ttrss ttrss

	docker exec -i \
		$(TTRSS_DB_CONTAINER_ID) pg_restore \
			--no-acl --no-owner -U ttrss -d ttrss < ttrss-latest.pgdump

# Files
#
ttrss-latest.pgdump:
	scp vinzpi.local:/nas/backups/`ssh vinzpi.local ls -1rt /nas/backups | tail -1` ttrss-latest.pgdump
