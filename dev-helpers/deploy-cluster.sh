#!/bin/sh

echo "lets clean up first:"
# exec as root

#k3s commands
kubectl delete deployments --all --force
kubectl delete services --all --force
kubectl delete pods --all --force
kubectl delete ing --all --force
kubectl delete roles --all --force
kubectl delete RoleBinding --all --force
kubectl delete daemonset --all --force 



echo "deploy the cluster:"


kubectl create -f ../cluster/drone-deployment.yaml
kubectl create -f ../cluster/gitea-deployment.yaml
kubectl create -f ../cluster/drone-runner-deployment.yaml
kubectl create -f ../cluster/drone-runner-roles.yaml
kubectl create -f ../cluster/registry-deployment.yaml

kubectl apply -f ../cluster/drone-service.yaml
kubectl apply -f ../cluster/gitea-service.yaml
kubectl apply -f ../cluster/registry-service.yaml
kubectl apply -f ../cluster/kubernetes-dashboard.yaml

kubectl create -f ../cluster/ingress.yaml


watch kubectl get nodes,pods,svc,ing,services,deployments


