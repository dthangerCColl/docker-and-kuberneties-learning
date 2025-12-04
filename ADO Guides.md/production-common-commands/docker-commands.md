# Docker Commands Reference

## Docker Workflow Overview

Docker Desktop provides a complete containerization platform with integrated Kubernetes support. The typical Docker workflow follows these stages:

1. **Development**: Create a `Dockerfile` to define your application environment
2. **Build**: Build Docker images from Dockerfiles
3. **Run**: Create and run containers from images
4. **Test**: Verify container functionality
5. **Push**: Upload images to Docker Hub or private registry
6. **Deploy**: Deploy to production (locally or with Kubernetes)
7. **Monitor & Maintain**: Manage running containers, view logs, and clean up resources

### Docker Desktop & Kubernetes

Docker Desktop includes a single-node Kubernetes cluster for local development. You can enable it in Docker Desktop preferences and use `kubectl` commands alongside Docker commands for orchestration.

---

## 15 Most Used Docker Commands

### 1. `docker ps`

**List running containers**

```bash
docker ps           # Show running containers
docker ps -a        # Show all containers (including stopped)
docker ps -q        # Show only container IDs
```

### 2. `docker images`

**List all Docker images**

```bash
docker images           # List all images
docker images -q        # Show only image IDs
docker images -a        # Show all images including intermediates
```

### 3. `docker build`

**Build an image from a Dockerfile**

```bash
docker build -t myapp:latest .              # Build with tag
docker build -t myapp:v1.0 -f Dockerfile .  # Specify Dockerfile
docker build --no-cache -t myapp:latest .   # Build without cache
```

### 4. `docker run`

**Create and start a container**

```bash
docker run nginx                            # Run container
docker run -d nginx                         # Run in detached mode
docker run -p 8080:80 nginx                 # Map ports (host:container)
docker run -v /host/path:/container/path nginx  # Mount volume
docker run --name mycontainer nginx         # Name the container
docker run -e ENV_VAR=value nginx           # Set environment variable
```

### 5. `docker stop`

**Stop running container(s)**

```bash
docker stop container_name          # Stop by name
docker stop container_id            # Stop by ID
docker stop $(docker ps -q)         # Stop all running containers
```

### 6. `docker start`

**Start stopped container(s)**

```bash
docker start container_name         # Start by name
docker start container_id           # Start by ID
docker start -a container_name      # Start and attach to output
```

### 7. `docker exec`

**Execute command in running container**

```bash
docker exec container_name ls -la           # Run single command
docker exec -it container_name bash         # Interactive bash shell
docker exec -it container_name sh           # Interactive sh shell
docker exec -u root container_name whoami   # Execute as specific user
```

### 8. `docker logs`

**View container logs**

```bash
docker logs container_name          # Show all logs
docker logs -f container_name       # Follow log output (tail -f)
docker logs --tail 100 container_name   # Show last 100 lines
docker logs --since 30m container_name  # Logs from last 30 minutes
```

### 9. `docker pull`

**Download image from registry**

```bash
docker pull nginx                   # Pull latest version
docker pull nginx:1.21              # Pull specific version
docker pull myregistry.com/myapp    # Pull from private registry
```

### 10. `docker push`

**Upload image to registry**

```bash
docker push username/myapp:latest           # Push to Docker Hub
docker push myregistry.com/myapp:v1.0       # Push to private registry
```

### 11. `docker rm`

**Remove container(s)**

```bash
docker rm container_name            # Remove stopped container
docker rm -f container_name         # Force remove running container
docker rm $(docker ps -aq)          # Remove all stopped containers
```

### 12. `docker rmi`

**Remove image(s)**

```bash
docker rmi image_name               # Remove image
docker rmi -f image_name            # Force remove image
docker rmi $(docker images -q)      # Remove all images
```

### 13. `docker-compose up`

**Start services defined in docker-compose.yml**

```bash
docker-compose up                   # Start services
docker-compose up -d                # Start in detached mode
docker-compose up --build           # Rebuild images before starting
docker-compose up service_name      # Start specific service
```

### 14. `docker-compose down`

**Stop and remove containers, networks**

```bash
docker-compose down                 # Stop and remove
docker-compose down -v              # Also remove volumes
docker-compose down --rmi all       # Also remove images
```

### 15. `docker system prune`

**Clean up unused Docker resources**

```bash
docker system prune                 # Remove stopped containers, unused networks, dangling images
docker system prune -a              # Remove all unused images
docker system prune -a --volumes    # Remove everything including volumes
docker system df                    # Show Docker disk usage
```

---

## Additional Useful Commands

### Inspect & Debug

```bash
docker inspect container_name       # Show detailed container info
docker stats                        # Show live resource usage
docker top container_name           # Show running processes
```

### Networking

```bash
docker network ls                   # List networks
docker network create mynetwork     # Create network
docker network connect mynetwork container_name  # Connect container to network
```

### Volumes

```bash
docker volume ls                    # List volumes
docker volume create myvolume       # Create volume
docker volume inspect myvolume      # Inspect volume
docker volume rm myvolume           # Remove volume
```

### Docker Desktop Specific

With Docker Desktop, you can also:

- View and manage containers via GUI
- Enable Kubernetes in Settings > Kubernetes
- Access container files via the GUI
- View resource usage in the Dashboard
- Quickly open container terminals

### Kubernetes Integration

When Kubernetes is enabled in Docker Desktop:

```bash
kubectl get pods                    # List pods
kubectl get services                # List services
kubectl apply -f deployment.yaml    # Deploy application
kubectl get nodes                   # View cluster nodes
```

---

## Best Practices

1. **Use `.dockerignore`**: Exclude unnecessary files from build context
2. **Tag images properly**: Use semantic versioning (v1.0.0, v1.1.0, etc.)
3. **Clean up regularly**: Use `docker system prune` to free disk space
4. **Use multi-stage builds**: Reduce image size
5. **Don't run as root**: Use non-root users in containers for security
6. **Health checks**: Define health checks in Dockerfile or docker-compose
7. **Resource limits**: Set memory and CPU limits for containers

---

## Quick Reference Card

| Task | Command |
|------|---------|
| List running containers | `docker ps` |
| List all containers | `docker ps -a` |
| List images | `docker images` |
| Build image | `docker build -t name:tag .` |
| Run container | `docker run -d -p host:container image` |
| Stop container | `docker stop container_name` |
| Remove container | `docker rm container_name` |
| Remove image | `docker rmi image_name` |
| View logs | `docker logs -f container_name` |
| Execute command | `docker exec -it container_name bash` |
| Clean up system | `docker system prune -a` |
| Start compose | `docker-compose up -d` |
| Stop compose | `docker-compose down` |
