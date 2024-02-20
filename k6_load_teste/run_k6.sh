#!/bin/bash
# https://k6.io/docs/testing-guides/api-load-testing/
# https://github.com/benc-uk/k6-reporter

DIR_ATUAL=$(pwd)
cd /home/ubuntu/environment/config/shift/
MASTER=$(terraform output -json ip_externo | jq .[] | jq .[0] | sed 's/"//g')
URL=$MASTER
cd $DIR_ATUAL

if [ $(echo $URL | grep . | wc -l) = "0" ]
then
  echo "Não foi possível verificar o IP do Master. Você está rodando o script no Cloud9 ?"
  exit
fi

echo "IP para teste de carga"
echo $URL
sed -i 's|INSERIR_IP|'$URL'|' run_javascript.js

#docker run -i loadimpact/k6 --vus 100 --iterations 2000 run - <run_javascript.js
docker run -i grafana/k6 --vus 100 --iterations 2000 run - <run_javascript.js

sed -i 's|'$URL'|INSERIR_IP|' run_javascript.js
