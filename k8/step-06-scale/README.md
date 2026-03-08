# Mission 6: Scale it

## Curiosity hook

What if one replica isn't enough?

## What you'll use

- **Concepts:** Deployment, replicas, Service load-balancing
- **Files:** `k8s/deployment.yaml`, `k8s/service.yaml`

## Task

1. Deploy with `replicas: 2`.
2. Hit the Service repeatedly and see different pods (e.g. different hostnames or logs).

## How to run

```bash
eval $(minikube docker-env)
docker build -t k8-curriculum-hello-probes:latest ../step-05-probes/app

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

kubectl get pods -l app=hello
# You should see 2 pods

# Hit the service multiple times (from inside cluster)
kubectl run curl --image=curlimages/curl -it --rm --restart=Never -- sh -c "for i in 1 2 3 4; do curl -s http://hello-svc:3000; done"
# Or use minikube service hello-svc --url and curl from host multiple times
```

## What to try next

- Scale to 3: `kubectl scale deployment/hello --replicas=3`
- Change `replicas` in the YAML and `kubectl apply` again.

**You've unlocked:** Scaling — multiple replicas and Service round-robin.
