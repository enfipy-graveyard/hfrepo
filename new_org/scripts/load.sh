#!/bin/bash

(
  PEER=${HOST_PEER:=peer3}
  cd explorer
  jq '."network-config".org1 += {"'${PEER}'": { "requests": "grpc://'${PEER}'org1:7051", "events": "grpc://'${PEER}'org1:7053", "server-hostname": "'${PEER}'.org1.example.com"}}' config.json > heh.json
  mv heh.json config.json
)
