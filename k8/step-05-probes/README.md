# Mission 5: Keep it healthy

## Curiosity hook

What if my process hangs and Kubernetes never restarts it?

## What you'll use

- **Concepts:** readinessProbe, livenessProbe
- **Files:** `k8s/deployment.yaml`, `k8s/service.yaml`, `app/`

## Task

1. Build the app (exposes `/health` and `/ready`).
2. Apply Deployment (with probes) and Service.
3. Verify the pod becomes Ready; optionally break `/ready` and watch the pod go Not Ready.

## How to run

```bash
eval $(minikube docker-env)
docker build -t k8-curriculum-hello-probes:latest ./app

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

kubectl get pods -w
# Wait until READY 1/1

# Optional: see "not ready" — edit server.js so /ready returns 500, rebuild image,
# kubectl rollout restart deployment/hello; watch pod go Not Ready and stay that way until fixed
```

## What to try next

- Make the liveness probe fail (e.g. wrong path): Kubernetes will restart the container.
- Tune `initialDelaySeconds` and `periodSeconds` and observe behavior.

**You've unlocked:** Health checks — readiness and liveness probes.
