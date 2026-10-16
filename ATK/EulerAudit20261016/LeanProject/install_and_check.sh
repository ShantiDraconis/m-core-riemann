#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if ! command -v elan >/dev/null 2>&1; then
  curl -fsSL https://elan.lean-lang.org/elan-init.sh | sh -s -- -y
fi
export PATH="$HOME/.elan/bin:$PATH"
printf '\n== Versions ==\n'
elan --version
lean --version
lake --version
printf '\n== Dependencies ==\n'
lake update
printf '\n== Mathlib cache ==\n'
lake exe cache get
printf '\n== Kernel compilation ==\n'
lake env lean ATK/RHLemmas.lean
printf '\n== Project build ==\n'
lake build
printf '\n== Axiom audit ==\n'
lake check
