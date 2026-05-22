---
name: api-contract-design
description: >-
  Design API contracts, DTOs, request/response shapes, error codes, compatibility rules, and validation behavior before implementation. Produces Chinese contract documents and optional handoff to software-delivery-pipeline.
---

# API Contract Design

Use this skill when the user asks to design or revise an API, endpoint, DTO, response shape, error code, validation rule, or frontend/backend contract.

## Core Rules

- Contract design is a confirmation gate before implementation.
- Preserve exact response shape unless the user explicitly approves a change.
- Prefer typed DTOs and explicit fields over loose containers.
- Record compatibility, versioning, and old-client behavior explicitly.
- All generated documents must be Simplified Chinese, except code identifiers, commands, paths, error text, API names, and quoted user text.
- Hand off confirmed contracts to `software-delivery-pipeline` for implementation.

## Preflight Checklist

Before writing artifacts:
- confirm current `cwd` and project root
- inspect whether the worktree already has changes if the result may hand off to implementation
- create artifacts under the project root, not under the skill directory
- keep the skill read-only unless the human explicitly changes the task


## Filename Compatibility

New runs must use the prefixed artifact filenames documented above. If an older run already exists with legacy names such as `01-requirements.md` or `handoff-to-delivery.md`, read those files for compatibility, but do not create new legacy-named files.

## Workflow Artifacts

Create artifacts under `<project-root>/workflow/api-contracts/<YYYY-MM-DD>-<slug>/`.

Required files:
1. `01-api-contract-scope.md`
2. `02-api-current-contract.md`
3. `03-api-proposed-contract.md`
4. `04-api-compatibility.md`
5. `05-api-validation-errors.md`
6. `06-api-examples.md`
7. `07-api-summary.md`
8. `api-to-delivery-handoff.md` (optional)
