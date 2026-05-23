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
- If the user provides an existing contract artifact path or asks to continue a prior contract run, resume that run instead of creating a new one unless a reset is explicitly requested.

## Document Quality Rules

API contract artifacts should be reusable by later delivery work:
- 文档元信息: project root, generation time, branch/commit, agent, source document, status.
- 证据引用: current contract, proposed contract, compatibility decision, and error behavior should point to code/config/docs/tests when available.
- 决策记录: capture selected contract option, rejected options, rationale, and confirmation.
- 范围锁定: clarify affected endpoints, DTOs, callers, and explicitly excluded changes.
- 示例与验证: provide request/response examples, validation errors, compatibility notes, and delivery handoff constraints.

## Preflight Checklist

Before writing artifacts:
- confirm current `cwd` and project root
- inspect whether the worktree already has changes if the result may hand off to implementation
- locate or create the current run directory
- read `api-contract-workflow-state.md` if it exists
- read the latest required stage document before continuing
- create artifacts under the project root, not under the skill directory
- keep the skill read-only unless the human explicitly changes the task

## Resume Protocol

When resuming after interruption, compaction, or a new agent turn:
1. read `api-contract-workflow-state.md`
2. read the latest stage document listed there
3. inspect current git diff/status if later handoff may affect implementation
4. state the current stage, blockers, and whether code edits are allowed
5. continue only from the recorded next action

## Filename Compatibility

New runs must use the prefixed artifact filenames documented above. If an older run already exists with legacy names such as `01-requirements.md` or `handoff-to-delivery.md`, read those files for compatibility, but do not create new legacy-named files.

## Workflow Artifacts

Create artifacts under `<project-root>/workflow/api-contracts/<YYYY-MM-DD>-<slug>/`.

Required files:
0. `api-contract-workflow-state.md`
1. `01-api-contract-scope.md`
2. `02-api-current-contract.md`
3. `03-api-proposed-contract.md`
4. `04-api-compatibility.md`
5. `05-api-validation-errors.md`
6. `06-api-examples.md`
7. `07-api-summary.md`
8. `api-to-delivery-handoff.md` (optional, when implementation should continue in `software-delivery-pipeline`)

Use the templates in `assets/api-contract-templates/`.

After each stage document is written or updated, update `api-contract-workflow-state.md` with current stage, status, next action, and whether code edits are allowed.

## Stage 1 — Scope

Goal: define what contract surface is being designed and what is intentionally out of scope.

Actions:
- identify target endpoint, API group, DTO set, response shape, or caller chain
- identify requested focus: request fields, response fields, validation, error codes, versioning, compatibility, or frontend/backend alignment
- define in-scope and out-of-scope changes
- write `01-api-contract-scope.md`

If the task is too broad, do a bounded first pass and document the boundary. If the contract target is ambiguous in a way that blocks safe design, ask one concise question.

## Stage 2 — Current Contract

Goal: record the current request/response and validation behavior before proposing changes.

Actions:
- inspect controllers/routes, DTOs, schemas, serializers, validators, tests, docs, and consumers
- write `02-api-current-contract.md`
- separate `事实`, `推断`, and `待确认`

## Stage 3 — Proposed Contract

Goal: propose the target contract in a way that downstream implementation can follow without guessing.

Actions:
- write `03-api-proposed-contract.md`
- define field names, field locations, types, nullability, defaults, enum/domain constraints, and ownership boundaries
- compare viable options when the design is not obvious
- stop and ask the human to confirm or revise the proposed contract before finalizing handoff-ready outputs

## Stage 4 — Compatibility

Goal: make compatibility impact and migration expectations explicit.

Actions:
- write `04-api-compatibility.md`
- state whether existing clients keep working unchanged
- document compatibility strategy, versioning, fallback behavior, and rollout constraints
- if compatibility risk is unclear or conflicts with code evidence, update the document and repeat the confirmation gate

## Stage 5 — Validation and Errors

Goal: define validation rules and failure behavior clearly.

Actions:
- write `05-api-validation-errors.md`
- define validation conditions, error code/shape, error message boundaries, and special edge cases
- record unresolved validation ambiguities as `待确认`

## Stage 6 — Examples

Goal: give concrete examples for implementation and human review.

Actions:
- write `06-api-examples.md`
- provide representative request/response samples, invalid examples, and compatibility examples when relevant

## Stage 7 — Summary and Handoff

Goal: produce the reusable final contract package and route to the next workflow when needed.

Actions:
- write `07-api-summary.md`
- summarize scope, current contract, final proposed contract, compatibility decision, validation behavior, and open questions
- if implementation should continue next, write `api-to-delivery-handoff.md`
- if unresolved contract conflicts remain, stop and ask for confirmation instead of handing off

## Handoff Rules

`api-to-delivery-handoff.md` should include:
- confirmed business/API goal
- affected endpoints, DTOs, schemas, and callers
- selected contract decisions and rejected alternatives
- compatibility constraints and forbidden changes
- validation/error requirements
- evidence sources and unresolved questions marked `待确认`

Do not invent implementation decisions that were not confirmed in the contract workflow.

## References

Read when doing actual contract design:
- `references/api-contract-document-contracts.md` — artifact minimums and handoff expectations
- `references/api-contract-guidelines.md` — contract evidence, compatibility, and output quality rules
