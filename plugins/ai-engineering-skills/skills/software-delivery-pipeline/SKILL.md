---
name: software-delivery-pipeline
description: >-
  Orchestrate software development work as a document-driven pipeline for coding agents. Use when implementing a feature or bugfix with a staged flow. Write all workflow artifacts in Chinese under the current project root so the human can review stage documents instead of intermediate chatter.
---

# Software Delivery Pipeline

Drive coding work through a fixed document pipeline. This skill combines the most useful superpowers-style programming workflows into one orchestrated process:

1. requirements capture
2. architecture design and technology selection when needed
3. planning
4. test-first implementation
5. change review gate when risk triggers apply
6. systematic debugging when blocked
7. verification before completion
8. delivery summary

## When to Use

Use this skill when:
- implementing a feature or bugfix
- restructuring a development task into explicit stages
- you want Codex/OpenClaw to execute one stage at a time
- the human mainly wants to review documents, not intermediate chatter
- you want a reusable workflow that survives long tasks and handoffs

Do not use when:
- trivial one-line edits
- purely conceptual Q&A
- destructive repo operations without explicit approval

Prefer another skill when:
- `codebase-orientation`: the user asks to understand unfamiliar code before changing it
- `code-review-triage`: the user asks to find or rank issues before choosing fixes
- `debug-root-cause`: a failure needs root cause before implementation
- `api-contract-design`: request/response/DTO/error behavior is not yet agreed
- `data-migration-planning`: schema, persisted data, rollback, or backfill needs planning first

Follow `docs/workflow-contracts.zh-CN.md` `Execution Mode Contract`; record `executionMode` as `lightweight`, `standard`, or `full` in state and summary.


## Execution Mode Selection

Choose and record `executionMode` as `lightweight`, `standard`, or `full` before creating workflow artifacts. Follow `docs/prompt-modules/lightweight-mode.zh-CN.md` for selection rules, produced/skipped artifacts, and upgrade conditions.

## Prompt Modules

This skill keeps workflow-specific rules here and delegates shared execution discipline to:

- `docs/prompt-modules/clarification.zh-CN.md` — 需求澄清
- `docs/prompt-modules/implementation-plan.zh-CN.md` — Implementation Plan
- `docs/prompt-modules/execution-discipline.zh-CN.md` — 按计划执行和 Execution Status
- `docs/prompt-modules/test-strategy.zh-CN.md` — Implementation Strategy
- `docs/prompt-modules/worktree-recommendation.zh-CN.md` — worktree 隔离建议
- `docs/prompt-modules/task-decomposition.zh-CN.md` — 复杂任务拆分
- `docs/prompt-modules/finish-checklist.zh-CN.md` — 交付收尾检查
- `docs/prompt-modules/lightweight-mode.zh-CN.md` — 轻量/标准/完整交付产物边界
- `docs/prompt-modules/handoff.zh-CN.md` — 上游 handoff 输入和结果回写
- `docs/prompt-modules/minimal-change.zh-CN.md` — 最小改动和 scope guard
- `docs/prompt-modules/verification-gate.zh-CN.md` — 完成前验证

- `docs/prompt-modules/write-guard.zh-CN.md` — 写入、删除、覆盖、安装和迁移门禁
- `docs/prompt-modules/risk-gate.zh-CN.md` — low/medium/high 风险等级、确认和回滚要求

## Domain Module: Java / Spring

If `docs/domain-modules/java-spring-microservice.zh-CN.md` is loaded, the Implementation Plan must include affectedServices, affectedControllers, affectedTables, affectedCollections, affectedTopics, affectedConfigKeys, riskLevel, rollbackPlan, and verificationPlan.

## Core Rules

- Follow the `Prompt Modules` section for shared clarification, execution mode, handoff, minimal-change, and verification discipline.

