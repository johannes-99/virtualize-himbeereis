#!/bin/sh

DRONE_RPC_FILE="../cluster/.drone-rpc-secret.txt"
echo -n `openssl rand -hex 20` > $DRONE_RPC_FILE

kubectl create secret generic drone-rpc-secret \
  --from-file=drone-rpc-secret=$DRONE_RPC_FILE \
  --namespace  ci-cd 

rm $DRONE_RPC_FILE
  