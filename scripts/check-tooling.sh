#!/usr/bin/env bash
set -euo pipefail

if [[ "$#" -eq 0 ]]; then
  cat >&2 <<'EOF'
ERROR: check-tooling.sh requires at least one command name.
Usage: bash scripts/check-tooling.sh <command> [<command> ...]
EOF
  exit 1
fi

missing=()
for cmd in "$@"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing+=("$cmd")
  fi
done

if [[ "${#missing[@]}" -eq 0 ]]; then
  exit 0
fi

cat >&2 <<EOF
ERROR: missing required command(s): ${missing[*]}

Install the missing tooling, then retry.
Common cases:
  macOS:        brew install ripgrep git python
  Ubuntu / WSL: sudo apt install ripgrep git python3
EOF
exit 1
