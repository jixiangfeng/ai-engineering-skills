#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TMP_ROOT="$(mktemp -d)"

cleanup() {
  rm -rf "${TMP_ROOT}"
}
trap cleanup EXIT

python3 "${REPO_ROOT}/scripts/validate-workflow-state.py" \
  --schema "${REPO_ROOT}/docs/workflow-state-schema.json" \
  "${REPO_ROOT}/tests/workflow-state/valid-state.json"

if python3 "${REPO_ROOT}/scripts/validate-workflow-state.py" \
  --schema "${REPO_ROOT}/docs/workflow-state-schema.json" \
  "${REPO_ROOT}/tests/workflow-state/invalid-state.json" >/tmp/ai-engineering-invalid-state.out 2>/tmp/ai-engineering-invalid-state.err; then
  echo "ERROR: invalid workflow state fixture unexpectedly passed" >&2
  exit 1
fi

rm -f /tmp/ai-engineering-invalid-state.out /tmp/ai-engineering-invalid-state.err

generated_state="${TMP_ROOT}/workflow-state.json"
python3 "${REPO_ROOT}/scripts/generate-workflow-state.py" \
  --workflow software-delivery-pipeline \
  --run-path workflow/runs/2026-05-26-generated \
  --source-artifact workflow/reviews/2026-05-26-review/review-to-delivery-handoff.md \
  --domain-module java-spring-microservice \
  --status in_progress \
  --current-stage requirements \
  --latest-document 01-delivery-requirements.md \
  --next-action "Wait for requirements confirmation." \
  --risk-level medium \
  --risk-reason "Review handoff requires user confirmation before implementation." \
  --confirmation-required \
  --selected-scope F-001 \
  --affected-service order-service \
  --affected-controller OrderController \
  --affected-table orders \
  --affected-topic order.event \
  --affected-config-key order.submit.timeout \
  --blocker "human confirmation" \
  --updated-at "2026-05-26T00:00:00+08:00" \
  --output "${generated_state}" >/dev/null

python3 "${REPO_ROOT}/scripts/validate-workflow-state.py" \
  --schema "${REPO_ROOT}/docs/workflow-state-schema.json" \
  "${generated_state}" >/dev/null

diff -u "${REPO_ROOT}/tests/workflow-state/generated-state.expected.json" "${generated_state}" >/dev/null

echo "Workflow state schema checks passed."
