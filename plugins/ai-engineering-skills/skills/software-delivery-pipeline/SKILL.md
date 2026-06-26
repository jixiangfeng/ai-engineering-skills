---
name: software-delivery-pipeline
description: >-
  Orchestrate software development work as a document-driven pipeline for coding agents. Use when implementing a feature or bugfix with a staged flow. Write all workflow artifacts in Chinese under the current project root so the human can review stage documents instead of intermediate chatter.
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [delivery, implementation, verification, handoff, pipeline]
    related_skills: [workflow-bootstrap, code-review-triage, debug-root-cause, api-contract-design, data-migration-planning, tdd-test-engineering]
---

# Software Delivery Pipeline

Drive implementation work through a document-backed delivery workflow:

1. requirements capture
2. architecture/design gate when needed
3. implementation planning
4. test-first implementation
5. change review gate when risk triggers apply
6. systematic debugging when blocked
7. verification before completion
8. delivery summary

Keep this `SKILL.md` as the entrypoint. Detailed artifact contracts live in `references/document-contracts.md`; stage execution details live in `references/stage-playbook.md`; upstream handoff interpretation lives in `references/handoff-inputs.md`.

## When to Use

Use this skill when:
- implementing a feature or bugfix
- applying an already confirmed handoff
- restructuring a development task into explicit stages
- the human mainly wants reviewable documents, not intermediate chatter
- the work must survive long tasks, interruptions, or agent handoff

Do not use when:
- the user only asks a conceptual question
- the user asks to review, debug, design an API contract, plan a migration, or write/run tests before implementation; use the more specific upstream workflow first
- destructive repo operations are requested without explicit approval

Prefer another skill when:
- `codebase-orientation`: the user asks to understand unfamiliar code before changing it
- `code-review-triage`: the user asks to find or rank issues before choosing fixes
- `debug-root-cause`: a failure needs root cause before implementation
- `api-contract-design`: request/response/DTO/error behavior is not yet agreed
- `data-migration-planning`: schema, persisted data, rollback, or backfill needs planning first
- `tdd-test-engineering`: the primary task is test design, failing tests, regression execution, or test evidence

## Execution Mode Selection

Choose and record `executionMode` before creating artifacts:
- `lightweight`: fast path for low-risk, clearly scoped, repo-local fixes.
- `standard`: guarded path for ordinary implementation work; default when a scope/plan gate is useful.
- `full`: audited path for handoff-driven, high-risk, API/data/permission/cross-service, or explicitly recoverable delivery.

Follow `docs/workflow-contracts.zh-CN.md` `Execution Mode Contract`, `docs/execution-modes.zh-CN.md`, `docs/prompt-modules/lightweight-mode.zh-CN.md`, and `docs/prompt-modules/conditional-blocks.zh-CN.md`. Start from the lightest safe path. Audited hard triggers override task size.

## Prompt Modules

This skill keeps delivery-specific rules here and delegates shared discipline to:

- `docs/prompt-modules/clarification.zh-CN.md` — 需求澄清
- `docs/prompt-modules/implementation-plan.zh-CN.md` — Implementation Plan
- `docs/prompt-modules/execution-discipline.zh-CN.md` — 按计划执行和 Execution Status
- `docs/prompt-modules/test-strategy.zh-CN.md` — Implementation Strategy
- `docs/prompt-modules/worktree-recommendation.zh-CN.md` — worktree 隔离建议
- `docs/prompt-modules/task-decomposition.zh-CN.md` — 复杂任务拆分
- `docs/prompt-modules/finish-checklist.zh-CN.md` — 交付收尾检查
- `docs/prompt-modules/lightweight-mode.zh-CN.md` — 轻量/标准/完整交付产物边界
- `docs/prompt-modules/conditional-blocks.zh-CN.md` — 条件块和 skipped reason
- `docs/prompt-modules/handoff.zh-CN.md` — 上游 handoff 输入和结果回写
- `docs/prompt-modules/minimal-change.zh-CN.md` — 最小改动和 scope guard
- `docs/prompt-modules/verification-gate.zh-CN.md` — 完成前验证
- `docs/prompt-modules/write-guard.zh-CN.md` — 写入、删除、覆盖、安装和迁移门禁
- `docs/prompt-modules/risk-gate.zh-CN.md` — low/medium/high 风险等级、确认和回滚要求

