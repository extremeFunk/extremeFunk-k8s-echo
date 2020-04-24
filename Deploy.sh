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
PROD_DB=$(echo mongodb://$DB_USER:$DB_PASS@$DB_URL/echo)
STAGE_DB=$(echo mongodb://$DB_USER:$DB_PASS@$DB_URL/echo-stage)

kubectl create secret generic echo-db -n production \
--from-literal MONGODBURL=$PROD_DB
kubectl create secret generic echo-db -n staging \
--from-literal MONGODBURL=$STAGE_DB
kubectl -n fluxcd create secret generic git-key \
--from-file=./identity

helm install cert-manager k8/helm/cert-manager -n cert-manager --wait
helm install nginx k8/helm/nginx -n nginx
helm install mongo k8/helm/mongodb -n db \
--set mongodbRootPassword=$DB_ROOT_PSS \
--set mongodbUsername=$DB_USER \
--set mongodbPassword=$DB_PASS
helm install prometheus k8/helm/prometheus-operator -n monitoring
helm install es-op k8/helm/elasticsearch-operator -n loggin --wait
helm install efk k8/helm/efk -n loggin
helm install flux k8/helm/flux -n fluxcd --wait
helm install helm-operator k8/helm/helm-operator -n fluxcd
helm install jenkins k8/helm/jenkins -n jenkins

kubectl exec -n db mongo-mongodb-primary-0 -it -- \
mongo echo-stage --authenticationDatabase admin \
-u $DB_ROOT_USR -p $DB_ROOT_PSS --eval \
"db.createUser( { user: '$DB_USER' , pwd: '$DB_PASS', roles: ['readWrite'] } )"

fluxctl sync --k8s-fwd-ns fluxcd