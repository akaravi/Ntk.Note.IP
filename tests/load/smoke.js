import http from 'k6/http';
import { check, sleep } from 'k6';

const baseUrl = __ENV.BASE_URL || 'http://localhost:5340';

export const options = {
  scenarios: {
    smoke: {
      executor: 'constant-vus',
      vus: 5,
      duration: '30s',
    },
  },
  thresholds: {
    http_req_failed: ['rate<0.02'],
    http_req_duration: ['p(95)<2000'],
    checks: ['rate>0.95'],
  },
};

export default function smoke() {
  const health = http.get(`${baseUrl}/health`);
  check(health, {
    'health status 200': (r) => r.status === 200,
  });

  const myIp = http.get(`${baseUrl}/api/v1/IpLookup/GetMyIp`, {
    headers: { Accept: 'application/json' },
  });
  check(myIp, {
    'GetMyIp status 200': (r) => r.status === 200,
    'GetMyIp envelope': (r) => {
      try {
        const body = r.json();
        return body.isSuccess === true && typeof body.data === 'object';
      } catch {
        return false;
      }
    },
  });

  sleep(1);
}
