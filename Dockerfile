FROM jenkins/jnlp-slave
USER root
RUN apt-get update
RUN apt-get install -y apt-utils docker python-pip python-dev build-essential apt-transport-https ca-certificates curl software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get install -y docker-ce
RUN easy_install pip
RUN pip install awscli --upgrade
USER jenkins
RUN mkdir /home/jenkins/.gradle
RUN  mkdir /home/jenkins/.m2
