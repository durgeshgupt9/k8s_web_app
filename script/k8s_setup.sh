#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}>>> Updating system and installing dependencies...${NC}"
sudo apt update && sudo apt install -y \
  curl wget apt-transport-https ca-certificates gnupg lsb-release conntrack

echo -e "${GREEN}>>> Installing kubectl...${NC}"
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

echo -e "${GREEN}>>> Installing Docker...${NC}"
sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker "$USER"

echo -e "${GREEN}>>> Docker installed. You may need to log out and log in again to activate docker group.${NC}"

echo -e "${GREEN}>>> Installing Minikube...${NC}"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm -f minikube-linux-amd64
minikube version

echo -e "${GREEN}>>> Starting Minikube with Docker driver...${NC}"
minikube start --driver=docker --cpus=2 --memory=2048

echo -e "${GREEN}Kubernetes (Minikube) environment setup complete!${NC}"
