# Spring Boot vs Quarkus Performance Comparison

A comprehensive performance comparison between Spring Boot and Quarkus JVM, testing real-world REST API scenarios with PostgreSQL in Docker containers.

## 🎯 Project Overview

This project benchmarks two identical REST APIs built with:
- **Spring Boot 3.x** (Java 17)
- **Quarkus 3.28.3** (Java 17)

Both applications implement the same endpoints, use PostgreSQL for data persistence, and run in Docker containers with identical resource constraints (512MB RAM, 1 CPU).

## 📊 Test Results Summary

### Startup Time
- **Spring Boot:** 8.0 seconds
- **Quarkus:** 5.0 seconds
- **Winner:** Quarkus (38% faster)

### Memory Usage
| State | Spring Boot | Quarkus | Difference |
|-------|-------------|---------|------------|
| Idle | 326 MB | 137 MB | Quarkus uses 58% less |
| Peak (under load) | 357 MB | 325 MB | Quarkus uses 9% less |
| After load | 347 MB | 305 MB | Quarkus uses 12% less |

### Throughput (10K requests, 100 concurrent)
- **Spring Boot:** 2,203 requests/sec
- **Quarkus:** 3,941 requests/sec
- **Winner:** Quarkus (79% faster)

### Response Times (Sustained Load)
- **Average:** Spring Boot 5.31ms | Quarkus 4.65ms (Quarkus 12% faster)
- **Median (p50):** Spring Boot 4.34ms | Quarkus 3.64ms (Quarkus 16% faster)
- **p95:** Spring Boot 11.83ms | Quarkus 11.14ms (Quarkus 6% faster)
- **p99:** Spring Boot 16.40ms | Quarkus 17.19ms (Spring Boot 5% faster)

### Reliability
- **Both frameworks:** 0% error rate, 0 failed requests
- **Both are production-ready**

## 🏗️ Architecture

Both applications implement:
- REST API with identical endpoints
- PostgreSQL database integration
- Entity/Repository pattern
- Containerized deployment
- 100 pre-loaded test users

### Endpoints
```
GET  /api/hello          # Simple health check
GET  /api/users          # List all users
```

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- Java 17
- Maven 3.9+
- k6, Apache Bench, hey for load testing

### Running the Applications
```bash
# Clone the repository
git clone https://github.com/yourusername/spring-vs-quarkus-performance-test.git
cd spring-vs-quarkus-performance-test

# Start all services (PostgreSQL + both apps)
docker-compose up -d

# Wait for services to start (~30 seconds)
sleep 30

# Test endpoints
curl http://localhost:8080/api/hello  # Spring Boot
curl http://localhost:8081/api/hello  # Quarkus
curl http://localhost:8080/api/users  # Get users (Spring Boot)
curl http://localhost:8081/api/users  # Get users (Quarkus)
```

### Running Locally (Development)
```bash
# Terminal 1: Start PostgreSQL only
docker-compose up postgres

# Terminal 2: Run Spring Boot
cd spring-demo
./mvnw spring-boot:run
# Available at http://localhost:8080

# Terminal 3: Run Quarkus
cd quarkus-demo
./mvnw quarkus:dev
# Available at http://localhost:8081
```

## 🧪 Running Performance Tests

### Install Testing Tools
```bash
# macOS
brew install httpd k6 hey

# Linux (Ubuntu/Debian)
sudo apt-get install apache2-utils
# k6: https://k6.io/docs/get-started/installation/
```

### Quick Performance Test
```bash
cd tests
chmod +x quick-test.sh
./quick-test.sh
```

### Individual Tests
```bash
# Startup time test
./startup-test.sh

# Memory under load test
./memory-test.sh

# k6 load test - Spring Boot
k6 run -e BASE_URL=http://localhost:8080 load-test.js

# k6 load test - Quarkus
k6 run -e BASE_URL=http://localhost:8081 load-test.js
```

## 🎓 Key Learnings

### When to Choose Quarkus

✅ **Cloud-native microservices** - Lower memory = higher pod density
✅ **Cost optimization** - 58% less idle memory = significant cloud savings
✅ **Fast startup requirements** - Kubernetes autoscaling, serverless
✅ **High throughput needs** - 79% more requests/sec in burst scenarios

### When to Choose Spring Boot

✅ **Large teams with Spring expertise** - Mature ecosystem, familiar patterns
✅ **Enterprise applications** - Extensive third-party integrations
✅ **Strict SLA requirements** - More predictable p99 latency
✅ **Lower risk tolerance** - Battle-tested in production for years

### Both Are Excellent For

✅ Production workloads (0% error rate in tests)
✅ RESTful microservices
✅ Database-backed applications
✅ Docker/Kubernetes deployment

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**⭐ If you found this comparison useful, please star the repo!**

