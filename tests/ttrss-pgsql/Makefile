SHELL := /bin/bash

.PHONY: up
up:
	@docker compose build --no-cache
	@docker compose up

.PHONY: down
down:
	@docker compose down --volumes --rmi local
