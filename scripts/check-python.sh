#!/usr/bin/env bash
set -euo pipefail

if ! command -v python3 >/dev/null 2>&1; then
  cat >&2 <<'EOF'
ERROR: python3 is required for structured workflow checks.

The public entrypoints are shell scripts, but JSON, metadata, and routing
checks use Python standard-library tooling internally.

Install python3, then retry:
  Ubuntu / WSL: sudo apt install python3
  macOS:        brew install python
EOF
  exit 1
fi
