# Set the required arguments
ARG APP=app
ARG PORT=8080
ARG UID=1000
ARG MIX_ENV=prod
ARG PROJECT=app_template

# ---- COMPILE ----
FROM elixir:1.10-alpine as builder

LABEL maintainer="marcin.praski@live.com"

ARG MIX_ENV
ARG APP
ARG PROJECT

ENV LANG C.UTF-8

# Install hex and rebar
RUN mix do \
    local.hex --force, \
    local.rebar --force

RUN mkdir /$APP
WORKDIR /$APP

# Copy over all the necessary application files and directories
COPY config ./config
COPY apps ./apps
COPY mix.exs .
COPY mix.lock .
COPY Makefile .

# Fetch the application dependencies and build the application
RUN apk add --update make && make build MIX_ENV=$MIX_ENV

# ---- PACKAGE ----
FROM alpine:3.11

ARG MIX_ENV
ARG APP
ARG PORT
ARG UID

RUN apk add --update ncurses-libs

USER nobody

WORKDIR /$APP

COPY --from=builder --chown=nobody:nobody /$APP/_build/$MIX_ENV/rel/$PROJECT .

EXPOSE $PORT

ENTRYPOINT ["app_template/bin/app_template"]
