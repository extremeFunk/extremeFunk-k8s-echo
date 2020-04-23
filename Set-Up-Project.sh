#!/bin/sh

# Add secret environment variable
# Rename file "secret-template.sh" to secret.sh
# Modify content for your project
. secret.sh

echo "Please authenticate GCP account - press any key"
read userin
gcloud auth login

# Configuring gcp
gcloud projects create $GCP_PROJECT --name $GCP_PROJECT
gcloud config set project $GCP_PROJECT
gcloud iam service-accounts create $GCP_ACCOUNT_NAME
gcloud projects add-iam-policy-binding $GCP_PROJECT \
--member "serviceAccount:$GCP_ACCOUNT_ADDRESS" \
--role "roles/owner"
gcloud iam service-accounts keys create gcp_crd.json \
 --iam-account $GCP_ACCOUNT_ADDRESS
gcloud auth configure-docker > /dev/null

cp gcp_crd.json jenkins/gcp_crd.json
cd jenkins
docker  docker build --build-arg GCP_PROJECT=$GCP_PROJECT \
-t us.gcr.io/$GCP_PROJECT/jenkins .
docker push us.gcr.io/$GCP_PROJECT/jenkins
cd ..
