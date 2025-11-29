#!/usr/bin/env bash
# Build the local app image and deploy my-app + mongo-express to the local Kubernetes cluster.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
K8S_DIR="$ROOT_DIR/k8s"

command -v docker >/dev/null 2>&1 || { echo "docker CLI not found in PATH" >&2; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "kubectl not found in PATH" >&2; exit 1; }

echo "Building Docker image local/my-app:1.0 from: $ROOT_DIR"
cd "$ROOT_DIR"
docker build -t local/my-app:1.0 .

echo "Applying my-app and mongo-express manifests from: $K8S_DIR"
kubectl apply -f "$K8S_DIR/my-app-deployment.yaml"
kubectl apply -f "$K8S_DIR/my-app-service.yaml"
kubectl apply -f "$K8S_DIR/mongo-express-deployment.yaml"
kubectl apply -f "$K8S_DIR/mongo-express-service.yaml"

echo "Waiting for my-app pod to become Ready (timeout 120s)..."
kubectl wait --for=condition=ready pod -l app=my-app --timeout=120s || {
  echo "my-app did not become ready. Gathering diagnostics..."
  kubectl get pods -l app=my-app -o wide
  kubectl describe pod -l app=my-app || true
  kubectl logs -l app=my-app --tail=200 || true
  exit 1
}

echo "Waiting for mongo-express pod to become Ready (timeout 120s)..."
kubectl wait --for=condition=ready pod -l app=mongo-express --timeout=120s || {
  echo "mongo-express did not become ready. Gathering diagnostics..."
  kubectl get pods -l app=mongo-express -o wide
  kubectl describe pod -l app=mongo-express || true
  kubectl logs -l app=mongo-express --tail=200 || true
  exit 1
}

echo "Services status:"
kubectl get svc my-app mongo-express

echo "Notes: On Docker Desktop a LoadBalancer service is accessible via localhost on the service port. If you cannot reach the app, try 'kubectl port-forward svc/my-app 3000:3000' and 'kubectl port-forward svc/mongo-express 8081:8081'"

echo "Done."