- Treat each stage as a separate checkpoint.
- Every stage must write its output document before the next stage starts.
- Stage 1 has a mandatory human review gate: after writing `01-delivery-requirements.md`, stop and ask the human to confirm or revise it before Stage 2.
- Architecture design is conditional: for simple tasks, record why no standalone architecture document is needed; for architecture-triggering tasks, write `02-delivery-architecture.md` and stop for human confirmation before planning.
- The planning stage has a mandatory human review gate: after writing the plan document, stop and ask the human to confirm or revise it before implementation.
- Confirmation gates are clarification-and-convergence loops, not one-shot approvals.
- Do not treat the human's initial description as automatically correct; compare it with code evidence, constraints, risk, and feasibility.
- If a requirement, architecture choice, or plan contains contradictions, missing decisions, unsafe assumptions, infeasible work, or conflicts with the current codebase, state the issue clearly, propose options, update the current stage document, and ask for confirmation again.
- If the human requests requirement, architecture, or plan changes, update the current stage document and ask for confirmation again; repeat until explicitly approved and no unresolved questions remain.
- Do not begin planning until the requirements document is approved.
- Do not begin implementation or code edits until required architecture and implementation plan documents are approved.
- During implementation, debugging, or verification, pause for human confirmation if scope expands, the plan must materially change, verification is blocked, or a destructive/high-risk operation is needed.
- Follow `docs/workflow-contracts.zh-CN.md` `Stop and Confirmation Contract`; when it triggers, update state and stop for human confirmation.
- If a stage is incomplete, blocked, or failed, do not silently continue.
- Prefer tool evidence over assumptions.
- Do not claim completion until verification has run.
- Do not summarize a task as complete when verification failed, was skipped without explanation, or only checked unrelated behavior.
- If verification cannot run, record the blocker, residual risk, and any substitute checks in the verification and summary documents.
- If implementation fails or behaves unexpectedly, switch to root-cause debugging before more fixes.
- All generated workflow documents must be written in Simplified Chinese, except code identifiers, commands, file paths, error text, API names, and quoted user text.
- When continuing from `code-review-triage`, use the review handoff files as the source of truth and do not repair unselected findings.
- When continuing from any upstream handoff, follow `docs/workflow-contracts.zh-CN.md` `Handoff Flow Contract` before writing delivery requirements.
- Review-originated fixes have a hard start gate: do not edit code until a delivery run has written and received approval for `01-delivery-requirements.md` and the required plan document.
- If code changes already exist before the delivery run starts, record them as pre-existing workspace state in `01-delivery-requirements.md`, lock the intended scope, and do not expand or normalize unrelated diffs.

## Implementation Strategy

Use `docs/prompt-modules/test-strategy.zh-CN.md` to choose and record `test_first`, `minimal_patch`, or `exploratory_fix` before code edits.

## Implementation Plan

Use `docs/prompt-modules/implementation-plan.zh-CN.md`. No implementation begins until the plan is written, scope-locked, and approved.

## Task Decomposition

Use `docs/prompt-modules/task-decomposition.zh-CN.md` for complex work. Only read-only analysis may be parallelized; code edits are not parallel by default.

## Finish Checklist

Use `docs/prompt-modules/finish-checklist.zh-CN.md` before writing the delivery summary.

## Execution Modes

### Mode A — Inline Execution
Use this mode for:
- single-file or small-scope tasks
- low-risk edits
- tightly scoped fixes with simple verification

### Mode B — Subagent Execution
Use this mode for:
- multi-step plans
- multi-file changes
- review-handoff implementation
- architecture-sensitive changes
- higher-risk bugfixes or refactors

Recommended Subagent Execution loop per plan item:
1. dispatch an implementer for the scoped task
2. review for spec compliance against the confirmed requirements/plan
3. review for code quality and maintainability
4. only then mark the item complete

Default principle:
- simple work may stay inline
- complex work should prefer subagent execution

## Workspace Isolation Guidance

Use `docs/prompt-modules/worktree-recommendation.zh-CN.md`. Worktree creation is only a recommendation unless the human explicitly asks.

## Review Handoff Input

