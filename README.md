# k8s_web_app
Kubernetes-Based Odoo ERP Platform
---------------------------------------
A lightweight infrastructure setup for deploying Odoo ERP with PostgreSQL and NGINX reverse proxy, using persistent volumes and container orchestration via Kubernetes or Docker.

Features
Containerized Odoo ERP and PostgreSQL services


NGINX reverse proxy to route requests to Odoo

Clean separation of services and persistent storage

Easily portable to Minikube, Docker, or any K8s environment

Stack Overview
Service	Purpose	Port
Odoo	ERP Frontend + Backend (Python)	8069
PostgreSQL	Database for Odoo	5432
NGINX	Reverse proxy for Odoo UI	80

Structure

odoo-k8s/
├── odoo-deployment.yaml         # Odoo + PVC + Service
├── postgres-deployment.yaml     # PostgreSQL + PVC + Service
├── nginx-deployment.yaml        # Reverse proxy for Odoo
├── pv/
│   ├── odoo-pv.yaml             # PersistentVolumeClaim for Odoo
│   └── postgres-pv.yaml         # PersistentVolumeClaim for PostgreSQL
├── config/
│   └── default.conf             # NGINX reverse proxy config
How to Deploy (Minikube or K8s)
bash
Copy
Edit
# Step 1: Create volumes
kubectl apply -f pv/postgres-pv.yaml
kubectl apply -f pv/odoo-pv.yaml

# Step 2: Deploy PostgreSQL
kubectl apply -f postgres-deployment.yaml

# Step 3: Deploy Odoo
kubectl apply -f odoo-deployment.yaml

# Step 4: Set up NGINX reverse proxy
kubectl create configmap nginx-config --from-file=config/default.conf
kubectl apply -f nginx-deployment.yaml
Access Odoo
minikube service nginx --url
Open the returned URL in your browser (usually http://<minikube-ip>:<nodePort>).

NGINX Config (example)
nginx
Copy
Edit
server {
    listen 80;

    location / {
        proxy_pass http://odoo:8069;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
Persistent Storage
Odoo data stored at: /mnt/data/odoo

PostgreSQL data stored at: /mnt/data/postgres

Make sure Minikube allows host path access to these folders.

Requirements
kubectl, minikube, or compatible K8s cluster Docker

