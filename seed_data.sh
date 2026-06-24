#!/bin/bash
set -e

FIRESTORE_URL="http://localhost:8080/v1/projects/demo-project/databases/(default)/documents"
AUTH_URL="http://localhost:9099"

echo "[seed] Clearing existing Firestore data..."
curl -s -X DELETE "http://localhost:8080/emulator/v1/projects/demo-project/databases/(default)/documents" > /dev/null

echo "[seed] Creating Auth users..."
USER1=$(curl -s -X POST \
  "${AUTH_URL}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=demo-key" \
  -H 'Content-Type: application/json' \
  -d '{"email":"alice@teamtasks.com","password":"password123","returnSecureToken":true}')
UID1=$(echo $USER1 | grep -o '"localId":"[^"]*' | cut -d'"' -f4)

USER2=$(curl -s -X POST \
  "${AUTH_URL}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=demo-key" \
  -H 'Content-Type: application/json' \
  -d '{"email":"bob@teamtasks.com","password":"password123","returnSecureToken":true}')
UID2=$(echo $USER2 | grep -o '"localId":"[^"]*' | cut -d'"' -f4)

USER3=$(curl -s -X POST \
  "${AUTH_URL}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=demo-key" \
  -H 'Content-Type: application/json' \
  -d '{"email":"carol@teamtasks.com","password":"password123","returnSecureToken":true}')
UID3=$(echo $USER3 | grep -o '"localId":"[^"]*' | cut -d'"' -f4)

USER4=$(curl -s -X POST \
  "${AUTH_URL}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=demo-key" \
  -H 'Content-Type: application/json' \
  -d '{"email":"dave@teamtasks.com","password":"password123","returnSecureToken":true}')
UID4=$(echo $USER4 | grep -o '"localId":"[^"]*' | cut -d'"' -f4)

echo "[seed] UIDs: $UID1 $UID2 $UID3 $UID4"

echo "[seed] Seeding teams..."
curl -s -X PATCH \
  "${FIRESTORE_URL}/teams/team-alpha" \
  -H 'Content-Type: application/json' \
  -d '{"fields":{"name":{"stringValue":"Alpha Squad"},"description":{"stringValue":"Frontend and mobile team"}}}' > /dev/null

curl -s -X PATCH \
  "${FIRESTORE_URL}/teams/team-beta" \
  -H 'Content-Type: application/json' \
  -d '{"fields":{"name":{"stringValue":"Beta Core"},"description":{"stringValue":"Backend and infrastructure team"}}}' > /dev/null

echo "[seed] Seeding user profiles..."
curl -s -X PATCH \
  "${FIRESTORE_URL}/users/${UID1}" \
  -H 'Content-Type: application/json' \
  -d "{\"fields\":{\"uid\":{\"stringValue\":\"${UID1}\"},\"displayName\":{\"stringValue\":\"Alice\"},\"email\":{\"stringValue\":\"alice@teamtasks.com\"},\"role\":{\"stringValue\":\"admin\"},\"teamId\":{\"stringValue\":\"team-alpha\"}}}" > /dev/null

curl -s -X PATCH \
  "${FIRESTORE_URL}/users/${UID2}" \
  -H 'Content-Type: application/json' \
  -d "{\"fields\":{\"uid\":{\"stringValue\":\"${UID2}\"},\"displayName\":{\"stringValue\":\"Bob\"},\"email\":{\"stringValue\":\"bob@teamtasks.com\"},\"role\":{\"stringValue\":\"member\"},\"teamId\":{\"stringValue\":\"team-alpha\"}}}" > /dev/null

curl -s -X PATCH \
  "${FIRESTORE_URL}/users/${UID3}" \
  -H 'Content-Type: application/json' \
  -d "{\"fields\":{\"uid\":{\"stringValue\":\"${UID3}\"},\"displayName\":{\"stringValue\":\"Carol\"},\"email\":{\"stringValue\":\"carol@teamtasks.com\"},\"role\":{\"stringValue\":\"member\"},\"teamId\":{\"stringValue\":\"team-beta\"}}}" > /dev/null

curl -s -X PATCH \
  "${FIRESTORE_URL}/users/${UID4}" \
  -H 'Content-Type: application/json' \
  -d "{\"fields\":{\"uid\":{\"stringValue\":\"${UID4}\"},\"displayName\":{\"stringValue\":\"Dave\"},\"email\":{\"stringValue\":\"dave@teamtasks.com\"},\"role\":{\"stringValue\":\"member\"},\"teamId\":{\"stringValue\":\"team-beta\"}}}" > /dev/null

