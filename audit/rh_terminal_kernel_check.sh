#!/usr/bin/env bash
set -euo pipefail

# Canonical RH kernel runner.
# Kept as a stable compatibility entrypoint for existing local commands.
exec bash audit/rh_preflight_kernel.sh
