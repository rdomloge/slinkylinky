FROM jenkins/inbound-agent:latest-jdk21

USER root

# Create /tools directory
RUN mkdir -p /tools

# Install Maven
ENV MAVEN_VERSION=3.9.7
ENV MAVEN_HOME=/tools/maven
ENV PATH=$MAVEN_HOME/bin:$PATH

# Download and extract Maven
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    | tar -xz -C /tools && \
    mv /tools/apache-maven-${MAVEN_VERSION} $MAVEN_HOME

# @@@@@@@ I N S T A L L   D O C K E R @@@@@@@
RUN apt update 
RUN apt-get install ca-certificates curl
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# @@@@@@@ I N S T A L L   D O C K E R @@@@@@@

# USER jenkins <--- Can't do this, as much as I'd like, because then we can't use the docker socket on the host

WORKDIR /home/jenkins