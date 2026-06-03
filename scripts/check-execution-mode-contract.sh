#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

require_file() {
  [[ -f "$1" ]] || fail "Missing file: $1"
}

require_dir() {
  [[ -d "$1" ]] || fail "Missing directory: $1"
}

require_file "${REPO_ROOT}/docs/execution-modes.zh-CN.md"
require_file "${REPO_ROOT}/docs/prompt-modules/conditional-blocks.zh-CN.md"
require_dir "${REPO_ROOT}/docs/run-examples/fast-patch"
require_dir "${REPO_ROOT}/docs/run-examples/guarded-change"
require_dir "${REPO_ROOT}/docs/run-examples/audited-delivery"
require_file "${REPO_ROOT}/docs/run-examples/fast-patch/summary.md"
require_file "${REPO_ROOT}/docs/run-examples/guarded-change/10-guarded-scope.md"
require_file "${REPO_ROOT}/docs/run-examples/guarded-change/11-guarded-plan.md"
require_file "${REPO_ROOT}/docs/run-examples/guarded-change/12-guarded-implementation.md"
require_file "${REPO_ROOT}/docs/run-examples/guarded-change/13-guarded-verification.md"
require_file "${REPO_ROOT}/docs/run-examples/guarded-change/14-guarded-summary.md"
require_file "${REPO_ROOT}/docs/run-examples/audited-delivery/README.md"
require_file "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates/00-fast-patch-summary.md"
require_file "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates/10-guarded-scope.md"
require_file "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates/11-guarded-plan.md"
require_file "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates/12-guarded-implementation.md"
require_file "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates/13-guarded-verification.md"
require_file "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates/14-guarded-summary.md"
require_file "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates/20-audited-run-map.md"

for term in fast guarded audited lightweight standard full; do
  rg -q "${term}" "${REPO_ROOT}/docs/execution-modes.zh-CN.md" || fail "execution modes missing term: ${term}"
done

rg -q 'conditional-blocks.zh-CN.md' "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md" || fail "delivery skill missing conditional blocks reference"
rg -q 'Fast Patch' "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md" || fail "delivery skill missing Fast Patch artifact path"
rg -q '00-fast-patch-summary.md' "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md" || fail "delivery skill should reference fast patch template"
rg -q 'Guarded Change' "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md" || fail "delivery skill missing Guarded Change artifact path"
rg -q '10-guarded-scope.md' "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md" || fail "delivery skill should reference guarded templates"
rg -q 'Audited Delivery' "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md" || fail "delivery skill missing Audited Delivery artifact path"
rg -q '20-audited-run-map.md' "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md" || fail "delivery skill should reference audited run map"

if rg -q '01-delivery-requirements|02-delivery-plan|03-delivery-implementation|05-delivery-verification' "${REPO_ROOT}/docs/run-examples/fast-patch"; then
  fail "fast-patch example should not include full delivery stage filenames"
fi

if rg -q '01-delivery-requirements|02-delivery-plan|03-delivery-implementation|05-delivery-verification' "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates/00-fast-patch-summary.md"; then
  fail "fast patch template should not include full delivery stage filenames"
fi

for old_guarded in 01-scope.md 02-plan.md 03-implementation.md 04-verification.md 05-summary.md; do
  if [[ -e "${REPO_ROOT}/docs/run-examples/guarded-change/${old_guarded}" ]]; then
    fail "guarded example should use 10-14 guarded filenames, found: ${old_guarded}"
  fi
done

for term in '20-audited-run-map.md' '01-delivery-requirements.md' '05-delivery-change-review.md' 'Verification Matrix' 'Risk Gate' 'Skipped Reason' 'handoff'; do
  rg -q "${term}" "${REPO_ROOT}/docs/run-examples/audited-delivery/README.md" || fail "audited example missing term: ${term}"
done

for term in 'Audited Trigger' 'Risk Gate' 'Gate Map' 'Verification Matrix Rule' 'Skipped Reason Rule' 'handoff'; do
  rg -q "${term}" "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates/20-audited-run-map.md" || fail "audited run map missing term: ${term}"
done

audited_templates=(
  01-delivery-requirements.md
  02-delivery-architecture.md
  02-delivery-plan.md
  03-delivery-plan.md
  03-delivery-implementation.md
  04-delivery-implementation.md
  04-delivery-debugging.md
  05-delivery-change-review.md
  05-delivery-verification.md
  06-delivery-debugging.md
  06-delivery-summary.md
  07-delivery-verification.md
  08-delivery-summary.md
)

for template in "${audited_templates[@]}"; do
  path="${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates/${template}"
  rg -q 'mode: audited only' "${path}" || fail "audited template missing audited-only marker: ${template}"
  rg -q 'executionMode: full' "${path}" || fail "audited template should use executionMode full: ${template}"
done

for template in \
  00-fast-patch-summary.md \
  10-guarded-scope.md \
  11-guarded-plan.md \
  12-guarded-implementation.md \
  13-guarded-verification.md \
  14-guarded-summary.md; do
  path="${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates/${template}"
  if rg -q 'mode: audited only' "${path}"; then
    fail "fast/guarded template must not be marked audited-only: ${template}"
  fi
done

rg -q 'Template Mode Taxonomy' "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/references/document-contracts.md" || fail "document contracts missing template mode taxonomy"

echo "Execution mode contract checks passed."
