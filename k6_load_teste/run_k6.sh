#!/bin/bash
# https://k6.io/docs/testing-guides/api-load-testing/

echo "Digite o IP para teste de carga"
read URL
LOCAL=$(curl -s checkip.amazonaws.com)
sed -i 's|INSERIR_IP|'$URL'|' script.js
docker run -i loadimpact/k6 --vus 500 --iterations 1000 run - <script.js
