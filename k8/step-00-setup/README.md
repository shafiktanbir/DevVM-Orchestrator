# Mission 0: Setup & first cluster

## Curiosity hook

What if I could run a real Kubernetes cluster on my laptop?

## What you'll use

- **Concepts:** Cluster, kubectl, context
- **Files:** `verify.sh` (or run commands below)

## Task

1. Start minikube (or use `../shared/minikube-start.sh`).
2. Run `kubectl cluster-info` and confirm you see API server and core DNS.
3. Run `verify.sh` to double-check.

## How to run

```bash
# From k8/ or from step-00-setup/
minikube start
kubectl cluster-info
kubectl get nodes

# Or use the shared script (from repo root):
# ./k8/shared/minikube-start.sh

# Then verify:
./verify.sh
```

## What to try next

- `kubectl config get-contexts` — see your current context.
- `minikube dashboard` — open the minikube UI (optional).

**You've unlocked:** Your first local Kubernetes cluster.
