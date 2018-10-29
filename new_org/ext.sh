#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# Use the CLI container to create the configuration transaction needed to add
# Org2 to the network
function createConfigTx () {
  echo
  echo "###############################################################"
  echo "####### Generate and submit config tx to add Org2 #############"
  echo "###############################################################"
  docker exec cli scripts/step1org2.sh $CHANNEL_NAME $CLI_DELAY $LANGUAGE $CLI_TIMEOUT $VERBOSE
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to create config tx"
    exit 1
  fi
}

# Generates Org2 certs using cryptogen tool
function generateCerts (){
  which cryptogen
  if [ "$?" -ne 0 ]; then
    echo "cryptogen tool not found. exiting"
    exit 1
  fi
  echo
  echo "###############################################################"
  echo "##### Generate Org2 certificates using cryptogen tool #########"
  echo "###############################################################"

  (cd org2-artifacts
   set -x
   cryptogen generate --config=./org2-crypto.yaml
   res=$?
   set +x
   if [ $res -ne 0 ]; then
     echo "Failed to generate certificates..."
     exit 1
   fi
  )
  echo
}

# Generate channel configuration transaction
function generateChannelArtifacts() {
  which configtxgen
  if [ "$?" -ne 0 ]; then
    echo "configtxgen tool not found. exiting"
    exit 1
  fi
  echo "##########################################################"
  echo "#########  Generating Org2 config material ###############"
  echo "##########################################################"
  (cd org2-artifacts
   export FABRIC_CFG_PATH=$PWD
   set -x
   configtxgen -printOrg Org2MSP > ../channel-artifacts/org2.json
   res=$?
   set +x
   if [ $res -ne 0 ]; then
     echo "Failed to generate Org2 config material..."
     exit 1
   fi
  )
  cp -r crypto-config/ordererOrganizations org2-artifacts/crypto-config/
  echo
}

# Generate the needed certificates, the genesis block and start the network.
function networkUp () {
  # generate artifacts if they don't exist
  if [ ! -d "org2-artifacts/crypto-config" ]; then
    generateCerts
    generateChannelArtifacts
    createConfigTx
  fi
  # start org2 peers
  IMAGE_TAG=$IMAGETAG docker-compose -f $COMPOSE_FILE_ORG2 up -d 2>&1
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to start Org2 network"
    exit 1
  fi
  echo
  echo "###############################################################"
  echo "############### Have Org2 peers join network ##################"
  echo "###############################################################"
  docker exec org2cli ./scripts/step2org2.sh $CHANNEL_NAME $CLI_DELAY $LANGUAGE $CLI_TIMEOUT $VERBOSE
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to have Org2 peers join network"
    exit 1
  fi
  echo
  echo "###############################################################"
  echo "##### Upgrade chaincode to have Org2 peers on the network #####"
  echo "###############################################################"
  docker exec cli ./scripts/step3org2.sh $CHANNEL_NAME $CLI_DELAY $LANGUAGE $CLI_TIMEOUT $VERBOSE
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to add Org2 peers on network"
    exit 1
  fi
  # finish by running the test
  # docker exec org2cli ./scripts/testorg2.sh $CHANNEL_NAME $CLI_DELAY $LANGUAGE $CLI_TIMEOUT $VERBOSE
  # if [ $? -ne 0 ]; then
  #   echo "ERROR !!!! Unable to run test"
  #   exit 1
  # fi
}

# If BYFN wasn't run abort
if [ ! -d crypto-config ]; then
  echo
  echo "ERROR: crypto-config must be exists"
  echo
  exit 1
fi

export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}
export VERBOSE=false

# timeout duration - the duration the CLI should wait for a response from
# another container before giving up
CLI_TIMEOUT=10
#default for delay
CLI_DELAY=3
# channel name defaults to "mychannel"
CHANNEL_NAME="mychannel"
# use this as the default docker-compose yaml definition
COMPOSE_FILE=docker-compose-cli.yaml
# use this as the default docker-compose yaml definition
COMPOSE_FILE_ORG2=docker-compose-org2.yaml
# use golang as the default language for chaincode
LANGUAGE=golang
# default image tag
IMAGETAG="latest"

echo "${EXPMODE} with channel '${CHANNEL_NAME}' and CLI timeout of '${CLI_TIMEOUT}' seconds and CLI delay of '${CLI_DELAY}' seconds"

#Create the network using docker compose
networkUp
