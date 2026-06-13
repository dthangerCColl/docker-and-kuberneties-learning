# Part 01: Docker Image Management, Versioning & Dockerfile Authoring

_Covers: `pull`, `tag`, `build`, `push`, image versioning, basic Dockerfile
authoring_

## Step 1: Pull Official Images

Pull generic official images for later use:

```bash
docker pull nginx:1.25-alpine
docker pull ubuntu:22.04
docker pull redis:7-alpine
```

### Command Breakdown (example for nginx):

#### Command: `docker pull nginx:1.25-alpine`

- **Function**: Download the official Nginx image with tag `1.25-alpine` from
  Docker Hub to local machine.
- **Flags**: None
- **Arguments**:
  - `nginx:1.25-alpine`: Image name and tag to pull. Format is
    `registry/image:tag`; defaults to Docker Hub if no registry specified,
    `latest` if no tag.

## Step 2: Image Tagging & Versioning

Tag an existing image to create a custom versioned copy:

```bash
docker tag nginx:1.25-alpine exercise-nginx:1.0
```

### Command Breakdown:

#### Command: `docker tag nginx:1.25-alpine exercise-nginx:1.0`

- **Function**: Create a new tag `exercise-nginx:1.0` that references the
  existing `nginx:1.25-alpine` image (no new data is downloaded).
- **Flags**: None
- **Arguments**:
  - `nginx:1.25-alpine`: Source image to tag.
  - `exercise-nginx:1.0`: Target image name and tag.

## Step 3: Basic Dockerfile Authoring

Create a simple Dockerfile for a custom Node.js app:

```bash
mkdir -p ~/docker-exercise/node-app && cd ~/docker-exercise/node-app
cat > Dockerfile << 'EOF'
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
EOF
```

### Command Breakdown:

#### Command: `mkdir -p ~/docker-exercise/node-app && cd ~/docker-exercise/node-app`

- **Function**: Create a directory for the exercise app and navigate into it.
- **Flags**:
  - `-p`: (parents) Create parent directories if they do not exist.
- **Arguments**:
  - `~/docker-exercise/node-app`: Path to create.

#### Command: `cat > Dockerfile << 'EOF' ... EOF`

- **Function**: Write the multi-line Dockerfile content to a file named
  `Dockerfile` using a heredoc.
- **Flags**: None
- **Arguments**: None (content is passed via heredoc).

## Step 4: Build Custom Image

Build the custom Node.js image from the Dockerfile:

```bash
docker build -t exercise-node-app:1.0 ~/docker-exercise/node-app
```

### Command Breakdown:

#### Command: `docker build -t exercise-node-app:1.0 ~/docker-exercise/node-app`

- **Function**: Build a Docker image from a Dockerfile in the specified
  directory.
- **Flags**:
  - `-t exercise-node-app:1.0`: (tag) Assign a name and tag to the built image.
- **Arguments**:
  - `~/docker-exercise/node-app`: Path to the directory containing the
    Dockerfile.

> **To push this image to a registry** (e.g., Docker Hub):  
> First log in with `docker login`, then run
> `docker push exercise-node-app:1.0`.

## Step 5: Image Version Upgrade

Simulate an image upgrade by building a new version:

```bash
# Update Dockerfile to use Node 21 (simulate upgrade)
# macOS uses sed -i '', Linux uses sed -i
sed -i '' 's/FROM node:20-alpine/FROM node:21-alpine/' ~/docker-exercise/node-app/Dockerfile 2>/dev/null || sed -i 's/FROM node:20-alpine/FROM node:21-alpine/' ~/docker-exercise/node-app/Dockerfile

docker build -t exercise-node-app:2.0 ~/docker-exercise/node-app
```

### Command Breakdown:

#### Command: `sed -i '' 's/FROM node:20-alpine/FROM node:21-alpine/' ~/docker-exercise/node-app/Dockerfile 2>/dev/null || sed -i 's/FROM node:20-alpine/FROM node:21-alpine/' ~/docker-exercise/node-app/Dockerfile`

- **Function**: Update the Dockerfile to use Node 21 instead of 20. Uses macOS
  `sed -i ''` first, falls back to Linux `sed -i` if macOS command fails.
- **Flags**:
  - `-i ''`: (macOS) Edit file in-place, with empty backup suffix.
  - `-i`: (Linux) Edit file in-place.
- **Arguments**:
  - `s/FROM node:20-alpine/FROM node:21-alpine/`: Sed substitution command to
    replace the FROM line.
  - `~/docker-exercise/node-app/Dockerfile`: File to edit.

#### Command: `docker build -t exercise-node-app:2.0 ~/docker-exercise/node-app`

- **Function**: Build a new version 2.0 of the custom image with the updated
  Node version.
- **Flags**:
  - `-t exercise-node-app:2.0`: (tag) Assign new version tag to the built image.
- **Arguments**:
  - `~/docker-exercise/node-app`: Path to the directory containing the
    Dockerfile.

## OS Notes

- **macOS**: `sed -i ''` requires an empty string for the backup suffix; Linux
  `sed -i` does not.
- **Linux**: All image layers are stored in `/var/lib/docker/` by default. macOS
  Docker Desktop stores image layers inside a Linux VM.
