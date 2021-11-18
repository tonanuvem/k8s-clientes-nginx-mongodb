//# https://k6.io/docs/testing-guides/api-load-testing/

import http from 'k6/http';

export default function () {
  let msec = "teste_"+Date.parse(Date());
  const url = 'http://IP/api/clientes';
  const payload = JSON.stringify({
    fname: msec,
    lname: msec,
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  http.post(url, payload, params);
}
