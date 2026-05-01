# Docker Core Principles Exercise for DevOps Engineers
*Generic, portable exercise covering all core Docker concepts. Designed to be moved to any project, with project-specific supplemental exercises added later.*

## Prerequisites
- **macOS**: Docker Desktop for macOS running (Intel/Apple Silicon supported)
- **Linux**: Docker Engine 20.10+ installed and running
- Terminal access (zsh/bash)
- No conflicting containers, volumes, or images (cleanup steps included in each section)

## Exercise Structure
This exercise is split into logical parts for portability. Each part is standalone, so you can copy only the relevant parts to future projects. All files are consolidated in the `docker-exercises/` directory at the project root:

1. [Part 01: Image Management, Versioning & Dockerfile Authoring](./docker-exercise-parts/01-image-management.md)  
   Covers: `pull`, `tag`, `build`, `push`, image versioning, basic Dockerfile authoring
2. [Part 02: Container Lifecycle & Persistent Storage](./docker-exercise-parts/02-container-lifecycle-storage.md)  
   Covers: `run`, `exec`, `stop`, `start`, `logs`, `inspect`, `rm`, volumes, bind mounts
3. [Part 03: Networking, Compose, Secrets & Cleanup](./docker-exercise-parts/03-networking-compose-secrets-cleanup.md)  
   Covers: Port mapping, custom networks, env vars, secrets, Docker Compose, cleanup/pruning
4. [Part 04: Project-Specific Local Exercise (docker-and-kuberneties-learning)](./docker-exercise-parts/04-project-specific-local.md)  
   Covers: Build my-app, Docker Compose with env vars, k8s deploy, smoke tests, MongoDB volume persistence. *Requires this project's existing files (Dockerfile, compose, k8s manifests, scripts).*

## Total Scope
- 19 steps total (~5 additional project-specific steps in Part 04)
- ~35 copy-paste commands (all with structured breakdowns)
- All 9 core Docker principles for DevOps Engineers included
- Part 04 adds project-specific workflows: build my-app, Compose with env vars, k8s deploy, smoke tests, volume persistence
- macOS-first with inline Linux notes
- All commands include structured function/flag/argument breakdowns
- All files consolidated in `docker-exercises/` directory at project root

## Quick Start Cleanup
Run the following to clean any conflicting resources before starting (safe to run if no exercise resources exist):
```bash
# Clean up any existing exercise resources
docker rm -f $(docker ps -a -q --filter "name=exercise-") 2>/dev/null
docker rmi -f $(docker images -q --filter "reference=exercise-*") 2>/dev/null
docker volume rm $(docker volume ls -q --filter "name=exercise-") 2>/dev/null
docker network rm $(docker network ls -q --filter "name=exercise-") 2>/dev/null
```

### Command Breakdown:
#### Command 1: `docker rm -f $(docker ps -a -q --filter "name=exercise-") 2>/dev/null`
- **Function**: Force stop and remove all containers with names starting with `exercise-`.
- **Flags**:
  - `-f`: (force) Stop running containers before removing them.
  - `-a`: (all) List all containers (not just running).
  - `-q`: (quiet) Only display numeric container IDs.
  - `--filter "name=exercise-"`: Filter containers to only those with names matching the pattern.
- **Arguments**: None (uses command substitution to pass container IDs).
- **Note**: `2>/dev/null` suppresses error output if no matching containers exist.

#### Command 2: `docker rmi -f $(docker images -q --filter "reference=exercise-*") 2>/dev/null`
- **Function**: Force remove all images with names starting with `exercise-`.
- **Flags**:
  - `-f`: (force) Remove images even if referenced by stopped containers.
  - `-q`: (quiet) Only display numeric image IDs.
  - `--filter "reference=exercise-*"`: Filter images to only those with names matching the pattern.
- **Arguments**: None (uses command substitution to pass image IDs).

#### Command 3: `docker volume rm $(docker volume ls -q --filter "name=exercise-") 2>/dev/null`
- **Function**: Remove all volumes with names starting with `exercise-`.
- **Flags**:
  - `-q`: (quiet) Only display volume names.
  - `--filter "name=exercise-"`: Filter volumes to only those matching the pattern.
- **Arguments**: None (uses command substitution to pass volume names).

#### Command 4: `docker network rm $(docker network ls -q --filter "name=exercise-") 2>/dev/null`
- **Function**: Remove all custom networks with names starting with `exercise-`.
- **Flags**:
  - `-q`: (quiet) Only display network IDs/names.
  - `--filter "name=exercise-"`: Filter networks to only those matching the pattern.
- **Arguments**: None (uses command substitution to pass network names).
