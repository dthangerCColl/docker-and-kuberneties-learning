# Demo app - Developing with Docker

A minimal Node.js/Express profile editor with a vanilla JS frontend that
persists profile updates to MongoDB. The project is intended for practicing
containerization and Compose orchestration.

## Repository layout

- `app/server.js` Express server exposing `/get-profile` and `/update-profile`
- `app/index.html` static profile editor that calls the API and shows a sample
  avatar from `/profile-picture`
- `app/utils.js` reusable helpers with accompanying tests
- `Dockerfile` to build the application image
- `docker-compose.yaml` to run the app with MongoDB and mongo-express
- `docker-compose.init.js` MongoDB init script (creates `app_user` on first
  boot)
- `k8s/` Kubernetes manifests for deployment
- `scripts/` helper scripts for deploying and testing

## Prerequisites

- Docker and Docker Compose
- Node.js (18+) and npm if you want to run outside containers
- A running MongoDB instance (the code defaults to
  `mongodb://admin:password@localhost:27017` and uses database
  `my-db`/collection `users`)

## Run locally (without Docker)

1. Start MongoDB locally or via Docker:

```sh
docker run -d -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password \
  --name mongodb mongo
```

1. (Optional) Point the app at a different Mongo instance:

```sh
export MONGO_URL="mongodb://<user>:<pass>@<host>:27017"
```

1. Install and start the app:

```sh
cd app
npm install
npm start
```

1. Open the UI at <http://localhost:3000> and edit the profile. The database and
   collection are created automatically on first update.

## Run with Docker (manual containers)

1. Create a network (optional but keeps names predictable):

```sh
docker network create mongo-network
```

1. Start MongoDB:

```sh
docker run -d -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password \
  --name mongodb --net mongo-network mongo
```

1. Start mongo-express:

```sh
docker run -d -p 8081:8081 \
  -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
  -e ME_CONFIG_MONGODB_ADMINPASSWORD=password \
  -e ME_CONFIG_MONGODB_SERVER=mongodb \
  --net mongo-network --name mongo-express mongo-express
```

1. (Optional) Use mongo-express at <http://localhost:8081> to inspect the
   `my-db` database and `users` collection the app writes to.

2. Build and run the Node.js app image:

```sh
docker build -t local/my-app:1.0 .
docker run -d -p 3000:3000 --net mongo-network -e MONGO_URL="mongodb://admin:password@mongodb:27017" local/my-app:1.0
```

1. Open <http://localhost:3000> to use the app.

## Run with Docker Compose

1. Build the app image so Compose can pull it locally:

```sh
docker build -t local/my-app:1.0 .
```

1. Start the stack:

```sh
docker-compose -f docker-compose.yaml up
```

- App: <http://localhost:3000>
- mongo-express: <http://localhost:8080> (log in with admin:password from
  `.env`)

> **Note:** Environment variables (`MONGO_USERNAME`, `MONGO_PASSWORD`,
> `DOCKER_REGISTRY`) are auto-loaded from the `.env` file — no `export` needed.

1. In mongo-express, create database `myappdb` and collection `users` if you
   want to browse documents. The app will upsert into them automatically when
   you submit the form.

## Tests and linting

JavaScript linting and tests (run from `app` directory):

```sh
npm test        # Jest unit + integration tests
npm run lint    # ESLint for JavaScript files
```

Markdown linting and formatting (run from project root):

```sh
npm run lint:md      # Check markdown files
npm run lint:md:fix  # Auto-fix markdown issues
npm run format       # Format all markdown files with Prettier
npm run format:check # Check formatting without writing
```

## API endpoints

- `GET /get-profile` – fetch the stored profile (empty object if none)
- `POST /update-profile` – save profile data (upserts userid 1)
- `GET /profile-picture` – serves the demo avatar image

The server reads `MONGO_URL` for the connection string; otherwise it defaults to
`mongodb://admin:password@localhost:27017`.

## Run with Kubernetes (Docker Desktop)

This repository includes Kubernetes manifests under the `k8s/` directory so you
can run the same stack (my-app, MongoDB, mongo-express) on a local Kubernetes
cluster such as Docker Desktop's built-in Kubernetes.

Files you will find in `k8s/`:

- `mongodb-secret.yaml` – Kubernetes Secret with credentials used by MongoDB,
  the app, and mongo-express (for learning only; replace for production).
- `mongodb-pvc.yaml` – PersistentVolumeClaim for MongoDB data (1Gi request).
- `mongodb-deployment.yaml` / `mongodb-service.yaml` – Deployment + ClusterIP
  service for MongoDB.
- `my-app-deployment.yaml` / `my-app-service.yaml` – Deployment + LoadBalancer
  service for the Node app.
- `mongo-express-deployment.yaml` / `mongo-express-service.yaml` – Deployment +
  LoadBalancer service for the mongo-express UI.
- `mongo-init-configmap.yaml` – ConfigMap for MongoDB init script (creates
  `app_user` with least-privilege access).

Quick start (Docker Desktop, single-node cluster):

1. Make sure Kubernetes is enabled in Docker Desktop and `kubectl` is configured
   for the cluster.

2. Apply the MongoDB manifests (you can run the helper script instead – see
   below):

```bash
kubectl apply -f k8s/mongodb-secret.yaml
kubectl apply -f k8s/mongodb-pvc.yaml
kubectl apply -f k8s/mongodb-deployment.yaml
kubectl apply -f k8s/mongodb-service.yaml
```

