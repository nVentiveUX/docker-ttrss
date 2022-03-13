SHELL := /bin/bash

.PHONY: up
up:
	@docker compose up --build

.PHONY: down
down:
	@docker compose down --volumes --rmi local