Use this mode when the user says to continue from a review, fix selected findings, follow `code-review-triage`, provides a `workflow/reviews/...` path, or says “按这个修”, “继续”, “落地”, “修复选中的问题” immediately after a review handoff. In these cases, automatically use the review handoff as input instead of asking which workflow to use.

Required input files, in priority order:
1. `workflow/reviews/<run>/review-to-delivery-handoff.md`
2. `workflow/reviews/<run>/03-review-fix-selection.md`
3. `workflow/reviews/<run>/04-review-fix-plan.md`
4. `workflow/reviews/<run>/02-review-findings.md` only for evidence lookup

Rules:
- Read the handoff before writing `01-delivery-requirements.md`.
- If `review-to-delivery-handoff.md` contains a YAML block, use it to verify selected findings, excluded findings, constraints, verification requirements, and forbidden scope.
- If no handoff exists but the review run has confirmed `03-review-fix-selection.md` and `04-review-fix-plan.md`, reconstruct the handoff in `01-delivery-requirements.md` from those files, state that no handoff file was found, and stop for requirements confirmation before any code edit.
- If no handoff and no confirmed review selection/plan exist, stop and ask the human to complete `code-review-triage`; do not implement.
- `01-delivery-requirements.md` must list the source review run, selected finding IDs, explicitly excluded finding IDs, user constraints, acceptance criteria for each selected finding, and any pre-existing workspace diffs that could affect the work.
- `02-delivery-plan.md` must map each selected finding ID to concrete implementation and verification steps.
- Do not include unselected findings in implementation scope. If an unselected finding blocks a selected fix, pause and ask the human to expand scope.
- Do not treat review plan approval as delivery implementation approval; delivery requirements and delivery plan approval are still required.
- After delivery, write or update `workflow/reviews/<run>/review-delivery-result.md` with fixed finding IDs, unfixed finding IDs, verification summary, delivery run path, and remaining risks.


## Document Quality Rules

Every generated workflow document should include the shared quality fields when relevant:
- 文档元信息: project root, generation time, branch/commit, agent, source document, status.
- 证据引用: map conclusions to file paths, line numbers, command output, docs, or mark them as inference/待确认.
- 决策记录: capture selected option, rejected options, rationale, and confirmation record.
- 范围锁定: allowed and forbidden files/behaviors; pause if implementation needs to exceed them.
- 验收样例 and 验证矩阵: connect requirements/findings to concrete examples and verification evidence.

All delivery stages also follow the shared engineering principles: clarify assumptions, keep implementation simple, make surgical changes, and tie completion to verification evidence.

## Preflight Checklist

Before doing stage work, run this mental/tool checklist and record the result in `delivery-workflow-state.md`:
- confirm current `cwd` and project root
- inspect whether the worktree already has changes
- locate or create the current run directory
- read `delivery-workflow-state.md` if it exists
- read the latest required stage document
- confirm whether this stage allows code edits
- if code edits are not explicitly allowed, do not modify code

## Resume Protocol

When resuming after interruption, compaction, or a new agent turn:
1. read `delivery-workflow-state.md`
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
3. Create artifacts at `<project-root>/workflow/runs/<YYYY-MM-DD>-<slug>/`.

Required files:

0. `delivery-workflow-state.md`
1. `01-delivery-requirements.md`
2. `02-delivery-architecture.md` (required only when architecture/design/selection triggers apply; otherwise note the reason in the plan)
3. `03-delivery-plan.md` (or `02-delivery-plan.md` for simple tasks without standalone architecture)
4. `04-delivery-implementation.md` (or `03-delivery-implementation.md` for simple tasks without standalone architecture)
5. `05-delivery-change-review.md` (required when Change Review Gate triggers apply)
6. `06-delivery-debugging.md` (for complex paths; if no debugging is needed, still create a short Chinese stub)
7. `07-delivery-verification.md` (or `05-delivery-verification.md` for simple low-risk tasks without change review/debugging)
8. `08-delivery-summary.md` (or `06-delivery-summary.md` for simple low-risk tasks)
9. `workflow-state.json` (machine-readable state, maintained alongside `delivery-workflow-state.md`)

