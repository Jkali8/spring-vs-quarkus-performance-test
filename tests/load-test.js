import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

const errorRate = new Rate('errors');

export let options = {
  stages: [
    { duration: '30s', target: 20 },   // Warm up
    { duration: '1m', target: 50 },    // Normal load
    { duration: '30s', target: 100 },  // Peak load
    { duration: '1m', target: 50 },    // Back to normal
    { duration: '30s', target: 0 },    // Cool down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500', 'p(99)<1000'],
    errors: ['rate<0.01'],
  },
};

const BASE_URL = __ENV.BASE_URL || 'http://localhost:8080';

export default function () {
  // Test 1: Simple endpoint
  let res1 = http.get(`${BASE_URL}/hello`);
  check(res1, {
    'hello status 200': (r) => r.status === 200,
  }) || errorRate.add(1);

  sleep(0.5);

  // Test 2: Database read (list users)
  let res2 = http.get(`${BASE_URL}/users`);
  check(res2, {
    'users list status 200': (r) => r.status === 200,
    'users list has data': (r) => JSON.parse(r.body).length > 0,
  }) || errorRate.add(1);

  sleep(0.5);

  sleep(1);
}
