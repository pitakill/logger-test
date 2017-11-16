#!/usr/bin/env bash

# Setting up vars
. .tools/bin/setup-vars.sh

# Test if docker command exists
docker -v > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -e "${RED}We love docker, give it a try...${NC}"
  echo -e "${YELLOW}To run this project docker must be installed${NC}"
  exit 1
fi

# Verify if the docker image exists
docker images | awk '{print $1}' | grep -w $DOCKER_IMAGE > /dev/null 2>&1

if [ $? -ne 0 ]; then
  echo -e "${GREEN}Building the docker image: ${NC}${DOCKER_IMAGE}"
  cd .tools/docker &&
  docker build \
    --build-arg MONGO_VERSION=$MONGO_VERSION \
    --build-arg VIRTUAL_HOST=$DOCKER_CONTAINER \
    --tag $DOCKER_IMAGE . &&
  cd ../..
fi

# Verify if docker network exists
docker network ls | awk '{print $2}' | grep -w $DOCKER_NETWORK > /dev/null 2>&1

if [ $? -ne 0  ]; then
  echo -e "${GREEN}Setting up docker network: ${NC}${DOCKER_NETWORK}"
  docker network create $DOCKER_NETWORK
fi

# Verify if nginx-proxy container exists
docker ps -a | awk '{print $NF}' | grep -w $DOCKER_CONTAINER_PROXY > /dev/null 2>&1

if [ $? -ne 0  ]; then
  echo -e "${GREEN}Setting up Proxy: ${NC}${DOCKER_CONTAINER_PROXY}"
  docker run \
    --detach \
    --name $DOCKER_CONTAINER_PROXY \
    --net $DOCKER_NETWORK \
    --publish 80:80 \
    --volume /var/run/docker.sock:/tmp/docker.sock:ro \
    $DOCKER_IMAGE_PROXY
fi

# Verify if the docker container exists
docker ps -a | awk '{print $NF}' | grep -w $DOCKER_CONTAINER > /dev/null 2>&1

if [ $? -ne 0 ]; then
  echo -e "${GREEN}Setting up ${NC}${DOCKER_CONTAINER}"
  docker run \
    --detach \
    --name $DOCKER_CONTAINER \
    --net $DOCKER_NETWORK \
    $DOCKER_IMAGE
else
  echo -e "${GREEN}Starting and Attaching: ${NC}${DOCKER_CONTAINER}"
  docker start $DOCKER_CONTAINER
fi
