#!/usr/bin/env bash
# Verify the cluster is up and kubectl can talk to it.
set -e
echo "Checking cluster..."
kubectl cluster-info
echo ""
echo "Nodes:"
kubectl get nodes
echo ""
echo "Setup OK."
