# Kubernetes Daily Commands Notes

## Quick Context and Cluster Info

```bash
# Show current context
kubectl config current-context

# List all contexts
kubectl config get-contexts

# Switch context
kubectl config use-context <context-name>

# Cluster info
kubectl cluster-info

# List nodes
kubectl get nodes -o wide
```

## Namespace Work

```bash
# List namespaces
kubectl get ns

# Set default namespace for current context
kubectl config set-context --current --namespace=<namespace>

# Get all resources in a namespace
kubectl get all -n <namespace>
```

## Pods (Most Used)

```bash
# List pods
kubectl get pods -n <namespace>

# Watch pod changes live
kubectl get pods -n <namespace> -w

# Pod details (events, status, conditions)
kubectl describe pod <pod-name> -n <namespace>

# Exec into pod
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh

# Pod logs
kubectl logs <pod-name> -n <namespace>

# Follow logs
kubectl logs -f <pod-name> -n <namespace>

# Logs from previous crashed container
kubectl logs --previous <pod-name> -n <namespace>

# Delete a pod (deployment/statefulset usually recreates it)
kubectl delete pod <pod-name> -n <namespace>
```

## Deployments and Rollouts

```bash
# List deployments
kubectl get deploy -n <namespace>

# Deployment details
kubectl describe deploy <deploy-name> -n <namespace>

# Apply manifest
kubectl apply -f <file-or-dir>

# Delete manifest resources
kubectl delete -f <file-or-dir>

# Check rollout status
kubectl rollout status deploy/<deploy-name> -n <namespace>

# Rollout history
kubectl rollout history deploy/<deploy-name> -n <namespace>

# Restart deployment (common after ConfigMap/Secret updates)
kubectl rollout restart deploy/<deploy-name> -n <namespace>

# Rollback deployment
kubectl rollout undo deploy/<deploy-name> -n <namespace>

# Scale deployment
kubectl scale deploy/<deploy-name> --replicas=3 -n <namespace>
```

## Services and Networking

```bash
# List services
kubectl get svc -n <namespace>

# Describe service
kubectl describe svc <service-name> -n <namespace>

# Port-forward service to local
kubectl port-forward svc/<service-name> 8080:80 -n <namespace>

# Port-forward pod to local
kubectl port-forward pod/<pod-name> 8080:80 -n <namespace>

# List ingresses
kubectl get ingress -n <namespace>
```

## ConfigMaps and Secrets

```bash
# List configmaps and secrets
kubectl get cm -n <namespace>
kubectl get secret -n <namespace>

# Describe configmap/secret
kubectl describe cm <configmap-name> -n <namespace>
kubectl describe secret <secret-name> -n <namespace>

# Create configmap from file
kubectl create cm <configmap-name> --from-file=<file> -n <namespace>

# Create secret from literal
kubectl create secret generic <secret-name> \
  --from-literal=username=<user> \
  --from-literal=password=<pass> \
  -n <namespace>
```

## Debug and Troubleshooting

```bash
# Show events (often first place to check)
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

# Top nodes/pods (metrics-server required)
kubectl top nodes
kubectl top pods -n <namespace>

# Get resource YAML
kubectl get deploy <deploy-name> -n <namespace> -o yaml

# Explain resource fields
kubectl explain deploy.spec.template.spec.containers

# Validate manifest without applying
kubectl apply --dry-run=client -f <file>
```

## Useful All-in-One Commands

```bash
# Get all major resources quickly
kubectl get all -A

# Find pod by label
kubectl get pods -n <namespace> -l app=<app-name>

# Delete all completed/failed pods in namespace
kubectl delete pod -n <namespace> --field-selector=status.phase==Succeeded
kubectl delete pod -n <namespace> --field-selector=status.phase==Failed
```

## Handy Aliases (Optional)

```bash
alias k=kubectl
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deploy'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
```

---

Tip: Replace `<namespace>`, `<pod-name>`, `<deploy-name>`, etc. with your actual values.
