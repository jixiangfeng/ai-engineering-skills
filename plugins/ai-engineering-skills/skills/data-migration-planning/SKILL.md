---
name: data-migration-planning
description: >-
  Plan database/schema/data migrations with compatibility, rollout, rollback, validation SQL, risk analysis, and implementation handoff. Use before changing tables, entities, stored data, migrations, cleanup scripts, or backfills.
---

# Data Migration Planning

Use this skill when the task involves schema changes, data backfill, cleanup scripts, storage migration, entity changes, data compatibility, or rollback planning.

## Usage Boundary

Use when:
- the task changes schema, entities, persisted data, migrations, cleanup scripts, or backfills
- rollout, rollback, validation SQL, compatibility window, or recovery strategy must be planned
- implementation should wait for a confirmed migration plan

Do not use when:
- the task only changes in-memory code behavior and no stored data contract changes
- the user asks for general code review or orientation without migration scope
- the migration plan is already confirmed and only implementation remains

Prefer another skill when:
- `codebase-orientation`: current data flow or schema ownership is unclear
- `debug-root-cause`: the task starts from a concrete data/runtime failure
- `api-contract-design`: the main decision is API shape, with no storage migration
- `code-review-triage`: the user wants to audit data code before choosing fixes
- `software-delivery-pipeline`: the migration plan is confirmed and ready to implement

Follow `docs/workflow-contracts.zh-CN.md` `Execution Mode Contract`; record `executionMode` as `lightweight`, `standard`, or `full` in state and summary.


## Execution Mode Selection

Choose and record `executionMode` as `lightweight`, `standard`, or `full` before creating workflow artifacts. Follow `docs/prompt-modules/lightweight-mode.zh-CN.md` for selection rules, produced/skipped artifacts, and upgrade conditions.

## Prompt Modules

This skill keeps workflow-specific rules here and delegates shared execution discipline to:

- `docs/prompt-modules/implementation-plan.zh-CN.md` — 迁移到实现的计划结构
- `docs/prompt-modules/worktree-recommendation.zh-CN.md` — 高风险迁移的隔离建议
- `docs/prompt-modules/lightweight-mode.zh-CN.md` — 轻量/标准/完整迁移规划产物边界
- `docs/prompt-modules/handoff.zh-CN.md` — migration 到 delivery 的交接
- `docs/prompt-modules/minimal-change.zh-CN.md` — 默认不执行迁移、不扩大数据范围
- `docs/prompt-modules/verification-gate.zh-CN.md` — 迁移校验、回滚和残余风险 Verification

- `docs/prompt-modules/write-guard.zh-CN.md` — 写入、删除、覆盖、安装和迁移门禁
- `docs/prompt-modules/risk-gate.zh-CN.md` — low/medium/high 风险等级、确认和回滚要求

## Domain Module: Java / Spring

If `domainModules` contains `java-spring-microservice`, migration planning must additionally check:

- MyBatis / MyBatis-Plus mapper usage of the affected columns
- XML dynamic SQL and wrapper query conditions
- MongoDB historical documents and missing-field compatibility
- DTO / VO / Entity fields affected by migration
- Feign and front-end contract compatibility
- Nacos config flags required for gray release or rollback
- Batch size, retry strategy, idempotency key, and rollback SQL
- Verification SQL or scripts before and after migration

Destructive SQL, field deletion, table deletion, or incompatible enum changes require explicit user confirmation.

Load `docs/domain-modules/java-spring-microservice.zh-CN.md` for the full checklist.

## Core Rules

- Follow the `Prompt Modules` section for shared clarification, execution mode, handoff, minimal-change, and verification discipline.

- Migration planning is a design gate before implementation.
- Never assume production data shape; inspect schema, entities, queries, and migration history when available.
- Always define rollback or recovery strategy, even if rollback is manual.
- Separate schema change, code compatibility, data backfill, verification, and cleanup phases.
- All generated documents must be Simplified Chinese, except code identifiers, commands, paths, SQL, error text, API names, and quoted user text.
- Follow `docs/workflow-contracts.zh-CN.md` `Stop and Confirmation Contract`; when it triggers, update state and stop for human confirmation.
- `workflow-state.json` must strictly match `docs/workflow-state-schema.json`: include `schemaVersion`, `runPath`, `executionMode`, `modePath`, risk and confirmation fields, and `updatedAt`; do not write ad hoc extra fields such as `projectRoot`, `runDir`, `branch`, `commit`, `producedArtifacts`, `skippedArtifacts`, or `verification`.
- Hand off confirmed migration plans to `software-delivery-pipeline` for implementation.
- If the user provides an existing migration artifact path or asks to continue a prior migration run, resume that run instead of creating a new one unless a reset is explicitly requested.

## Worktree Recommendation

For migrations, explicitly decide whether an isolated worktree or branch should be recommended. Recommend isolation when the migration spans modules, touches core flows, has dirty worktree risk, includes destructive or irreversible steps, or needs multiple strategy experiments. Only recommend; do not run `git worktree add` unless the user explicitly asks.

## Document Quality Rules

