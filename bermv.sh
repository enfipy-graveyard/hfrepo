#!/bin/bash
set -e

remPeer() {
  (
    PEER=$1
    cd explorer
    jq 'del(.. | .'${PEER}'?)' config.json > heh.json
    mv heh.json config.json
  )
}

if [ -z "$PEER" ]; then
  echo "Parameter PEER is empty"
  exit 1
fi

remPeer $PEER
docker-compose up -d --force-recreate blockchain-explorer
