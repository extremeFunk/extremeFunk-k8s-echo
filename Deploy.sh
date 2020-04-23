#!/bin/sh

# Add secret environment variable
# Rename file "secret-template.sh" to secret.sh
# Modify content for your project
. secret.sh

terraform init
terraform apply -auto-approve \
-var cluster_name=$CLUSTER_NAME \
-var project=$GCP_PROJECT

gcloud container clusters get-credentials $CLUSTER_NAME \
--region us-central1

kubectl apply -f k8/namespaces

DB_URL=mongo-mongodb.db.svc.cluster.local:27017
PROD_DB=$(echo mongodb://$DB_USER:$DB_PASS@$DB_URL/echo | base64 -w 0)
STAGE_DB=$(echo mongodb://$DB_USER:$DB_PASS@$DB_URL/echo-stage | base64 -w 0)

kubectl create secret generic echo-db -n production \
--from-literal echo-prod=$PROD_DB
kubectl create secret generic echo-db -n staging \
--from-literal echo-stage=$STAGE_DB

helm install cert-manager k8/helm/cert-manager -n cert-manager
helm install nginx k8/helm/nginx -n nginx
helm install mongo k8/helm/mongodb -n db \
--set mongodbUsername=$DB_USER \
--set mongodbPassword=$DB_PASS
helm install prometheus k8/helm/prometheus-operator -n monitoring
helm install es-op k8/helm/elasticsearch-operator -n loggin
helm install efk k8/helm/efk -n loggin
helm install flux k8/helm/flux -n fluxcd --wait
helm install helm-operator k8/helm/helm-operator -n fluxcd

fluxctl identity --k8s-fwd-ns fluxcd

echo "upload this key to git with name = flux-key"
echo "add dns name - press any key"
read userin

fluxctl sync --k8s-fwd-ns fluxcd