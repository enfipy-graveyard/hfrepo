#!/bin/bash
set -e

addPeer() {
  (
    PEER=$1
    cd explorer
    jq '."network-config".org1 += {"'${PEER}'": { "requests": "grpc://'${PEER}'org1:7051", "events": "grpc://'${PEER}'org1:7053", "server-hostname": "'${PEER}'.org1.example.com"}}' config.json > heh.json
    mv heh.json config.json
  )
}

if [ -z "$PEER" ]; then
  echo "Parameter PEER is empty"
  exit 1
fi

addPeer $PEER
docker-compose up -d --force-recreate blockchain-explorer
