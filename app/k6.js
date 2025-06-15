import http from 'k6/http';
import { check } from 'k6';

export const options = {
  vus: 5,
  duration: '15s',
};

export default function () {
  const res = http.get('https://www.higuchi-dev.jp/');
  check(res, {
    'status is 200': (r) => r.status === 200,
  });
}