Use the templates in `assets/workflow-templates/`. The templates are Chinese-first and should remain Chinese when filled.

After each stage document is written or updated, update `delivery-workflow-state.md` and `workflow-state.json` with current stage, status, latest document, next action, blockers, selected scope, and whether code edits are allowed. If `workflow/index.md` exists in the project root, update the run entry as well.

## Stage 1 — Requirements Capture

Goal: turn the user's request into a concrete engineering target.

Actions:
- if continuing from `code-review-triage`, read the review handoff files first
- restate the requested outcome in Chinese
- capture assumptions and constraints
- identify affected files, systems, or repos if known
- define acceptance criteria
- write `01-delivery-requirements.md`
- mark the document status as pending human confirmation
- reply to the human with the run folder path, a concise summary, identified gaps/risks/conflicts, options if needed, and a direct request to confirm or revise the requirements
- stop before Stage 2 until the human explicitly approves the requirements and `01-delivery-requirements.md` has no unresolved blocking questions

If the task is ambiguous in a way that blocks safe work, or if the requested behavior conflicts with code evidence or project constraints, include the open issue in `01-delivery-requirements.md`, explain the conflict, ask concise questions or offer options, and pause before Stage 2.
If the human revises the requirement, update `01-delivery-requirements.md` and ask for confirmation again. Only proceed after explicit approval such as "确认", "可以", "按这个来", or an equivalent instruction, and only when unresolved blocking questions are cleared.


## Architecture Gate — Design and Technology Selection

Goal: decide whether the task needs standalone architecture/design/technology-selection review before implementation planning.

Generate `02-delivery-architecture.md` and stop for human confirmation when any of these triggers apply:
- cross-module or cross-service change
- new or changed persistence structure
- new external dependency, library, middleware, or technology component
- API or data contract change
- async, MQ, scheduler, workflow, or concurrency change
- permissions, security, privacy, data consistency, or migration concern
- review handoff marks a selected finding as architecture-level
- the human explicitly asks for design, architecture, technology selection, or方案

For simple tasks where none of these triggers apply, do not create standalone `02-delivery-architecture.md`; instead, write a short “无需独立架构设计” note in the plan with the reason.

If `02-delivery-architecture.md` is created:
- challenge unsafe or mismatched user-proposed designs using code evidence and constraints
- compare viable options and explain tradeoffs
- state the selected option and rejected options
- define module/service/data/interface boundaries
- state compatibility and migration strategy if relevant
- list constraints that the implementation plan must follow
- stop and ask the human to confirm or revise the architecture before writing the implementation plan
- if the human changes or challenges the design, update `02-delivery-architecture.md` and repeat the confirmation gate until the chosen design, rejected options, risks, and constraints are explicit

## Stage 2 — Planning

Goal: convert requirements into an execution plan.

Actions:
- read `01-delivery-requirements.md`
- if `02-delivery-architecture.md` exists, read it and follow its confirmed constraints
- if no standalone architecture document exists, record why independent architecture/design/selection was not needed
- break work into concrete steps
- record `Implementation Strategy`
- write the required `Implementation Plan`
- record `Task Decomposition` when the task is complex
- record `Worktree Recommendation` for risky, dirty, multi-module, or long-running tasks
- identify risks, dependencies, and verification strategy
- define test targets before implementation
- write `02-delivery-plan.md` for simple tasks, or `03-delivery-plan.md` after a standalone architecture stage

Planning should be specific enough that another agent could implement from the document.
After writing the plan, reply to the human with the run folder path, a concise plan summary, major risks, verification strategy, any unresolved assumptions, and a direct request to confirm or revise the plan. Stop before implementation until explicit approval and no unresolved blocking questions remain.
If the human revises the plan or the plan conflicts with confirmed requirements/architecture/code evidence, update the active plan document and repeat the confirmation gate.

