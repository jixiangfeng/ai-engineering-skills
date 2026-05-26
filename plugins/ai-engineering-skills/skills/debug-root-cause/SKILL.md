---
name: debug-root-cause
description: >-
  Read-first root-cause debugging workflow for errors, failing tests, startup failures, API bugs, regressions, or unexpected runtime behavior. Produces Chinese reproduction, evidence, hypothesis, trace, root cause, fix options, verification, and optional handoff to software-delivery-pipeline.
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

Follow `docs/workflow-contracts.zh-CN.md` `Execution Mode Contract`; record whether the run is lightweight or full in state and summary.

## Core Rules

- Follow `docs/prompt-modules/debug-discipline.zh-CN.md` for `Debug Analysis` structure and evidence-first root-cause rules.
- Follow `docs/prompt-modules/test-strategy.zh-CN.md` when choosing reproduction, test-first confirmation, or exploratory fix strategy.
- Follow `docs/prompt-modules/verification-gate.zh-CN.md` before summary or handoff closure.
- Debugging starts read-first and evidence-first. Do not patch code until root cause and fix direction are confirmed or the user explicitly asks for immediate repair.
- Reproduce before explaining when practical. If reproduction is blocked, record the blocker and use available evidence.
- Do not guess fixes from symptoms. Trace data/control flow back to the source.
- Do not propose code fixes before establishing a root-cause hypothesis supported by evidence.
- Do not confuse symptom relief with root-cause correction.
- If two or more fix attempts have already failed, explicitly check whether the problem is architectural, contractual, or lifecycle-related rather than continuing incremental patching.
- Separate environment failures, existing failures, test bugs, product-code bugs, and unclear behavior.
- All generated documents must be Simplified Chinese, except code identifiers, commands, paths, error text, API names, and quoted user text.
- Follow `docs/workflow-contracts.zh-CN.md` `Stop and Confirmation Contract`; when it triggers, update state and stop for human confirmation.
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
1. `01-debug-scope.md`
2. `02-debug-reproduction.md`
3. `03-debug-evidence.md`
4. `04-debug-hypotheses.md`
5. `05-debug-root-cause.md`
6. `06-debug-fix-options.md`
7. `07-debug-verification-plan.md`
8. `08-debug-summary.md`
9. `debug-to-delivery-handoff.md` (optional, when implementation is needed)
10. `workflow-state.json` (machine-readable state, maintained alongside `debug-workflow-state.md`)

Use templates in `assets/debug-templates/`.

After each stage document is written or updated, update `debug-workflow-state.md` and `workflow-state.json` with current stage, status, latest document, next action, blockers, reproduction status, and whether code edits are allowed. If `workflow/index.md` exists in the project root, update the run entry as well.

## Workflow

1. Define the failing behavior and scope.
2. Reproduce or document why reproduction is blocked.
3. Collect exact evidence: commands, logs, stack traces, code paths, configs, data.
4. Generate hypotheses and eliminate them with evidence.
5. State root cause with confidence and source evidence.
6. Propose fix options and tradeoffs.
7. Define verification plan.
8. Ask the human to confirm fix direction before implementation, or hand off to `software-delivery-pipeline`.

## Escalation After Repeated Failed Fixes

If the same issue has already gone through two or three failed fix attempts:

1. stop stacking new fixes
2. review each prior hypothesis and why it failed
3. inspect whether the real issue is caused by:
   - incorrect system-boundary assumptions
   - incorrect data-contract assumptions
   - incorrect initialization or lifecycle assumptions
   - a design or architecture mismatch
4. explicitly state in `05-debug-root-cause.md` whether the issue should escalate into architecture review or delivery replanning

## Fix Options Guidance

`06-debug-fix-options.md` should distinguish clearly between:
- symptom relief
- root-cause fix
- monitoring/logging/guardrail improvements

## Summary Guidance

`08-debug-summary.md` should capture at least:
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
- `docs/prompt-modules/debug-discipline.zh-CN.md` — evidence-first Debug Analysis structure
- `docs/prompt-modules/test-strategy.zh-CN.md` — test-first, minimal patch, and exploratory fix strategy
- `docs/prompt-modules/verification-gate.zh-CN.md` — final Verification output contract
