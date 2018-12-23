SHELL = /bin/bash
ARCH = amd64 arm32v6

# Tasks
#
.PHONY: dockerfiles
dockerfiles: $(ARCH)

.PHONY: install
install:
	@pipenv install

.PHONY: backup
backup: ttrss-latest.pgdump

.PHONY: restore
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
$(ARCH):
	ARCH=$@ pipenv run j2 Dockerfile.j2 > Dockerfile.$@

ttrss-latest.pgdump:
	scp vinzpi.local:/nas/backups/`ssh vinzpi.local ls -1rt /nas/backups | tail -1` ttrss-latest.pgdump
