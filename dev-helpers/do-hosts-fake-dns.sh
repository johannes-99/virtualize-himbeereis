#!/bin/sh

#run this script only after the cluster ist up and running

sudo cp /etc/hosts /etc/hosts.bak
#clean up previous entries:
sudo awk '!/ gitea| drone| myregistry/' /etc/hosts | sudo tee /etc/hosts-new >/dev/null && sudo mv /etc/hosts-new /etc/hosts

echo "$( kubectl get ing -n default -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}' 2> /dev/null) gitea"    | sudo tee -a /etc/hosts
echo "$( kubectl get ing -n default -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}' 2> /dev/null) drone"    | sudo tee -a /etc/hosts
echo "192.168.178.36 myregistry" | sudo tee -a /etc/hosts #we don't want to use the registry on wsl2 node. so we hard code it to the k3s cluster

