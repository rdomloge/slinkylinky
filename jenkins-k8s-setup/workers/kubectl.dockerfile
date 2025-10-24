FROM jenkins/inbound-agent:latest-jdk21

USER root

# Install vim for debian
RUN apt-get update && apt-get install -y vim

# Install kubectl
ENV KUBECTL_VERSION=1.33.0

# Download and install kubectl
RUN dpkgArch="$(dpkg --print-architecture)"; \
    curl -LO https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${dpkgArch}/kubectl && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

RUN chmod +x kubectl
RUN mkdir -p /home/jenkins/.local/bin
RUN mv ./kubectl /home/jenkins/.local/bin/kubectl
# and then append (or prepend) ~/.local/bin to $PATH
ENV PATH=/home/jenkins/.local/bin:$PATH

USER jenkins

WORKDIR /home/jenkins