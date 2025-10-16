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
GET  /api/users/{id}     # Get user by ID
POST /api/users          # Create new user
PUT  /api/users/{id}     # Update user
```

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- Java 17
- Maven 3.9+
- (Optional) k6, Apache Bench, hey for load testing

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

### Complete Test Suite
```bash
cd tests
chmod +x run-all-tests.sh
./run-all-tests.sh > results.txt
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

## 📁 Project Structure
```
.
├── docker-compose.yml           # Orchestrates all services
├── postgres-init/
│   └── init.sql                 # Database schema and test data
├── spring-demo/
│   ├── Dockerfile               # Spring Boot container
│   ├── pom.xml
│   └── src/
│       └── main/
│           ├── java/
│           │   └── com/example/springdemo/
│           │       ├── model/User.java
│           │       ├── repository/UserRepository.java
│           │       └── controller/
│           │           ├── HelloController.java
│           │           └── UserController.java
│           └── resources/
│               └── application.properties
├── quarkus-demo/
│   ├── Dockerfile.jvm           # Quarkus JVM container
│   ├── pom.xml
│   └── src/
│       └── main/
│           ├── java/
│           │   └── com/test/
│           │       ├── User.java
│           │       ├── GreetingResource.java
│           │       └── UserResource.java
│           └── resources/
│               └── application.properties
└── tests/
    ├── quick-test.sh            # Fast comparison test
    ├── startup-test.sh          # Measures cold start time
    ├── memory-test.sh           # Memory under load
    ├── load-test.js             # k6 load test script
    └── run-all-tests.sh         # Complete test suite
```

## 🔧 Configuration

### Docker Resource Limits

Both containers are configured with identical limits in `docker-compose.yml`:
```yaml
mem_limit: 512m
cpus: 1
```

### Database Configuration

PostgreSQL is pre-configured with:
- Database: `testdb`
- User: `test`
- Password: `test`
- 100 test users pre-loaded

## 📈 Test Methodology

### Test Environment
- **Hardware:** Apple Silicon Mac (ARM64)
- **Docker:** Desktop for Mac
- **Resource Limits:** 512MB RAM, 1 CPU per container
- **Network:** Local (localhost)

### Test Types

1. **Startup Time Test**
   - Measures cold start time from container start to first successful HTTP response
   - Tests application initialization and framework overhead

2. **Memory Test**
   - Measures idle memory footprint
   - Tracks memory growth under 60s sustained load
   - Monitors memory after load (GC effectiveness)

3. **Throughput Test**
   - 10,000 requests with 100 concurrent connections
   - Tests raw request handling capacity

4. **Load Test (k6)**
   - Realistic user simulation with ramp-up/down
   - 3.5 minutes duration with varying load (20→50→100→50→0 users)
   - Tests database read operations
   - Measures response time percentiles

### Repeatability

All tests were run multiple times to ensure consistency. Results shown are representative of typical runs.

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

## 🤝 Contributing

Found issues or have improvements? Contributions welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit changes (`git commit -am 'Add improvement'`)
4. Push to branch (`git push origin feature/improvement`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Spring Boot team for the excellent framework
- Quarkus team for pushing Java forward
- PostgreSQL community for the reliable database
- k6 team for the great load testing tool

## 📞 Contact

Questions or feedback? Open an issue or reach out:
- GitHub: [@yourusername](https://github.com/yourusername)
- LinkedIn: [Your Name](https://linkedin.com/in/yourprofile)

---

**⭐ If you found this comparison useful, please star the repo!**

Made with ☕ and 🐳 by [Your Name]