## Stage 3 — Test-First Implementation

Goal: implement from the plan with test-first discipline.

Actions:
- read the approved plan document: `02-delivery-plan.md` for simple tasks, or `03-delivery-plan.md` when a standalone architecture stage exists
- follow the recorded `Implementation Strategy`
- follow the approved `Implementation Plan` and update `Execution Status`
- identify the smallest meaningful failing test or failing reproduction
- default to fail-first for behavior changes that are reasonably testable
- verify the test or reproduction fails for the right reason
- implement the minimal change to pass
- repeat incrementally
- keep notes of files changed, tests added, and deviations from the plan
- if implementation requires materially deviating from the approved plan or expanding scope, update the active implementation report (`03-delivery-implementation.md` for simple tasks, or `04-delivery-implementation.md` after standalone architecture), explain the deviation, ask for human confirmation, and pause before continuing
- write the implementation report

Default rule:
- do not treat “tests later” as the normal path

If strict fail-first is not practical, document all of the following in the active implementation report:
- why fail-first was not practical
- what alternative verification strategy was used
- what regression coverage was added later
- what residual risk remains because fail-first was not fully applied


## Failure Escalation

If implementation fails, verification fails, or behavior contradicts the plan, do not continue with repeated guess-based edits.

Switch to the debugging stage when any of the following is true:
- the same issue has already had two or more fix attempts
- the current fix depends on an unverified hypothesis
- the failure crosses multiple layers or components
- the current plan no longer explains the observed behavior

When escalating into debugging, record:
- attempted fixes so far
- rejected hypotheses
- current best root-cause hypothesis
- whether the task should return to requirements, architecture, or planning

Return to implementation only after the debugging stage has produced a root-cause hypothesis with supporting evidence and an updated fix direction.

## Change Review Gate — Post-Implementation Review

Goal: review the actual code changes against requirements, architecture, plan, scope lock, and code-quality standards before verification.

Generate `05-delivery-change-review.md` after implementation and before verification when any trigger applies:
- continuing from `code-review-triage` handoff
- standalone architecture gate was used
- cross-module or cross-service change
- API, DTO, response shape, or data contract change
- database, migration, entity, or persistence structure change
- async, MQ, scheduler, workflow, or concurrency change
- permissions, security, privacy, or data consistency concern
- worktree was dirty before implementation or current diff is broad/noisy
- the human explicitly asks for a second review

Checks:
- matches `01-delivery-requirements.md`
- follows confirmed architecture and plan
- stays inside scope lock
- has no unrelated diff, broad formatting, or line-ending pollution
- does not break API/DTO/data contracts or strong typing rules
- keeps the verification plan valid

Allowed conclusions:
- `approved_for_verification`
- `approved_with_notes`
- `changes_required`
- `scope_violation`
- `blocked_needs_user_decision`

Only `approved_for_verification` and `approved_with_notes` allow Stage 5 verification to start. Any other conclusion must return to implementation/debugging/plan/architecture/requirements or pause for human confirmation.

## Stage 4 — Systematic Debugging

Goal: resolve failures through root-cause analysis, not guesswork.

Trigger this stage when:
- tests fail unexpectedly
- build/lint/runtime behavior contradicts the plan
- implementation gets blocked by unclear system behavior

Actions:
- reproduce the failure
- capture the exact error/output
- inspect recent changes and likely boundaries
- trace the failing data/control path backward to source
- only then propose and apply a fix
- if the fix changes approved scope, architecture, persistence, compatibility behavior, or other high-risk boundaries, write the finding to the active debugging report (`04-delivery-debugging.md` for simple paths, or `06-delivery-debugging.md` for architecture/change-review paths), ask for human confirmation, and pause before applying it
- write the debugging report

If debugging is not needed, still create the active debugging report with a short Chinese note saying no debugging stage was required: `04-delivery-debugging.md` for simple paths, or `06-delivery-debugging.md` for architecture/change-review paths.

