#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! bash "${SCRIPT_DIR}/check-tooling.sh" python3; then
  cat >&2 <<'EOF'

The public entrypoints are shell scripts, but JSON, metadata, and routing
checks use Python standard-library tooling internally.
EOF
  exit 1
fi
