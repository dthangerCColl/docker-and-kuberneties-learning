# AGENTS.md - Docker & Kubernetes Learning Project

## Quick Start

```sh
# 1. Build the app image (required — compose uses a pre-built image, not a build context)
docker build -t local/my-app:1.0 .

# 2. Start the stack (my-app + mongodb + mongo-express)
docker-compose -f docker-compose.yaml up
```

Open http://localhost:3000 to use the app.

> **Note:** Environment variables (`MONGO_USERNAME`, `MONGO_PASSWORD`, `DOCKER_REGISTRY`) are auto-loaded from the `.env` file — no `export` needed.

## Docker & K8s

```sh
# Environment setup (auto-loaded from .env — only needed if .env is missing)
export MONGO_USERNAME=admin
export MONGO_PASSWORD=password
export DOCKER_REGISTRY=local

# Build app image
docker build -t ${DOCKER_REGISTRY}/my-app:1.0 .

# Run with Docker Compose (starts my-app + mongodb + mongo-express)
docker-compose -f docker-compose.yaml up

# Kubernetes (Docker Desktop)
kubectl apply -f k8s/                   # apply all manifests
./scripts/deploy-mongodb.sh            # deploy mongodb + wait
./scripts/deploy-apps.sh               # build image, deploy app + mongo-express
./scripts/smoke-test.sh                # verify services

# Teardown — Docker Compose
docker-compose -f docker-compose.yaml down -v

# Teardown — Manual containers
docker stop my-app mongodb mongo-express 2>/dev/null
docker rm my-app mongodb mongo-express 2>/dev/null
docker network rm mongo-network 2>/dev/null

# Teardown — Remove built image
docker rmi local/my-app:1.0

# Teardown — Kubernetes
kubectl delete -f k8s/

# Teardown — Dangling images/volumes (affects ALL projects)
docker system prune
```

## Run Commands

```sh
# Root-level markdown linting
npm run lint:md        # check
npm run lint:md:fix    # auto-fix

# Root-level markdown formatting (Prettier)
npm run format         # format all markdown files
npm run format:check   # check formatting without writing

# App-level (cd app/ first)
cd app && npm install
npm start              # runs server.js on port 3000
npm test               # Jest unit + integration tests
npm run lint           # ESLint
```

## Graphify

```sh
# Generate knowledge graph from project
/graphify                    # full pipeline on current directory
/graphify --update           # incremental update (new/changed files only)
/graphify query "question"   # search the graph
```

## Service Ports

| Service       | URL                                                           |
| ------------- | ------------------------------------------------------------- |
| my-app        | http://localhost:3000                                         |
| mongo-express | http://localhost:8080 (compose) / http://localhost:8081 (k8s) |
| mongodb       | localhost:27017                                               |

## Key Files

- `docker-compose.yaml` - 3 services: my-app, mongodb, mongo-express
- `docker-compose.init.js` - MongoDB init script (creates app_user on first
  boot)
- `Dockerfile` - Builds the Node.js app image
- `.env` - Default credentials (admin:password) - learning use only
- `k8s/` - 9 YAML manifests for Kubernetes deployment
- `scripts/deploy-mongodb.sh` - Deploy mongodb + wait for readiness
- `scripts/deploy-apps.sh` - Build image, deploy app + mongo-express
- `scripts/smoke-test.sh` - Verify services are running
- `app/server.js` - Express server with `/get-profile`, `/update-profile`,
  `/profile-picture`
- `SESSION-LOG-01.md` - Session history and next steps

## When to Run / When Not to Run

| Command                       | When to Run                            | When NOT to Run                                           |
| ----------------------------- | -------------------------------------- | --------------------------------------------------------- |
| `docker-compose up`           | Starting the full stack locally        | When K8s is running (port 8080 conflict)                  |
| `kubectl apply -f k8s/`       | Deploying to Kubernetes                | When Compose is running (port conflicts)                  |
| `docker-compose down -v`      | Stopping and cleaning up Compose stack | When you want to keep MongoDB data                        |
| `kubectl delete -f k8s/`      | Removing K8s resources                 | When you want to preserve deployed services               |
| `docker system prune`         | Cleanup time, freeing disk space       | When other projects are running (affects ALL)             |
| `docker rmi local/my-app:1.0` | Removing the built image               | When you want to reuse the image without rebuilding       |
| `npm run lint:md:fix`         | After editing markdown files           | Before running `npm run format` (lint first, then format) |
| `npm run format`              | After lint:md:fix, before commit       | When you want to preserve custom markdown formatting      |
| `./scripts/smoke-test.sh`     | After K8s deployment                   | When services are not running (will fail)                 |
| `/graphify`                   | After significant code changes         | When you only changed markdown (use format instead)       |
| `/graphify --update`          | Adding/changing a few files            | On first run (use full `/graphify` instead)               |

## Learning Notes (for training context)

- **Environment variables are critical**: docker-compose.yaml uses
  ${MONGO_USERNAME}, ${MONGO_PASSWORD}, ${DOCKER_REGISTRY} - these MUST be
  exported before running compose
- **DOCKER_REGISTRY=local**: means "build and tag locally, not pushed to any
  registry". Image becomes `local/my-app:1.0`
- **Port conflict warning**: mongo-express uses port 8080 in Compose but 8081 in
  K8s (intentional to avoid conflict with Compose)
- **Pod readiness**: my-app's readiness probe depends on MongoDB connectivity -
  if MongoDB is down, my-app pod won't be Ready
- **Secret management**: k8s/mongodb-secret.yaml contains plaintext
  credentials - learning only, replace for production
- **Smoke tests**: scripts/smoke-test.sh verifies 3 things: my-app returns 200,
  mongo-express returns 401 without auth, returns 200 with auth
- **Least privilege**: docker-compose.init.js creates a dedicated `app_user`
  with readWrite access to `myappdb` only - the app never uses root credentials
- **Build vs orchestration**: docker-compose.yaml uses `image:` (not `build:`)
  for my-app — this teaches that image building and orchestration are separate
  concerns. In production, CI/CD builds images once, then deploys them many times.
