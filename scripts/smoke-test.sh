#!/usr/bin/env bash
# Simple smoke tests for my-app and mongo-express
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Load environment variables from .env file
if [ -f "$ROOT_DIR/.env" ]; then
    set -a
    source "$ROOT_DIR/.env"
    set +a
fi

APP_URL="http://localhost:3000"
ME_URL="http://localhost:8080"
ME_USER="${MONGO_USERNAME:-admin}"
ME_PASS="${MONGO_PASSWORD:-password}"

echo "Testing my-app at $APP_URL"
status=$(curl -o /dev/null -s -w "%{http_code}" "$APP_URL/" || true)
echo "my-app HTTP status: $status"
if [ "$status" != "200" ]; then
  echo "my-app did not return 200 OK" >&2
  exit 1
fi

echo "Testing mongo-express without credentials (expect 401)"
status=$(curl -o /dev/null -s -w "%{http_code}" "$ME_URL/" || true)
echo "mongo-express (no auth) HTTP status: $status"
if [ "$status" != "401" ]; then
  echo "mongo-express without auth did not return 401" >&2
  exit 1
fi

echo "Testing mongo-express with credentials (expect 200)"
status=$(curl -u "$ME_USER:$ME_PASS" -o /dev/null -s -w "%{http_code}" "$ME_URL/" || true)
echo "mongo-express (with auth) HTTP status: $status"
if [ "$status" != "200" ]; then
  echo "mongo-express with auth did not return 200" >&2
  exit 1
fi

echo "All smoke tests passed."
