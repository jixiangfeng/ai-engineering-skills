---
name: code-review-triage
description: >-
  Review code before making changes, produce a Chinese issue triage document with evidence and severity, require the human to choose which findings to fix, then create a confirmed fix plan. Use when the user asks Codex to review code, audit a module, find problems, or modify code based on review findings.
---

# Code Review Triage

Use this skill when the work starts with code review rather than a known implementation request. The purpose is to find real issues, let the human choose what to fix, and only then move into implementation.

## Usage Boundary

Use when:
- the user asks to review code, audit a module, find problems, or assess risk
- the task should produce evidence-backed findings before any code edit
- the user wants to choose which findings should be fixed

Do not use when:
- the user already has a confirmed bug reproduction and needs root-cause debugging
- the user only wants to understand code structure without findings
- the implementation plan is already approved and ready to execute

Prefer another skill when:
- `codebase-orientation`: the user asks for familiarity or architecture mapping first
- `debug-root-cause`: the primary input is a failure, error log, regression, or reproduction
- `api-contract-design`: the main decision is API shape or compatibility
- `data-migration-planning`: findings require schema/data migration planning before fixes
- `software-delivery-pipeline`: selected findings and fix plan are already confirmed

Follow `docs/workflow-contracts.zh-CN.md` `Execution Mode Contract`; record `executionMode` as `lightweight`, `standard`, or `full` in state and summary.


## Execution Mode Selection

Choose and record `executionMode` as `lightweight`, `standard`, or `full` before creating workflow artifacts. Follow `docs/prompt-modules/lightweight-mode.zh-CN.md` for selection rules, produced/skipped artifacts, and upgrade conditions.

## Prompt Modules

This skill keeps workflow-specific rules here and delegates shared execution discipline to:

- `docs/prompt-modules/review-loop.zh-CN.md` — Review Findings、accepted scope 和 fix handoff
- `docs/prompt-modules/task-decomposition.zh-CN.md` — 复杂 review 的只读并行拆分
- `docs/prompt-modules/lightweight-mode.zh-CN.md` — 轻量/标准/完整 review 产物边界
- `docs/prompt-modules/handoff.zh-CN.md` — review 到 delivery 的交接
- `docs/prompt-modules/minimal-change.zh-CN.md` — review 默认只读，修复不扩大 scope
- `docs/prompt-modules/verification-gate.zh-CN.md` — review 结论和修复闭环 Verification

- `docs/prompt-modules/write-guard.zh-CN.md` — 写入、删除、覆盖、安装和迁移门禁
- `docs/prompt-modules/risk-gate.zh-CN.md` — low/medium/high 风险等级、确认和回滚要求

## Domain Module: Java / Spring

If `domainModules` contains `java-spring-microservice`, review findings must prioritize:

- Transaction boundaries and `@Transactional` misuse
- Feign / OpenFeign coupling, timeout, fallback, and N+1 remote calls
- MQ idempotency, ack/nack, retry, DLQ, duplicate consumption, and ordering
- Redis / Redisson lock safety, TTL, owner check, and cache key design
- MyBatis / MyBatis-Plus dynamic SQL risks, missing `WHERE`, empty `foreach`, unstable pagination
- MongoDB historical field compatibility and field-missing semantics
- DTO / VO / Entity boundary leakage
- enum / status / magic string compatibility
- patientId / storeId / tenantId / deptId authorization risks
- Nacos / YAML config default value and gray release risks
- Observability gaps: missing traceId, jobId, checkNo, orderNo, topic, config key, or elapsed-time logs

High-risk findings must include rollback and verification suggestions.

Load `docs/domain-modules/java-spring-microservice.zh-CN.md` for the full checklist.

## Core Rules

- Follow the `Prompt Modules` section for shared clarification, execution mode, handoff, minimal-change, and verification discipline.

