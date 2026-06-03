#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PLUGIN_DIR="${REPO_ROOT}/plugins/ai-engineering-skills"
SKILLS_DIR="${PLUGIN_DIR}/skills"

bash "${REPO_ROOT}/scripts/check-tooling.sh" rg

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

require_file "${REPO_ROOT}/README.md"
require_file "${REPO_ROOT}/CHANGELOG.md"
require_file "${REPO_ROOT}/docs/skills-guide.zh-CN.md"
require_file "${REPO_ROOT}/docs/versioning.zh-CN.md"
require_file "${REPO_ROOT}/docs/workflow-contracts.zh-CN.md"
require_file "${REPO_ROOT}/docs/workflow-state-schema.json"
require_file "${REPO_ROOT}/docs/artifact-metadata-schema.json"
require_file "${REPO_ROOT}/docs/workflow-index-template.md"
require_file "${REPO_ROOT}/docs/execution-modes.zh-CN.md"
require_file "${REPO_ROOT}/docs/artifact-templates/state.md"
require_file "${REPO_ROOT}/docs/artifact-templates/stage-document.md"
require_file "${REPO_ROOT}/docs/artifact-templates/summary.md"
require_file "${REPO_ROOT}/docs/artifact-templates/handoff.md"
require_file "${REPO_ROOT}/docs/artifact-templates/stop-record.md"
require_file "${REPO_ROOT}/docs/bootstrap-examples.zh-CN.md"
require_file "${REPO_ROOT}/docs/examples-policy.zh-CN.md"
require_file "${REPO_ROOT}/docs/compatibility.zh-CN.md"
require_file "${REPO_ROOT}/docs/superpowers-inspired-rules.zh-CN.md"
require_file "${REPO_ROOT}/docs/full-run-examples/README.zh-CN.md"
require_file "${REPO_ROOT}/docs/run-examples/README.zh-CN.md"
require_file "${REPO_ROOT}/docs/install-smoke-test.zh-CN.md"
require_file "${REPO_ROOT}/docs/release-checklist.zh-CN.md"
require_file "${REPO_ROOT}/docs/domain-modules/java-spring-microservice.zh-CN.md"
require_file "${PLUGIN_DIR}/.codex-plugin/plugin.json"
require_file "${PLUGIN_DIR}/.claude-plugin/plugin.json"
require_file "${REPO_ROOT}/.claude-plugin/marketplace.json"
require_file "${REPO_ROOT}/tests/bootstrap-routing/cases.tsv"
require_file "${REPO_ROOT}/tests/bootstrap-routing/fake-agent-runtime.py"
require_file "${REPO_ROOT}/tests/domain-modules/java-spring-microservice-cases.tsv"
require_file "${REPO_ROOT}/scripts/install-codex-skills.sh"
require_file "${REPO_ROOT}/scripts/install-claude-plugin.sh"
require_file "${REPO_ROOT}/scripts/smoke-install-local.sh"
require_file "${REPO_ROOT}/scripts/generate-workflow-state.py"
require_file "${REPO_ROOT}/scripts/update-workflow-index.py"
require_file "${REPO_ROOT}/scripts/validate-workflow-state.py"
require_file "${REPO_ROOT}/scripts/check-markdown.py"
require_file "${REPO_ROOT}/scripts/check-artifact-metadata.py"
require_file "${REPO_ROOT}/scripts/check-bootstrap-routing.py"
require_file "${REPO_ROOT}/scripts/check-domain-module-routing.py"
require_file "${REPO_ROOT}/scripts/check-python.sh"
require_file "${REPO_ROOT}/scripts/check-tooling.sh"
require_file "${REPO_ROOT}/scripts/check-example-completeness.py"
require_file "${REPO_ROOT}/scripts/check-structured.sh"
require_file "${REPO_ROOT}/scripts/check-execution-mode-contract.sh"
require_file "${REPO_ROOT}/scripts/check-workflow-state.sh"
require_file "${REPO_ROOT}/scripts/check-workflow-index.sh"
require_file "${REPO_ROOT}/scripts/release-check.sh"
require_dir "${SKILLS_DIR}"
require_file "${REPO_ROOT}/tests/workflow-state/valid-state.json"
require_file "${REPO_ROOT}/tests/workflow-state/invalid-state.json"
require_file "${REPO_ROOT}/tests/workflow-state/generated-state.expected.json"
require_file "${REPO_ROOT}/tests/workflow-index/expected-index.md"
require_file "${REPO_ROOT}/tests/artifact-metadata/valid-artifact.md"
require_dir "${REPO_ROOT}/docs/prompt-modules"
for prompt_module in \
  clarification.zh-CN.md \
  implementation-plan.zh-CN.md \
  execution-discipline.zh-CN.md \
  test-strategy.zh-CN.md \
  debug-discipline.zh-CN.md \
  verification-gate.zh-CN.md \
  review-loop.zh-CN.md \
  worktree-recommendation.zh-CN.md \
  task-decomposition.zh-CN.md \
  conditional-blocks.zh-CN.md \
  finish-checklist.zh-CN.md \
  handoff.zh-CN.md \
  lightweight-mode.zh-CN.md \
  minimal-change.zh-CN.md \
  write-guard.zh-CN.md \
  risk-gate.zh-CN.md; do
  require_file "${REPO_ROOT}/docs/prompt-modules/${prompt_module}"
done

