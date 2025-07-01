#!/bin/bash

set -e

echo ">>> Stopping and deleting Minikube..."
minikube stop
minikube delete

echo ">>> Removing kubectl..."
sudo rm -f /usr/local/bin/kubectl
sudo apt remove -y kubectl
sudo snap remove kubectl || true

echo ">>> Removing Minikube..."
sudo rm -f /usr/local/bin/minikube
rm -rf ~/.minikube ~/.kube

echo ">>> Uninstalling Docker..."
sudo apt remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt purge -y docker-ce docker-ce-cli containerd.io
sudo rm -rf /var/lib/docker /etc/docker
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -f /etc/apt/keyrings/docker.gpg

echo ">>> Cleaning up unused dependencies..."
sudo apt autoremove -y
sudo apt clean

echo ">>> Optional: removing docker group..."
sudo groupdel docker || true

echo "Cleaned up Kubernetes and Docker environment."