- Review mode is read-only until the human confirms selected findings and an implementation plan.
- All generated workflow documents must be written in Simplified Chinese, except code identifiers, commands, file paths, error text, API names, and quoted user text.
- Findings must be evidence-based: include file path, line number when available, code path, behavior, impact, and suggested fix direction.
- Findings lead the response, ordered by severity: blocker, high, medium, low.
- Do not treat style preferences, speculative refactors, or generic best practices as required fixes.
- If no material issues are found, say so clearly and record residual risks or test gaps.
- Do not modify code before the human confirms the selected findings and `12-review-fix-plan.md` (or the expanded `03-review-fix-selection.md` + `04-review-fix-plan.md` path when that split trail is being used).
- Follow `docs/workflow-contracts.zh-CN.md` `Stop and Confirmation Contract`; when it triggers, update state and stop for human confirmation.
- `workflow-state.json` must strictly match `docs/workflow-state-schema.json`: include `schemaVersion`, `runPath`, `executionMode`, `modePath`, risk and confirmation fields, and `updatedAt`; do not write ad hoc extra fields such as `projectRoot`, `runDir`, `branch`, `commit`, `producedArtifacts`, `skippedArtifacts`, or `verification`.
- By default, this skill must not implement fixes. After `12-review-fix-plan.md` is approved, generate `review-to-delivery-handoff.md` and stop so `software-delivery-pipeline` can run requirements, architecture, plan, implementation, and verification.
- Implement inside this skill only if the human explicitly says not to use `software-delivery-pipeline` and explicitly asks this review skill to implement the selected findings.
- If implementation discovers new issues or requires scope expansion, append the issue to the review artifacts and pause for human confirmation.
- Fix selection and fix-plan gates are clarification-and-convergence loops: do not treat the human's first selected findings or proposed fix direction as automatically safe or sufficient.
- If selected findings are insufficient, conflict with each other, require an unselected finding, or imply architecture/scope expansion, explain the issue, update the current review artifact, and ask for confirmation again.
- If the human provides an existing review artifact path or asks to continue a prior review run, resume that run instead of creating a new one unless a reset is explicitly requested.

## Review Findings Format

Use this minimum structure for every material finding:

```md
## Review Findings

### Finding 1: 标题

- Severity: critical / high / medium / low / suggestion
- Evidence:
- Impact:
- Suggested fix:
- Confidence:
- Requires user decision: yes / no
```

Do not convert findings into code edits until the accepted scope is confirmed.

## Fix Handoff Format

After the human selects findings and approves the fix plan, produce:

```md
## Fix Handoff

### Accepted scope
- ...

### Excluded scope
- ...

### Files likely affected
- ...

### Verification focus
- ...

### Recommended next workflow
- software-delivery-pipeline
```

## Review Does Not Implement

- `code-review-triage` is read-first and read-only by default.
- Do not start code edits inside this workflow unless the human explicitly overrides the workflow boundary.
- “按这个修”, “继续修”, “把这些问题修掉” should normally mean:
  1. confirm the selected findings
  2. create or update `review-to-delivery-handoff.md`
  3. continue in `software-delivery-pipeline`
- Do not silently convert review work into implementation work.


## Document Quality Rules

Review artifacts should be reusable and auditable:
- 文档元信息: project root, generation time, branch/commit, agent, source document, status.
- 证据引用: every material finding or selection should point to code/config/test/docs evidence.
- 决策记录: capture selected findings, rejected findings, rationale, and confirmation.
- 范围锁定: selected and excluded findings, allowed files/behaviors, forbidden scope.
- 验证矩阵: map each selected finding to validation commands or manual checks.

## Preflight Checklist

Before doing stage work, run this mental/tool checklist and record the result in `review-workflow-state.md`:
- confirm current `cwd` and project root
- inspect whether the worktree already has changes
- locate or create the current run directory
- read `review-workflow-state.md` if it exists
- read the latest required stage document
- confirm whether this stage allows code edits
- if code edits are not explicitly allowed, do not modify code

## Resume Protocol

When resuming after interruption, compaction, or a new agent turn:
1. read `review-workflow-state.md`
2. read the latest stage document listed there
3. inspect current git diff/status for the scoped files
4. state the current stage, blockers, and whether code edits are allowed
5. continue only from the recorded next action

## Forbidden Actions

- Do not edit code before the relevant requirements and plan gates are approved.
- Do not treat review plan approval as delivery implementation approval.
- Do not implement review findings without `review-to-delivery-handoff.md` or a confirmed delivery requirements document.
- Do not broaden scope beyond the locked files/behaviors without pausing for confirmation.
- Do not run broad formatting, line-ending normalization, or unrelated cleanup to hide actual diffs.
- Do not revert user or pre-existing changes unless the user explicitly asks.


## Filename Compatibility

New runs must use the prefixed artifact filenames documented above. If an older run already exists with legacy names such as `01-requirements.md` or `handoff-to-delivery.md`, read those files for compatibility, but do not create new legacy-named files.

## Workflow Artifacts

Create the run directory under the current project root, not under the skill installation directory.

Project root resolution:
1. Prefer the current workspace's git root: `git rev-parse --show-toplevel` from the active working directory.
2. If the active working directory is not inside a git repository, use the active working directory itself.
3. Create artifacts at `<project-root>/workflow/reviews/<YYYY-MM-DD>-<slug>/`.

