#!/bin/bash

export GCP_PROJECT=echo-k8s-project
export GCP_ACCOUNT_NAME=rainrobot
export GCP_ACCOUNT_ADDRESS=$GCP_ACCOUNT_NAME@$GCP_PROJECT.iam.gserviceaccount.com
#export TF_VAR_project=$GCP_PROJECT