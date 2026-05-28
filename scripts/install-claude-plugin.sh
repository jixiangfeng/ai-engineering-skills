#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOURCE_DIR="${REPO_ROOT}/plugins/ai-engineering-skills"
SHARED_DOCS_DIR="${REPO_ROOT}/docs"
TARGET_DIR="${CLAUDE_PLUGINS_DIR:-${HOME}/.claude/plugins}"
PLUGIN_NAME="${CLAUDE_PLUGIN_NAME:-ai-engineering-skills}"
TARGET_PLUGIN_DIR="${TARGET_DIR}/${PLUGIN_NAME}"
BACKUP_ROOT="${CLAUDE_PLUGINS_BACKUP_DIR:-${HOME}/.claude/plugins-backups}"
DRY_RUN=0
FORCE=0
BACKUP=0

action() {
  if [[ "${DRY_RUN}" -eq 1 ]]; then
    echo "DRY-RUN: $*"
  else
    echo "$*"
  fi
}

usage() {
  cat <<'USAGE'
Usage: scripts/install-claude-plugin.sh [--dry-run] [--force | --backup]

Installs the plugin from plugins/ai-engineering-skills into ~/.claude/plugins
or CLAUDE_PLUGINS_DIR.

Options:
  --dry-run   Print planned actions without writing files.
  --force     Replace the existing target plugin directory.
  --backup    Move the existing target plugin directory into a timestamped backup.
  -h, --help  Show this help.

By default, an existing target plugin directory is not overwritten.
USAGE
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    --force)
      FORCE=1
      ;;
    --backup)
      BACKUP=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [[ "${FORCE}" -eq 1 && "${BACKUP}" -eq 1 ]]; then
  echo "--force and --backup are mutually exclusive" >&2
  exit 1
fi

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "Source plugin directory not found: ${SOURCE_DIR}" >&2
  exit 1
fi

if [[ ! -f "${SOURCE_DIR}/.claude-plugin/plugin.json" ]]; then
  echo "Source Claude plugin metadata not found: ${SOURCE_DIR}/.claude-plugin/plugin.json" >&2
  exit 1
fi
if [[ ! -d "${SHARED_DOCS_DIR}" ]]; then
  echo "Shared docs directory not found: ${SHARED_DOCS_DIR}" >&2
  exit 1
fi

echo "Source: ${SOURCE_DIR}"
echo "Shared docs: ${SHARED_DOCS_DIR}"
echo "Target: ${TARGET_PLUGIN_DIR}"
if [[ "${BACKUP}" -eq 1 ]]; then
  echo "Backup root: ${BACKUP_ROOT}"
fi

if [[ "${DRY_RUN}" -eq 0 ]]; then
  mkdir -p "${TARGET_DIR}"
fi

if [[ -e "${TARGET_PLUGIN_DIR}" ]]; then
  if [[ "${BACKUP}" -eq 1 ]]; then
    timestamp="$(date +%Y%m%d-%H%M%S)"
    backup_dir="${BACKUP_ROOT}/${timestamp}/${PLUGIN_NAME}"
    action "Backup ${TARGET_PLUGIN_DIR} -> ${backup_dir}"
    if [[ "${DRY_RUN}" -eq 0 ]]; then
      mkdir -p "$(dirname "${backup_dir}")"
      mv "${TARGET_PLUGIN_DIR}" "${backup_dir}"
    fi
  elif [[ "${FORCE}" -eq 1 ]]; then
    action "Replace existing ${TARGET_PLUGIN_DIR}"
    if [[ "${DRY_RUN}" -eq 0 ]]; then
      rm -rf "${TARGET_PLUGIN_DIR}"
    fi
  else
    echo "Target exists: ${TARGET_PLUGIN_DIR}. Use --force to replace or --backup to preserve it." >&2
    if [[ "${DRY_RUN}" -eq 1 ]]; then
      echo "Dry run complete: use --dry-run --force or --dry-run --backup to preview replacement behavior."
      exit 0
    fi
    exit 1
  fi
fi

action "Install Claude plugin ${PLUGIN_NAME} -> ${TARGET_PLUGIN_DIR}"
if [[ "${DRY_RUN}" -eq 0 ]]; then
  cp -R "${SOURCE_DIR}" "${TARGET_PLUGIN_DIR}"
  cp -R "${SHARED_DOCS_DIR}" "${TARGET_PLUGIN_DIR}/docs"
fi
action "Install shared docs -> ${TARGET_PLUGIN_DIR}/docs"

if [[ "${DRY_RUN}" -eq 1 ]]; then
  echo "Dry run complete: Claude plugin would be installed into ${TARGET_PLUGIN_DIR}."
else
  echo "Installed Claude plugin ${PLUGIN_NAME} -> ${TARGET_PLUGIN_DIR}"
fi
