#!/bin/bash

# Hey : script que pode ser usados
# https://github.com/rakyll/hey
# curl -s https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64 -o hey && chmod +x hey
# hey -n 10 -c 2 -m POST -T "application/x-www-form-urlencoded" -d 'username=1&message=hello' http://your-rest-url/resource
# docker run --rm ricoli/hey -n 10 -c 2 -m POST -T "application/x-www-form-urlencoded" http://localhost:32500/api/clientes -d \
#   "fname=teste_$RANDOM&lname=teste_$RANDOM"

IP=localhost
NUM=100
SLEEP=0.5
NOW=`date +%Y-%m-%d_%H-%M-%S`

for i in $(seq $NUM); 
do    
    #printf "\tTeste $i: "
    NUMRANDOM=$RANDOM
    curl -X POST "http://$IP:32500/api/clientes" -H "accept: */*" -H "Content-Type: application/json" \
      -d "{  \"fname\": \"teste_$NOW_$NUMRANDOM\", \"lname\": \"teste_$NOW_$NUMRANDOM\" }"
    sleep $SLEEP
    #printf ""
done
