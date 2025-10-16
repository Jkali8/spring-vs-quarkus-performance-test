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