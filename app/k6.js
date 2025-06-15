import http from 'k6/http';
import { check } from 'k6';

export const options = {
  vus: 5,
  duration: '5s',
};

export default function () {
  const res = http.get('https://test.k6.io/');
  check(res, {
    'status is 200': (r) => r.status === 200,
  });
}