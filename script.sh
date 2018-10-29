export CHANNEL_NAME=mychannel
CORE_PEER_ADDRESS=peer1org1:7051

CORE_PEER_LOCALMSPID="Org1MSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/peer

peer channel fetch 0 mychannel.block --channelID mychannel --orderer orderer.example.com:7050

CORE_PEER_ADDRESS=peer1org1:7051

peer channel join -b mychannel.block

extra_hosts:
  - "peer1.org1.example.com:54.224.120.200
extra_hosts:
  - "peer1.org1.example.com:54.224.120.200

docker run --rm -it --network="basic" --name couchdb1 -p 6984:5984 -e COUCHDB_USER= -e COUCHDB_PASSWORD= -e CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=basic hyperledger/fabric-couchdb



docker network create --attachable --driver overlay basic




docker service create \
--network basic \
--constraint node.hostname==ip-172-31-23-232.ec2.internal \
--name couchdb1 -p 6984:5984 \
-e COUCHDB_USER= -e COUCHDB_PASSWORD= -e CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=basic \
hyperledger/fabric-couchdb

docker service create \
--network basic --replicas 1 \
--constraint node.hostname==ip-172-31-23-232.ec2.internal \
--name peer1org1 -p 7151:7051 -p 8053:7053 -e CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock \
-e CORE_PEER_ID=peer1.org1.example.com -e CORE_LOGGING_PEER=debug \
-e CORE_CHAINCODE_LOGGING_LEVEL=DEBUG -e CORE_PEER_LOCALMSPID=Org1MSP \
-e CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/peer/ -e CORE_PEER_ADDRESS=peer1org1:7051 \
-e CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=${COMPOSE_PROJECT_NAME}_basic -e CORE_LEDGER_STATE_STATEDATABASE=CouchDB \
-e CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=couchdb1:5984 \
-e CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME= -e CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD= \
-w /opt/gopath/src/github.com/hyperledger/fabric \
--mount type=bind,src=/var/run/,dst=/host/var/run/ \
--mount type=bind,src=/home/centos/fabricdev/crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/msp,dst=/etc/hyperledger/msp/peer \
--mount type=bind,src=/home/centos/fabricdev/crypto-config/peerOrganizations/org1.example.com/users,dst=/etc/hyperledger/msp/users \
--mount type=bind,src=/home/centos/fabricdev/config,dst=/etc/hyperledger/configtx \
--mount type=bind,src=/home/centos/fabricdev/volumes/peer1,dst=/var/hyperledger/production \
hyperledger/fabric-peer peer node start

docker run --rm -it --network="basic" --name cli --link orderer.example.com:orderer.example.com --link peer0.org1.example.com:peer0.org1.example.com --link peer1.org1.example.com:peer1.org1.example.com -p 12051:7051 -p 12053:7053 -e GOPATH=/opt/gopath -e CORE_PEER_LOCALMSPID=Org1MSP -e CORE_PEER_TLS_ENABLED=false -e CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock -e CORE_LOGGING_LEVEL=DEBUG -e CORE_PEER_ID=cli -e CORE_PEER_ADDRESS=peer1org1:7051 -e CORE_PEER_NETWORKID=cli -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp -e CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=basic -v /home/centos/chaincode/:/opt/gopath/src/github.com/petroleum/ -v /var/run/:/host/var/run/ -v $(pwd)/chaincode/:/opt/gopath/src/github.com/hyperledger/fabric/examples/chaincode/go -v $(pwd)/crypto-config:/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ -v $(pwd)/scripts:/opt/gopath/src/github.com/hyperledger/fabric/peer/scripts/ -v $(pwd)/channel-artifacts:/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts -w /opt/gopath/src/github.com/hyperledger/fabric/peer hyperledger/fabric-tools /bin/bash


docker volume create --driver nfs --opt device=:/var/run var-run
docker volume create --driver nfs --opt device=:/home/centos/fabricdev/crypto-config/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/msp peer2-msp
docker volume create --driver nfs --opt device=:/home/centos/fabricdev/crypto-config/peerOrganizations/org1.example.com/users org-users
docker volume create --driver nfs --opt device=:/home/centos/fabricdev/config config
docker volume create --driver nfs --opt device=:/home/centos/fabricdev/volumes/peer2 peer2



docker volume create --driver local --opt type=nfs --opt o=addr=192.168.1.1,uid=1000,gid=1000,rw --opt device=:/var/run var-run

docker volume create --driver local --opt type=nfs --opt o=addr=192.168.1.1,uid=1000,gid=1000,rw --opt device=:/home/centos/fabricdev/crypto-config/peerOrganizations/org1.example.com/peers/peer2.org1.example.com/msp peer2-msp

docker volume create --driver local --opt type=nfs --opt o=addr=192.168.1.1,uid=1000,gid=1000,rw --opt device=:/home/centos/fabricdev/crypto-config/peerOrganizations/org1.example.com/users org-users

docker volume create --driver local --opt type=nfs --opt o=addr=192.168.1.1,uid=1000,gid=1000,rw --opt device=:/home/centos/fabricdev/config config

docker volume create --driver local --opt type=nfs --opt o=addr=192.168.1.1,uid=1000,gid=1000,rw --opt device=:/home/centos/fabricdev/volumes/peer2 peer2



docker service create \
--network basic \
--constraint node.hostname==ip-172-31-17-67.ec2.internal \
--name couchdb2 -p 7984:5984 \
-e COUCHDB_USER= -e COUCHDB_PASSWORD= -e CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=basic \
hyperledger/fabric-couchdb

docker service create \
--network basic --replicas 1 \
--constraint node.hostname==ip-172-31-17-67.ec2.internal \
--name peer2org1 -p 9051:7051 -p 9053:7053 -e CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock \
-e CORE_PEER_ID=peer2.org1.example.com -e CORE_LOGGING_PEER=debug \
-e CORE_CHAINCODE_LOGGING_LEVEL=DEBUG -e CORE_PEER_LOCALMSPID=Org1MSP \
-e CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/peer/ -e CORE_PEER_ADDRESS=peer2org1:7051 \
-e CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=${COMPOSE_PROJECT_NAME}_basic -e CORE_LEDGER_STATE_STATEDATABASE=CouchDB \
-e CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=couchdb2:5984 \
-e CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME= -e CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD= \
-w /opt/gopath/src/github.com/hyperledger/fabric \
--mount type=volume,src=var-run,dst=/host/var/run/ \
--mount type=volume,src=peer2-msp,dst=/etc/hyperledger/msp/peer \
--mount type=volume,src=org-users,dst=/etc/hyperledger/msp/users \
--mount type=volume,src=config,dst=/etc/hyperledger/configtx \
--mount type=volume,src=peer2,dst=/var/hyperledger/production \
hyperledger/fabric-peer peer node start
