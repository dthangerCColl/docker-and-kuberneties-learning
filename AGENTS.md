# AGENTS.md - Docker & Kubernetes Learning Project

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

## Docker & K8s

```sh
# Environment setup (required before docker-compose)
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

## Service Ports

| Service       | URL                                                           |
| ------------- | ------------------------------------------------------------- |
| my-app        | http://localhost:3000                                         |
| mongo-express | http://localhost:8080 (compose) / http://localhost:8081 (k8s) |
| mongodb       | localhost:27017                                               |

## Key Files

- `docker-compose.yaml` - 3 services: my-app, mongodb, mongo-express
- `k8s/` - 8 YAML manifests for Kubernetes deployment
- `app/server.js` - Express server with `/get-profile`, `/update-profile`,
  `/profile-picture`
- `.env` - Default credentials (admin:password) - learning use only

## Learning Notes (for training context)

- **Environment variables are critical**: docker-compose.yaml uses
  ${MONGO_USERNAME}, ${MONGO_PASSWORD}, ${DOCKER_REGISTRY} - these MUST be
  exported before running compose
- **Port conflict warning**: mongo-express uses port 8080 in Compose but 8081 in
  K8s (intentional to avoid conflict with Compose)
- **Pod readiness**: my-app's readiness probe depends on MongoDB connectivity -
  if MongoDB is down, my-app pod won't be Ready
- **Secret management**: k8s/mongodb-secret.yaml contains plaintext
  credentials - learning only, replace for production
- **Smoke tests**: scripts/smoke-test.sh verifies 3 things: my-app returns 200,
  mongo-express returns 401 without auth, returns 200 with auth
