# Boss: Multi-component app

## Curiosity hook

What if I deploy an API and a consumer and have to wire them together?

## What you'll use

- **Concepts:** Multiple Deployments, Services, ConfigMap, design choice (e.g. config via env, resource limits)
- **Files:** `api/`, `consumer/`, `k8s/*.yaml`

## Task

1. Build both images (API and consumer) in minikube's Docker.
2. Apply ConfigMap, API Deployment + Service, Consumer Deployment.
3. Verify: API is reachable at `api-svc:3000`; consumer logs show it calling the API. Optionally expose the API with NodePort and curl from the host.

## How to run

```bash
eval $(minikube docker-env)
docker build -t k8-boss-api:latest ./api
docker build -t k8-boss-consumer:latest ./consumer

kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment-api.yaml
kubectl apply -f k8s/service-api.yaml
kubectl apply -f k8s/deployment-consumer.yaml

kubectl get pods
kubectl logs -l app=consumer -f
# You should see the consumer periodically fetching /items from the API

# Call API from inside cluster
kubectl run curl --image=curlimages/curl -it --rm --restart=Never -- curl -s http://api-svc:3000/items
```

## Design choice you made

- **Config:** API URL and interval are in a ConfigMap and injected via `envFrom` — no rebuild to change them.
- **Resources:** API has requests/limits so the scheduler and node have a hint (optional but good practice).

## What to try next

- Expose the API with a NodePort Service and open it in the browser.
- Add a second replica for the API and hit the Service — see round-robin.
- What if we added a cache (e.g. another Deployment + Service) and had the consumer call the cache? Design the wiring.

**You've unlocked:** Boss level — multi-component deployment and wiring.
