#!/bin/bash

echo "Deploying SonarQube with PostgreSQL..."

# Create namespace if not exists
kubectl apply -f sonarqube-namespace.yaml

# Create directories for hostPath volumes
echo "Creating directories for persistent storage..."
sudo mkdir -p /mnt/data/postgresql
sudo mkdir -p /mnt/data/sonarqube
sudo chmod 777 /mnt/data/postgresql /mnt/data/sonarqube

echo "Step 1: Deploying PostgreSQL..."
# Deploy PostgreSQL first
kubectl apply -f postgresql-pvc.yaml
kubectl apply -f sonarqube-postgresql-deployment.yaml
kubectl apply -f postgresql-service.yaml

echo "Waiting for PostgreSQL to be ready (60 seconds)..."
sleep 60

# Check PostgreSQL status
echo "PostgreSQL status:"
kubectl get pods -n sonarqube -l app=postgresql

# Check if PostgreSQL is running
POSTGRES_POD=$(kubectl get pods -n sonarqube -l app=postgresql -o jsonpath='{.items[0].metadata.name}')
if kubectl get pod -n sonarqube $POSTGRES_POD | grep -q Running; then
    echo "PostgreSQL is running!"
else
    echo "PostgreSQL is not running. Checking logs..."
    kubectl logs -n sonarqube $POSTGRES_POD
    exit 1
fi

echo "Step 2: Deploying SonarQube..."
# Deploy SonarQube
kubectl apply -f sonarqube-pvc.yaml
kubectl apply -f sonarqube-deployment.yaml
kubectl apply -f sonarqube-service.yaml

echo "SonarQube deployment initiated!"
echo "Note: SonarQube takes 2-3 minutes to start completely."

# Show status
echo ""
echo "Current status:"
kubectl get all,pvc -n sonarqube

echo ""
echo "To monitor SonarQube startup:"
echo "kubectl logs -f deployment/sonarqube -n sonarqube"
echo ""
echo "To access SonarQube:"
echo "1. Wait for pod to be in Running state"
echo "2. Port forward: kubectl port-forward service/sonarqube-service -n sonarqube 9000:9000"
echo "3. Access at: http://localhost:9000"
echo "   Default credentials: admin/admin"