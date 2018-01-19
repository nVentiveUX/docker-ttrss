SHELL=/bin/bash
DOCKERFILES=Dockerfile Dockerfile.arm32v6
TEMPLATE=Dockerfile.template

.PHONY: \
	all \
	backup \
	clean \
	dockerfiles \
	restore

# Tasks
#
all: clean dockerfiles

backup: ttrss-latest.pgdump

clean:
	rm -f $(DOCKERFILES)

dockerfiles: $(DOCKERFILES)

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
Dockerfile:
	sed -r \
	  -e "s!%%DF_FROM%%!alpine:3.7!g" \
		$(TEMPLATE) > Dockerfile

Dockerfile.arm32v6:
	sed -r \
	  -e "s!%%DF_FROM%%!arm32v6/alpine:3.7!g" \
		$(TEMPLATE) > Dockerfile.arm32v6

ttrss-latest.pgdump:
	scp vinzpi.local:/nas/backups/`ssh vinzpi.local ls -1rt /nas/backups | tail -1` ttrss-latest.pgdump
