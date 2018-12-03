FROM elixir:alpine

LABEL maintainer="Ryan Durham <rdurham@phylos.bio>"

RUN apk update && apk upgrade && apk add --no-cache git openssh inotify-tools make gcc libc-dev

WORKDIR /home/advent
