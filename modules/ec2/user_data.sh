#!/bin/bash

# Update system
yum update -y

# Install Docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker

# Pull and run app (replace with your Docker Hub image)
docker run -d -p 80:3000 chaitanyaaaa/devops-app:latest
