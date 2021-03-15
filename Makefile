NAME	:= carla/docker
TAG		:= 0.1.0
IMG		:= ${NAME}:${TAG}

all: carla ros-bridge

carla:
	@docker build -t ${IMG} carla_docker

ros-bridge:
	@git clone --recurse-submodules https://github.com/carla-simulator/ros-bridge.git
	@cd ros-bridge/; git checkout --recurse-submodules 0.9.10.1 -b 0.9.10.1; rm -r docker
	@mv docker/ ros-bridge/
	@cd ros-bridge/docker/; ./build.sh