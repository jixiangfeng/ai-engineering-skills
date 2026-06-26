---
name: debug-root-cause
description: >-
  Read-first root-cause debugging workflow for errors, failing tests, startup failures, API bugs, regressions, or unexpected runtime behavior. Produces Chinese reproduction, evidence, hypothesis, trace, root cause, fix options, verification, and optional handoff to software-delivery-pipeline.
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [debugging, root-cause, reproduction, evidence, handoff]
    related_skills: [workflow-bootstrap, codebase-orientation, tdd-test-engineering, software-delivery-pipeline]
---

# Debug Root Cause

Use this skill when the user asks to investigate an error, failing test, startup failure, runtime exception, bad API behavior, regression, or confusing system behavior.

## Usage Boundary

Use when:
- the user reports an error, failing test, startup failure, regression, or unexpected runtime behavior
- the task needs reproduction, evidence, hypotheses, root cause, and fix options before implementation
- prior fix attempts failed or the real cause is unclear

Do not use when:
- the user only asks to become familiar with code without a concrete symptom
- the user asks for broad code review rather than one failure path
- root cause and fix plan are already confirmed and ready for implementation

Prefer another skill when:
- `codebase-orientation`: the user needs context before investigating a symptom
- `code-review-triage`: the user wants multiple findings ranked by severity
- `api-contract-design`: the failure is primarily an unresolved API contract decision
- `data-migration-planning`: the cause or fix requires schema/data migration
- `software-delivery-pipeline`: the fix option is confirmed and ready to implement

Follow `docs/workflow-contracts.zh-CN.md` `Execution Mode Contract`; record `executionMode` as `lightweight`, `standard`, or `full` in state and summary.


## Execution Mode Selection

Choose and record `executionMode` as `lightweight`, `standard`, or `full` before creating workflow artifacts. Follow `docs/prompt-modules/lightweight-mode.zh-CN.md` for selection rules, produced/skipped artifacts, and upgrade conditions.

## Prompt Modules

This skill keeps workflow-specific rules here and delegates shared execution discipline to:

- `docs/prompt-modules/debug-discipline.zh-CN.md` — 证据优先 Debug Analysis
- `docs/prompt-modules/test-strategy.zh-CN.md` — 复现、test-first、minimal patch、exploratory fix
- `docs/prompt-modules/lightweight-mode.zh-CN.md` — 轻量/标准/完整 debug 产物边界
- `docs/prompt-modules/handoff.zh-CN.md` — debug 到 delivery 的交接
- `docs/prompt-modules/minimal-change.zh-CN.md` — 最小修复点和不扩大排查范围
- `docs/prompt-modules/verification-gate.zh-CN.md` — 根因、修复建议和验证判断

- `docs/prompt-modules/write-guard.zh-CN.md` — 写入、删除、覆盖、安装和迁移门禁
- `docs/prompt-modules/risk-gate.zh-CN.md` — low/medium/high 风险等级、确认和回滚要求

## Domain Module: Java / Spring

If `domainModules` contains `java-spring-microservice`, the debug hypothesis tree must consider:

- Profile / Nacos / YAML config missing or stale
- Bean injection, circular dependency, proxy, and conditional bean issues
- `@Transactional` not taking effect, self-invocation, swallowed exception, or rollback mismatch
- Feign timeout, fallback, response contract mismatch, or service dependency failure
- MQ ack/nack, retry, DLQ, duplicate consumption, idempotency, and ordering issues
- Redis lock expiration, wrong key, owner mismatch, stale cache, or cache penetration
- MyBatis SQL condition bugs, empty collection, missing `WHERE`, mapper XML mismatch
- MongoDB historical documents missing fields, null vs empty vs missing-field semantics
- Security context mismatch, token claim missing, login scene mismatch, or permission leakage

Each confirmed or rejected hypothesis must include evidence.

Load `docs/domain-modules/java-spring-microservice.zh-CN.md` for the full checklist.

## Core Rules

- Follow the `Prompt Modules` section for shared clarification, execution mode, handoff, minimal-change, and verification discipline.

- Debugging starts read-first and evidence-first. Do not patch code until root cause and fix direction are confirmed or the user explicitly asks for immediate repair.
- Reproduce before explaining when practical. If reproduction is blocked, record the blocker and use available evidence.
- Do not guess fixes from symptoms. Trace data/control flow back to the source.
- Do not propose code fixes before establishing a root-cause hypothesis supported by evidence.
- Do not confuse symptom relief with root-cause correction.
- If two or more fix attempts have already failed, explicitly check whether the problem is architectural, contractual, or lifecycle-related rather than continuing incremental patching.
- Separate environment failures, existing failures, test bugs, product-code bugs, and unclear behavior.
- All generated documents must be Simplified Chinese, except code identifiers, commands, paths, error text, API names, and quoted user text.
- Follow `docs/workflow-contracts.zh-CN.md` `Stop and Confirmation Contract`; when it triggers, update state and stop for human confirmation.
- `workflow-state.json` must strictly match `docs/workflow-state-schema.json`: include `schemaVersion`, `runPath`, `executionMode`, `modePath`, risk and confirmation fields, and `updatedAt`; do not write ad hoc extra fields such as `projectRoot`, `runDir`, `branch`, `commit`, `producedArtifacts`, `skippedArtifacts`, or `verification`.
- If a fix is needed, create `debug-to-delivery-handoff.md` for `software-delivery-pipeline` rather than silently expanding into implementation.

