# Session Log: Service-Specific MongoDB Credentials

## Goal
Split the shared `admin:password` account into separate service accounts for least-privilege access.

## Session Date
2026-05-25

## What We Learned

### Why
- One shared account = if one service is compromised, everything is exposed
- No audit trail to know which service did what
- The app has root access when it only needs read/write on one database

### What Changed
- MongoDB root user stays (`admin:password`) for admin tasks
- New `app_user` for `my-app` with read/write only on `myappdb`
- Connection string now includes the database name and options

### Key Concepts
- **Least privilege**: each service gets only the access it needs
- **MongoDB init scripts**: files in `/docker-entrypoint-initdb.d/` run once on first boot
- **K8s ConfigMap**: same init script, but stored as a Kubernetes ConfigMap instead of a volume

## Files Changed

1. `.env` — Added `MONGO_APP_USERNAME` + `MONGO_APP_PASSWORD`
2. `docker-compose.yaml` — my-app uses `${MONGO_APP_USERNAME}`, added mongo-init.js volume
3. `docker-compose.init.js` (new) — Creates `app_user` on first MongoDB boot
4. `k8s/mongodb-secret.yaml` — `MONGO_DB_USERNAME/PWD` and `MONGO_URL` use `app_user`
5. `k8s/mongo-init-configmap.yaml` (new) — K8s ConfigMap for the init script

## Paused — How to Resume

**Suggested session name:** `secure-mongo-exposure`

**What was done:**
- Split MongoDB credentials: root (`admin:password`) stays for admin/mongo-express, new `app_user:app_password_123` for my-app
- Added `docker-compose.init.js` — creates `app_user` on first MongoDB boot
- Added `k8s/mongo-init-configmap.yaml` — same init script for K8s
- Updated `.env`, `docker-compose.yaml`, `k8s/mongodb-secret.yaml`, `k8s/mongodb-deployment.yaml`

**What's next (in order):**

### 1. mongo-express behind reverse proxy
- **Compose:** Add nginx container in front of mongo-express with HTTP Basic Auth
  - nginx config with `auth_basic` pointing to a `.htpasswd` file
  - nginx container on port 8080, mongo-express on 8081 (internal only, no host port)
- **K8s:** Add Ingress resource with auth annotations
  - Ingress routes `/mongo-express` to the service
  - Uses `nginx.ingress.kubernetes.io/auth-type: basic` with a K8s Secret for credentials

### 2. TLS on the connection string
- Generate self-signed certs in compose
- Update `MONGO_URL` to use `?tls=true` + `tlsCAFile`
- Add cert volumes to MongoDB and my-app deployments

### 3. mongo-express credentials (optional)
- Separate mongo-express MongoDB admin account from root
- Create `me_admin` with limited read-only access to `myappdb`

**Quick reference — current credentials:**
| Service | Username | Password |
|---------|----------|----------|
| MongoDB root | `admin` | `password` |
| my-app | `app_user` | `app_password_123` |
| mongo-express (MongoDB) | `admin` | `password` |
| mongo-express (itself) | `admin` | `password` |

**Files changed in this session:**
- `.env` — added `MONGO_APP_USERNAME`, `MONGO_APP_PASSWORD`
- `.env.example` — same
- `docker-compose.yaml` — my-app env vars + mongo-init volume
- `docker-compose.init.js` (new) — JS init script
- `k8s/mongodb-secret.yaml` — app creds updated
- `k8s/mongodb-deployment.yaml` — init ConfigMap volume mount
- `k8s/mongo-init-configmap.yaml` (new) — ConfigMap for K8s
- `SESSION-LOG-01.md` (this file)

**To restart from compose:**
```sh
export MONGO_APP_USERNAME=app_user MONGO_APP_PASSWORD=app_password_123
docker-compose down -v
docker-compose up -d
```

**To restart from K8s:**
```sh
kubectl apply -f k8s/mongo-init-configmap.yaml
kubectl apply -f k8s/mongodb-secret.yaml
kubectl apply -f k8s/mongodb-deployment.yaml
```

---

## Session 2: Teardown Documentation & Tooling Cleanup

**Date:** 2026-06-12

**Goal:** Add comprehensive teardown documentation and migrate uv tools to brew where possible.

### What We Did

#### 1. Added Teardown Documentation to README.md

Added a complete `## Teardown` section covering:
- **Docker Compose** — `docker-compose down -v` (removes containers, network, mongo-data volume)
- **Manual containers** — `docker stop/rm` for my-app, mongodb, mongo-express + network removal
- **Built image** — `docker rmi local/my-app:1.0`
- **Kubernetes** — `kubectl delete -f k8s/` (all 9 manifests)
- **Dangling cleanup** — `docker system prune` options with warnings about project scope
- **K8s disable/re-enable** — Docker Desktop settings with note that re-enabling doesn't restore deleted resources

#### 2. Migrated uv Tools to Brew

| Tool | Before (uv) | After (brew) | Command |
|------|------------|--------------|---------|
| graphifyy | 0.7.13 | — (no brew) | stays in uv |
| kimi-cli | 1.5 | 1.47.0 | `kimi` |
| posting | 2.9.2 | httpie 3.2.4 | `http` |
| specify-cli | 0.0.22 | 0.10.2 | `specify` |

**Commands run:**
```sh
brew install httpie kimi-cli specify
uv tool uninstall posting kimi-cli specify-cli
```

**Note:** `posting` is now invoked as `http` (HTTPie's command name).

### Files Changed

1. `README.md` — Added `## Teardown` section (lines 203-313)
2. `AGENTS.md` — Added teardown commands to Docker & K8s section

### What's Next

No pending follow-ups from this session. The project now has complete setup and teardown documentation.
