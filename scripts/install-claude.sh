#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$HOME/.claude/skills"
BACKUP_DIR="$HOME/.claude/skills-backups"
MODE="replace"

for arg in "$@"; do
  case "$arg" in
    --strict)
      MODE="strict"
      ;;
    --backup-existing)
      MODE="backup"
      ;;
    -h|--help)
      cat <<HELP
Usage: $(basename "$0") [--strict|--backup-existing]

Links all skills from this repository into claude skills directory.

Default behavior:
  If a target skill already exists as a real directory, delete it and then link
  the repository copy. Existing symlinks are refreshed.

Options:
  --backup-existing   Move an existing real directory to
                      $BACKUP_DIR/<name>.backup.<timestamp> before linking.
  --strict            Fail if a target skill already exists as a real directory.
HELP
      exit 0
      ;;
    *)
      echo "error: unknown argument: $arg" >&2
      exit 1
      ;;
  esac
done

mkdir -p "$DEST"
if [ "$MODE" = "backup" ]; then
  mkdir -p "$BACKUP_DIR"
fi

timestamp="$(date +%Y%m%d%H%M%S)"

find "$REPO/skills" -mindepth 1 -maxdepth 1 -type d -print0 |
while IFS= read -r -d '' src; do
  name="$(basename "$src")"
  target="$DEST/$name"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    case "$MODE" in
      strict)
        echo "error: $target exists and is not a symlink; refusing to overwrite in --strict mode" >&2
        exit 1
        ;;
      backup)
        backup="$BACKUP_DIR/$name.backup.$timestamp"
        mv "$target" "$backup"
        echo "backed up existing claude skill: $target -> $backup"
        ;;
      replace)
        rm -rf "$target"
        echo "removed existing claude skill directory: $target"
        ;;
    esac
  fi

  ln -sfn "$src" "$target"
  echo "linked claude skill: $name -> $src"
done