## Debug Analysis Format

Every debug run must be able to produce this structure across its stage documents or summary:

```md
## Debug Analysis

### 1. 现象复述
- ...

### 2. 影响范围
- ...

### 3. 已知证据
- 日志：
- 代码：
- 配置：
- 数据：
- 复现步骤：

### 4. 初始假设
| 假设 | 支持证据 | 反证 | 当前状态 |
| --- | --- | --- | --- |

### 5. 排除过程
1. ...

### 6. 根因判断
- Root cause:
- Confidence: high / medium / low
- Evidence:

### 7. 最小修复点
- ...

### 8. 验证方案
- ...
```

Forbidden: no evidence-free root cause, no patch without reproduction or evidence, no unrelated multi-point fixes, and no use of “大概/可能/应该” as a substitute for validation.

## Preflight Checklist

Before writing artifacts:
- confirm current `cwd` and project root
- inspect whether the worktree already has changes if reproduction or prior fix attempts may matter
- locate or create the current run directory
- if the user provides `workflow/tests/.../test-to-debug-handoff.md`, read it first and validate shared/test-specific YAML fields against `docs/handoff-routing-matrix.json`
- read `debug-workflow-state.md` if it exists
- read the latest required stage document before continuing
- create artifacts under the project root, not under the skill directory
- keep the skill read-only unless the human explicitly changes the task

## Resume Protocol

When resuming after interruption, compaction, or a new agent turn:
1. read `debug-workflow-state.md`
2. read the latest stage document listed there
3. inspect current git diff/status if any attempted fix or reproduction artifact exists
4. state the current stage, blockers, whether code edits are allowed, and whether a handoff already exists
5. continue only from the recorded next action

## Filename Compatibility

New runs must use the prefixed artifact filenames documented above. If an older run already exists with legacy names such as `01-requirements.md` or `handoff-to-delivery.md`, read those files for compatibility, but do not create new legacy-named files.

## Workflow Artifacts

Create artifacts under `<project-root>/workflow/debug/<YYYY-MM-DD>-<slug>/`.

Required files:
0. `debug-workflow-state.md`
1. `10-debug-scope-reproduction.md`
2. `11-debug-evidence.md`
3. `12-debug-root-cause.md`
4. `13-debug-summary.md`
5. `debug-to-delivery-handoff.md` (optional, when implementation is needed)
6. `workflow-state.json` (machine-readable state, maintained alongside `debug-workflow-state.md`)

Expanded files (only when the case is contested, high-risk, or the human explicitly wants the fully split trail):
- `02-debug-reproduction.md`
- `03-debug-evidence.md`
- `04-debug-hypotheses.md`
- `05-debug-root-cause.md`
- `06-debug-fix-options.md`
- `07-debug-verification-plan.md`
- `08-debug-summary.md`

Use templates in `assets/debug-templates/`.

After each stage document is written or updated, update `debug-workflow-state.md` and `workflow-state.json` with current stage, status, latest document, next action, blockers, reproduction status, and whether code edits are allowed. If `workflow/index.md` exists in the project root, update the run entry as well.

## Default Slim Workflow

1. Define the failing behavior and scope, and reproduce or document why reproduction is blocked in `10-debug-scope-reproduction.md`.
2. Collect exact evidence in `11-debug-evidence.md`: commands, logs, stack traces, code paths, configs, data, and active hypotheses with elimination status.
3. State root cause with confidence and source evidence in `12-debug-root-cause.md`, and include fix options, tradeoffs, and verification plan in the same document.
4. Ask the human to confirm fix direction before implementation, or hand off to `software-delivery-pipeline`.
5. Write `13-debug-summary.md` to capture confirmed root cause, rejected hypotheses, remaining uncertainty, and the recommended next workflow.

When starting from `test-to-debug-handoff.md`, use `failure_symptoms`, `executed_commands`, `rejected_explanations`, and `debug_questions` as starting evidence. Do not treat the test handoff as a confirmed root cause or fix approval.

## Escalation After Repeated Failed Fixes

If the same issue has already gone through two or three failed fix attempts:

1. stop stacking new fixes
2. review each prior hypothesis and why it failed
3. inspect whether the real issue is caused by:
   - incorrect system-boundary assumptions
   - incorrect data-contract assumptions
   - incorrect initialization or lifecycle assumptions
   - a design or architecture mismatch
4. explicitly state in the root-cause artifact whether the issue should escalate into architecture review or delivery replanning

## Fix Options Guidance

The root-cause artifact should distinguish clearly between:
- symptom relief
- root-cause fix
- monitoring/logging/guardrail improvements

## Summary Guidance

`13-debug-summary.md` should capture at least:
- attempted fixes
- rejected hypotheses
- confirmed root cause
- recommended next workflow
- `Verification`: reproduction status, evidence checked, unverified assumptions, and completion judgment

## Handoff

`debug-to-delivery-handoff.md` must include root cause, selected fix option, affected files, scope lock, verification requirements, risks, and unresolved questions.

## References

Read when doing actual debugging:
- `examples/standard-run.md` — canonical miniature run shape for reproduction, evidence, root cause, state, and handoff output
