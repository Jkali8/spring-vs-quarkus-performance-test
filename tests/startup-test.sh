#!/bin/bash

echo "=== Startup Time Test ==="
echo ""

services=("spring-boot:8080" "quarkus-jvm:8081")

for service in "${services[@]}"; do
  name=$(echo $service | cut -d: -f1)
  port=$(echo $service | cut -d: -f2)
  
  echo "Testing $name..."
  
  # Stop the service
  docker-compose -f ../docker-compose.yml stop $name
  
  # Start and measure
  start=$(date +%s%N)
  docker-compose -f ../docker-compose.yml start $name
  
  # Wait for service to respond
  max_attempts=60
  attempt=0
  until curl -sf http://localhost:$port/hello > /dev/null 2>&1; do
    attempt=$((attempt + 1))
    if [ $attempt -eq $max_attempts ]; then
      echo "Failed to start after ${max_attempts} seconds"
      break
    fi
    sleep 0.1
  done
  
  end=$(date +%s%N)
  startup_time=$(((end - start) / 1000000))
  
  echo "$name startup: ${startup_time}ms"
  echo ""
done
