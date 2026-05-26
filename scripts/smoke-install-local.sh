#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TMP_ROOT="$(mktemp -d)"

cleanup() {
  rm -rf "${TMP_ROOT}"
}
trap cleanup EXIT

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

require_file() {
  [[ -f "$1" ]] || fail "Missing file after smoke install: $1"
}

CODEX_SKILLS_DIR="${TMP_ROOT}/codex-skills"
CLAUDE_PLUGINS_DIR="${TMP_ROOT}/claude-plugins"
export CODEX_SKILLS_DIR
export CLAUDE_PLUGINS_DIR

echo "Smoke install temp root: ${TMP_ROOT}"

bash "${REPO_ROOT}/scripts/install-codex-skills.sh" --force
bash "${REPO_ROOT}/scripts/install-claude-plugin.sh" --force

expected_skills=(
  workflow-bootstrap
  codebase-orientation
  code-review-triage
  software-delivery-pipeline
  debug-root-cause
  api-contract-design
  data-migration-planning
)

for skill in "${expected_skills[@]}"; do
  require_file "${CODEX_SKILLS_DIR}/${skill}/SKILL.md"
done

CLAUDE_PLUGIN_DIR="${CLAUDE_PLUGINS_DIR}/ai-engineering-skills"
require_file "${CLAUDE_PLUGIN_DIR}/.claude-plugin/plugin.json"
require_file "${CLAUDE_PLUGIN_DIR}/.codex-plugin/plugin.json"

for skill in "${expected_skills[@]}"; do
  require_file "${CLAUDE_PLUGIN_DIR}/skills/${skill}/SKILL.md"
done

echo "Smoke install checks passed."
