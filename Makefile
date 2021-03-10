SHELL = /bin/bash
ARCH = amd64 arm32v6

# Tasks
#
.PHONY: dockerfiles
dockerfiles: install $(ARCH)

.PHONY: install
install:
	@pipenv install --dev

.PHONY: tests-mysql
tests-mysql:
	$(MAKE) -C tests/ttrss-mysql up

.PHONY: tests-pgsql
tests-pgsql:
	$(MAKE) -C tests/ttrss-pgsql up

# Files
#
$(ARCH):
	ARCH=$@ pipenv run j2 Dockerfile.j2 > Dockerfile.$@
