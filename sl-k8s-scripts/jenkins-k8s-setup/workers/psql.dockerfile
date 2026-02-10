FROM rdomloge/jenkins-worker-kubectl:1.0.0

USER root

# Install psql
RUN apt-get update && apt-get install -y postgresql-client

USER jenkins

WORKDIR /home/jenkins