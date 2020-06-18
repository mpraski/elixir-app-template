# ---- ARGUMENTS ----
ARG APP=app
ARG PORT=8080
ARG MIX_ENV=prod
ARG PROJECT=app_template

# ---- COMPILE ----
FROM elixir:1.10-alpine as builder

LABEL maintainer="marcin.praski@live.com"

ARG MIX_ENV
ARG APP
ARG PROJECT

ENV LANG C.UTF-8

WORKDIR /$APP

# Copy over configuration that
# is unlikely to change often
COPY mix.* ./
COPY config ./config
COPY apps/api/mix.exs ./apps/api/
COPY apps/domain/mix.exs ./apps/domain/

# Install hex, rebar and dependencies
RUN mix do \
    local.hex --force, \
    local.rebar --force, \
    deps.get --only $MIX_ENV, \
    deps.compile

# Copy over the code
COPY apps ./apps

# Build the application
RUN MIX_ENV=$MIX_ENV mix do compile, release

# ---- PACKAGE ----
FROM alpine:3.11

ARG MIX_ENV
ARG APP
ARG PORT

# Erlang runtime depends on ncurses library. For SSL support
# we could also install openssl, but this will be handled by Kubernetes in our setup
RUN apk add --no-cache ncurses-libs && rm -rf /var/cache/apk/*

# Run as unprivileged user for smaller attack surface
USER nobody

WORKDIR /$APP

# Copy and chown the binaries
COPY --from=builder --chown=nobody:nobody /$APP/_build/$MIX_ENV/rel/$PROJECT .

EXPOSE $PORT

ENTRYPOINT ["app_template/bin/app_template"]
