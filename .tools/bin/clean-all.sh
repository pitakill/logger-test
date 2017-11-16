#!/usr/bin/env bash

# Setting up vars
. .tools/bin/setup-vars.sh

# Stop and remove the instance image
echo -e "${GREEN}Stopping and removing the container: ${NC}${DOCKER_CONTAINER}"
docker rm -f ${DOCKER_CONTAINER}

echo -e "${GREEN}Stopping and removing the image: ${NC}${DOCKER_IMAGE}"
docker image rm -f ${DOCKER_IMAGE}
