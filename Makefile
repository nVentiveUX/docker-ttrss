SHELL = /bin/bash
ARCH = amd64 arm32v6

# Tasks
#
.PHONY: dockerfiles
dockerfiles: install $(ARCH)

.PHONY: install
install:
	@pipenv install --dev

# Files
#
$(ARCH):
	ARCH=$@ pipenv run j2 Dockerfile.j2 > Dockerfile.$@
