#!/usr/bin/env bash
# Small helper to apply the MongoDB Kubernetes manifests and wait for readiness.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
K8S_DIR="$ROOT_DIR/k8s"

echo "Applying MongoDB manifests from: $K8S_DIR"

kubectl apply -f "$K8S_DIR/mongodb-secret.yaml"
kubectl apply -f "$K8S_DIR/mongodb-pvc.yaml"
kubectl apply -f "$K8S_DIR/mongodb-deployment.yaml"
kubectl apply -f "$K8S_DIR/mongodb-service.yaml"

echo "Waiting for MongoDB pod to become Ready (timeout 120s)..."
kubectl wait --for=condition=ready pod -l app=mongodb --timeout=120s || {
  echo "Timed out waiting for MongoDB pod to be ready. Showing status and logs..."
  kubectl get pods -l app=mongodb -o wide
  kubectl describe pod -l app=mongodb || true
  kubectl logs -l app=mongodb --tail=200 || true
  exit 1
}

echo "MongoDB should be Ready. Showing brief status:"
kubectl get pods -l app=mongodb
kubectl get pvc mongo-pvc
kubectl get svc mongodb

echo "Done. If you prefer to run the commands manually, run them one at a time to avoid paste/continuation issues." 
