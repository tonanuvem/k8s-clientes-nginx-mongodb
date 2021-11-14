#!/bin/bash

# Hey : script que pode ser usados
# https://github.com/rakyll/hey
# hey -n 10 -c 2 -m POST -T "application/x-www-form-urlencoded" -d 'username=1&message=hello' http://your-rest-url/resource

IP=localhost
NUM=100
SLEEP=0.5
NOW=`date +%Y-%m-%d_%H-%M-%S`

for i in 'seq $NUM'
do    
    curl -X POST "http://$IP:32500/api/clientes" -H "accept: */*" -H "Content-Type: application/json" \
      -d "{  \"fname\": \"teste_$i_$NOW\", \"lname\": \"teste_$i_$NOW\" }";
    sleep $SLEEP
done
