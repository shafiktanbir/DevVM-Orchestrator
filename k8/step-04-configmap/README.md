# Mission 4: Configure without rebuilding

## Curiosity hook

What if I need different config per environment without building new images?

## What you'll use

- **Concepts:** ConfigMap, envFrom
- **Files:** `k8s/configmap.yaml`, `k8s/deployment.yaml`, `k8s/service.yaml`, `app/`

## Task

1. Build the app image (server reads `GREETING` from env).
2. Apply ConfigMap, Deployment, and Service.
3. Open the app and see the ConfigMap message; edit the ConfigMap, restart the pod, see the change.

## How to run

```bash
eval $(minikube docker-env)
docker build -t k8-curriculum-hello-config:latest ./app

kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

minikube service hello-svc --url
# Open URL in browser — you should see "Hello from ConfigMap"

# Change config without rebuilding image:
kubectl edit configmap hello-config
# Change GREETING to "Guten Tag from ConfigMap" (or use kubectl apply with updated YAML)
kubectl rollout restart deployment/hello
# Reload browser — new message
```

## What to try next

- Add another key to the ConfigMap (e.g. `LOG_LEVEL`) and read it in the app.
- Use a single `env` entry with `valueFrom.configMapKeyRef` instead of `envFrom`.

**You've unlocked:** ConfigMaps — externalized configuration.
