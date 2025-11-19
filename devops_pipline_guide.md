# Docker in a DevOps Pipeline

## The Modern DevOps Sequence

Code → Build Image → Test in Container → Push to Registry → Deploy

## When to Use Docker in Your Workflow

### Local Development (Feature Branch)

| Step | What Happens |
| --- | --- |
| 1. Write code | Make changes on your feature branch |
| 2. Build image | `docker build -t localhost/my-app:1.0 .` |
| 3. Test locally | `docker-compose up` — test in a containerized environment |
| 4. Commit & Push | Push code to remote (not the image yet) |

Why test in Docker locally? Catches "works on my machine" issues early.

## Azure DevOps CI/CD Pipeline

### Typical `azure-pipelines.yml` Flow

```text
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Trigger   │────▶│    Build    │────▶│    Test     │────▶│    Push     │
│  (PR/merge) │     │   Image     │     │  in Image   │     │ to Registry │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
                                                                   │
                                                                   ▼
                                                            ┌─────────────┐
                                                            │   Deploy    │
                                                            │  (AKS/ACI)  │
                                                            └─────────────┘
```

### Pipeline Stages

| Stage | Actions |
| --- | --- |
| Build | `docker build`, tag with commit SHA or version |
| Test | Run unit/integration tests inside the container |
| Push | Push to Azure Container Registry (ACR) |
| Deploy Dev | Auto-deploy to dev environment |
| Deploy Prod | Manual approval → deploy to production |

## Best Practices

### 1. Image Tagging Strategy

Don't use just `latest` — use semantic versioning + commit SHA, for example:

```text
myapp:1.0.0-abc123f
```

### 2. Environment Promotion

Use the same image with different configuration files or environment variables:

- Dev: `myapp:1.0.0-abc123f` + `dev.env`
- Prod: `myapp:1.0.0-abc123f` + `prod.env`

### 3. Branch Strategy

| Branch | Docker Action |
| --- | --- |
| `feature/*` | Build & test locally, maybe push to dev registry |
| `develop` | CI builds image, runs tests, pushes to dev registry, deploys to dev |
| `main` / `master` | CI builds image, runs tests, pushes to prod registry, deploys to staging → prod |

## Answer to Your Question

Build the Docker image AFTER writing code and BEFORE committing tests:

1. Write code on a feature branch
2. Build the Docker image
3. Test inside the container (unit + integration)
4. If tests pass → commit, push, open PR

CI pipeline builds a fresh image from the PR and runs automated tests. Merge → deploy.

## Simple Azure DevOps Pipeline Example

```yaml
trigger:
  - main
  - develop

stages:
  - stage: Build
    jobs:
      - job: BuildImage
        steps:
          - task: Docker@2
            inputs:
              command: build
              repository: my-app
              tags: $(Build.BuildId)

          - task: Docker@2
            inputs:
              command: push
              repository: my-app
              tags: $(Build.BuildId)

  - stage: Deploy
    dependsOn: Build
    jobs:
      - job: DeployToAKS
        steps:
          - task: KubernetesManifest@0
            inputs:
              action: deploy
              manifests: k8s/deployment.yaml
```

## Summary

- **Locally:** Build & test before committing
- **CI:** Build, test, push on every PR/merge
- **CD:** Deploy the same tested image to each environment

The key principle: Build once, deploy everywhere — the same image goes from dev → staging → prod, only configuration changes.
