#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TMP_ROOT="$(mktemp -d)"

bash "${REPO_ROOT}/scripts/check-python.sh"

cleanup() {
  rm -rf "${TMP_ROOT}"
}
trap cleanup EXIT

state_file="${TMP_ROOT}/workflow-state.json"
index_file="${TMP_ROOT}/workflow/index.md"

python3 "${REPO_ROOT}/scripts/generate-workflow-state.py" \
  --workflow software-delivery-pipeline \
  --run-path workflow/runs/2026-05-26-generated \
  --source-artifact workflow/reviews/2026-05-26-review/review-to-delivery-handoff.md \
  --status in_progress \
  --current-stage requirements \
  --latest-document 01-delivery-requirements.md \
  --next-action "Wait for requirements confirmation." \
  --selected-scope F-001 \
  --blocker "human confirmation" \
  --updated-at "2026-05-26T00:00:00+08:00" \
  --output "${state_file}" >/dev/null

python3 "${REPO_ROOT}/scripts/update-workflow-index.py" \
  --state "${state_file}" \
  --index "${index_file}" \
  --summary workflow/runs/2026-05-26-generated/01-delivery-requirements.md >/dev/null

diff -u "${REPO_ROOT}/tests/workflow-index/expected-index.md" "${index_file}" >/dev/null

echo "Workflow index checks passed."
