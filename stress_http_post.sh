#!/bin/bash

# Hey : script que pode ser usados
# https://github.com/rakyll/hey
# curl -s https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64 -o hey && chmod +x hey
# hey -n 10 -c 2 -m POST -T "application/x-www-form-urlencoded" -d 'username=1&message=hello' http://your-rest-url/resource
# docker run --rm ricoli/hey -n 200 -c 2 -m GET -H "Content-Type: application/json" http://$(curl checkip.amazonaws.com):32500/api/clientes
# docker run --rm ricoli/hey -n 10 -c 2 -m POST -H "Content-Type: application/json" -d "fname=teste_$RANDOM&lname=teste_$RANDOM" http://$(curl checkip.amazonaws.com):32500/api/clientes 

echo ""

IP=$(curl -s checkip.amazonaws.com)
NUM=1000
SLEEP=0.1

for i in $(seq $NUM); 
do    
    printf "\tTeste $i: "
    NOW=`date +_%N_%Y-%m-%d_%H-%M-%S`
    curl -X POST "http://$IP:32500/api/clientes" -H "accept: */*" -H "Content-Type: application/json" \
      -d "{  \"fname\": \"teste_$NOW\", \"lname\": \"teste_$NOW\" }"
    sleep $SLEEP
    printf "\n"
done

echo ""

echo "Quantidade de registros inseridos no BD:"
echo $(curl  -s -X GET "http://$IP:32500/api/clientes" -H "accept: */*" -H "Content-Type: application/json" | grep fname | wc -l)
echo ""
