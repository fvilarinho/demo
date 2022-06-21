#!/bin/bash

echo "Starting service..."

# Check if the backend is up and running.
while [ true ]; do
  response=$(curl --write-out '%{http_code}' --silent --output /dev/null http://backend:8080/demo)

  if [ "$response" -eq "200" ] || [ "$response" -eq "301" ] || [ "$response" -eq "302" ]; then
    break
  else
    sleep 1
  fi
done

# Start the service
echo "Service started!"

nginx -g "daemon off;"