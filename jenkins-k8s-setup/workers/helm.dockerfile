FROM jenkins/inbound-agent:latest-jdk21

USER root

# Install Helm
RUN apt-get update && apt-get install -y curl gpg apt-transport-https
RUN curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
RUN apt-get update
RUN apt-get install -y helm
# End install Helm



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
# End install kubectl



USER jenkins

WORKDIR /home/jenkins