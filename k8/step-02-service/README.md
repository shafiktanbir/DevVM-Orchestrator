# Mission 2: Give it a stable name

## Curiosity hook

How would another app or a user call my API without knowing the Pod IP?

## What you'll use

- **Concepts:** Service (ClusterIP) — stable DNS name and IP for pods
- **Files:** `k8s/pod.yaml`, `k8s/service.yaml`

## Task

1. Use the same image from step 01 (build if you haven't).
2. Apply the Pod and Service.
3. Call the app from inside the cluster using the Service name.

## How to run

```bash
eval $(minikube docker-env)
docker build -t k8-curriculum-hello:latest ../step-01-hello-pod/app

kubectl apply -f k8s/pod.yaml
kubectl apply -f k8s/service.yaml

kubectl get pods
kubectl get svc

# Call the app from inside the cluster (Service name = hello-svc, port 3000)
kubectl run curl --image=curlimages/curl -it --rm --restart=Never -- curl -s http://hello-svc:3000
```

## What to try next

- Delete the pod and re-apply; the Service still works and routes to the new pod IP.
- `kubectl get endpoints hello-svc` — see which pod IP the Service points to.

**You've unlocked:** Services — stable network identity for your pods.
