#!/bin/sh

echo "lets clean up first:"
# exec as root

#k3s commands
kubectl delete deployments --all --force --namespace ci-cd
kubectl delete services --all --force --namespace ci-cd
kubectl delete pods --all --force --namespace ci-cd
kubectl delete ing --all --force --namespace ci-cd
kubectl delete roles --all --force --namespace ci-cd
kubectl delete RoleBinding --all --force --namespace ci-cd
kubectl delete daemonset --all --force  --namespace ci-cd


echo "deploy the cluster:"

kubectl apply -f ../cluster/namespaces.yaml


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


#watch kubectl get nodes,pods,svc,ing,services,deployments,secrets


