SHELL = /bin/bash
IMAGE := nventiveux/ttrss:latest

# Tasks
#
.PHONY: venv
venv:
	@pipenv install --dev

.PHONY: clean
clean: clean-tests

.PHONY: tests
tests: tests-image

.PHONY: clean-tests
clean-tests:
	@docker rmi --force $(IMAGE)
	$(MAKE) -C tests/ttrss-mysql down
	$(MAKE) -C tests/ttrss-pgsql down

.PHONY: tests-image
tests-image:
	@docker build --rm --no-cache --tag $(IMAGE) .

.PHONY: tests-mysql
tests-mysql:
	$(MAKE) -C tests/ttrss-mysql up

.PHONY: tests-pgsql
tests-pgsql:
	$(MAKE) -C tests/ttrss-pgsql up
