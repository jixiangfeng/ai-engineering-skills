---
name: data-migration-planning
description: >-
  Plan database/schema/data migrations with compatibility, rollout, rollback, validation SQL, risk analysis, and implementation handoff. Use before changing tables, entities, stored data, migrations, cleanup scripts, or backfills.
---

# Data Migration Planning

Use this skill when the task involves schema changes, data backfill, cleanup scripts, storage migration, entity changes, data compatibility, or rollback planning.

## Core Rules

- Migration planning is a design gate before implementation.
- Never assume production data shape; inspect schema, entities, queries, and migration history when available.
- Always define rollback or recovery strategy, even if rollback is manual.
- Separate schema change, code compatibility, data backfill, verification, and cleanup phases.
- All generated documents must be Simplified Chinese, except code identifiers, commands, paths, SQL, error text, API names, and quoted user text.
- Hand off confirmed migration plans to `software-delivery-pipeline` for implementation.
- If the user provides an existing migration artifact path or asks to continue a prior migration run, resume that run instead of creating a new one unless a reset is explicitly requested.

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
1. `01-migration-scope.md`
2. `02-migration-current-data-model.md`
3. `03-migration-target-data-model.md`
4. `04-migration-plan.md`
5. `05-migration-rollback-plan.md`
6. `06-migration-validation-sql.md`
7. `07-migration-summary.md`
8. `migration-to-delivery-handoff.md` (optional, when implementation should continue in `software-delivery-pipeline`)

Use the templates in `assets/data-migration-templates/`.

After each stage document is written or updated, update `migration-workflow-state.md` with current stage, status, next action, and whether code edits are allowed.

## Stage 1 — Scope

Goal: define what storage/data surface is changing and what must stay untouched.

Actions:
- identify target tables, entities, documents, storage paths, migration scripts, or read/write flows
- identify requested focus: schema change, data backfill, cleanup, compatibility, validation SQL, rollback, or phased rollout
- define in-scope and out-of-scope changes
- write `01-migration-scope.md`

If scope is broad, do a bounded first pass and document the boundary. If the migration target is ambiguous in a way that blocks safe planning, ask one concise question.

## Stage 2 — Current Data Model

Goal: record the current schema/data model and actual read/write path before planning changes.

Actions:
- inspect schema definitions, ORM entities, migration history, SQL, repositories, services, scripts, and tests
- write `02-migration-current-data-model.md`
- separate `事实`, `推断`, and `待确认`

## Stage 3 — Target Data Model

Goal: define the desired end state clearly enough that later delivery work can implement it without guessing.

Actions:
- write `03-migration-target-data-model.md`
- describe target schema/entity/state changes, compatibility period expectations, and cleanup intent
- compare viable options when more than one migration path exists
- stop and ask the human to confirm or revise the target model before finalizing handoff-ready outputs

## Stage 4 — Migration Plan

Goal: break the migration into safe executable phases.

Actions:
- write `04-migration-plan.md`
- separate schema change, code compatibility, data backfill, verification, rollout, and cleanup steps
- if risk or ordering is unclear, update the document and repeat the confirmation gate

## Stage 5 — Rollback / Recovery Plan

Goal: make failure recovery explicit before implementation begins.

Actions:
- write `05-migration-rollback-plan.md`
- define rollback, recovery, fallback read strategy, or manual repair path as applicable
- mark destructive or irreversible steps clearly

## Stage 6 — Validation SQL / Checks

Goal: define how the migration result will be verified.

Actions:
- write `06-migration-validation-sql.md`
- include validation SQL, integrity checks, row-count expectations, and reconciliation steps
- if SQL is not the right validation surface, document equivalent executable checks

## Stage 7 — Summary and Handoff

Goal: produce the reusable final migration package and route to delivery when needed.

Actions:
- write `07-migration-summary.md`
- summarize current model, target model, migration phases, rollback path, validation strategy, and open questions
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