## Domain Module: Java / Spring

If `domainModules` contains `java-spring-microservice`, the implementation plan must record:
- affectedServices
- affectedControllers
- affectedFeignClients
- affectedTables
- affectedCollections
- affectedTopics
- affectedConfigKeys
- riskLevel
- rollbackRequired
- verificationRequired
- rollbackPlan
- verificationPlan

For high-risk Java/Spring tasks, do not enter implementation until the user confirms the implementation plan. Load `docs/domain-modules/java-spring-microservice.zh-CN.md` for the full checklist.

## Core Rules

- Follow the referenced prompt modules for clarification, execution mode, handoff, minimal-change, write guard, risk gate, and verification discipline.
- Follow `references/stage-playbook.md` for the detailed stage actions and confirmation loops.
- Follow `references/document-contracts.md` for required fields in delivery artifacts.
- Follow `references/handoff-inputs.md` when consuming upstream workflow artifacts.
- Treat each generated stage document as a checkpoint and update state after writing or changing it.
- Do not generate full `01-08` artifacts unless `executionMode` is `full` / audited or a risk trigger requires them.
- Guarded runs use one scope+plan gate on `10-guarded-scope-plan.md`; this is a single combined gate for requirements, scope, implementation plan, and verification target when the user's instruction already provides a valid approval basis.
- Fast runs may use `00-fast-patch-summary.md` or a concise verification note, but must still record goal, scope, assumptions, minimal plan, verification, skipped gates, remaining risk, and upgrade conditions.
- Do not begin implementation or code edits until the required requirements/architecture/plan gates are satisfied, except in a safe `lightweight` fast run whose note records scope and stop conditions.
- Pause for human confirmation if scope expands, the plan materially changes, verification is blocked, or a destructive/high-risk operation is needed. Follow `docs/workflow-contracts.zh-CN.md` `Stop and Confirmation Contract` when this happens.
- `workflow-state.json` must match `docs/workflow-state-schema.json`; do not add ad hoc fields.
- Prefer evidence over assumptions; do not claim completion until meaningful verification has run or a blocker is explicitly documented.
- If implementation or verification fails unexpectedly, switch to systematic debugging before more fixes.
- Generated workflow documents must be Simplified Chinese except identifiers, commands, paths, API names, error text, and quoted user text.
- If code changes already exist before the run starts, record them as pre-existing workspace state and do not normalize unrelated diffs.

## Implementation Strategy

Use `docs/prompt-modules/test-strategy.zh-CN.md` to choose and record `test_first`, `minimal_patch`, or `exploratory_fix` before code edits.

## Implementation Plan

Use `docs/prompt-modules/implementation-plan.zh-CN.md`. No implementation begins until the plan is written, scope-locked, and approved, except for allowed fast runs.

## Task Decomposition

Use `docs/prompt-modules/task-decomposition.zh-CN.md` for complex work. Only read-only analysis may be parallelized; code edits are not parallel by default.

## Finish Checklist

Use `docs/prompt-modules/finish-checklist.zh-CN.md` before writing the delivery summary.

## Execution Modes

### Mode A — Inline Execution
Use this mode for single-file or small-scope low-risk tasks with simple verification.

### Mode B — Subagent Execution
Use this mode for multi-step plans, multi-file changes, handoff implementation, architecture-sensitive work, or higher-risk bugfixes/refactors.

Recommended loop: implement a scoped plan item, review for spec compliance, review for code quality, then mark complete.

## Worktree Recommendation / Workspace Isolation Guidance

Use `docs/prompt-modules/worktree-recommendation.zh-CN.md`. Worktree creation is only a recommendation unless the human explicitly asks.

## Upstream Handoff Source of Truth

Use `docs/workflow-contracts.zh-CN.md` `Handoff Flow Contract` and `docs/handoff-routing-matrix.json` as the shared machine-readable source of truth for allowed upstream handoff routes, shared YAML keys, route-specific YAML keys, and required source artifacts.

