#!/bin/bash
#create a k3d cluster with definition file
k3d cluster create --config ./k3d/k3d-local-dev-cluster.yaml
#create namespace for the argocd installation
kubectl create namespace argocd
# install argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# the argo-cd intial admin password can be read with the following command:
# kubectl get secret argocd-initial-admin-secret -n argocd -o yaml
# OR
# replace it with your own fixed admin password
# https://www.browserling.com/tools/bcrypt
# bcrypt("jku-argocd-pass")=$2a$10$6kh.T.ID.kokPshuMstv/uKos5scx34pRrq6a6XSlYPmbS90z2O1C
kubectl -n argocd patch secret argocd-secret -p '{"stringData": {"admin.password": "$2a$10$IJDVisWb2JZd3cpvEBrAROyQJ1/xd.h/tUK1LKHi6Z5uAZjnpjU.i","admin.passwordMtime": "'$(date +%FT%T%Z)'"}}'

# start the GitOps with creation of argo-cd app
kubectl -n argocd apply -f ./argo-cd/argo-cd-app.yaml

#set up port forwarding
#kubectl port-forward svc/argocd-server -n argocd 8080:443
#URL https://localhost:8080

#port forwarding for guestbook microservice
#kubectl port-forward svc/helm-guestbook 9090:80
#access on http://localhost:9090/

