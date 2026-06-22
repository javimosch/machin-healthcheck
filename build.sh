#!/usr/bin/env bash
# Compile the tool to a single native binary.
set -euo pipefail
cd "$(dirname "$0")"
MACHIN="${MACHIN:-machin}"
command -v "$MACHIN" >/dev/null 2>&1 || { echo "error: '$MACHIN' not found (set MACHIN=/path/to/machin)"; exit 1; }
"$MACHIN" encode healthcheck.src > healthcheck.mfl
"$MACHIN" build healthcheck.mfl -o healthcheck
echo "built ./healthcheck"
