# Docker Compose → Kubernetes (Docker Desktop) — Learning Guide

## TL;DR

A step-by-step guide to convert your existing Docker Compose stack (my-app, mongodb, mongo-express) into Kubernetes manifests and run it on Docker Desktop's Kubernetes. We'll teach Deployments, Services, Secrets, PersistentVolumeClaims, and common debugging commands.

---

## Goals

- Deploy MongoDB with persistent storage in Kubernetes
- Deploy the Node.js `my-app` and connect it to MongoDB using Secrets
- Deploy `mongo-express` for admin UI
- Verify the whole stack locally using Docker Desktop K8s

## Prerequisites

- Docker Desktop installed with the Kubernetes feature enabled
- kubectl installed and configured (Docker Desktop provides a kube config)
- A working local image for the app (we use `local/my-app:1.0` in examples)
- Basic familiarity with Docker Compose and the repository containing `docker-compose.yaml`, `Dockerfile`, and `app/`

## Mapping Compose → Kubernetes (high level)

- services.my-app → Deployment + Service
- services.mongodb → Deployment + Service + PersistentVolumeClaim
- services.mongo-express → Deployment + Service
- environment variables (sensitive) → Secret
- non-sensitive config → ConfigMap
- ports → Service type (ClusterIP/NodePort/LoadBalancer)
- depends_on → either init container or the app must retry connections; use readiness probes for health checks

## Suggested manifest filenames (create under `k8s/`)

- `mongodb-secret.yaml`        — Kubernetes Secret for MongoDB credentials
- `mongodb-pvc.yaml`           — PersistentVolumeClaim for MongoDB data
- `mongodb-deployment.yaml`    — Deployment manifest for MongoDB
- `mongodb-service.yaml`       — ClusterIP Service for MongoDB
- `my-app-deployment.yaml`     — Deployment for the Node app
- `my-app-service.yaml`        — Service (NodePort or LoadBalancer) to expose the app
- `mongo-express-deployment.yaml` — Deployment for mongo-express
- `mongo-express-service.yaml` — Service to expose mongo-express (for learning use NodePort or LoadBalancer)

## Step-by-step (teach & run)

### 1) Enable Kubernetes in Docker Desktop

- Open Docker Desktop → Settings → Kubernetes → Enable
- Wait for the cluster to become ready, then verify with:

```bash
kubectl cluster-info
kubectl get nodes
```

### 2) Build the app image locally (so K8s can use it)

Use the image tag used in your `docker-compose.yaml`. For local development prefer `IfNotPresent` ImagePullPolicy.

```bash
# from repository root (where Dockerfile lives)
docker build -t local/my-app:1.0 .
# confirm image exists
docker images | grep my-app
```

Notes: Docker Desktop’s Kubernetes will use local images when ImagePullPolicy is `IfNotPresent` or `Never`.

### 3) Create Secrets for MongoDB credentials

Do NOT commit real credentials to Git. For learning, you can use sample values.

```bash
kubectl create secret generic mongodb-creds \
  --from-literal=MONGO_INITDB_ROOT_USERNAME=admin \
  --from-literal=MONGO_INITDB_ROOT_PASSWORD=password
```

Or create `k8s/mongodb-secret.yaml` with the base64-encoded values (example in repo later).

### 4) Create PersistentVolumeClaim for MongoDB

A simple PVC that uses the cluster's default StorageClass (Docker Desktop provides one).

`k8s/mongodb-pvc.yaml` (example):

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongo-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

Apply it:

```bash
kubectl apply -f k8s/mongodb-pvc.yaml
kubectl get pvc
```

### 5) Deploy MongoDB

Create `k8s/mongodb-deployment.yaml` and `k8s/mongodb-service.yaml` (Service ClusterIP, name `mongodb` so the app can resolve it).

- Ensure the Pod uses the Secret for `MONGO_INITDB_ROOT_USERNAME` and `MONGO_INITDB_ROOT_PASSWORD`
- Mount the `mongo-pvc` at `/data/db`

Apply and verify:

```bash
kubectl apply -f k8s/mongodb-secret.yaml
kubectl apply -f k8s/mongodb-pvc.yaml
kubectl apply -f k8s/mongodb-deployment.yaml
kubectl apply -f k8s/mongodb-service.yaml
kubectl get pods -l app=mongodb
kubectl logs <mongodb-pod-name>
```

### 6) Deploy `my-app` (Node.js)

Create `k8s/my-app-deployment.yaml`:

- Use envFrom or env entries to inject `MONGO_DB_USERNAME`, `MONGO_DB_PWD`, and construct `MONGO_URL` to point at `mongodb:27017` (the Service name)
- Set `imagePullPolicy: IfNotPresent` for local images

Apply and verify:

```bash
kubectl apply -f k8s/my-app-deployment.yaml
kubectl apply -f k8s/my-app-service.yaml
kubectl get pods -l app=my-app
kubectl logs -f deploy/my-app
```

To access the app from your machine (for testing):

- Option A: `kubectl port-forward svc/my-app 3000:3000` and open <http://localhost:3000>
- Option B: Use a Service of type LoadBalancer (Docker Desktop maps it to localhost) or NodePort

### 7) Deploy `mongo-express`

Create `k8s/mongo-express-deployment.yaml` and `k8s/mongo-express-service.yaml`.

- Use the same credentials Secret (or new ones) for the UI
- Expose via NodePort or LoadBalancer on port 8081 to access at <http://localhost:8081>

Apply and verify:

```bash
kubectl apply -f k8s/mongo-express-deployment.yaml
kubectl apply -f k8s/mongo-express-service.yaml
kubectl get svc
```

## Troubleshooting (common issues & fixes)

- Image not found: ensure you built the local image and set `imagePullPolicy: IfNotPresent` or push to a registry
- PVC Pending: check StorageClass availability. Docker Desktop usually provides a default storage class; if absent, use `hostPath` for learning only.
- App fails to connect to DB on startup: use retry logic or an init container that waits for DB availability. K8s `depends_on` equivalent doesn't exist.
- Secrets: when using `kubectl apply -f`, ensure values are base64-encoded when creating yaml files; `kubectl create secret` is easier for interactive use.

## Next steps & enhancements

- Add readiness and liveness probes to Deployments
- Convert to Helm chart for easier templating and environment handling
- Use `kubectl rollout` commands to learn update/rollback strategies
- When ready, use Terraform to provision cloud Kubernetes clusters and deploy manifests or use Terraform’s Kubernetes provider

## Example resources to add to the repo

- `k8s/` folder with the YAML files listed above
- `ADO Guides.md/docker-compose-to-kuberneties.md` (this file)
- A `README` snippet in `k8s/` showing the exact order of `kubectl apply` commands

---

If you'd like, I can now create the `k8s/` manifests for each service with examples and apply them locally (I will show the commands and ask you to run them, since I cannot run Docker Desktop here). Tell me whether you want the manifests as minimal working examples or more production-like manifests (with probes and resource requests).
