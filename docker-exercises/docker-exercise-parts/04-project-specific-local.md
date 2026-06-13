# Part 04: Project-Specific Local Exercise (docker-and-kuberneties-learning)

_Covers: Building my-app, Docker Compose with env vars, k8s deploy, smoke tests,
MongoDB volume persistence. References generic Parts 01-03 for core principles._

## Prerequisites

- Complete Parts 01-03 of the generic Docker Core DevOps Exercise first.
- Docker Desktop for macOS running (with Kubernetes enabled in Settings >
  Kubernetes for k8s steps).
- Project files present: existing Dockerfile, `docker-compose.yaml`, `k8s/`
  manifests, `scripts/` directory.
- `.env` file in project root (contains `MONGO_USERNAME=admin`,
  `MONGO_PASSWORD=password`, `DOCKER_REGISTRY=local` for learning use only).
- Never commit `.env` to git: verify it is added to `.gitignore`.

## Secure Environment Setup

```bash
# 1. Verify .env exists (learning credentials only - never use in production)
cat .env

# 2. Export required environment variables for Docker Compose
# (Alternative: use --env-file flag with docker-compose instead)
export MONGO_USERNAME=admin
export MONGO_PASSWORD=password
export DOCKER_REGISTRY=local

# 3. Ensure .env is ignored by git to prevent credential leaks
echo ".env" >> .gitignore
grep ".env" .gitignore > /dev/null && echo ".env added to .gitignore" || echo "Error: .gitignore not updated"
```

### Command Breakdown:

#### Command: `export MONGO_USERNAME=admin MONGO_PASSWORD=password DOCKER_REGISTRY=local`

- **Function**: Set required environment variables for Docker Compose and image
  building in the current shell session.
- **Flags**: None
- **Arguments**: Space-separated `KEY=value` pairs to export to the shell.

#### Command: `echo ".env" >> .gitignore`

- **Function**: Append `.env` to the project's `.gitignore` file to prevent
  accidental commits of sensitive credentials.
- **Flags**: None
- **Arguments**: `.env` is the file pattern to ignore; `>> .gitignore` appends
  to the existing gitignore file.

## Step 1: Build my-app Image (Existing Dockerfile)

Use the project's existing Dockerfile to build the `my-app` container image:

```bash
# Build image with version tag, using DOCKER_REGISTRY env var
docker build -t ${DOCKER_REGISTRY}/my-app:1.0 .
```

### Command Breakdown:

#### Command: `docker build -t ${DOCKER_REGISTRY}/my-app:1.0 .`

- **Function**: Build a Docker image from the Dockerfile located in the current
  project root directory.
- **Flags**:
  - `-t ${DOCKER_REGISTRY}/my-app:1.0`: (tag) Assign image name and version tag
    using the `DOCKER_REGISTRY` environment variable.
- **Arguments**:
  - `.`: Path to the build context (project root, where the Dockerfile is
    located).

## Step 2: Run with Docker Compose (Multi-Service)

Start `my-app`, `mongodb`, and `mongo-express` using the project's
`docker-compose.yaml`:

```bash
# Start all services in detached mode, load vars from .env file
docker-compose -f docker-compose.yaml --env-file .env up -d

# Verify all services are running
docker-compose -f docker-compose.yaml ps
```

### Command Breakdown:

#### Command: `docker-compose -f docker-compose.yaml --env-file .env up -d`

- **Function**: Start all services defined in `docker-compose.yaml`, loading
  environment variables from the `.env` file.
- **Flags**:
  - `-f docker-compose.yaml`: (file) Specify the Compose file to use.
  - `--env-file .env`: Load environment variables from the `.env` file instead
    of exporting them manually.
  - `-d`: (detach) Run services in the background.
- **Arguments**: None

#### Command: `docker-compose -f docker-compose.yaml ps`

- **Function**: List the status of all services defined in the Compose file.
- **Flags**:
  - `-f docker-compose.yaml`: Specify the Compose file.
- **Arguments**: None

## Step 3: Verify Services & MongoDB Volume Persistence

Docker Compose defines a named volume for MongoDB. Verify data survives
container restarts:

```bash
# 1. Check MongoDB volume exists
docker volume ls | grep mongo

# 2. Write test data to my-app (requires my-app running)
curl -X POST http://localhost:3000/update-profile \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","age":25}'

# 3. Stop and remove Compose services (volumes are preserved by default)
docker-compose -f docker-compose.yaml down

# 4. Restart services, verify data persisted
docker-compose -f docker-compose.yaml --env-file .env up -d
curl http://localhost:3000/get-profile
```

