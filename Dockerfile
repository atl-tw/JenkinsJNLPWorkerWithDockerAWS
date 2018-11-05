FROM openjdk:8-jdk-stretch

ENV HOME /root
LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="3.23"

USER root

ARG VERSION=3.26
ARG AGENT_WORKDIR=/root/agent
RUN apt-get update
RUN apt-get install -y curl bash git openssh-client openssl procps unzip
RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar 
RUN curl https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator > /usr/local/bin/aws-iam-authenticator && chmod a+x /usr/local/bin/aws-iam-authenticator
RUN curl https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/kubectl > /usr/local/bin/kubectl && chmod a+x /usr/local/bin/kubectl
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /root/.jenkins && mkdir -p ${AGENT_WORKDIR}
RUN curl https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip > terraform.zip \
  && unzip terraform.zip && mv terraform /usr/local/bin

VOLUME /root/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /root

RUN apt-get install -y apt-utils docker python-pip python-dev build-essential apt-transport-https ca-certificates curl software-properties-common jq
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y docker-ce mono-runtime mono-devel
RUN easy_install pip
RUN pip install awscli --upgrade
RUN mkdir /root/.gradle
RUN mkdir /root/.m2
RUN curl https://raw.githubusercontent.com/jenkinsci/docker-jnlp-slave/master/jenkins-slave > /usr/local/bin/jenkins-slave
RUN chmod +x /usr/local/bin/jenkins-slave
ENTRYPOINT ["jenkins-slave"]
