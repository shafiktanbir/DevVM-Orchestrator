# Mission 7: Store data that survives restarts

## Curiosity hook

What if my app needs a file or DB that must outlive the pod?

## What you'll use

- **Concepts:** Volume (emptyDir here; optional PVC later), volumeMounts
- **Files:** `k8s/deployment.yaml`, `app/`

## Task

1. Build the app (writes a counter to a file in `/data`).
2. Apply Deployment (with volume and volumeMount) and Service.
3. Hit the app a few times, delete the pod, wait for the new pod; with emptyDir the counter resets (data is per-pod). Optionally try a hostPath or document PVC as "what to try next."

## How to run

```bash
eval $(minikube docker-env)
docker build -t k8-curriculum-hello-volumes:latest ./app

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Hit the service a few times
minikube service hello-svc --url
# curl that URL 3 times — see visit count go 1, 2, 3

# Delete the pod; a new one is created (emptyDir is per-pod, so counter resets)
kubectl delete pod -l app=hello
# Wait for new pod, curl again — counter starts at 1 again
```

## What to try next

- Use a PersistentVolumeClaim so the counter survives pod deletion (same Deployment, change volume to `persistentVolumeClaim: claimName: hello-pvc` and add a PVC manifest).
- Try hostPath (minikube single node) to see data persist across pod restarts.

**You've unlocked:** Volumes — storage that can outlive a container.
