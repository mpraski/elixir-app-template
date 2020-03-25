# Phoenix Helm Chart

This repo will contain a template for an Elixir/Phoenix application, ready for packaging and deployment in a Kubernetes cluster.

To-Do:
- [x] MySQL database connector
- [x] Healthchecks
- [x] Metrics
- [x] Directory structure 
- [ ] Kinesis support
- [x] Migrations

## Requirements

For local development:

- Elixir (https://elixir-lang.org/install.html)
- Hex package manager
- Phoenix web framework

For packaging and testing with the DB:

- docker
- docker-compose

## Development

- `make run` to start a development Phoenix server with live code reloading. 
- `make lint` to analyze code of the project using Credo
- `make test` to run all unit tests in the project

## Release

- `docker-compose up --build` to build the app container and start it along with configured MySQL 8.0 instance

## Migrations

In order to run migrations you have to run the container with command `eval Domain.Migration.migrate` (while supplying all the env variables you would for starting the app).

## Helm install

`helm install elixir-app-template --namespace=default --values=./charts/elixir-app-template/values.yaml ./charts/elixir-app-template`

## Notes

If you run into problems with running the MySQL container in docker-compose run `docker system prune --volumes`. This will ensure MySQL doesn't complain about any files from previous runs being present in this volume when initializing the DB for the first time.
