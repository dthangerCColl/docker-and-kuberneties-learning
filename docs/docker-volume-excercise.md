# Quick Docker Volumes Recap

Docker volumes are Docker-managed persistent storage decoupled from container lifecycles:

- Data survives container deletion, restarts, or image upgrades
- Stored inside Docker Desktop's Linux VM on macOS (native Linux uses `/var/lib/docker/volumes/`)
- Attached to containers at runtime via `-v` or `--mount`
- Preferred over host directory bind mounts for portability and Docker-native management

---

## Tailored Exercise (Matches All Your Specs)

- Ubuntu image (not Nginx)
- Add data via container exec
- Upgrade using newer official Ubuntu tags (22.04 → 24.04)
- Verify volume data directly on your macOS host
- Full cleanup (including volume, images, temp host files)
- macOS (Docker Desktop) specific steps

---

## Prerequisites

- Docker Desktop for macOS running
- No conflicting `my-ubuntu-data` volumes or `ubuntu-v1`/`ubuntu-v2` containers (cleanup step handles this regardless)

---

## Step 1: Pull Initial Ubuntu Image (Official Tag)

Use `ubuntu:22.04` as the initial "base" version:

```bash
docker pull ubuntu:22.04
```

---

## Step 2: Create Named Local Volume

```bash
docker volume create my-ubuntu-data

# Verify it exists
docker volume ls | grep my-ubuntu-data
```

---

## Step 3: Run Initial Container, Mount Volume, Add Data Via Container

Ubuntu's base image has no default long-running process, so we use `sleep infinity` to keep the container alive for exec commands:

```bash
# Run Ubuntu 22.04, mount volume to /data, keep container running in background
docker run -d \
  --name ubuntu-v1 \
  -v my-ubuntu-data:/data \
  ubuntu:22.04 \
  sleep infinity

# Exec into the container to write data to the volume
docker exec ubuntu-v1 sh -c "echo 'Persistent data from Ubuntu 22.04' > /data/volume-test.txt"

# Verify data was written inside the container
docker exec ubuntu-v1 cat /data/volume-test.txt
```

**Output:**

```
Persistent data from Ubuntu 22.04
```

---

## Step 4: Stop & Remove Initial Container

```bash
docker stop ubuntu-v1
docker rm ubuntu-v1
```

> Volume data is still fully preserved

---

## Step 5: Upgrade Image (Pull Newer Official Ubuntu Tag)

Pull `ubuntu:24.04` as the upgraded official release:

```bash
docker pull ubuntu:24.04
```

---

## Step 6: Reattach Volume to Upgraded Image, Verify Data

```bash
# Run upgraded Ubuntu 24.04, mount the SAME volume to /data
docker run -d \
  --name ubuntu-v2 \
  -v my-ubuntu-data:/data \
  ubuntu:24.04 \
  sleep infinity

# Verify the old data is still present in the upgraded image
docker exec ubuntu-v2 cat /data/volume-test.txt
```

**Output:**

```
Persistent data from Ubuntu 22.04
```

---

## Step 7: Verify Volume Data Directly On Your macOS Host

Docker Desktop stores volumes inside a Linux VM, so they aren't directly accessible on your macOS filesystem. We copy the volume contents to a host directory to check them directly:

```bash
# Create a temp directory on your macOS host to receive files
mkdir -p ~/docker-volume-check

# Copy volume contents to your host directory (temp container auto-removed after)
docker run --rm \
  -v my-ubuntu-data:/data:ro \
  -v ~/docker-volume-check:/host \
  ubuntu:24.04 \
  cp -r /data/* /host/

# Verify directly on your macOS host
cat ~/docker-volume-check/volume-test.txt

# Open the folder in Finder to inspect visually
open ~/docker-volume-check
```

---

## Step 8: Full Cleanup (Delete Everything Including Volume)

```bash
# Stop and remove upgraded container
docker stop ubuntu-v2
docker rm ubuntu-v2

# Remove both Ubuntu images
docker rmi ubuntu:22.04 ubuntu:24.04

# Permanently delete the volume (erases all data)
docker volume rm my-ubuntu-data

# Remove the temp host directory created for verification
rm -rf ~/docker-volume-check
```

**Final verification: nothing left**

```bash
docker ps -a                          # No containers
docker images ubuntu                  # No Ubuntu images
docker volume ls | grep my-ubuntu-data # No volume
ls ~/docker-volume-check              # Error: No such file or directory (correct)
```

---

## macOS-Specific Notes

1. **Ubuntu container lifecycle**: We use `sleep infinity` to keep the container running for exec commands. If you prefer an interactive shell, replace the `docker run -d` command with `docker run -it --name ubuntu-v1 -v my-ubuntu-data:/data ubuntu:22.04 /bin/bash`, write your file, then exit (this stops the container).

2. **Host volume access**: Docker Desktop automatically shares your `/Users` directory, so the `~/docker-volume-check` mount works without extra configuration.

3. **Official tags**: We use LTS releases (22.04, 24.04) as production-grade official Ubuntu tags for the upgrade workflow.