# Echo Kubernetes Automation
**About:**

This project if a full automation of k8s.
It use the following:
* Terraform - Provisionning
* Jenkins   -   CI - building and publishing 
* Flux  - CD - deploying
* (ELK) Elasticsearch, Logstash & Kibana    - logging
* Prometheos & Garphana - Monitoring
* MongoDB - Presisstence
* Nginx - Web Server
* CertManeger - TLS Certificate Automation
* Node.js - restFul API

**Prerequisites:**

* Before you start, make sure this command line tools have been installed:
    * docker
    * gcloud
    * kubectl
    * helm
    * terraform
    * fluxctl

**How to use:**

* First time use:
    1) Add environment variable to `secret-template.sh` and rename it to `secret.sh`:
    ```sh
        export GCP_PROJECT=my_project
        export GCP_ACCOUNT_NAME=my_account
        export GCP_ACCOUNT_ADDRESS=my_address
        export CLUSTER_NAME=my_cluster
        export DB_USER=my_usr
        export DB_PASS=_my_pass
    ```   
    ii. set up the project with: 
   ```sh
       sh Set-Up-Project.sh
   ```    
        
        
* Deploying cluster:
    ```sh
        sh Deploy.sh
    ```
* Teardown cluster:
    ```sh
        terraform destroy
    ```
         
**How dose it work?:**
* Set-up:                  
1) Log in to GCP using browser authentication
2) Create the project
3) Create authentication account and token
4) Push default Docker image on to GCR
5) Build and Push Jenkins image on to GCR 

* Deploy:

1) Terraform Provision cluster as configured in `cluster.tf`
2) Secrets for DB and Git access are been deployed localy.
3) Helm chart for infrastructure are installed
(CI/CD, Monitoring, Loggin, Certificate Management, DB).
4) Flux CD Deploy automatically Production, Staging & Development API Relese according to the `k8/flux-config`  


