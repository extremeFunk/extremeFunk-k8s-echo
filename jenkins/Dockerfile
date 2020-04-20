FROM jenkins/jenkins:lts

USER root
RUN echo "root:pass" | chpasswd

RUN curl -sSL https://get.docker.com/ | sh
RUN usermod -aG docker jenkins
ENV DOCKER_HOST unix:///var/run/docker.sock

RUN apt-get update
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get install apt-transport-https ca-certificates gnupg -y
RUN apt-get update
RUN apt-get install google-cloud-sdk -y

COPY --chown=jenkins jenkins_home /var/jenkins_home

COPY jenkins-plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

COPY gcp_crd.json /gcp_crd.json

ARG GCP_PROJECT
RUN gcloud auth activate-service-account rainrobot@$GCP_PROJECT.iam.gserviceaccount.com --key-file=/gcp_crd.json

USER jenkins