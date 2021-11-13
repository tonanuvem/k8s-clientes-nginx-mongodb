#!/bin/bash

# https://github.com/rakyll/hey

IP=localhost
NUM=100
SLEEP=0.5
NOW=$(date)

for i in 'seq $NUM'
do
  curl -X POST --header 'Content-Type: application/json' --header 'Accept: text/html' -d '{ \ 
     "fname": "teste_$i_$NOW", \ 
     "lname": "teste_$i_$NOW" \ 
   }' 'http://$IP:32500/api/clientes'
   sleep $SLEEP
done
