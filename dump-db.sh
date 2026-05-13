#!/usr/bin/env bash
#
# Dumps the Craft Postgres database as plain SQL into ./db/.
# Reads connection settings from .env, runs pg_dump inside the running
# postgres container (the host doesn't need pg_dump installed).
#
# Usage:
#   ./dump-db.sh                 # write db/craft.v2_DD_MM_YY_HHMMSS
#   ./dump-db.sh <name>          # write db/<name>
#

set -euo pipefail

cd "$(dirname "$0")"

if [ ! -f .env ]; then
	echo ".env not found in $(pwd)" >&2
	exit 1
fi

set -a
# shellcheck disable=SC1091
source .env
set +a

: "${CRAFT_DB_DATABASE:?CRAFT_DB_DATABASE not set in .env}"
: "${CRAFT_DB_USER:?CRAFT_DB_USER not set in .env}"
: "${CRAFT_DB_PORT:?CRAFT_DB_PORT not set in .env}"

container=${POSTGRES_CONTAINER:-}
if [ -z "$container" ]; then
	container=$(docker ps --filter "publish=${CRAFT_DB_PORT}" --filter "ancestor=postgres" --format '{{.Names}}' | head -n1)
fi
if [ -z "$container" ]; then
	container=$(docker ps --filter "name=postgres" --format '{{.Names}}' | head -n1)
fi
if [ -z "$container" ]; then
	echo "Could not find a running postgres container. Set POSTGRES_CONTAINER to override." >&2
	exit 1
fi

mkdir -p db

dump_name=${1:-"craft.v2_$(date +%d_%m_%y_%H%M%S)"}
dump_path="db/${dump_name}"

if [ -e "$dump_path" ]; then
	echo "Refusing to overwrite existing ${dump_path}" >&2
	exit 1
fi

echo "Dumping database '${CRAFT_DB_DATABASE}' from container '${container}' as user '${CRAFT_DB_USER}'..."
echo "  → ${dump_path}"

docker exec \
	-e "PGPASSWORD=${CRAFT_DB_PASSWORD:-}" \
	"${container}" \
	pg_dump -U "${CRAFT_DB_USER}" -d "${CRAFT_DB_DATABASE}" \
	> "${dump_path}"

bytes=$(wc -c < "${dump_path}")
echo ""
echo "Wrote ${bytes} bytes."
echo "Head:"
head -3 "${dump_path}"
