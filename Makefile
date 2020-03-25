NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m
SERVICE_NAME=app-template
MIX_ENV?=prod

.PHONY: all clean test build
all: clean test build

build:
	@echo "$(OK_COLOR)==> Building $(SERVICE_NAME) ($(MIX_ENV))... $(NO_COLOR)"
	@MIX_ENV=$(MIX_ENV) mix do deps.get --only=$(MIX_ENV), deps.compile, release

run:
	@echo "$(OK_COLOR)==> Running $(SERVICE_NAME)... $(NO_COLOR)"
	@mix do deps.get, phx.server

test: lint
	@echo "$(OK_COLOR)==> Running tests$(NO_COLOR)..."
	@MIX_ENV=test mix do deps.get, test

lint:
	@echo "$(OK_COLOR)==> Checking code style with 'credo' tool$(NO_COLOR)..."
	@mix do deps.get, credo --strict

clean:
	@echo "$(OK_COLOR)==> Cleaning unused deps$(NO_COLOR)..."
	@mix do deps.clean --unused
