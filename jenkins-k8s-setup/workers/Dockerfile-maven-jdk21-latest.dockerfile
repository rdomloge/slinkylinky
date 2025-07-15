FROM jenkins/inbound-agent:latest-jdk21

USER root

# Create /tools directory
RUN mkdir -p /tools

# Install Maven
ENV MAVEN_VERSION=3.9.7
ENV MAVEN_HOME=/tools/maven
ENV PATH=$MAVEN_HOME/bin:$PATH

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    | tar -xz -C /tools && \
    mv /tools/apache-maven-${MAVEN_VERSION} $MAVEN_HOME

USER jenkins