Required files:

0. `review-workflow-state.md`
1. `10-review-scope.md`
2. `11-review-findings.md`
3. `12-review-fix-plan.md`
4. `13-review-summary.md`
5. `review-to-delivery-handoff.md` (optional, when fixes should continue in `software-delivery-pipeline`)
6. `review-delivery-result.md` (written by `software-delivery-pipeline` when fixes are implemented there)
7. `workflow-state.json` (machine-readable state, maintained alongside `review-workflow-state.md`)

Expanded files (only when the review is large, strongly disputed, or the human explicitly wants a fully split trail):
- `03-review-fix-selection.md`
- `04-review-fix-plan.md`
- `05-review-implementation.md` (exception only: if the human explicitly refuses `software-delivery-pipeline` and asks this skill to implement)
- `06-review-verification.md` (exception only: after in-skill implementation)
- `07-review-summary.md`

Use the templates in `assets/review-templates/`.

After each stage document is written or updated, update `review-workflow-state.md` and `workflow-state.json` with current stage, status, latest document, next action, blockers, selected scope when known, and whether code edits are allowed. If `workflow/index.md` exists in the project root, update the run entry as well.

## Default Slim Flow

### Stage 1 — Review Scope
Goal: define what is being reviewed and what kind of issues matter.

Actions:
- identify review target: whole repo, diff, module, package, endpoint, flow, or files
- identify requested focus if any: bugs, security, performance, API contract, tests, maintainability, regression risk
- define out-of-scope areas
- write `10-review-scope.md`

If the scope is broad but still reviewable, proceed with a bounded first pass and document assumptions. If scope is unsafe or impossible to infer, ask one concise question.

### Stage 2 — Findings
Goal: produce a concrete issue list before discussing fixes.

Actions:
- inspect the relevant code, tests, configs, docs, and call paths
- write `11-review-findings.md`
- group findings by severity
- for every finding include: ID, title, severity, location, evidence, impact, fix direction, confidence
- when applicable, also include: `requires_spec_compliance_check`, `requires_code_quality_review`, `requires_architecture_gate`, `verification_focus`
- include a `不建议处理` section for items that look tempting but should not be changed now

After writing `11-review-findings.md`, stop and ask the human which finding IDs to fix. Do not plan fixes before the selected finding set is clear.
If the human says no fixes are needed, says to only record the review, or closes the review without implementation, write `13-review-summary.md` as a no-fix closure and stop.

### Stage 3 — Fix Plan + Closure/Handoff
Goal: lock the selected findings and define only the needed repair path.

Actions:
- write `12-review-fix-plan.md`
- include selected finding IDs, explicitly excluded finding IDs, user constraints, risks, likely changed files, and tests/checks to run
- map each selected finding to planned code changes and verification

Human confirmation gate: stop after `12-review-fix-plan.md` and ask the human to confirm or revise the plan. Do not implement before approval. If the plan is unsafe, incomplete, conflicts with code evidence, or needs architecture/scope expansion, state that plainly, update `12-review-fix-plan.md`, and repeat the confirmation gate.

After approval:
- write `review-to-delivery-handoff.md` when the next step is `software-delivery-pipeline`
- write `13-review-summary.md` to record selected/excluded findings, readiness, and recommended next workflow
- stop

Hard rules:
- Do not edit code in the default review flow.
- If `review-to-delivery-handoff.md` does not exist, implementation must not start.
- If the human says “按这个修”, “继续”, “落地”, or “修复选中的问题”, treat that as a request to start `software-delivery-pipeline` with the handoff, not as permission for this skill to edit code.
- Do not include unselected findings in implementation scope.
- If an unselected finding blocks a selected fix, stop, explain the dependency clearly, and ask the human whether to expand scope.
- Implement inside this skill only when the human explicitly says to bypass `software-delivery-pipeline` and explicitly asks this skill to implement. In that exception, expand into `05-review-implementation.md`, `06-review-verification.md`, and `07-review-summary.md`.

If the task becomes a normal feature/bugfix after findings are selected, chain into `software-delivery-pipeline` by passing `review-to-delivery-handoff.md` as the source-of-truth input. Keep the review artifacts as the source of truth for selected findings and scope.

## References

Read when doing an actual review:
- `references/review-guidelines.md` — finding quality, severity, and response rules
- `examples/standard-run.md` — canonical miniature run shape for findings, selection, plan, state, and handoff output
