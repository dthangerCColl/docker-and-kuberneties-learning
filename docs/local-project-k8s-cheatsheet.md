## Kubernetes Cheatsheet — local Docker Desktop / kind

Quick reference for running this repo's Node app + MongoDB + mongo-express on a local Kubernetes cluster.

Prereqs

- Docker Desktop with Kubernetes enabled (or kind for CI/local testing)
- kubectl configured for the target cluster (docker-desktop or kind)
- Make the helper scripts executable: `chmod +x scripts/*.sh`

Common tasks

- Deploy MongoDB only
  - ./scripts/deploy-mongodb.sh

- Build image and deploy app + mongo-express
  - ./scripts/deploy-apps.sh

- Run the smoke tests (checks app + mongo-express)
  - ./scripts/smoke-test.sh

Useful kubectl commands

- Check pods and status
  - kubectl get pods -o wide -n default

- Check services
  - kubectl get svc my-app mongo-express -o wide

- Describe a pod (diagnostics)
  - kubectl describe pod <pod-name>

- Stream logs
  - kubectl logs -f deployment/my-app

- Port-forward fallback (if LoadBalancer doesn't map to localhost)
  - kubectl port-forward svc/my-app 3000:3000
  - kubectl port-forward svc/mongo-express 8081:8081

Probes & Secrets notes

- The manifests include readiness and liveness probes. The mongo-express probes are implemented as an exec probe that builds the Basic Auth header at runtime using env vars sourced from the `mongodb-creds` Secret.
- Secrets in `k8s/mongodb-secret.yaml` are for learning/demo purposes only. For production, use a secret manager or SealedSecrets.

Troubleshooting tips

- If a pod fails readiness/liveness repeatedly, inspect the container logs and describe the pod to check probe stderr/stdout.
- If your LoadBalancer Service doesn't show `EXTERNAL-IP: localhost` on Docker Desktop, use port-forward as shown above.

Next steps

- Replace plaintext/development secrets with SealedSecrets or an external secret store.
- Add resource limits and probes tuning for production-like behavior.

Happy hacking! 🚀
