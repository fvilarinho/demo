#!/bin/bash

# Authenticate in the packaging repository.
echo $DOCKER_REGISTRY_PASSWORD | docker login -u $DOCKER_REGISTRY_USER $DOCKER_REGISTRY_URL --password-stdin

# Tag the version in the packages and push into the repository
BUILD_VERSION=$(md5sum -b /tmp/demo-database.tar | awk '{print $1}')
docker tag $DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/demo-database:latest $DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/demo-database:$BUILD_VERSION
docker push $DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/demo-database:$BUILD_VERSION

BUILD_VERSION=$(md5sum -b /tmp/demo-backend.tar | awk '{print $1}')
docker tag $DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/demo-backend:latest $DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/demo-backend:$BUILD_VERSION
docker push $DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/demo-backend:$BUILD_VERSION

BUILD_VERSION=$(md5sum -b /tmp/demo-frontend.tar | awk '{print $1}')
docker tag $DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/demo-frontend:latest $DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/demo-frontend:$BUILD_VERSION
docker push $DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/demo-frontend:$BUILD_VERSION

docker-compose -f ./iac/docker-compose.yml push