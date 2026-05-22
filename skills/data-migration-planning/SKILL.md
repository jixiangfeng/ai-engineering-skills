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

## Preflight Checklist

Before writing artifacts:
- confirm current `cwd` and project root
- inspect whether the worktree already has changes if the result may hand off to implementation
- create artifacts under the project root, not under the skill directory
- keep the skill read-only unless the human explicitly changes the task


## Filename Compatibility

New runs must use the prefixed artifact filenames documented above. If an older run already exists with legacy names such as `01-requirements.md` or `handoff-to-delivery.md`, read those files for compatibility, but do not create new legacy-named files.

## Workflow Artifacts

Create artifacts under `<project-root>/workflow/data-migrations/<YYYY-MM-DD>-<slug>/`.

Required files:
1. `01-migration-scope.md`
2. `02-migration-current-data-model.md`
3. `03-migration-target-data-model.md`
4. `04-migration-plan.md`
5. `05-migration-rollback-plan.md`
6. `06-migration-validation-sql.md`
7. `07-migration-summary.md`
8. `migration-to-delivery-handoff.md` (optional)
