#!/bin/bash

# Define packaging environment.
echo "DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL" > ./iac/.env
echo "DOCKER_REGISTRY_ID=$DOCKER_REGISTRY_ID" >> ./iac/.env

# Build docker images.
docker-compose -f ./iac/docker-compose.yml build

# Save images locally.
rm -f /tmp/demo-*.tar

docker save $DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/demo-database:latest -o /tmp/demo-database.tar
docker save $DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/demo-backend:latest -o /tmp/demo-backend.tar
docker save $DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/demo-frontend:latest -o /tmp/demo-frontend.tar