1. Build the local app image and deploy the app + UI (helper script provided):

```bash
# build image and deploy my-app + mongo-express
chmod +x scripts/deploy-apps.sh
./scripts/deploy-apps.sh
```

1. The services use `type: LoadBalancer`. On Docker Desktop these are mapped to
   `localhost` so you can open:

- App: <http://localhost:3000>
- mongo-express: <http://localhost:8081>

If the LoadBalancer mapping isn't available for any reason, you can port-forward
instead:

```bash
kubectl port-forward svc/my-app 3000:3000
kubectl port-forward svc/mongo-express 8081:8081
```

Utility scripts

- `scripts/deploy-mongodb.sh` – convenience script to apply the MongoDB
  manifests and wait for the pod to become Ready.
- `scripts/deploy-apps.sh` – builds `local/my-app:1.0`, applies the my-app and
  mongo-express manifests and waits for readiness.
- `scripts/smoke-test.sh` – simple smoke tests that verify my-app returns HTTP
  200, mongo-express returns 401 without credentials and 200 with credentials
  (admin:password). Run after deployment to verify basic functionality.

Health checks and probes

- `k8s/my-app-deployment.yaml` includes readiness and liveness probes. The
  readiness probe checks `/get-profile` (so the Pod is only marked Ready when it
  can reach MongoDB), and the liveness probe checks `/` to ensure the web server
  responds.
- `k8s/mongo-express-deployment.yaml` uses exec probes that construct the Basic
  Auth header at runtime from the Secret-backed environment variables (safer
  than embedding base64 in the manifest).

Security notes

- The manifests and scripts in this repo are intended for local learning. They
  use a plaintext Kubernetes Secret and the `admin:password` credentials for
  convenience. For any non-local or production use, replace these with stronger
  credentials and use a secure secrets mechanism (sealed-secrets, HashiCorp
  Vault, cloud KMS, etc.).

Troubleshooting

- If a pod is not Ready, check:
  - `kubectl get pods -o wide`
  - `kubectl describe pod <pod-name>`
  - `kubectl logs <pod-name>`
- If PVC is `Pending`, ensure your cluster has a default StorageClass (Docker
  Desktop provides `hostpath` by default).

## Teardown

Complete cleanup instructions to remove all project resources from your machine.

### Docker Compose

Stop containers, remove them, and delete the `mongo-data` volume:

```sh
docker-compose -f docker-compose.yaml down -v
```

The `-v` flag removes the named volume (`mongo-data`) that stored MongoDB data.
Without it, the volume persists and data is reused on the next
`docker-compose up`.

### Manual Docker containers

If you started containers manually (outside Compose):

```sh
# Stop and remove the containers
docker stop my-app mongodb mongo-express 2>/dev/null
docker rm my-app mongodb mongo-express 2>/dev/null

# Remove the network
docker network rm mongo-network 2>/dev/null
```

### Remove the built image

Delete the `local/my-app:1.0` image built for this project:

```sh
docker rmi local/my-app:1.0
```

### Kubernetes

Delete all Kubernetes resources created for this project:

```sh
# Delete in reverse order of creation
kubectl delete -f k8s/mongo-express-service.yaml
kubectl delete -f k8s/mongo-express-deployment.yaml
kubectl delete -f k8s/my-app-service.yaml
kubectl delete -f k8s/my-app-deployment.yaml
kubectl delete -f k8s/mongodb-service.yaml
kubectl delete -f k8s/mongodb-deployment.yaml
kubectl delete -f k8s/mongodb-pvc.yaml
kubectl delete -f k8s/mongodb-secret.yaml
```

Or delete all at once:

```sh
kubectl delete -f k8s/
```

Verify nothing remains:

```sh
kubectl get pods,services,secrets,pvc
```

### Clean up dangling images and volumes

Remove unused Docker resources across all projects:

```sh
# Remove stopped containers, dangling images, and unused networks
docker container prune
docker image prune
docker network prune

# Remove unused volumes (caution: this affects ALL projects, not just this one)
docker volume prune

# Full cleanup (all of the above in one command)
docker system prune

# Nuclear option: remove everything including unused images across all projects
docker system prune -a --volumes
```

> **Warning:** `docker volume prune` and `docker system prune -a --volumes` are
> **not project-scoped** — they remove unused resources from all Docker projects
> on your machine. Use them only if you want a completely clean Docker
> environment.

### Disable Kubernetes in Docker Desktop

If you only used Kubernetes for this project and want to free resources:

1. Open **Docker Desktop** → **Settings** → **Kubernetes**
2. Uncheck **Enable Kubernetes**
3. Click **Apply & Restart**
4. Wait for Docker Desktop to restart

This removes the single-node Kubernetes cluster and all resources in it. Docker
containers (Compose and manual) are unaffected.

**To re-enable for other projects:**

1. Docker Desktop → **Settings** → **Kubernetes**
2. Check **Enable Kubernetes**
3. Click **Apply & Restart**
4. Wait for the cluster to become ready (green indicator in the bottom-left)

Verify with:

```sh
kubectl cluster-info
kubectl get nodes
```

> **Note:** Re-enabling Kubernetes does not restore previously deleted
> resources. You must re-apply any `k8s/` manifests you need.
