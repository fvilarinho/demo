#!/bin/bash

# Define packaging environment.
echo "REPOSITORY_URL=$REPOSITORY_URL" > ./iac/.env
echo "REPOSITORY_ID=$REPOSITORY_ID" >> ./iac/.env

# Build docker images.
docker-compose -f ./iac/docker-compose.yml build

# Save images locally.
rm -f /tmp/demo-*.tar

docker save $REPOSITORY_ID/demo-database:latest -o /tmp/demo-database.tar
docker save $REPOSITORY_ID/demo-backend:latest -o /tmp/demo-backend.tar
docker save $REPOSITORY_ID/demo-frontend:latest -o /tmp/demo-frontend.tar