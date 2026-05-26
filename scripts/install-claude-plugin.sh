#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOURCE_DIR="${REPO_ROOT}/plugins/ai-engineering-skills"
TARGET_DIR="${CLAUDE_PLUGINS_DIR:-${HOME}/.claude/plugins}"
PLUGIN_NAME="${CLAUDE_PLUGIN_NAME:-ai-engineering-skills}"
TARGET_PLUGIN_DIR="${TARGET_DIR}/${PLUGIN_NAME}"

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "Source plugin directory not found: ${SOURCE_DIR}" >&2
  exit 1
fi

if [[ ! -f "${SOURCE_DIR}/.claude-plugin/plugin.json" ]]; then
  echo "Source Claude plugin metadata not found: ${SOURCE_DIR}/.claude-plugin/plugin.json" >&2
  exit 1
fi

mkdir -p "${TARGET_DIR}"

rm -rf "${TARGET_PLUGIN_DIR}"
cp -R "${SOURCE_DIR}" "${TARGET_PLUGIN_DIR}"

echo "Installed Claude plugin ${PLUGIN_NAME} -> ${TARGET_PLUGIN_DIR}"
