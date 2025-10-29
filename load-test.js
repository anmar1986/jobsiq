// Load Testing Script for k6
// Install k6: https://k6.io/docs/getting-started/installation/
// Run: k6 run load-test.js

import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

// Custom metrics
const errorRate = new Rate('errors');

// Test configuration
export const options = {
  stages: [
    { duration: '30s', target: 20 },  // Ramp up to 20 users
    { duration: '1m', target: 50 },   // Stay at 50 users
    { duration: '30s', target: 100 }, // Spike to 100 users
    { duration: '1m', target: 50 },   // Drop back to 50
    { duration: '30s', target: 0 },   // Ramp down to 0
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests should be below 500ms
    errors: ['rate<0.1'],              // Error rate should be below 10%
  },
};

const BASE_URL = 'http://localhost:8000';

export default function () {
  // Test 1: Home page
  let response = http.get(`${BASE_URL}/api/home`);
  const homeCheck = check(response, {
    'home page status is 200': (r) => r.status === 200,
    'home page response time < 500ms': (r) => r.timings.duration < 500,
  });
  if (!homeCheck) errorRate.add(1);
  
  sleep(1);

  // Test 2: Jobs listing
  response = http.get(`${BASE_URL}/api/jobs?page=1&per_page=20`);
  const jobsCheck = check(response, {
    'jobs listing status is 200': (r) => r.status === 200,
    'jobs listing response time < 800ms': (r) => r.timings.duration < 800,
  });
  if (!jobsCheck) errorRate.add(1);
  
  sleep(1);

  // Test 3: Companies listing
  response = http.get(`${BASE_URL}/api/companies?page=1&per_page=20`);
  const companiesCheck = check(response, {
    'companies listing status is 200': (r) => r.status === 200,
    'companies listing response time < 800ms': (r) => r.timings.duration < 800,
  });
  if (!companiesCheck) errorRate.add(1);
  
  sleep(2);
}

export function handleSummary(data) {
  return {
    'load-test-results.json': JSON.stringify(data, null, 2),
    stdout: textSummary(data, { indent: ' ', enableColors: true }),
  };
}

function textSummary(data, _options) {
  return `
📊 Load Test Summary
====================
Duration: ${data.state.testRunDurationMs / 1000}s
VUs: ${data.metrics.vus.values.max}
Requests: ${data.metrics.http_reqs.values.count}
Error Rate: ${(data.metrics.errors?.values.rate || 0) * 100}%

Response Times:
- Average: ${data.metrics.http_req_duration.values.avg.toFixed(2)}ms
- Median: ${data.metrics.http_req_duration.values.med.toFixed(2)}ms
- 95th percentile: ${data.metrics.http_req_duration.values['p(95)'].toFixed(2)}ms
- 99th percentile: ${data.metrics.http_req_duration.values['p(99)'].toFixed(2)}ms
`;
}
