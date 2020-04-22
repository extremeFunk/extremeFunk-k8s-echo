#!/bin/sh

CLUSTER_NAME=echo-cluster

terraform init
terraform apply -auto-approve \
-var cluster_name=$CLUSTER_NAME \
-var project=$GCP_PROJECT

gcloud container clusters get-credentials $CLUSTER_NAME \
--region us-central1

kubectl apply -f k8/namespaces
kubectl apply -f k8/secrets/prod.yaml -n production
kubectl apply -f k8/secrets/stage.yaml -n staging

helm install cert-manager k8/helm/cert-manager -n cert-manager
helm install nginx k8/helm/nginx -n nginx
helm install mongo k8/helm/mongodb -n db
helm install prometheus k8/helm/prometheus-operator -n monitoring
helm install es-op k8/helm/elasticsearch-operator -n loggin
helm install efk k8/helm/efk -n loggin
helm install flux k8/helm/flux -n fluxcd --wait
helm install helm-operator k8/helm/helm-operator -n fluxcd

fluxctl identity --k8s-fwd-ns fluxcd

echo "upload this key to git with name = flux-key"
echo "add dns name - press any key"
echo "add database with name echo-stageing - press any key"
read userin

fluxctl sync --k8s-fwd-ns fluxcd