# Kubernetes Learning Path — Learn by Doing

A curiosity-driven, game-like curriculum. One concept per step, runnable deliverables, and a boss level that ties it together.

## Prerequisites

- **minikube** — [Install](https://minikube.sigs.k8s.io/docs/start/)
- **kubectl** — [Install](https://kubernetes.io/docs/tasks/tools/) (1.28+)
- **Docker** (or use minikube's built-in)
- **Node 18+** (for the sample app)

## How to run

1. One-time: start your cluster (from repo root or `k8/`):
   ```bash
   ./k8/shared/minikube-start.sh
   ```
   Or: `minikube start`
2. Work through steps in order: `step-00-setup` → … → `step-08-boss-multi-app`.
3. Each step has its own README with: curiosity hook, task, how to run, what to try next.

## Path overview

| Step | Mission | Concept |
|------|---------|---------|
| 00 | Setup & first cluster | Cluster, kubectl, context |
| 01 | Run one process | Pod |
| 02 | Give it a stable name | Service (ClusterIP) |
| 03 | Expose it to the world | NodePort / LoadBalancer |
| 04 | Configure without rebuilding | ConfigMap |
| 05 | Keep it healthy | Readiness + Liveness probes |
| 06 | Scale it | Deployment + replicas |
| 07 | Store data that survives restarts | Volumes |
| 08 | **Boss** — Multi-component app | Deployments, Services, config, design choices |

**Time:** One weekend if done in order.

## Folder structure

```
k8/
├── README.md              (this file)
├── shared/
│   └── minikube-start.sh
├── step-00-setup/
├── step-01-hello-pod/
├── ...
└── step-08-boss-multi-app/
```

Start with [step-00-setup/README.md](step-00-setup/README.md).
