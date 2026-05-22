---
name: code-review-triage
description: >-
  Review code before making changes, produce a Chinese issue triage document with evidence and severity, require the human to choose which findings to fix, then create a confirmed fix plan. Use when the user asks Codex to review code, audit a module, find problems, or modify code based on review findings.
---

# Code Review Triage

Use this skill when the work starts with code review rather than a known implementation request. The purpose is to find real issues, let the human choose what to fix, and only then move into implementation.

## Core Rules

- Review mode is read-only until the human confirms selected findings and an implementation plan.
- All generated workflow documents must be written in Simplified Chinese, except code identifiers, commands, file paths, error text, API names, and quoted user text.
- Findings must be evidence-based: include file path, line number when available, code path, behavior, impact, and suggested fix direction.
- Findings lead the response, ordered by severity: blocker, high, medium, low.
- Do not treat style preferences, speculative refactors, or generic best practices as required fixes.
- If no material issues are found, say so clearly and record residual risks or test gaps.
- Do not modify code before the human confirms `03-review-fix-selection.md` and `04-review-fix-plan.md`.
- By default, this skill must not implement fixes. After `04-review-fix-plan.md` is approved, generate `review-to-delivery-handoff.md` and stop so `software-delivery-pipeline` can run requirements, architecture, plan, implementation, and verification.
- Implement inside this skill only if the human explicitly says not to use `software-delivery-pipeline` and explicitly asks this review skill to implement the selected findings.
- If implementation discovers new issues or requires scope expansion, append the issue to the review artifacts and pause for human confirmation.
- Fix selection and fix-plan gates are clarification-and-convergence loops: do not treat the human's first selected findings or proposed fix direction as automatically safe or sufficient.
- If selected findings are insufficient, conflict with each other, require an unselected finding, or imply architecture/scope expansion, explain the issue, update the current review artifact, and ask for confirmation again.


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
1. `01-review-scope.md`
2. `02-review-findings.md`
3. `03-review-fix-selection.md`
4. `04-review-fix-plan.md`
5. `review-to-delivery-handoff.md` (after `04-review-fix-plan.md` is approved, when fixes should continue in `software-delivery-pipeline`)
6. `review-delivery-result.md` (written by `software-delivery-pipeline` when fixes are implemented there)
7. `07-review-summary.md` (after explicit no-fix closure, or after an explicitly requested in-skill implementation)
8. `05-review-implementation.md` (exception only: if the human explicitly refuses `software-delivery-pipeline` and asks this skill to implement)
9. `06-review-verification.md` (exception only: after in-skill implementation)

Use the templates in `assets/review-templates/`.

## Stage 1 — Review Scope

Goal: define what is being reviewed and what kind of issues matter.

Actions:
- identify review target: whole repo, diff, module, package, endpoint, flow, or files
- identify requested focus if any: bugs, security, performance, API contract, tests, maintainability, regression risk
- define out-of-scope areas
- write `01-review-scope.md`

If the scope is broad but still reviewable, proceed with a bounded first pass and document assumptions. If scope is unsafe or impossible to infer, ask one concise question.

## Stage 2 — Findings

Goal: produce a concrete issue list before discussing fixes.

Actions:
- inspect the relevant code, tests, configs, docs, and call paths
- write `02-review-findings.md`
- group findings by severity
- for every finding include: ID, title, severity, location, evidence, impact, fix direction, confidence
- include a `不建议处理` section for items that look tempting but should not be changed now

After writing `02-review-findings.md`, stop and ask the human which finding IDs to fix. Do not write the fix plan yet unless the human has already clearly selected the findings.
If the human says no fixes are needed, says to only record the review, or closes the review without implementation, write `07-review-summary.md` as a no-fix closure and stop.

## Stage 3 — Fix Selection

Goal: capture the human's selected findings.

Actions:
- write `03-review-fix-selection.md`
- list selected finding IDs and explicitly excluded finding IDs
- record any user constraints such as “只修高优先级”, “不改接口”, “不兼容旧数据”

Human confirmation gate: stop until the selected findings are clear and internally consistent. If the selection omits a finding that blocks a selected fix, or includes a risky combination, explain the issue, update `03-review-fix-selection.md`, and ask for confirmation again.

## Stage 4 — Fix Plan

Goal: plan the fixes for only the selected findings.

Actions:
- write `04-review-fix-plan.md`
- map each selected finding to planned code changes and verification
- call out risks, files likely to change, and tests/checks to run

Human confirmation gate: stop after `04-review-fix-plan.md` and ask the human to confirm or revise the plan. Do not implement before approval. If the plan is unsafe, incomplete, conflicts with code evidence, or needs architecture/scope expansion, state that plainly, update `04-review-fix-plan.md`, and repeat the confirmation gate.

After the human approves the fix plan, write `review-to-delivery-handoff.md` if the next step is to use `software-delivery-pipeline`. The handoff must include selected finding IDs, excluded finding IDs, evidence locations, user constraints, architecture-gate recommendation, fix plan summary, verification requirements, the source review run path, and a machine-readable YAML summary.
If the human says “按这个修”, “继续”, “落地”, “修复选中的问题”, or equivalent after handoff creation, treat that as intent to continue with `software-delivery-pipeline` using the handoff file.

## Stage 5 — Delivery Handoff or Explicit No-Fix Closure

Default path after `04-review-fix-plan.md` approval:
- write `review-to-delivery-handoff.md`
- stop
- tell the human that implementation must continue through `software-delivery-pipeline`

Hard rules:
- Do not edit code in the default review flow.
- If `review-to-delivery-handoff.md` does not exist, implementation must not start.
- If the human says “按这个修”, “继续”, “落地”, or “修复选中的问题”, treat that as a request to start `software-delivery-pipeline` with the handoff, not as permission for this skill to edit code.
- Implement inside this skill only when the human explicitly says to bypass `software-delivery-pipeline` and explicitly asks this skill to implement. In that exception, still write `05-review-implementation.md`, `06-review-verification.md`, and `07-review-summary.md`.

If the task becomes a normal feature/bugfix after findings are selected, chain into `software-delivery-pipeline` by passing `review-to-delivery-handoff.md` as the source-of-truth input. Keep the review artifacts as the source of truth for selected findings and scope.

## References

Read when doing an actual review:
- `references/review-guidelines.md` — finding quality, severity, and response rules
