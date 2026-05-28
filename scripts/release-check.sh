#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
RUN_SMOKE=1
RUN_DRY_RUN=1

usage() {
  cat <<'USAGE'
Usage: scripts/release-check.sh [--no-smoke] [--skip-dry-run] [--ci]

Options:
  --no-smoke      Skip isolated smoke install.
  --skip-dry-run  Skip real install dry-run previews.
  --ci            CI-friendly mode: skip smoke install and real install dry-run previews.
  -h, --help      Show this help.
USAGE
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --no-smoke)
      RUN_SMOKE=0
      ;;
    --skip-dry-run)
      RUN_DRY_RUN=0
      ;;
    --ci)
      RUN_SMOKE=0
      RUN_DRY_RUN=0
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

echo "== Git worktree status =="
git -C "${REPO_ROOT}" status --short

echo
echo "== Static consistency =="
bash "${REPO_ROOT}/scripts/check-consistency.sh"

echo
echo "== Workflow state schema =="
bash "${REPO_ROOT}/scripts/check-workflow-state.sh"

echo
echo "== Workflow index =="
bash "${REPO_ROOT}/scripts/check-workflow-index.sh"

echo
echo "== Execution mode contract =="
bash "${REPO_ROOT}/scripts/check-execution-mode-contract.sh"

echo
echo "== Markdown lint =="
bash "${REPO_ROOT}/scripts/check-structured.sh"

echo
echo "== Isolated smoke install =="
if [[ "${RUN_SMOKE}" -eq 1 ]]; then
  bash "${REPO_ROOT}/scripts/smoke-install-local.sh"
else
  echo "Skipped."
fi

echo
echo "== Real install dry-run previews =="
if [[ "${RUN_DRY_RUN}" -eq 1 ]]; then
  bash "${REPO_ROOT}/scripts/install-codex-skills.sh" --dry-run --backup
  bash "${REPO_ROOT}/scripts/install-claude-plugin.sh" --dry-run --backup
else
  echo "Skipped."
fi

echo
echo "Release checks passed."
