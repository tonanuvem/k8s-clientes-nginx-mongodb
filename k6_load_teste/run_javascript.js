import http from 'k6/http';

export default function () {
  let msec = "teste_"+Math.round(Date.parse(Date())*Math.random());
  const url = 'http://INSERIR_IP:32500/api/clientes';
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
  http.get(url);
}
