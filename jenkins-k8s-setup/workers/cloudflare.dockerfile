FROM jenkins/inbound-agent:latest-jdk21

USER root

# Install vim for debian
RUN apt-get update && apt-get install -y vim

# Install cloudflared (Cloudflare CLI)
RUN mkdir -p --mode=0755 /usr/share/keyrings
RUN curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main" | tee /etc/apt/sources.list.d/cloudflared.list
RUN apt-get update && apt-get install cloudflared -y
RUN mkdir /etc/cloudflared
# End install cloudflared


USER jenkins

WORKDIR /home/jenkins