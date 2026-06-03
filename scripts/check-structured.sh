#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

bash "${REPO_ROOT}/scripts/check-python.sh"

python3 "${REPO_ROOT}/scripts/check-markdown.py" \
  "${REPO_ROOT}/README.md" \
  "${REPO_ROOT}/docs" \
  "${REPO_ROOT}/plugins/ai-engineering-skills/skills"

python3 "${REPO_ROOT}/scripts/check-artifact-metadata.py" \
  --schema "${REPO_ROOT}/docs/artifact-metadata-schema.json" \
  "${REPO_ROOT}/docs/artifact-templates" \
  "${REPO_ROOT}/plugins/ai-engineering-skills/skills/api-contract-design/assets/api-contract-templates" \
  "${REPO_ROOT}/plugins/ai-engineering-skills/skills/code-review-triage/assets/review-templates" \
  "${REPO_ROOT}/plugins/ai-engineering-skills/skills/codebase-orientation/assets/orientation-templates" \
  "${REPO_ROOT}/plugins/ai-engineering-skills/skills/data-migration-planning/assets/data-migration-templates" \
  "${REPO_ROOT}/plugins/ai-engineering-skills/skills/debug-root-cause/assets/debug-templates" \
  "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates" \
  "${REPO_ROOT}/docs/full-run-examples" \
  "${REPO_ROOT}/docs/run-examples" \
  "${REPO_ROOT}/tests/artifact-metadata/valid-artifact.md"

python3 "${REPO_ROOT}/scripts/check-example-completeness.py" \
  "${REPO_ROOT}/docs/full-run-examples" \
  "${REPO_ROOT}/docs/run-examples" \
  "${REPO_ROOT}/plugins/ai-engineering-skills/skills/api-contract-design/examples" \
  "${REPO_ROOT}/plugins/ai-engineering-skills/skills/code-review-triage/examples" \
  "${REPO_ROOT}/plugins/ai-engineering-skills/skills/codebase-orientation/examples" \
  "${REPO_ROOT}/plugins/ai-engineering-skills/skills/data-migration-planning/examples" \
  "${REPO_ROOT}/plugins/ai-engineering-skills/skills/debug-root-cause/examples" \
  "${REPO_ROOT}/plugins/ai-engineering-skills/skills/software-delivery-pipeline/examples"

echo "== Bootstrap routing cases =="
python3 "${REPO_ROOT}/scripts/check-bootstrap-routing.py" \
  --cases "${REPO_ROOT}/tests/bootstrap-routing/cases.tsv"

echo "== Bootstrap routing runtime-command harness =="
python3 "${REPO_ROOT}/scripts/check-bootstrap-routing.py" \
  --cases "${REPO_ROOT}/tests/bootstrap-routing/cases.tsv" \
  --runtime-command "${REPO_ROOT}/tests/bootstrap-routing/fake-agent-runtime.py"

echo "== Domain module routing =="
python3 "${REPO_ROOT}/scripts/check-domain-module-routing.py" \
  --cases "${REPO_ROOT}/tests/domain-modules/java-spring-microservice-cases.tsv"

echo "Structured checks passed."
