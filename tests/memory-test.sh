#!/bin/bash

echo "=== Memory Test ==="
echo ""

echo "1. Memory at Idle (waiting 10s for stabilization):"
sleep 10
docker stats --no-stream --format "table {{.Name}}\t{{.MemUsage}}\t{{.MemPerc}}" | grep -E "NAME|spring-boot|quarkus-jvm"

echo ""
echo "2. Starting HEAVY load test (60 seconds)..."
echo "   - 100 concurrent connections"
echo "   - No rate limiting"
echo "   - Mix of endpoints"

# Run HEAVY load in background - Spring Boot
hey -z 60s -c 100 http://localhost:8080/hello > /dev/null 2>&1 &
PID_SPRING_HELLO=$!

hey -z 60s -c 100 http://localhost:8080/users > /dev/null 2>&1 &
PID_SPRING_USERS=$!

# Run HEAVY load in background - Quarkus
hey -z 60s -c 100 http://localhost:8081/hello > /dev/null 2>&1 &
PID_QUARKUS_HELLO=$!

hey -z 60s -c 100 http://localhost:8081/users > /dev/null 2>&1 &
PID_QUARKUS_USERS=$!

echo ""
echo "Load started. Sampling memory every 5 seconds..."

# Sample memory every 5 seconds
for i in {1..12}; do
  sleep 5
  echo "Sample $i/12:"
  docker stats --no-stream --format "table {{.Name}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.CPUPerc}}" | grep -E "spring-boot|quarkus-jvm"
done

# Wait for load tests to complete
wait $PID_SPRING_HELLO $PID_SPRING_USERS $PID_QUARKUS_HELLO $PID_QUARKUS_USERS

echo ""
echo "3. Memory after load (cooling down 10s):"
sleep 10
docker stats --no-stream --format "table {{.Name}}\t{{.MemUsage}}\t{{.MemPerc}}" | grep -E "NAME|spring-boot|quarkus-jvm"

echo ""
echo "4. Peak statistics during test:"
docker stats --no-stream --format "table {{.Name}}\t{{.MemUsage}}\t{{.CPUPerc}}" | grep -E "NAME|spring-boot|quarkus-jvm"