#!/bin/bash
# https://k6.io/docs/testing-guides/api-load-testing/

echo "Digite o IP para teste de carga"
read URL
#URL=$(curl -s checkip.amazonaws.com)
curl -s https://raw.githubusercontent.com/tonanuvem/k8s-clientes-nginx-mongodb/master/k6_load_teste/script.js
sed -i 's|INSERIR_IP|'$URL'|' script.js
docker run -i loadimpact/k6 --vus 1000 --iterations 10000 run - <script.js
