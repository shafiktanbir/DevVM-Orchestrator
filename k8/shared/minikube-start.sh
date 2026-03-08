#!/usr/bin/env bash
# Start minikube and wait until the cluster is ready.
set -e
echo "Starting minikube..."
minikube start
echo "Waiting for cluster to be ready..."
kubectl cluster-info
echo "Done. Run: kubectl get nodes"
