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

# Verify if the docker container exists
docker ps -a | awk '{print $NF}' | grep -w $DOCKER_CONTAINER > /dev/null 2>&1

if [ $? -eq 0 ]; then
  ACCEPTED_COMMANDS=('create-dump', 'mysql-run')

  # This can be done better
  echo ${ACCEPTED_COMMANDS[*]} | grep -q -w $1

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Going to run into ${YELLOW}${DOCKER_CONTAINER}${GREEN}:${NC} $@"
    docker exec \
      $DOCKER_CONTAINER \
      mysql-wrapper.sh "$@"
  else
    echo -e "${RED}Unrecognized command: ${NC}$1"
  fi

else
  echo -e "${RED}We can find the container: ${NC}${DOCKER_CONTAINER}"
fi
