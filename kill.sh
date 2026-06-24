#!/bin/bash
set -e

echo "[kill.sh] Stopping and removing containers..."
docker compose -f /root/task/docker-compose.yml down --remove-orphans || true

echo "[kill.sh] Removing Docker images..."
docker rmi andreysenov/firebase-tools --force || true

echo "[kill.sh] Pruning Docker system..."
docker system prune -a --volumes -f || true

echo "[kill.sh] Removing task directory..."
rm -rf /root/task || true

echo "[kill.sh] Cleanup complete."