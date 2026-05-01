# Part 03: Networking, Docker Compose, Secrets & Cleanup
*Covers: Port mapping, custom networks, environment variables, secrets, Docker Compose, cleanup/pruning*

## Step 11: Custom Networks & Environment Variables
Run a Redis container on a custom network with environment variables:
```bash
docker network create exercise-network

docker run -d --name exercise-redis \
  --network exercise-network \
  -e REDIS_PASSWORD=secretpass \
  redis:7-alpine \
  redis-server --requirepass secretpass
```

### Command Breakdown:
#### Command: `docker network create exercise-network`
- **Function**: Create a custom Docker bridge network for container-to-container communication.
- **Flags**: None
- **Arguments**:
  - `exercise-network`: Name of the custom network.

#### Command: `docker run -d --name exercise-redis --network exercise-network -e REDIS_PASSWORD=secretpass redis:7-alpine redis-server --requirepass secretpass`
- **Function**: Run Redis container on custom network with environment variables.
- **Flags**:
  - `--network exercise-network`: Attach container to the custom network.
  - `-e REDIS_PASSWORD=secretpass`: (env) Set environment variable inside the container.
- **Arguments**:
  - `redis:7-alpine`: Image to use.
  - `redis-server --requirepass secretpass`: Command to run inside the container to set a Redis password.

## Step 12: Docker Compose Multi-Service
Create a docker-compose.yaml for Nginx + Redis:
```bash
cat > ~/docker-exercise/docker-compose.yaml << 'EOF'
version: '3.8'
services:
  web:
    image: nginx:1.25-alpine
    ports:
      - "8090:80"
    volumes:
      - exercise-compose-data:/usr/share/nginx/html
    networks:
      - compose-network
  redis:
    image: redis:7-alpine
    command: redis-server --requirepass redis123
    networks:
      - compose-network
volumes:
  exercise-compose-data:
networks:
  compose-network:
    driver: bridge
EOF

cd ~/docker-exercise && docker-compose up -d
```

### Command Breakdown:
#### Command: `cat > ~/docker-exercise/docker-compose.yaml << 'EOF' ... EOF`
- **Function**: Write Docker Compose configuration to a file using a heredoc.
- **Flags**: None
- **Arguments**: None (content passed via heredoc).

#### Command: `cd ~/docker-exercise && docker-compose up -d`
- **Function**: Start all services defined in docker-compose.yaml in detached mode.
- **Flags**:
  - `-d`: (detach) Run services in background.
- **Arguments**: None (uses default `docker-compose.yaml` file).

## Step 13: Basic Secret Management
Use a bind-mounted file for secret storage (simplified for non-Swarm environments):
```bash
echo "redis-secret-123" > ~/docker-exercise/redis-pass.txt

docker run -d --name exercise-redis-secret \
  --network exercise-network \
  -v ~/docker-exercise/redis-pass.txt:/run/secrets/redis-pass.txt \
  redis:7-alpine \
  redis-server --requirepass $(cat /run/secrets/redis-pass.txt)
```

### Command Breakdown:
#### Command: `docker run -d --name exercise-redis-secret --network exercise-network -v ~/docker-exercise/redis-pass.txt:/run/secrets/redis-pass.txt redis:7-alpine redis-server --requirepass $(cat /run/secrets/redis-pass.txt)`
- **Function**: Run Redis with a bind-mounted secret file instead of an environment variable.
- **Flags**:
  - `-v ~/docker-exercise/redis-pass.txt:/run/secrets/redis-pass.txt`: Bind mount secret file to container's `/run/secrets/` directory.
- **Arguments**:
  - `$(cat /run/secrets/redis-pass.txt)`: Read password from the secret file to pass to Redis.

## Step 14: Cleanup & Pruning
Remove all exercise resources and prune unused Docker objects:
```bash
# Stop and remove containers
docker stop exercise-nginx exercise-nginx-vol exercise-nginx-vol2 exercise-nginx-bind exercise-redis exercise-redis-secret
docker rm exercise-nginx exercise-nginx-vol exercise-nginx-vol2 exercise-nginx-bind exercise-redis exercise-redis-secret

# Remove custom images
docker rmi exercise-nginx:1.0 exercise-nginx:2.0 exercise-node-app:1.0 exercise-node-app:2.0

# Remove volumes
docker volume rm exercise-nginx-data exercise-compose-data

# Remove custom networks
docker network rm exercise-network compose-network

# (Optional) Aggressive prune of all unused Docker resources
docker system prune -a --volumes -f
```

### Command Breakdown:
#### Command: `docker system prune -a --volumes -f`
- **Function**: Remove all unused containers, images, networks, and volumes.
- **Flags**:
  - `-a`: (all) Remove all unused images, not just dangling ones.
  - `--volumes`: Also remove unused volumes.
  - `-f`: (force) Do not prompt for confirmation.
- **Arguments**: None

## OS Notes
- **macOS**: `docker-compose` is included with Docker Desktop; Linux may require installing `docker-compose-plugin` separately via package manager.
- **Linux**: `docker system prune` will only remove resources not used by running containers.
- **Compose Version**: This uses Compose V2 (`docker compose` instead of `docker-compose`) is also supported; replace `docker-compose` with `docker compose` if using V2.
