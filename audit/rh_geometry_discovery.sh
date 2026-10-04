#!/usr/bin/env bash
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

FILE="open_math/lean/RHGeometryDiscovery.lean"
LOG="${TMPDIR:-/tmp}/rh-geometry-discovery.log"

rm -f /tmp/rh_geom_gap_*.txt 2>/dev/null || true

echo "[RH-GEOMETRY] compiling intentional geometry discovery tree"
echo "[RH-GEOMETRY] file=$FILE"

set +e
lake env lean "$FILE" 2>&1 | tee "$LOG"
code=${PIPESTATUS[0]}
set -e

echo "[RH-GEOMETRY] LEAN_EXIT=$code"
for f in /tmp/rh_geom_gap_*.txt; do
  [[ -e "$f" ]] || continue
  echo
  echo "===== $(basename "$f") ====="
  cat "$f"
done

if [[ $code -eq 0 ]]; then
  echo "[RH-GEOMETRY] STATUS=UNEXPECTED_GREEN"
  echo "[RH-GEOMETRY] NOTE=Check whether a real GeometryLogCertificate was produced."
  exit 0
fi

echo "[RH-GEOMETRY] STATUS=EXPECTED_DISCOVERY_FAILURE"
echo "[RH-GEOMETRY] CERTIFICATE=FORBIDDEN_WITHOUT_GeometryLogCertificate"
exit 2
