# Mission 3: Expose it to the world

## Curiosity hook

How do I hit my app from the browser?

## What you'll use

- **Concepts:** Service types — NodePort or LoadBalancer (minikube tunnel)
- **Files:** `k8s/deployment.yaml`, `k8s/service.yaml`

## Task

1. Deploy using a Deployment (so we have a stable way to expose).
2. Expose via NodePort or LoadBalancer.
3. Open the app in your browser.

## How to run

```bash
eval $(minikube docker-env)
docker build -t k8-curriculum-hello:latest ../step-01-hello-pod/app

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Option A: NodePort — get the port and open via minikube IP
kubectl get svc hello-svc
minikube service hello-svc --url
# Open that URL in browser (or: minikube service hello-svc)

# Option B: LoadBalancer + tunnel (in another terminal)
# minikube tunnel
# Then get EXTERNAL-IP from kubectl get svc hello-svc and open http://<EXTERNAL-IP>:3000
```

## What to try next

- Change the NodePort in `service.yaml` (e.g. 30080) and re-apply.
- Use `minikube tunnel` and switch the Service to `type: LoadBalancer` to get an external IP.

**You've unlocked:** Exposing apps to the outside world (NodePort / LoadBalancer).
