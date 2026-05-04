# Part 02: Container Lifecycle & Persistent Storage
*Covers: `run`, `exec`, `stop`, `start`, `logs`, `inspect`, `rm`, volumes, bind mounts*

## Step 6: Container Lifecycle Basics
Run a detached Nginx container, then practice lifecycle commands:
```bash
docker run -d --name exercise-nginx -p 8080:80 exercise-nginx:1.0

# View container logs
docker logs exercise-nginx

# Stop the container
docker stop exercise-nginx

# Restart the container
docker start exercise-nginx
```

### Command Breakdown:
#### Command: `docker run -d --name exercise-nginx -p 8080:80 exercise-nginx:1.0`
- **Function**: Create and start a new container from the custom Nginx image.
- **Flags**:
  - `-d`: (detach) Run container in background and print container ID.
  - `--name exercise-nginx`: Assign custom name for easy reference.
  - `-p 8080:80`: (publish) Map host port 8080 to container port 80 (format: `host_port:container_port`).
- **Arguments**:
  - `exercise-nginx:1.0`: Image to use.

#### Command: `docker logs exercise-nginx`
- **Function**: View logs output from the running container.
- **Flags**: None
- **Arguments**:
  - `exercise-nginx`: Container name to view logs for.

#### Command: `docker stop exercise-nginx`
- **Function**: Gracefully stop the running container (sends SIGTERM, waits 10s, then SIGKILL).
- **Flags**: None
- **Arguments**:
  - `exercise-nginx`: Container name to stop.

#### Command: `docker start exercise-nginx`
- **Function**: Restart a stopped container.
- **Flags**: None
- **Arguments**:
  - `exercise-nginx`: Container name to start.

## Step 7: Inspect & Exec into Container
View container details and run commands inside the container:
```bash
# View container IP address
docker inspect exercise-nginx | grep IPAddress -m 1

# Run a command inside the container
docker exec exercise-nginx cat /etc/nginx/nginx.conf | head -5
```

### Command Breakdown:
#### Command: `docker inspect exercise-nginx | grep IPAddress -m 1`
- **Function**: Show container metadata (IP address, mounts, env vars) and filter for the first line containing IPAddress.
- **Flags**:
  - `exercise-nginx`: Container name to inspect.
  - `| grep IPAddress -m 1`: Pipe output to grep to find the first matching line.

#### Command: `docker exec exercise-nginx cat /etc/nginx/nginx.conf | head -5`
- **Function**: Run a command inside the running container to view the first 5 lines of the Nginx config.
- **Flags**:
  - `exercise-nginx`: Running container name.
  - `cat /etc/nginx/nginx.conf`: Command to run inside the container.
  - `| head -5`: Pipe output to show only first 5 lines.

## Step 8: Persistent Storage (Named Volumes)
Create a named volume, mount it to Nginx, and verify persistence:
```bash
docker volume create exercise-nginx-data

docker run -d --name exercise-nginx-vol \
  -v exercise-nginx-data:/usr/share/nginx/html \
  -p 8081:80 \
  nginx:1.25-alpine

# Write test data to the volume
docker exec exercise-nginx-vol sh -c "echo 'Hello from Volume' > /usr/share/nginx/html/index.html"

# Verify data is served
curl http://localhost:8081
```

### Command Breakdown:
#### Command: `docker volume create exercise-nginx-data`
- **Function**: Create a new named Docker volume for persistent storage.
- **Flags**: None
- **Arguments**:
  - `exercise-nginx-data`: Name of the volume to create.

#### Command: `docker run -d --name exercise-nginx-vol -v exercise-nginx-data:/usr/share/nginx/html -p 8081:80 nginx:1.25-alpine`
- **Function**: Run Nginx container with mounted named volume.
- **Flags**:
  - `-v exercise-nginx-data:/usr/share/nginx/html`: Mount named volume to container directory. Docker creates the volume automatically if it does not exist.
  - `-p 8081:80`: Map host port 8081 to container port 80.

#### Command: `docker exec exercise-nginx-vol sh -c "echo 'Hello from Volume' > /usr/share/nginx/html/index.html"`
- **Function**: Write a test file to the volume-mounted directory inside the container.
- **Flags**:
  - `sh -c`: Run a shell command inside the container.

#### Command: `curl http://localhost:8081`
- **Function**: Test the Nginx server to verify the volume content is served.
- **Flags**: None
- **Arguments**:
  - `http://localhost:8081`: URL to request.

## Step 9: Storage Persistence Test
Stop and remove the container, then reattach the volume to a new container to verify data survives:
```bash
docker stop exercise-nginx-vol && docker rm exercise-nginx-vol

docker run -d --name exercise-nginx-vol2 \
  -v exercise-nginx-data:/usr/share/nginx/html \
  -p 8081:80 \
  nginx:1.25-alpine

# Verify data is still present
curl http://localhost:8081
```

### Command Breakdown:
#### Command: `docker stop exercise-nginx-vol && docker rm exercise-nginx-vol`
- **Function**: Stop the running container, then remove it.
- **Flags**: None
- **Arguments**: Container names to stop/remove.

#### Expected Output for `curl`:
```
Hello from Volume
```
Proves volume data survives container deletion.

## Step 10: Bind Mounts (Host Directory Mounting)
Mount a local host directory to a container instead of a named volume:
```bash
mkdir -p ~/docker-exercise/bind-dir
echo "Hello from Bind Mount" > ~/docker-exercise/bind-dir/index.html

docker run -d --name exercise-nginx-bind \
  -v ~/docker-exercise/bind-dir:/usr/share/nginx/html \
  -p 8082:80 \
  nginx:1.25-alpine

curl http://localhost:8082
```

### Command Breakdown:
#### Command: `docker run -d --name exercise-nginx-bind -v ~/docker-exercise/bind-dir:/usr/share/nginx/html -p 8082:80 nginx:1.25-alpine`
- **Function**: Run Nginx container with a bind mount (host directory mapped to container).
- **Flags**:
  - `-v ~/docker-exercise/bind-dir:/usr/share/nginx/html`: Bind mount host directory to container directory. Changes on host are immediately reflected in the container and vice versa.
  - `-p 8082:80`: Map host port 8082 to container port 80.

## OS Notes
- **macOS**: Docker Desktop automatically shares your `/Users` directory, so bind mounts to `~/docker-exercise` work without extra config.
- **Linux**: Bind mounts work for any directory the Docker daemon has access to.
- **macOS Volume Access**: Docker Desktop stores volumes inside a Linux VM, so you cannot access them directly on your macOS host. To copy volume data to your host:  
  `docker run --rm -v exercise-nginx-data:/data -v ~/docker-exercise:/host ubuntu:22.04 cp -r /data/* /host/`