Rules:
- Validate every handoff route and machine-readable fields before interpretation.
- If the handoff route is not declared in the matrix, stop and ask for confirmation instead of improvising a new transition.
- If handoff YAML is missing matrix-required keys or required source artifacts, stop before writing `01-delivery-requirements.md`.
- Use `references/handoff-inputs.md` for detailed field extraction and stop conditions.

## Review Handoff Input

When continuing from `code-review-triage`, prefer `review-to-delivery-handoff.md` as the source of truth and do not repair unselected findings. Required source paths and compatibility fallbacks are defined in `references/handoff-inputs.md`.

## Other Upstream Handoff Inputs

### Orientation Handoff Input
Use `orientation-to-delivery-handoff.md` as source of truth when continuing from orientation. Record accepted scope, excluded scope, constraints, unresolved questions, verification focus, and source artifacts in `01-delivery-requirements.md`.

### Debug Handoff Input
Use `debug-to-delivery-handoff.md` as source of truth when implementing from a confirmed root cause. Record confirmed root cause, selected fix direction, allowed scope, forbidden scope, and verification signals in `01-delivery-requirements.md`.

### Test Handoff Input
Use `test-to-delivery-handoff.md` as source of truth when implementing from confirmed failing tests. Record approved failing tests, fix scope, forbidden scope, required regression, and source artifacts in `01-delivery-requirements.md`.

### API Contract Handoff Input
Use `api-to-delivery-handoff.md` as source of truth when implementing from a confirmed API contract. Record DTO / endpoint / response boundaries, compatibility commitments, forbidden changes, and verification examples in `01-delivery-requirements.md`.

### Migration Handoff Input
Use `migration-to-delivery-handoff.md` as source of truth when implementing from a confirmed migration plan. Record migration phases, rollback / recovery obligations, destructive-operation boundaries, validation SQL/checks, and verification checks in `01-delivery-requirements.md`.

## Document Quality Rules

Every generated workflow document should include relevant shared quality fields:
- 文档元信息: project root, generation time, branch/commit, agent, source document, status.
- 证据引用: map conclusions to file paths, line numbers, command output, docs, or mark them as inference/待确认.
- 决策记录: capture selected option, rejected options, rationale, and confirmation record.
- 范围锁定: allowed and forbidden files/behaviors; pause if implementation needs to exceed them.
- 验收样例 and 验证矩阵: connect requirements/findings to concrete examples and verification evidence.

## Preflight Checklist

Before stage work, record the result in `delivery-workflow-state.md`:
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
3. inspect current git diff/status for scoped files
4. state the current stage, blockers, and whether code edits are allowed
5. continue only from the recorded next action

## Forbidden Actions

- Do not edit code before relevant requirements and plan gates are approved.
- Do not treat review plan approval or upstream handoff as delivery implementation approval.
- Do not implement unselected review findings.
- Do not broaden scope beyond locked files/behaviors without pausing for confirmation.
- Do not run broad formatting, line-ending normalization, or unrelated cleanup to hide actual diffs.
- Do not revert user or pre-existing changes unless the user explicitly asks.

## Filename Compatibility

New runs must use the prefixed artifact filenames documented here and in `references/document-contracts.md`. If an older run already exists with legacy names such as `01-requirements.md` or `handoff-to-delivery.md`, read those files for compatibility, but do not create new legacy-named files.

## Workflow Artifacts

Create the run directory under the current project root, not under the skill installation directory.

Project root resolution:
1. Prefer the current workspace's git root: `git rev-parse --show-toplevel` from the active working directory.
2. If the active working directory is not inside a git repository, use the active working directory itself.
3. Create artifacts at `<project-root>/workflow/runs/<YYYY-MM-DD>-<slug>/`.

### Fast Patch — `lightweight` / fast
Required files:
- `workflow-state.json`
- `delivery-workflow-state.md` only when a persistent run directory is useful
- `00-fast-patch-summary.md` or a concise summary / verification note

### Guarded Change — `standard` / guarded
Required files:
- `delivery-workflow-state.md`
- `10-guarded-scope-plan.md`
- `11-guarded-execution.md`
- `12-guarded-summary.md`
- `workflow-state.json`

