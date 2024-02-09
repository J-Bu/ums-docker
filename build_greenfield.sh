#!/bin/bash

docker build -t 'builder/greenfield' - < Dockerfile_build_greenfield
docker run --rm -v "${PWD}/greenfield:/opt/greenfield:rw" -v "${PWD}/patches:/patches" --user ${UID}:${GID} builder/greenfield