echo "[seed] Seeding tasks for team-alpha..."
for i in 1 2 3 4 5; do
  curl -s -X PATCH \
    "${FIRESTORE_URL}/tasks/alpha-todo-${i}" \
    -H 'Content-Type: application/json' \
    -d "{\"fields\":{\"title\":{\"stringValue\":\"Alpha Todo Task ${i}\"},\"status\":{\"stringValue\":\"todo\"},\"assignedTo\":{\"stringValue\":\"${UID1}\"},\"teamId\":{\"stringValue\":\"team-alpha\"},\"priority\":{\"stringValue\":\"high\"},\"createdAt\":{\"timestampValue\":\"2024-01-0${i}T10:00:00Z\"}}}" > /dev/null
done

for i in 1 2 3; do
  curl -s -X PATCH \
    "${FIRESTORE_URL}/tasks/alpha-inprogress-${i}" \
    -H 'Content-Type: application/json' \
    -d "{\"fields\":{\"title\":{\"stringValue\":\"Alpha In Progress Task ${i}\"},\"status\":{\"stringValue\":\"in_progress\"},\"assignedTo\":{\"stringValue\":\"${UID2}\"},\"teamId\":{\"stringValue\":\"team-alpha\"},\"priority\":{\"stringValue\":\"medium\"},\"createdAt\":{\"timestampValue\":\"2024-01-1${i}T10:00:00Z\"}}}" > /dev/null
done

for i in 1 2; do
  curl -s -X PATCH \
    "${FIRESTORE_URL}/tasks/alpha-done-${i}" \
    -H 'Content-Type: application/json' \
    -d "{\"fields\":{\"title\":{\"stringValue\":\"Alpha Done Task ${i}\"},\"status\":{\"stringValue\":\"done\"},\"assignedTo\":{\"stringValue\":\"${UID1}\"},\"teamId\":{\"stringValue\":\"team-alpha\"},\"priority\":{\"stringValue\":\"low\"},\"createdAt\":{\"timestampValue\":\"2024-01-2${i}T10:00:00Z\"}}}" > /dev/null
done

echo "[seed] Seeding tasks for team-beta..."
for i in 1 2 3; do
  curl -s -X PATCH \
    "${FIRESTORE_URL}/tasks/beta-todo-${i}" \
    -H 'Content-Type: application/json' \
    -d "{\"fields\":{\"title\":{\"stringValue\":\"Beta Todo Task ${i}\"},\"status\":{\"stringValue\":\"todo\"},\"assignedTo\":{\"stringValue\":\"${UID3}\"},\"teamId\":{\"stringValue\":\"team-beta\"},\"priority\":{\"stringValue\":\"medium\"},\"createdAt\":{\"timestampValue\":\"2024-02-0${i}T10:00:00Z\"}}}" > /dev/null
done

for i in 1 2 3 4; do
  curl -s -X PATCH \
    "${FIRESTORE_URL}/tasks/beta-inprogress-${i}" \
    -H 'Content-Type: application/json' \
    -d "{\"fields\":{\"title\":{\"stringValue\":\"Beta In Progress Task ${i}\"},\"status\":{\"stringValue\":\"in_progress\"},\"assignedTo\":{\"stringValue\":\"${UID4}\"},\"teamId\":{\"stringValue\":\"team-beta\"},\"priority\":{\"stringValue\":\"high\"},\"createdAt\":{\"timestampValue\":\"2024-02-1${i}T10:00:00Z\"}}}" > /dev/null
done

for i in 1 2 3; do
  curl -s -X PATCH \
    "${FIRESTORE_URL}/tasks/beta-done-${i}" \
    -H 'Content-Type: application/json' \
    -d "{\"fields\":{\"title\":{\"stringValue\":\"Beta Done Task ${i}\"},\"status\":{\"stringValue\":\"done\"},\"assignedTo\":{\"stringValue\":\"${UID3}\"},\"teamId\":{\"stringValue\":\"team-beta\"},\"priority\":{\"stringValue\":\"low\"},\"createdAt\":{\"timestampValue\":\"2024-02-2${i}T10:00:00Z\"}}}" > /dev/null
done

echo "[seed] Seed complete."
echo "[seed] Test credentials:"
echo "  alice@teamtasks.com / password123  (team-alpha, admin)"
echo "  bob@teamtasks.com / password123    (team-alpha, member)"
echo "  carol@teamtasks.com / password123  (team-beta, member)"
echo "  dave@teamtasks.com / password123   (team-beta, member)"