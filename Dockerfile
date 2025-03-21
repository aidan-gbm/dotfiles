FROM docker.io/debian:12
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && \
    apt-get -qq install sudo wget python3 python3-venv && \
    useradd -Ums /bin/bash user && \
    usermod -aG sudo user && \
    echo "user:password" | chpasswd
WORKDIR /home/user
USER user
