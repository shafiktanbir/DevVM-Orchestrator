# Mission 1: Run one process

## Curiosity hook

How does Kubernetes run my app instead of me typing `node server.js`?

## What you'll use

- **Concepts:** Pod = one runnable unit, container image, kubectl apply
- **Files:** `app/server.js`, `app/Dockerfile`, `k8s/pod.yaml`

## Task

1. Build the image inside minikube's Docker so the cluster can use it.
2. Apply the Pod manifest.
3. Wait for the pod to be Running, then check logs.

## How to run

```bash
# Use minikube's Docker so the image is available in the cluster
eval $(minikube docker-env)
docker build -t k8-curriculum-hello:latest ./app

# Deploy the pod
kubectl apply -f k8s/pod.yaml

# Wait until Running
kubectl get pods -w
# Ctrl+C when hello-pod is Running

# See logs
kubectl logs hello-pod
```

## What to try next

- `kubectl describe pod hello-pod` — see events and spec.
- `kubectl delete pod hello-pod` then `kubectl apply -f k8s/pod.yaml` again — observe new pod name.

**You've unlocked:** Pods — the smallest runnable unit in Kubernetes.
