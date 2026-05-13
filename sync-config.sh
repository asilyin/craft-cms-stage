#!/usr/bin/env bash
#
# Applies pending project-config YAML changes to the database and
# verifies the apply finished by re-running `project-config/diff`.
# Exits 0 on clean sync, 1 if drift remains.
#
# Usage: ./sync-config.sh
#

set -euo pipefail

cd "$(dirname "$0")"

echo "[1/3] Pending changes before apply:"
echo "--------------------------------------------------------------------"
php craft project-config/diff || true
echo ""

echo "[2/3] Applying project config..."
echo "--------------------------------------------------------------------"
php craft project-config/apply
echo ""

echo "[3/3] Diff after apply (must be empty):"
echo "--------------------------------------------------------------------"
diff_output=$(php craft project-config/diff)
echo "$diff_output"
echo ""

if echo "$diff_output" | grep -qi "no pending project config"; then
	echo "OK — files and DB are in sync."
	exit 0
fi

echo "FAIL — drift remains after apply."
exit 1
