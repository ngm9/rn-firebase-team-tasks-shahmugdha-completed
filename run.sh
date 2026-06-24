#!/bin/bash
set -e

WORKDIR=/root/task
cd $WORKDIR

echo "[run.sh] Stopping any existing containers..."
docker compose down --remove-orphans || true

echo "[run.sh] Starting Firebase Emulator Suite..."
docker compose up -d

echo "[run.sh] Waiting for Firestore emulator to be ready..."
for i in $(seq 1 30); do
  if curl -s http://localhost:8080 > /dev/null 2>&1; then
    echo "[run.sh] Firestore emulator is ready."
    break
  fi
  echo "[run.sh] Attempt $i: Firestore not ready yet, retrying in 3s..."
  sleep 3
done

echo "[run.sh] Waiting for Auth emulator to be ready..."
for i in $(seq 1 30); do
  if curl -s http://localhost:9099 > /dev/null 2>&1; then
    echo "[run.sh] Auth emulator is ready."
    break
  fi
  echo "[run.sh] Attempt $i: Auth emulator not ready yet, retrying in 3s..."
  sleep 3
done

echo "[run.sh] Seeding data..."
bash $WORKDIR/seed_data.sh

echo "[run.sh] Deployment complete."
echo "[run.sh] Emulator UI:  http://localhost:4000"
echo "[run.sh] Firestore:    http://localhost:8080"
echo "[run.sh] Auth:         http://localhost:9099"