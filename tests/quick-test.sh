#!/bin/bash

echo "=================================="
echo "Quick Performance Comparison"
echo "=================================="
echo ""

echo "Checking services..."
curl -s http://localhost:8080/hello > /dev/null && echo "✓ Spring Boot running"
curl -s http://localhost:8081/hello > /dev/null && echo "✓ Quarkus running"
echo ""

echo "=== Throughput Test (10,000 requests, 100 concurrent) ==="
echo ""
echo "Spring Boot:"
ab -n 10000 -c 100 -q http://localhost:8080/hello 2>&1 | grep -E "Requests per second|Time per request|Failed"

echo ""
echo "Quarkus JVM:"
ab -n 10000 -c 100 -q http://localhost:8081/hello 2>&1 | grep -E "Requests per second|Time per request|Failed"

echo ""
echo "=== Memory Usage ==="
docker stats --no-stream --format "table {{.Name}}\t{{.MemUsage}}\t{{.MemPerc}}" | grep -E "NAME|spring-boot|quarkus-jvm"

echo ""
echo "=== Image Sizes ==="
docker images --format "{{.Repository}}: {{.Size}}" | grep -E "spring|quarkus"

