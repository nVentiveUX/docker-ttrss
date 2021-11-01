SHELL = /bin/bash

# Tasks
#
.PHONY: install
install:
	@pipenv install --dev

.PHONY: tests-mysql
tests-mysql:
	$(MAKE) -C tests/ttrss-mysql up

.PHONY: tests-pgsql
tests-pgsql:
	$(MAKE) -C tests/ttrss-pgsql up
