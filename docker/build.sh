#!/bin/sh

docker build -t carla-ros-bridge:0.9.10.1 -f Dockerfile ./.. "$@"
