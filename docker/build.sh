#!/bin/sh

docker build -t carla-docker-ll7:0.9.10.1 -f Dockerfile ./.. "$@"