Migration planning artifacts should be reusable by later delivery work:
- 文档元信息: project root, generation time, branch/commit, agent, source document, status.
- 证据引用: current schema, read/write path, migration plan, rollback plan, and validation SQL should point to code/config/docs/schema/tests when available.
- 决策记录: capture selected migration strategy, rejected options, rationale, and confirmation.
- 范围锁定: clarify affected tables/entities/scripts/jobs and explicitly excluded data changes.
- 迁移保障: separate schema, compatibility, backfill, verification, rollback, and cleanup expectations.

## Preflight Checklist

Before writing artifacts:
- confirm current `cwd` and project root
- inspect whether the worktree already has changes if the result may hand off to implementation
- locate or create the current run directory
- read `migration-workflow-state.md` if it exists
- read the latest required stage document before continuing
- create artifacts under the project root, not under the skill directory
- keep the skill read-only unless the human explicitly changes the task

## Resume Protocol

When resuming after interruption, compaction, or a new agent turn:
1. read `migration-workflow-state.md`
2. read the latest stage document listed there
3. inspect current git diff/status if later handoff may affect implementation
4. state the current stage, blockers, and whether code edits are allowed
5. continue only from the recorded next action

## Filename Compatibility

New runs must use the prefixed artifact filenames documented above. If an older run already exists with legacy names such as `01-requirements.md` or `handoff-to-delivery.md`, read those files for compatibility, but do not create new legacy-named files.

## Workflow Artifacts

Create artifacts under `<project-root>/workflow/data-migrations/<YYYY-MM-DD>-<slug>/`.

Required files:
0. `migration-workflow-state.md`
1. `10-migration-scope-current.md`
2. `11-migration-target-plan.md`
3. `12-migration-rollback-validation.md`
4. `13-migration-summary.md`
5. `migration-to-delivery-handoff.md` (optional, when implementation should continue in `software-delivery-pipeline`)
6. `workflow-state.json` (machine-readable state, maintained alongside `migration-workflow-state.md`)

Expanded files (only when the migration is broad, high-risk, or the human explicitly wants a fully split plan):
- `02-migration-current-data-model.md`
- `03-migration-target-data-model.md`
- `04-migration-plan.md`
- `05-migration-rollback-plan.md`
- `06-migration-validation-sql.md`
- `07-migration-summary.md`

Use the templates in `assets/data-migration-templates/`.

After each stage document is written or updated, update `migration-workflow-state.md` and `workflow-state.json` with current stage, status, latest document, next action, blockers, and whether code edits are allowed. If `workflow/index.md` exists in the project root, update the run entry as well.

## Default Slim Flow

### Stage 1 — Scope + Current State
Goal: define what storage/data surface is changing and record the current reality before planning.

Actions:
- identify target tables, entities, documents, storage paths, migration scripts, or read/write flows
- identify requested focus: schema change, data backfill, cleanup, compatibility, validation SQL, rollback, or phased rollout
- define in-scope and out-of-scope changes
- inspect current schema definitions, ORM entities, migration history, SQL, repositories, services, scripts, and tests
- write `10-migration-scope-current.md`
- separate `事实`, `推断`, and `待确认`

If scope is broad, do a bounded first pass and document the boundary. If the migration target is ambiguous in a way that blocks safe planning, ask one concise question.

### Stage 2 — Target Model + Migration Plan
Goal: define the desired end state and the executable path in one main planning artifact.

Actions:
- write `11-migration-target-plan.md`
- describe target schema/entity/state changes, compatibility period expectations, and cleanup intent
- compare viable options when more than one migration path exists
- separate schema change, code compatibility, data backfill, verification, rollout, and cleanup steps
- if risk or ordering is unclear, update the document and repeat the confirmation gate
- stop and ask the human to confirm or revise the target model and plan before finalizing handoff-ready outputs

### Stage 3 — Rollback + Validation
Goal: make failure recovery and acceptance checks explicit before implementation begins.

Actions:
- write `12-migration-rollback-validation.md`
- define rollback, recovery, fallback read strategy, or manual repair path as applicable
- mark destructive or irreversible steps clearly
- include validation SQL, integrity checks, row-count expectations, reconciliation steps, or equivalent executable checks when SQL is not enough

### Stage 4 — Summary and Handoff
Goal: produce the reusable final migration package and route to delivery when needed.

Actions:
- write `13-migration-summary.md`
- summarize current model, target model, migration phases, rollback path, validation strategy, and open questions
- include `Verification`: inspected schema/read-write paths, validation SQL/checks, rollback evidence, unverified assumptions, and completion judgment
- if implementation should continue next, write `migration-to-delivery-handoff.md`
- if unresolved migration-risk conflicts remain, stop and ask for confirmation instead of handing off

## Handoff Rules

`migration-to-delivery-handoff.md` should include:
- confirmed migration goal
- affected schema/entities/scripts/jobs
- selected migration strategy and rejected alternatives
- compatibility window and forbidden changes
- rollback/recovery requirements
- validation SQL or equivalent checks
- evidence sources and unresolved questions marked `待确认`

Do not invent execution sequencing or destructive operations that were not confirmed in the migration workflow.

## References

Read when doing actual migration planning:
- `references/data-migration-document-contracts.md` — artifact minimums and handoff expectations
- `references/data-migration-guidelines.md` — schema evidence, rollback, validation, and output quality rules
- `examples/standard-run.md` — canonical miniature run shape for migration plan, rollback, validation, state, and handoff output
