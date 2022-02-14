#!/bin/sh

GITEA_CLIENT_ID_FILE="../cluster/.drone-gitea-client-id.txt"
GITEA_CLIENT_SECRET_FILE="../cluster/.drone-gitea-client-secret.txt"

if [ -f "$GITEA_CLIENT_ID_FILE" ]; then
    echo "$GITEA_CLIENT_ID_FILE exists. "
else 
    echo "$GITEA_CLIENT_ID_FILE does not exist. Please add the gitea CLIENT ID to the file (w/o line breaks) and run this script again." 
    touch $GITEA_CLIENT_ID_FILE
    chown ubuntu:ubuntu $GITEA_CLIENT_ID_FILE
    exit
fi

if [ -f "$GITEA_CLIENT_SECRET_FILE" ]; then
    echo "$GITEA_CLIENT_SECRET_FILE exists. "
else 
    echo "$GITEA_CLIENT_SECRET_FILE does not exist. Please add the gitea CLIENT SECRET to the file (w/o line breaks) and run this script again." 
    touch $GITEA_CLIENT_SECRET_FILE
    chown ubuntu:ubuntu $GITEA_CLIENT_SECRET_FILE
    exit
fi

kubectl create secret generic drone-gitea \
  --from-file=drone-gitea-client-id=$GITEA_CLIENT_ID_FILE \
  --from-file=drone-gitea-client-secret=$GITEA_CLIENT_SECRET_FILE \
  --namespace  ci-cd 

  