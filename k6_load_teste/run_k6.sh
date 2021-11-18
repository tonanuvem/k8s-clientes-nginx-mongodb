URL = $(curl -s checkip.amazonaws.com)
sed -i 's|INSERIR_IP|'$URL'|' script.js
docker run -i loadimpact/k6 run - <script.js