### Audited Delivery — `full` / audited
Use this path for review handoff, high-risk changes, API/data/permission changes, or user-requested auditable delivery.

Hard triggers:
- continuing from review handoff
- API, DTO, response shape, error code, or data contract change
- migration, destructive SQL, field deletion, historical data compatibility, or persisted entity change
- authentication, authorization, permission, privacy, funds, payment, refund, medical, or health advice impact
- cross-service, Feign, MQ, scheduler, workflow, concurrency, or consistency change
- dirty worktree risk that may affect scoped files
- user explicitly asks for full, audited, recoverable, handoff-based, or document-complete delivery

Required/conditional chain:
- `delivery-workflow-state.md`
- `20-audited-run-map.md`
- `01-delivery-requirements.md`
- `02-delivery-architecture.md` when architecture/design/selection triggers apply
- `03-delivery-plan.md` or `02-delivery-plan.md` when no standalone architecture document exists
- implementation, change-review, debugging, verification, and summary documents according to `references/document-contracts.md`
- `workflow-state.json`

Use templates in `assets/workflow-templates/`. After each stage document is written or updated, update `delivery-workflow-state.md` and `workflow-state.json`; if `workflow/index.md` exists, update the run entry as well.

## Stage 1 — Requirements Capture

Write `01-delivery-requirements.md` for audited runs and stop for confirmation unless an allowed fast/guarded path applies. Follow `references/stage-playbook.md` for full actions.

## Architecture Gate — Design and Technology Selection

Create `02-delivery-architecture.md` only when architecture triggers apply; otherwise record skipped reason in the plan. Follow `references/stage-playbook.md` for trigger details.

## Stage 2 — Planning

Write the implementation plan, map every requirement/finding to concrete steps and verification, then stop for confirmation unless the chosen mode permits a combined gate. Follow `references/stage-playbook.md`.

## Stage 3 — Test-First Implementation

Implement from the approved plan with fail-first discipline where practical. Record deviations, changed files, tests, and plan execution status. Follow `references/stage-playbook.md`.

## Failure Escalation

If repeated fixes, unverified hypotheses, cross-layer failures, or plan contradictions appear, enter systematic debugging before more edits. Follow `references/stage-playbook.md`.

## Change Review Gate — Post-Implementation Review

Generate `05-delivery-change-review.md` when risk triggers apply. Only `approved_for_verification` and `approved_with_notes` allow verification to start. Follow `references/stage-playbook.md` for triggers and conclusions.

## Stage 4 — Systematic Debugging

Reproduce, capture evidence, trace to root cause, and record the debugging report when implementation or verification is blocked. Follow `references/stage-playbook.md`.

## Stage 5 — Verification Before Completion

Run the smallest meaningful project-native verification and record exact results. Do not mark work complete without verification evidence or an explicit blocker. Follow `references/stage-playbook.md`.

## Stage 6 — Delivery Summary

Write the delivery summary with changed files, verification results, remaining risks, and follow-up decisions. If continuing from review, update `review-delivery-result.md`. Follow `references/stage-playbook.md`.

## Execution Pattern

For live execution, use the concise sequence in `references/stage-playbook.md` `Live Execution Pattern`: resolve project root, run preflight, create `workflow/runs/<YYYY-MM-DD>-<slug>`, choose mode, write/update state, satisfy gates, implement, review/debug when needed, verify, summarize, and request acceptance.

## Recommended Companion Behaviors

- Use plan tooling to keep visible stage state current.
- Use subagents only when tasks are truly separable.
- Keep user-visible updates short; workflow documents carry the detail.
- Prefer append/update of the current run documents over scattered notes.

## References

Read these only when needed:
- `references/document-contracts.md` — required fields for each artifact and mode-specific templates
- `references/stage-playbook.md` — detailed execution actions, gates, and live sequence
- `references/handoff-inputs.md` — upstream handoff extraction, validation, and stop conditions
- `references/example-run.md` — example of a completed workflow run
- `examples/standard-run.md` — canonical miniature run shape for state, stages, verification, and summary
