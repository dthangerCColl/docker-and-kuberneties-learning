# Demo app - Developing with Docker

A minimal Node.js/Express profile editor with a vanilla JS frontend that persists profile updates to MongoDB. The project is intended for practicing containerization and Compose orchestration.

## Repository layout
- `app/server.js` Express server exposing `/get-profile` and `/update-profile`
- `app/index.html` static profile editor that calls the API and shows a sample avatar from `/profile-picture`
- `app/utils.js` reusable helpers with accompanying tests
- `Dockerfile` to build the application image
- `docker-compose.yaml` to run the app with MongoDB and mongo-express

## Prerequisites
- Docker and Docker Compose
- Node.js (18+) and npm if you want to run outside containers
- A running MongoDB instance (the code defaults to `mongodb://admin:password@localhost:27017` and uses database `my-db`/collection `users`)

## Run locally (without Docker)
1) Start MongoDB locally or via Docker:

```sh
docker run -d -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password \
  --name mongodb mongo
```

2) (Optional) Point the app at a different Mongo instance:

```sh
export MONGO_URL="mongodb://<user>:<pass>@<host>:27017"
```

3) Install and start the app:

```sh
cd app
npm install
npm start
```

4) Open the UI at http://localhost:3000 and edit the profile. The database and collection are created automatically on first update.

## Run with Docker (manual containers)
1) Create a network (optional but keeps names predictable):

```sh
docker network create mongo-network
```

2) Start MongoDB:

```sh
docker run -d -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password \
  --name mongodb --net mongo-network mongo
```

3) Start mongo-express:

```sh
docker run -d -p 8081:8081 \
  -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
  -e ME_CONFIG_MONGODB_ADMINPASSWORD=password \
  -e ME_CONFIG_MONGODB_SERVER=mongodb \
  --net mongo-network --name mongo-express mongo-express
```

4) (Optional) Use mongo-express at http://localhost:8081 to inspect the `my-db` database and `users` collection the app writes to.

5) Build and run the Node.js app image:

```sh
docker build -t local/my-app:1.0 .
docker run -d -p 3000:3000 --net mongo-network -e MONGO_URL="mongodb://admin:password@mongodb:27017" local/my-app:1.0
```

6) Open http://localhost:3000 to use the app.

## Run with Docker Compose
1) Set environment values used by `docker-compose.yaml`:

```sh
export MONGO_USERNAME=admin
export MONGO_PASSWORD=password
export DOCKER_REGISTRY=local
```

2) Build the app image so Compose can pull it locally:

```sh
docker build -t ${DOCKER_REGISTRY}/my-app:1.0 .
```

3) Start the stack:

```sh
docker-compose -f docker-compose.yaml up
```

- App: http://localhost:3000
- mongo-express: http://localhost:8080 (log in with the values above)

4) In mongo-express, create database `my-db` and collection `users` if you want to browse documents. The app will upsert into them automatically when you submit the form.

## Tests and linting
Run from the `app` directory:

```sh
npm test   # Jest unit + integration tests
npm run lint
```

## API endpoints
- `GET /get-profile` – fetch the stored profile (empty object if none)
- `POST /update-profile` – save profile data (upserts userid 1)
- `GET /profile-picture` – serves the demo avatar image

The server reads `MONGO_URL` for the connection string; otherwise it defaults to `mongodb://admin:password@localhost:27017`.

## Run with Kubernetes (Docker Desktop)

This repository includes Kubernetes manifests under the `k8s/` directory so you can run the same stack (my-app, MongoDB, mongo-express) on a local Kubernetes cluster such as Docker Desktop's built-in Kubernetes.

Files you will find in `k8s/`:
- `mongodb-secret.yaml` – Kubernetes Secret with credentials used by MongoDB, the app, and mongo-express (for learning only; replace for production).
- `mongodb-pvc.yaml` – PersistentVolumeClaim for MongoDB data (1Gi request).
- `mongodb-deployment.yaml` / `mongodb-service.yaml` – Deployment + ClusterIP service for MongoDB.
- `my-app-deployment.yaml` / `my-app-service.yaml` – Deployment + LoadBalancer service for the Node app.
- `mongo-express-deployment.yaml` / `mongo-express-service.yaml` – Deployment + LoadBalancer service for the mongo-express UI.

Quick start (Docker Desktop, single-node cluster):

1) Make sure Kubernetes is enabled in Docker Desktop and `kubectl` is configured for the cluster.

2) Apply the MongoDB manifests (you can run the helper script instead – see below):

```bash
kubectl apply -f k8s/mongodb-secret.yaml
kubectl apply -f k8s/mongodb-pvc.yaml
kubectl apply -f k8s/mongodb-deployment.yaml
kubectl apply -f k8s/mongodb-service.yaml
```

3) Build the local app image and deploy the app + UI (helper script provided):

```bash
# build image and deploy my-app + mongo-express
chmod +x scripts/deploy-apps.sh
./scripts/deploy-apps.sh
```

4) The services use `type: LoadBalancer`. On Docker Desktop these are mapped to `localhost` so you can open:

- App: http://localhost:3000
- mongo-express: http://localhost:8081

If the LoadBalancer mapping isn't available for any reason, you can port-forward instead:

```bash
kubectl port-forward svc/my-app 3000:3000
kubectl port-forward svc/mongo-express 8081:8081
```

Utility scripts
- `scripts/deploy-mongodb.sh` – convenience script to apply the MongoDB manifests and wait for the pod to become Ready.
- `scripts/deploy-apps.sh` – builds `local/my-app:1.0`, applies the my-app and mongo-express manifests and waits for readiness.
- `scripts/smoke-test.sh` – simple smoke tests that verify my-app returns HTTP 200, mongo-express returns 401 without credentials and 200 with credentials (admin:password). Run after deployment to verify basic functionality.

Health checks and probes
- `k8s/my-app-deployment.yaml` includes readiness and liveness probes. The readiness probe checks `/get-profile` (so the Pod is only marked Ready when it can reach MongoDB), and the liveness probe checks `/` to ensure the web server responds.
- `k8s/mongo-express-deployment.yaml` uses exec probes that construct the Basic Auth header at runtime from the Secret-backed environment variables (safer than embedding base64 in the manifest).

Security notes
- The manifests and scripts in this repo are intended for local learning. They use a plaintext Kubernetes Secret and the `admin:password` credentials for convenience. For any non-local or production use, replace these with stronger credentials and use a secure secrets mechanism (sealed-secrets, HashiCorp Vault, cloud KMS, etc.).

Troubleshooting
- If a pod is not Ready, check:
  - `kubectl get pods -o wide`
  - `kubectl describe pod <pod-name>`
  - `kubectl logs <pod-name>`
- If PVC is `Pending`, ensure your cluster has a default StorageClass (Docker Desktop provides `hostpath` by default).

If you'd like, I can prepare a short commit message and commit these manifests and scripts to a branch, or add extra documentation snippets to this README (for example, expanding the troubleshooting section or adding screenshots).