## Stage 5 — Verification Before Completion

Goal: prove the change works before reporting success.

Precondition: if Change Review Gate triggers applied, `05-delivery-change-review.md` must conclude `approved_for_verification` or `approved_with_notes`.

Before verification, confirm that the implementation still matches the approved requirements and plan, and that no unnecessary scope expansion or over-engineering was introduced.

Actions:
- run the smallest meaningful verification gates
- prefer project-native checks: tests, build, lint, typecheck, smoke test, screenshot, diff inspection
- record exactly what was run and the outcome
- list any skipped checks and why they were skipped
- include the shared `Verification` structure with completed / analysis-only / blocked / needs-user-confirmation judgment
- if meaningful verification is blocked or cannot be run, write the blocker to the active verification report (`05-delivery-verification.md` for simple low-risk paths, or `07-delivery-verification.md` for architecture/change-review paths), ask whether to accept the risk or provide the missing environment/input, and pause before claiming completion
- write the verification report

Do not mark the work complete unless verification evidence exists or a blocker is explicitly documented.

## Stage 6 — Delivery Summary

Goal: hand the result to the human in one concise document and wait for acceptance feedback.

Actions:
- complete the `Finish Checklist`
- summarize what changed
- list files touched
- summarize verification results
- note any remaining risks, follow-ups, or decisions needed
- write `06-delivery-summary.md` for simple low-risk paths, or `08-delivery-summary.md` for architecture/change-review paths
- if continuing from `code-review-triage`, write or update the source review run's `review-delivery-result.md`
- reply with the delivery summary path and ask the human to accept the result or provide follow-up changes

## Execution Pattern

When using this skill in a live task:

1. resolve the current project root
2. run the preflight checklist
3. create the run folder under `<project-root>/workflow/runs/<YYYY-MM-DD>-<slug>/`
4. create or update `delivery-workflow-state.md`
5. write `01-delivery-requirements.md` in Chinese
6. ask the human to confirm or revise `01-delivery-requirements.md`, then stop
7. if revisions are requested, update `01-delivery-requirements.md` and repeat the confirmation gate
6. after explicit approval, evaluate the architecture gate
7. if architecture triggers apply, write `02-delivery-architecture.md` in Chinese, ask the human to confirm or revise it, then stop
8. if architecture revisions are requested, update `02-delivery-architecture.md` and repeat the confirmation gate
9. after architecture approval, or when no standalone architecture document is needed, write the implementation plan in Chinese (`03-delivery-plan.md` when architecture exists, otherwise `02-delivery-plan.md`)
10. ask the human to confirm or revise the plan, then stop
11. if revisions are requested, update the plan and repeat the confirmation gate
12. after explicit approval, execute implementation and write the implementation report in Chinese
13. during implementation/debugging/verification, pause for confirmation if scope expands, the architecture/plan materially changes, verification is blocked, or a destructive/high-risk operation is needed
14. after implementation, evaluate the Change Review Gate triggers
15. if triggers apply, write `05-delivery-change-review.md`; only continue if the conclusion is `approved_for_verification` or `approved_with_notes`
16. if needed, perform debugging and write the debugging report in Chinese; otherwise write the Chinese not-needed stub
17. verify and write the verification report in Chinese
18. summarize in the delivery report in Chinese
19. reply to the human with the key outcome, the run folder path, and a request for acceptance or follow-up feedback

## Recommended Companion Behaviors

- Use plan tooling to keep visible stage state current.
- Use subagents only when tasks are truly separable.
- Keep user-visible updates short; the documents carry the detail.
- Prefer append/update of the current run documents over scattered notes.

## References

Read these only when needed:
- `references/document-contracts.md` — required fields for each artifact
- `references/stage-playbook.md` — how to execute each stage with the right discipline
- `references/example-run.md` — example of a completed workflow run
- `examples/standard-run.md` — canonical miniature run shape for state, stages, verification, and summary