codex_skills_path="$(sed -n 's/^[[:space:]]*"skills":[[:space:]]*"\([^"]*\)".*/\1/p' "${PLUGIN_DIR}/.codex-plugin/plugin.json" | head -n 1)"
[[ -n "${codex_skills_path}" ]] || fail "Cannot find skills path in Codex plugin manifest"
[[ "${codex_skills_path}" == "./skills/" ]] || fail "Codex plugin skills path must be ./skills/: ${codex_skills_path}"
require_dir "${PLUGIN_DIR}/${codex_skills_path#./}"
rg -q '"name":[[:space:]]*"ai-engineering-skills"' "${PLUGIN_DIR}/.codex-plugin/plugin.json" || fail "Codex plugin manifest should use ai-engineering-skills name"
rg -q '"name":[[:space:]]*"ai-engineering-skills"' "${PLUGIN_DIR}/.claude-plugin/plugin.json" || fail "Claude plugin manifest should use ai-engineering-skills name"
rg -q '"source":[[:space:]]*"./plugins/ai-engineering-skills"' "${REPO_ROOT}/.claude-plugin/marketplace.json" || fail "Claude marketplace should point to canonical plugin directory"
require_dir "${PLUGIN_DIR}/skills"
require_dir "${PLUGIN_DIR}/.codex-plugin"
require_dir "${PLUGIN_DIR}/.claude-plugin"
rg -q "workflow-bootstrap" "${PLUGIN_DIR}/.codex-plugin/plugin.json" || fail "Codex plugin defaultPrompt should recommend workflow-bootstrap"
rg -q 'Handoff Flow Contract' "${SKILLS_DIR}/workflow-bootstrap/SKILL.md" || fail "workflow-bootstrap should reference Handoff Flow Contract"
rg -q 'Handoff Flow Contract' "${SKILLS_DIR}/software-delivery-pipeline/SKILL.md" || fail "software-delivery-pipeline should reference Handoff Flow Contract"
rg -q 'Workflow 契约' "${REPO_ROOT}/README.md" || fail "README should link workflow contract"
rg -q 'Execution Modes' "${REPO_ROOT}/README.md" || fail "README should link execution modes"
rg -q 'workflow/runs/<run>/' "${REPO_ROOT}/docs/skills-guide.zh-CN.md" || fail "skills guide should document delivery run path"
rg -q 'workflow/runs/<YYYY-MM-DD>-<slug>/' "${REPO_ROOT}/docs/skills-guide.zh-CN.md" || fail "skills guide should document delivery run slug path"
rg -q 'workflow/runs/<YYYY-MM-DD>-<slug>' "${SKILLS_DIR}/software-delivery-pipeline/SKILL.md" || fail "delivery skill should use canonical workflow/runs path"
rg -q 'workflow/runs/' "${SKILLS_DIR}/software-delivery-pipeline/examples/standard-run.md" || fail "delivery standard example should use workflow/runs path"
if rg -q 'workflow/delivery' "${SKILLS_DIR}/software-delivery-pipeline" "${REPO_ROOT}/docs/skills-guide.zh-CN.md"; then
  fail "delivery path should be workflow/runs, not workflow/delivery"
fi

codex_version="$(sed -n 's/^[[:space:]]*"version":[[:space:]]*"\([^"]*\)".*/\1/p' "${PLUGIN_DIR}/.codex-plugin/plugin.json" | head -n 1)"
claude_version="$(sed -n 's/^[[:space:]]*"version":[[:space:]]*"\([^"]*\)".*/\1/p' "${PLUGIN_DIR}/.claude-plugin/plugin.json" | head -n 1)"
[[ -n "${codex_version}" ]] || fail "Cannot find version in Codex plugin manifest"
[[ -n "${claude_version}" ]] || fail "Cannot find version in Claude plugin manifest"
[[ "${codex_version}" == "${claude_version}" ]] || fail "Codex and Claude plugin versions differ: ${codex_version} vs ${claude_version}"
rg -q "^## \\[${codex_version}\\]" "${REPO_ROOT}/CHANGELOG.md" || fail "CHANGELOG missing current version: ${codex_version}"
rg -q "MAJOR.MINOR.PATCH" "${REPO_ROOT}/docs/versioning.zh-CN.md" || fail "versioning policy missing semantic versioning guidance"
rg -q '最小发布检查清单' "${REPO_ROOT}/docs/release-checklist.zh-CN.md" || fail "release checklist missing minimum release checklist"
for term in 'manifest' 'marketplace' '版本号' '文档' '示例' '模板' '安装脚本' '测试脚本' '发布说明'; do
  rg -q "${term}" "${REPO_ROOT}/docs/release-checklist.zh-CN.md" || fail "release checklist missing term: ${term}"
done

[[ -x "${REPO_ROOT}/scripts/install-codex-skills.sh" ]] || fail "Codex install script should be executable"
rg -q 'plugins/ai-engineering-skills/skills' "${REPO_ROOT}/scripts/install-codex-skills.sh" || fail "Codex install script should install from the canonical plugin skills directory"
rg -q 'SHARED_DOCS_DIR' "${REPO_ROOT}/scripts/install-codex-skills.sh" || fail "Codex install script should copy shared docs"
rg -q -- '--dry-run' "${REPO_ROOT}/scripts/install-codex-skills.sh" || fail "Codex install script should support --dry-run"
rg -q -- '--force' "${REPO_ROOT}/scripts/install-codex-skills.sh" || fail "Codex install script should support --force"
rg -q -- '--backup' "${REPO_ROOT}/scripts/install-codex-skills.sh" || fail "Codex install script should support --backup"
rg -q 'DRY-RUN:' "${REPO_ROOT}/scripts/install-codex-skills.sh" || fail "Codex install script dry-run output should be explicit"

[[ -x "${REPO_ROOT}/scripts/install-claude-plugin.sh" ]] || fail "Claude install script should be executable"
rg -q 'plugins/ai-engineering-skills' "${REPO_ROOT}/scripts/install-claude-plugin.sh" || fail "Claude install script should install from the canonical plugin directory"
rg -q 'SHARED_DOCS_DIR' "${REPO_ROOT}/scripts/install-claude-plugin.sh" || fail "Claude install script should copy shared docs"
rg -q -- '--dry-run' "${REPO_ROOT}/scripts/install-claude-plugin.sh" || fail "Claude install script should support --dry-run"
rg -q -- '--force' "${REPO_ROOT}/scripts/install-claude-plugin.sh" || fail "Claude install script should support --force"
rg -q -- '--backup' "${REPO_ROOT}/scripts/install-claude-plugin.sh" || fail "Claude install script should support --backup"
rg -q 'DRY-RUN:' "${REPO_ROOT}/scripts/install-claude-plugin.sh" || fail "Claude install script dry-run output should be explicit"

[[ -x "${REPO_ROOT}/scripts/smoke-install-local.sh" ]] || fail "Smoke install script should be executable"
[[ -x "${REPO_ROOT}/scripts/generate-workflow-state.py" ]] || fail "Workflow state generator should be executable"
[[ -x "${REPO_ROOT}/scripts/update-workflow-index.py" ]] || fail "Workflow index updater should be executable"
[[ -x "${REPO_ROOT}/scripts/validate-workflow-state.py" ]] || fail "Workflow state validator should be executable"
[[ -x "${REPO_ROOT}/scripts/check-markdown.py" ]] || fail "Markdown check script should be executable"
[[ -x "${REPO_ROOT}/scripts/check-artifact-metadata.py" ]] || fail "Artifact metadata check script should be executable"
[[ -x "${REPO_ROOT}/scripts/check-bootstrap-routing.py" ]] || fail "Bootstrap routing harness should be executable"
[[ -x "${REPO_ROOT}/scripts/check-domain-module-routing.py" ]] || fail "Domain module routing harness should be executable"
[[ -x "${REPO_ROOT}/scripts/check-python.sh" ]] || fail "Python availability check script should be executable"
[[ -x "${REPO_ROOT}/scripts/check-structured.sh" ]] || fail "Structured check wrapper should be executable"
[[ -x "${REPO_ROOT}/scripts/check-execution-mode-contract.sh" ]] || fail "Execution mode contract check script should be executable"
[[ -x "${REPO_ROOT}/tests/bootstrap-routing/fake-agent-runtime.py" ]] || fail "Fake agent runtime should be executable"
[[ -x "${REPO_ROOT}/scripts/check-workflow-state.sh" ]] || fail "Workflow state check script should be executable"
[[ -x "${REPO_ROOT}/scripts/check-workflow-index.sh" ]] || fail "Workflow index check script should be executable"
[[ -x "${REPO_ROOT}/scripts/release-check.sh" ]] || fail "Release check script should be executable"
rg -q 'mktemp -d' "${REPO_ROOT}/scripts/smoke-install-local.sh" || fail "Smoke install script should use a temporary directory"
rg -q 'CODEX_SKILLS_DIR' "${REPO_ROOT}/scripts/smoke-install-local.sh" || fail "Smoke install script should isolate Codex install target"
rg -q 'CLAUDE_PLUGINS_DIR' "${REPO_ROOT}/scripts/smoke-install-local.sh" || fail "Smoke install script should isolate Claude install target"
rg -q 'docs/workflow-contracts.zh-CN.md' "${REPO_ROOT}/scripts/smoke-install-local.sh" || fail "Smoke install script should verify installed shared docs"
rg -q '.codex-plugin/plugin.json' "${REPO_ROOT}/scripts/smoke-install-local.sh" || fail "Smoke install script should verify Codex plugin metadata"
rg -q '.claude-plugin/plugin.json' "${REPO_ROOT}/scripts/smoke-install-local.sh" || fail "Smoke install script should verify Claude plugin metadata"
rg -q 'generate-workflow-state.py' "${REPO_ROOT}/scripts/check-workflow-state.sh" || fail "Workflow state check should call generator"
rg -q 'validate-workflow-state.py' "${REPO_ROOT}/scripts/check-workflow-state.sh" || fail "Workflow state check should call validator"
rg -q 'update-workflow-index.py' "${REPO_ROOT}/scripts/check-workflow-index.sh" || fail "Workflow index check should call updater"
for wrapper in check-workflow-state.sh check-workflow-index.sh check-structured.sh; do
  rg -q 'check-python.sh' "${REPO_ROOT}/scripts/${wrapper}" || fail "${wrapper} should use check-python.sh before Python-backed checks"
done
rg -q 'check-tooling.sh' "${REPO_ROOT}/scripts/check-consistency.sh" || fail "consistency check should validate rg availability"
rg -q 'check-tooling.sh' "${REPO_ROOT}/scripts/check-execution-mode-contract.sh" || fail "execution mode contract check should validate rg availability"
rg -q 'check-tooling.sh' "${REPO_ROOT}/scripts/release-check.sh" || fail "release-check.sh should validate git availability"
rg -q 'check-tooling.sh' "${REPO_ROOT}/scripts/check-python.sh" || fail "check-python.sh should use shared tooling validation"
rg -q 'check-structured.sh' "${REPO_ROOT}/scripts/release-check.sh" || fail "release-check.sh should use check-structured.sh for Python-backed checks"
for term in 'check-consistency.sh' 'check-workflow-state.sh' 'check-workflow-index.sh' 'check-structured.sh' 'smoke-install-local.sh' 'install-codex-skills.sh" --dry-run --backup' 'install-claude-plugin.sh" --dry-run --backup'; do
  rg -q "${term}" "${REPO_ROOT}/scripts/release-check.sh" || fail "release check script missing term: ${term}"
done
for term in '--ci' '--no-smoke' '--skip-dry-run'; do
  rg -q -- "${term}" "${REPO_ROOT}/scripts/release-check.sh" || fail "release check script missing option: ${term}"
  rg -q -- "${term}" "${REPO_ROOT}/scripts/README.md" || fail "scripts README missing release option: ${term}"
done
rg -q -- '--strict-jsonschema' "${REPO_ROOT}/scripts/validate-workflow-state.py" || fail "workflow state validator missing strict jsonschema option"
rg -q 'executionMode' "${REPO_ROOT}/docs/workflow-state-schema.json" || fail "workflow state schema missing executionMode"
rg -q 'modePath' "${REPO_ROOT}/docs/workflow-state-schema.json" || fail "workflow state schema missing modePath"
rg -q -- '--execution-mode' "${REPO_ROOT}/scripts/generate-workflow-state.py" || fail "workflow state generator missing execution mode option"
rg -q -- '--mode-path' "${REPO_ROOT}/scripts/generate-workflow-state.py" || fail "workflow state generator missing mode path option"
for mode in lightweight standard full; do
  rg -q "${mode}" "${REPO_ROOT}/docs/workflow-contracts.zh-CN.md" || fail "workflow contract missing execution mode: ${mode}"
  rg -q "${mode}" "${REPO_ROOT}/docs/workflow-state-schema.json" || fail "workflow state schema missing execution mode: ${mode}"
done
for mode_path in fast guarded audited; do
  rg -q "${mode_path}" "${REPO_ROOT}/docs/workflow-contracts.zh-CN.md" || fail "workflow contract missing mode path: ${mode_path}"
  rg -q "${mode_path}" "${REPO_ROOT}/docs/workflow-state-schema.json" || fail "workflow state schema missing mode path: ${mode_path}"
done
rg -q 'artifact-metadata-schema' "${REPO_ROOT}/scripts/check-artifact-metadata.py" || fail "artifact metadata checker should use schema"
rg -q 'extract_front_matter' "${REPO_ROOT}/scripts/check-artifact-metadata.py" || fail "artifact metadata checker should parse YAML front matter"
rg -q 'REQUIRED_HANDOFF_KEYS' "${REPO_ROOT}/scripts/check-artifact-metadata.py" || fail "artifact metadata checker should enforce handoff metadata"
rg -q 'docs/artifact-templates' "${REPO_ROOT}/scripts/check-structured.sh" || fail "structured check should validate artifact templates"
rg -q 'check-example-completeness.py' "${REPO_ROOT}/scripts/check-structured.sh" || fail "structured check should validate published examples for leftover placeholders"
rg -q 'assets/.\\*-templates' "${REPO_ROOT}/docs/testing.zh-CN.md" || fail "testing docs should include artifact template metadata check"
rg -q -- '--runtime-command' "${REPO_ROOT}/scripts/check-bootstrap-routing.py" || fail "bootstrap routing harness missing runtime command mode"
rg -q -- '--strict-jsonschema' "${REPO_ROOT}/docs/testing.zh-CN.md" || fail "testing docs missing strict jsonschema option"
rg -q '自动化 Harness' "${REPO_ROOT}/docs/bootstrap-examples.zh-CN.md" || fail "bootstrap examples missing automation harness"
rg -q '真实 agent harness' "${REPO_ROOT}/docs/bootstrap-examples.zh-CN.md" || fail "bootstrap examples missing real agent harness boundary"
rg -q 'Delivery 执行模式冒烟' "${REPO_ROOT}/docs/bootstrap-examples.zh-CN.md" || fail "bootstrap examples missing delivery execution mode smoke tests"
rg -q '三档执行模式冒烟' "${REPO_ROOT}/docs/install-smoke-test.zh-CN.md" || fail "install smoke test missing execution mode smoke prompts"
rg -q 'NO_WORKFLOW_INTENTS' "${REPO_ROOT}/scripts/check-bootstrap-routing.py" || fail "bootstrap routing should use no-workflow intent rules"
rg -q 'WORKFLOW_ACTIONS' "${REPO_ROOT}/scripts/check-bootstrap-routing.py" || fail "bootstrap routing should use workflow action rules"
rg -q 'review 后修复' "${REPO_ROOT}/tests/bootstrap-routing/cases.tsv" || fail "bootstrap routing cases should cover review-first conflict"
rg -q '解释一下这个问题' "${REPO_ROOT}/tests/bootstrap-routing/cases.tsv" || fail "bootstrap routing cases should cover no-workflow Q&A intent"
rg -q '不默认维护完整 01-07/08 示例' "${REPO_ROOT}/docs/examples-policy.zh-CN.md" || fail "examples policy missing full-run decision"
rg -q '用户自主决策原则' "${REPO_ROOT}/docs/compatibility.zh-CN.md" || fail "compatibility docs missing user decision principle"
rg -q 'Full Run 示例' "${REPO_ROOT}/docs/full-run-examples/README.zh-CN.md" || fail "full-run examples README missing title"
rg -q '不代表默认执行路径' "${REPO_ROOT}/docs/full-run-examples/README.zh-CN.md" || fail "full-run examples should state they are not the default path"
rg -q 'Run Examples' "${REPO_ROOT}/docs/run-examples/README.zh-CN.md" || fail "run examples README missing title"
bash "${REPO_ROOT}/scripts/check-execution-mode-contract.sh" >/dev/null
for workflow in codebase-orientation code-review-triage software-delivery-pipeline debug-root-cause api-contract-design data-migration-planning; do
  require_file "${REPO_ROOT}/docs/full-run-examples/${workflow}/full-run.md"
  require_dir "${REPO_ROOT}/docs/full-run-examples/${workflow}/files"
  rg -q "workflow: ${workflow}" "${REPO_ROOT}/docs/full-run-examples/${workflow}/full-run.md" || fail "full-run example missing workflow metadata: ${workflow}"
  rg -q '## Verification' "${REPO_ROOT}/docs/full-run-examples/${workflow}/full-run.md" || fail "full-run example missing Verification: ${workflow}"
  rg -q "workflow: ${workflow}" "${REPO_ROOT}/docs/full-run-examples/${workflow}/files"/*.md || fail "full-run files missing workflow metadata: ${workflow}"
done
rg -q 'Superpowers 方法论吸收说明' "${REPO_ROOT}/README.md" || fail "README should link superpowers-inspired rules"
rg -q 'execution-modes.zh-CN.md' "${SKILLS_DIR}/software-delivery-pipeline/SKILL.md" || fail "delivery skill should reference execution modes"
rg -q 'conditional-blocks.zh-CN.md' "${SKILLS_DIR}/software-delivery-pipeline/SKILL.md" || fail "delivery skill should reference conditional blocks"
rg -q 'Audited hard triggers override task size' "${SKILLS_DIR}/software-delivery-pipeline/SKILL.md" || fail "delivery skill should make audited triggers override task size"
rg -q 'single combined gate' "${SKILLS_DIR}/software-delivery-pipeline/SKILL.md" || fail "delivery skill should define guarded combined confirmation"
rg -q '风险触发优先于任务大小' "${REPO_ROOT}/docs/execution-modes.zh-CN.md" || fail "execution modes should prioritize risk over task size"
rg -q 'fast 模式例外' "${REPO_ROOT}/docs/prompt-modules/write-guard.zh-CN.md" || fail "write guard should define fast mode write exception"
for term in 'brainstorming' 'writing-plans' 'executing-plans' 'test-driven-development' 'systematic-debugging' 'verification-before-completion' 'requesting-code-review' 'receiving-code-review' 'using-git-worktrees' 'subagent-driven-development' 'finishing-a-development-branch'; do
  rg -q "${term}" "${REPO_ROOT}/docs/superpowers-inspired-rules.zh-CN.md" || fail "superpowers-inspired rules missing capability: ${term}"
done
for term in 'Implementation Plan' 'Implementation Strategy' 'Debug Analysis' 'Review Findings' 'Fix Handoff' 'Verification' 'Worktree Recommendation' 'Task Decomposition' 'Finish Checklist'; do
  rg -q "${term}" "${REPO_ROOT}/docs/prompt-modules" "${REPO_ROOT}/docs/superpowers-inspired-rules.zh-CN.md" || fail "prompt modules missing term: ${term}"
done
for module in "${REPO_ROOT}"/docs/prompt-modules/*.md; do
  rg -q '## 正例' "${module}" || fail "prompt module missing positive examples: ${module}"
  rg -q '## 反例' "${module}" || fail "prompt module missing negative examples: ${module}"
done

if [[ -d "${REPO_ROOT}/skills" ]]; then
  fail "Root-level skills directory should not exist; canonical source is plugins/ai-engineering-skills/skills"
fi

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
  skill_dir="${SKILLS_DIR}/${skill}"
  require_dir "${skill_dir}"
  require_file "${skill_dir}/SKILL.md"

  rg -q "\\[.*${skill}.*\\]" "${REPO_ROOT}/README.md" || fail "README does not mention skill link: ${skill}"
  rg -q "\`${skill}\`" "${REPO_ROOT}/docs/skills-guide.zh-CN.md" || fail "skills guide does not mention skill: ${skill}"
  rg -q "${skill}" "${SKILLS_DIR}/workflow-bootstrap/SKILL.md" || fail "workflow-bootstrap does not mention skill: ${skill}"
  rg -q 'Use when' "${skill_dir}/SKILL.md" || fail "skill missing Use when boundary: ${skill}"
  rg -q 'Do not use when' "${skill_dir}/SKILL.md" || fail "skill missing Do not use when boundary: ${skill}"
  rg -q 'Prefer another skill when' "${skill_dir}/SKILL.md" || fail "skill missing Prefer another skill when boundary: ${skill}"
  rg -q 'Execution Mode Selection' "${skill_dir}/SKILL.md" || fail "skill missing execution mode selection section: ${skill}"
  rg -q 'Prompt Modules' "${skill_dir}/SKILL.md" || fail "skill missing Prompt Modules section: ${skill}"
  rg -q 'lightweight-mode.zh-CN.md' "${skill_dir}/SKILL.md" || fail "skill missing lightweight mode prompt module: ${skill}"
  rg -q 'minimal-change.zh-CN.md' "${skill_dir}/SKILL.md" || fail "skill missing minimal change prompt module: ${skill}"
  rg -q 'write-guard.zh-CN.md' "${skill_dir}/SKILL.md" || fail "skill missing write guard prompt module: ${skill}"
  rg -q 'risk-gate.zh-CN.md' "${skill_dir}/SKILL.md" || fail "skill missing risk gate prompt module: ${skill}"
  rg -q 'java-spring-microservice.zh-CN.md' "${skill_dir}/SKILL.md" || fail "skill missing Java/Spring domain module reference: ${skill}"
  for mode in lightweight standard full; do
    rg -q "${mode}" "${skill_dir}/SKILL.md" || fail "skill missing execution mode ${mode}: ${skill}"
  done
  if ! rg -q 'verification-gate.zh-CN.md' "${skill_dir}/SKILL.md" && ! rg -q 'Verification' "${skill_dir}/SKILL.md"; then
    fail "skill missing Verification gate reference: ${skill}"
  fi

  if [[ "${skill}" != "workflow-bootstrap" ]]; then
    require_dir "${skill_dir}/assets"
    require_dir "${skill_dir}/references"
    require_dir "${skill_dir}/examples"
    require_file "${skill_dir}/examples/standard-run.md"
    rg -q "${skill}" "${REPO_ROOT}/docs/bootstrap-examples.zh-CN.md" || fail "bootstrap examples do not mention workflow: ${skill}"
    rg -q 'workflow-state.json' "${skill_dir}/SKILL.md" || fail "skill does not declare workflow-state.json: ${skill}"
    rg -q 'Stop and Confirmation Contract' "${skill_dir}/SKILL.md" || fail "skill does not reference Stop and Confirmation Contract: ${skill}"
    rg -q 'Execution Mode Contract' "${skill_dir}/SKILL.md" || fail "skill does not reference Execution Mode Contract: ${skill}"
    rg -q 'examples/standard-run.md' "${skill_dir}/SKILL.md" || fail "skill does not reference standard example: ${skill}"
    rg -q 'workflow-state.json' "${skill_dir}/examples/standard-run.md" || fail "standard example missing workflow-state.json: ${skill}"
  fi
done

rg -q 'clarification.zh-CN.md' "${SKILLS_DIR}/workflow-bootstrap/SKILL.md" || fail "workflow-bootstrap missing clarification prompt module"
rg -q 'handoff.zh-CN.md' "${SKILLS_DIR}/workflow-bootstrap/SKILL.md" || fail "workflow-bootstrap missing handoff prompt module"
rg -q 'handoff.zh-CN.md' "${SKILLS_DIR}/code-review-triage/SKILL.md" || fail "review skill missing handoff prompt module"
rg -q 'handoff.zh-CN.md' "${SKILLS_DIR}/debug-root-cause/SKILL.md" || fail "debug skill missing handoff prompt module"
rg -q 'handoff.zh-CN.md' "${SKILLS_DIR}/api-contract-design/SKILL.md" || fail "api contract skill missing handoff prompt module"
rg -q 'handoff.zh-CN.md' "${SKILLS_DIR}/data-migration-planning/SKILL.md" || fail "migration skill missing handoff prompt module"
rg -q 'handoff.zh-CN.md' "${SKILLS_DIR}/codebase-orientation/SKILL.md" || fail "orientation skill missing handoff prompt module"
rg -q 'handoff.zh-CN.md' "${SKILLS_DIR}/software-delivery-pipeline/SKILL.md" || fail "delivery skill missing handoff prompt module"
rg -q 'Implementation Plan' "${SKILLS_DIR}/software-delivery-pipeline/SKILL.md" || fail "delivery skill missing Implementation Plan"
rg -q 'Implementation Strategy' "${SKILLS_DIR}/software-delivery-pipeline/SKILL.md" || fail "delivery skill missing Implementation Strategy"
rg -q 'Task Decomposition' "${SKILLS_DIR}/software-delivery-pipeline/SKILL.md" || fail "delivery skill missing Task Decomposition"
rg -q 'Worktree Recommendation' "${SKILLS_DIR}/software-delivery-pipeline/SKILL.md" || fail "delivery skill missing Worktree Recommendation"
rg -q 'Finish Checklist' "${SKILLS_DIR}/software-delivery-pipeline/SKILL.md" || fail "delivery skill missing Finish Checklist"
rg -q 'Debug Analysis' "${SKILLS_DIR}/debug-root-cause/SKILL.md" || fail "debug skill missing Debug Analysis"
rg -q 'Review Findings' "${SKILLS_DIR}/code-review-triage/SKILL.md" || fail "review skill missing Review Findings"
rg -q 'Fix Handoff' "${SKILLS_DIR}/code-review-triage/SKILL.md" || fail "review skill missing Fix Handoff"
rg -q 'worktree-recommendation.zh-CN.md' "${SKILLS_DIR}/data-migration-planning/SKILL.md" || fail "migration skill missing worktree recommendation module"
rg -q 'task-decomposition.zh-CN.md' "${SKILLS_DIR}/codebase-orientation/SKILL.md" || fail "orientation skill missing task decomposition module"
rg -q 'Implementation Strategy' "${SKILLS_DIR}/software-delivery-pipeline/examples/standard-run.md" || fail "delivery standard example missing Implementation Strategy"
rg -q 'Implementation Plan' "${SKILLS_DIR}/software-delivery-pipeline/examples/standard-run.md" || fail "delivery standard example missing Implementation Plan"
rg -q 'Finish Checklist' "${SKILLS_DIR}/software-delivery-pipeline/examples/standard-run.md" || fail "delivery standard example missing Finish Checklist"
rg -q 'Debug Analysis' "${SKILLS_DIR}/debug-root-cause/examples/standard-run.md" || fail "debug standard example missing Debug Analysis"
rg -q 'Review Findings' "${SKILLS_DIR}/code-review-triage/examples/standard-run.md" || fail "review standard example missing Review Findings"
rg -q 'Fix Handoff' "${SKILLS_DIR}/code-review-triage/examples/standard-run.md" || fail "review standard example missing Fix Handoff"
rg -q 'Task Decomposition' "${SKILLS_DIR}/codebase-orientation/examples/standard-run.md" || fail "orientation standard example missing Task Decomposition"
rg -q 'Worktree Recommendation' "${SKILLS_DIR}/data-migration-planning/examples/standard-run.md" || fail "migration standard example missing Worktree Recommendation"
for skill in codebase-orientation code-review-triage software-delivery-pipeline debug-root-cause api-contract-design data-migration-planning; do
  rg -q '## Verification' "${SKILLS_DIR}/${skill}/examples/standard-run.md" || fail "standard example missing Verification: ${skill}"
done
rg -q 'Implementation Strategy' "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/02-delivery-plan.md" || fail "delivery simple plan template missing Implementation Strategy"
rg -q 'Implementation Plan' "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/02-delivery-plan.md" || fail "delivery simple plan template missing Implementation Plan"
rg -q 'Task Decomposition' "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/02-delivery-plan.md" || fail "delivery simple plan template missing Task Decomposition"
rg -q 'Worktree Recommendation' "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/02-delivery-plan.md" || fail "delivery simple plan template missing Worktree Recommendation"
rg -q 'Implementation Strategy' "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/03-delivery-plan.md" || fail "delivery complex plan template missing Implementation Strategy"
rg -q 'Implementation Plan' "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/03-delivery-plan.md" || fail "delivery complex plan template missing Implementation Plan"
rg -q 'Task Decomposition' "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/03-delivery-plan.md" || fail "delivery complex plan template missing Task Decomposition"
rg -q 'Worktree Recommendation' "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/03-delivery-plan.md" || fail "delivery complex plan template missing Worktree Recommendation"
rg -q 'Finish Checklist' "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/06-delivery-summary.md" || fail "delivery simple summary template missing Finish Checklist"
rg -q 'Finish Checklist' "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/08-delivery-summary.md" || fail "delivery complex summary template missing Finish Checklist"
rg -q 'Debug Analysis' "${SKILLS_DIR}/debug-root-cause/assets/debug-templates/08-debug-summary.md" || fail "debug summary template missing Debug Analysis"
rg -q 'Review Findings' "${SKILLS_DIR}/code-review-triage/assets/review-templates/02-review-findings.md" || fail "review findings template missing Review Findings"
rg -q 'Fix Handoff' "${SKILLS_DIR}/code-review-triage/assets/review-templates/review-to-delivery-handoff.md" || fail "review handoff template missing Fix Handoff"
rg -q 'Worktree Recommendation' "${SKILLS_DIR}/data-migration-planning/assets/data-migration-templates/04-migration-plan.md" || fail "migration plan template missing Worktree Recommendation"
for template in \
  "${SKILLS_DIR}/codebase-orientation/assets/orientation-templates/07-orientation-summary.md" \
  "${SKILLS_DIR}/code-review-triage/assets/review-templates/07-review-summary.md" \
  "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/05-delivery-verification.md" \
  "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/06-delivery-summary.md" \
  "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/07-delivery-verification.md" \
  "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/08-delivery-summary.md" \
  "${SKILLS_DIR}/debug-root-cause/assets/debug-templates/08-debug-summary.md" \
  "${SKILLS_DIR}/api-contract-design/assets/api-contract-templates/07-api-summary.md" \
  "${SKILLS_DIR}/data-migration-planning/assets/data-migration-templates/07-migration-summary.md"; do
  rg -q '## Verification' "${template}" || fail "template missing Verification section: ${template}"
  rg -q '完成判断' "${template}" || fail "template missing completion judgment: ${template}"
done

tail -n +2 "${REPO_ROOT}/tests/bootstrap-routing/cases.tsv" | while IFS=$'\t' read -r prompt expected_workflow expect_workflow_run; do
  [[ -n "${prompt}" ]] || continue
  [[ -n "${expected_workflow}" ]] || fail "Missing expected workflow for prompt: ${prompt}"
  [[ "${expect_workflow_run}" == "yes" || "${expect_workflow_run}" == "no" ]] || fail "Invalid expect_workflow_run for prompt: ${prompt}"
  if [[ "${expected_workflow}" != "none" ]]; then
    require_dir "${SKILLS_DIR}/${expected_workflow}"
    rg -q "${expected_workflow}" "${REPO_ROOT}/docs/bootstrap-examples.zh-CN.md" || fail "bootstrap examples missing expected workflow: ${expected_workflow}"
  fi
done

check_required_files_have_templates() {
  local skill="$1"
  local template_dir="$2"
  local skill_file="${SKILLS_DIR}/${skill}/SKILL.md"
  local full_template_dir="${SKILLS_DIR}/${skill}/${template_dir}"

  require_dir "${full_template_dir}"

  sed -n '/^Required files:/,/^$/p' "${skill_file}" \
    | sed -n 's/^[[:space:]]*[0-9][0-9]*\.[[:space:]]*`\([^`]*\)`.*/\1/p' \
    | while IFS= read -r artifact; do
        [[ -n "${artifact}" ]] || continue
        if [[ "${artifact}" == *"<"* ]]; then
          continue
        fi
        if [[ "${artifact}" == "workflow-state.json" ]]; then
          continue
        fi
        require_file "${full_template_dir}/${artifact}"
      done
}

check_required_files_have_templates "codebase-orientation" "assets/orientation-templates"
check_required_files_have_templates "code-review-triage" "assets/review-templates"
check_required_files_have_templates "software-delivery-pipeline" "assets/workflow-templates"
check_required_files_have_templates "debug-root-cause" "assets/debug-templates"
check_required_files_have_templates "api-contract-design" "assets/api-contract-templates"
check_required_files_have_templates "data-migration-planning" "assets/data-migration-templates"

for state_template in \
  "${SKILLS_DIR}/codebase-orientation/assets/orientation-templates/orientation-workflow-state.md" \
  "${SKILLS_DIR}/code-review-triage/assets/review-templates/review-workflow-state.md" \
  "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/delivery-workflow-state.md" \
  "${SKILLS_DIR}/debug-root-cause/assets/debug-templates/debug-workflow-state.md" \
  "${SKILLS_DIR}/api-contract-design/assets/api-contract-templates/api-contract-workflow-state.md" \
  "${SKILLS_DIR}/data-migration-planning/assets/data-migration-templates/migration-workflow-state.md"; do
  require_file "${state_template}"
  rg -q 'executionMode' "${state_template}" || fail "state template missing executionMode: ${state_template}"
  rg -q 'workflow-state.json' "${state_template}" || fail "state template missing workflow-state.json reference: ${state_template}"
  rg -q 'workflow/index.md' "${state_template}" || fail "state template missing workflow index reference: ${state_template}"
done

for summary_template in \
  "${SKILLS_DIR}/codebase-orientation/assets/orientation-templates/07-orientation-summary.md" \
  "${SKILLS_DIR}/code-review-triage/assets/review-templates/07-review-summary.md" \
  "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/06-delivery-summary.md" \
  "${SKILLS_DIR}/software-delivery-pipeline/assets/workflow-templates/08-delivery-summary.md" \
  "${SKILLS_DIR}/debug-root-cause/assets/debug-templates/08-debug-summary.md" \
  "${SKILLS_DIR}/api-contract-design/assets/api-contract-templates/07-api-summary.md" \
  "${SKILLS_DIR}/data-migration-planning/assets/data-migration-templates/07-migration-summary.md"; do
  require_file "${summary_template}"
  rg -q 'executionMode' "${summary_template}" || fail "summary template missing executionMode: ${summary_template}"
done

for term in "Shared Artifact Templates" "Stop and Confirmation Contract" "Execution Mode Contract" "State File Contract" "Machine-Readable State Contract" "Workflow Index Contract" "Summary Contract" "Handoff Contract" "Handoff Flow Contract" "Documentation Boundary Contract" "Naming Contract" "Resume Contract"; do
  rg -q "${term}" "${REPO_ROOT}/docs/workflow-contracts.zh-CN.md" || fail "workflow contract missing section: ${term}"
done

for term in 'NN-<workflow>-<stage>.md' 'review-delivery-result.md' '07-*-summary.md' '*-workflow-state.md' '*-to-*-handoff.md'; do
  rg -F -q "${term}" "${REPO_ROOT}/docs/workflow-contracts.zh-CN.md" || fail "naming contract missing term: ${term}"
done

for term in \
  'orientation-to-review-handoff.md' \
  'orientation-to-delivery-handoff.md' \
  'review-to-delivery-handoff.md' \
  'debug-to-delivery-handoff.md' \
  'api-to-delivery-handoff.md' \
  'migration-to-delivery-handoff.md' \
  'source of truth'; do
  rg -q "${term}" "${REPO_ROOT}/docs/workflow-contracts.zh-CN.md" || fail "workflow handoff flow missing term: ${term}"
done

for term in 'README.md' 'docs/' 'SKILL.md' 'assets/' 'references/' 'examples/'; do
  rg -q "${term}" "${REPO_ROOT}/docs/workflow-contracts.zh-CN.md" || fail "documentation boundary missing term: ${term}"
done

for term in "文档元信息" "当前状态" "workflow-state.json" "workflow/index.md" "Resume 记录"; do
  rg -q "${term}" "${REPO_ROOT}/docs/artifact-templates/state.md" || fail "shared state template missing term: ${term}"
done

for term in "范围" "证据" "事实 / 推断 / 待确认" "决策记录" "停止 / 确认记录" "验证关注点" "下一步"; do
  rg -q "${term}" "${REPO_ROOT}/docs/artifact-templates/stage-document.md" || fail "shared stage template missing term: ${term}"
done

for term in "触发条件" "已确认事实和证据" "可选继续方向" "推荐选择" "暂停期间不得执行的动作" "等待用户确认的问题"; do
  rg -q "${term}" "${REPO_ROOT}/docs/artifact-templates/stop-record.md" || fail "shared stop record template missing term: ${term}"
done

for term in "当前结论" "已确认 Scope" "未解决问题" "主要风险" "推荐下一步" "推荐下一个 Workflow"; do
  rg -q "${term}" "${REPO_ROOT}/docs/artifact-templates/summary.md" || fail "shared summary template missing term: ${term}"
done

for term in "Accepted Scope" "Excluded Scope" "Evidence" "Constraints" "Unresolved Questions" "Verification Focus" "Machine-Readable Summary"; do
  rg -q "${term}" "${REPO_ROOT}/docs/artifact-templates/handoff.md" || fail "shared handoff template missing term: ${term}"
done

for term in "schemaVersion" "workflow" "runPath" "domainModules" "executionMode" "modePath" "affectedServices" "affectedControllers" "affectedTables" "affectedCollections" "affectedTopics" "affectedConfigKeys" "status" "currentStage" "nextAction" "codeEditsAllowed" "riskLevel" "riskReason" "confirmationRequired" "rollbackRequired" "updatedAt"; do
  rg -q "\"${term}\"" "${REPO_ROOT}/docs/workflow-state-schema.json" || fail "workflow state schema missing field: ${term}"
  rg -q "\"${term}\"" "${REPO_ROOT}/tests/workflow-state/valid-state.json" || fail "valid workflow state fixture missing field: ${term}"
  rg -q "\"${term}\"" "${REPO_ROOT}/tests/workflow-state/generated-state.expected.json" || fail "generated workflow state fixture missing field: ${term}"
done

bash "${REPO_ROOT}/scripts/check-workflow-state.sh" >/dev/null

for term in "Updated At" "Workflow" "Status" "Scope" "Run Path" "Summary" "Next Action"; do
  rg -q "${term}" "${REPO_ROOT}/docs/workflow-index-template.md" || fail "workflow index template missing column: ${term}"
  rg -q "${term}" "${REPO_ROOT}/tests/workflow-index/expected-index.md" || fail "workflow index fixture missing column: ${term}"
done

bash "${REPO_ROOT}/scripts/check-workflow-index.sh" >/dev/null

echo "Consistency checks passed."
