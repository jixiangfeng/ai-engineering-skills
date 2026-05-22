#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$HOME/.claude/skills"

mkdir -p "$DEST"

find "$REPO/skills" -mindepth 1 -maxdepth 1 -type d -print0 |
while IFS= read -r -d '' src; do
  name="$(basename "$src")"
  target="$DEST/$name"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "error: $target exists and is not a symlink; refusing to overwrite" >&2
    exit 1
  fi

  ln -sfn "$src" "$target"
  echo "linked claude skill: $name -> $src"
done