### Command Breakdown:

#### Command: `docker-compose -f docker-compose.yaml down`

- **Function**: Stop and remove all containers and networks defined in the
  Compose file. Volumes are _not_ removed by default.
- **Flags**:
  - `-f docker-compose.yaml`: Specify the Compose file.
- **Arguments**: None

#### Expected Output for `curl http://localhost:3000/get-profile`:

```json
{"name": "Test User", "age": 25}
```

This proves MongoDB volume data survives container deletion and restarts.

## Step 4: Deploy to Kubernetes (Existing Manifests)

Use the project's existing k8s manifests and scripts to deploy to Docker
Desktop's local k8s cluster:

```bash
# 1. Apply all k8s manifests (create deployments, services, secrets)
kubectl apply -f k8s/

# 2. Run existing deployment scripts (build image, deploy app + mongo-express)
./scripts/deploy-mongodb.sh
./scripts/deploy-apps.sh

# 3. Verify k8s resources are running
kubectl get pods -w  # Watch pod status until all are Running/Ready
kubectl get svc      # List services and their ports
```

### Command Breakdown:

#### Command: `kubectl apply -f k8s/`

- **Function**: Apply all Kubernetes manifest files in the `k8s/` directory
  recursively.
- **Flags**:
  - `-f k8s/`: (file) Path to directory containing manifest YAML files.
- **Arguments**: None

#### Command: `./scripts/deploy-mongodb.sh`

- **Function**: Execute the existing script to deploy MongoDB to k8s, wait for
  pod readiness.
- **Flags**: None
- **Arguments**: None (script handles internal steps: build image, apply mongodb
  manifests, wait for ready state).

## Step 5: Run Smoke Test (Existing Script)

Execute the project's smoke test to verify all services work as expected:

```bash
./scripts/smoke-test.sh
```

### Command Breakdown:

#### Command: `./scripts/smoke-test.sh`

- **Function**: Run the existing smoke test script to verify:
  1. `my-app` returns 200 OK at http://localhost:3000
  2. `mongo-express` returns 401 Unauthorized without auth, 200 OK with
     credentials at http://localhost:8081
- **Flags**: None
- **Arguments**: None

## Step 6: Project-Specific Cleanup

Remove all project-specific resources (safe to run even if some resources don't
exist):

```bash
# Stop and remove docker-compose services (including volumes)
docker-compose -f docker-compose.yaml down -v

# Remove k8s resources
kubectl delete -f k8s/

# Remove built my-app image
docker rmi ${DOCKER_REGISTRY}/my-app:1.0 2>/dev/null

# Remove exported env vars (optional, clears shell session)
unset MONGO_USERNAME MONGO_PASSWORD DOCKER_REGISTRY
```

### Command Breakdown:

#### Command: `docker-compose -f docker-compose.yaml down -v`

- **Function**: Stop and remove containers, networks, _and_ volumes defined in
  the Compose file.
- **Flags**:
  - `-v`: (volumes) Remove anonymous volumes and named volumes defined in the
    Compose file.
- **Arguments**: None

## Secure Practices Note

1. **Never commit `.env`**: The `.env` file contains plaintext credentials for
   learning only. It must be added to `.gitignore` immediately.
2. **k8s Secrets**: The existing `k8s/mongodb-secret.yaml` contains plaintext
   credentials. For production, replace with:
   ```bash
   kubectl create secret generic mongodb-secret \
     --from-literal=MONGO_INITDB_ROOT_USERNAME=admin \
     --from-literal=MONGO_INITDB_ROOT_PASSWORD=password
   ```
3. **Image Registry**: Use a private registry (Docker Hub, ACR, ECR) for
   production images instead of the `local` tag.
4. **Port Conflicts**: Note `mongo-express` uses port 8080 in Compose and 8081
   in k8s to avoid conflicts.

## OS Notes

- **macOS**: Docker Desktop includes a local k8s cluster; enable it in
  _Settings > Kubernetes_ before running k8s steps.
- **Linux**: Ensure `kubectl` is configured to connect to your cluster, and the
  Docker daemon is running.
- **All Platforms**: The `deploy-*.sh` and `smoke-test.sh` scripts assume a
  zsh/bash shell; run `chmod +x scripts/*.sh` if they are not executable.
