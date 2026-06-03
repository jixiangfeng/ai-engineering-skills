---
name: api-contract-design
description: >-
  Design API contracts, DTOs, request/response shapes, error codes, compatibility rules, and validation behavior before implementation. Produces Chinese contract documents and optional handoff to software-delivery-pipeline.
---

# API Contract Design

Use this skill when the user asks to design or revise an API, endpoint, DTO, response shape, error code, validation rule, or frontend/backend contract.

## Usage Boundary

Use when:
- the user asks to design or revise an endpoint, DTO, response shape, error code, or validation rule
- frontend/backend contract, compatibility, versioning, or examples must be agreed before coding
- implementation should wait for a confirmed contract

Do not use when:
- the task is only to understand existing code without changing a contract
- a runtime failure needs root-cause debugging first
- the contract is already approved and only implementation remains

Prefer another skill when:
- `codebase-orientation`: current API behavior is not understood yet
- `debug-root-cause`: the issue starts from a failing API behavior or log
- `code-review-triage`: the user wants to audit existing API code for problems
- `data-migration-planning`: contract changes require persisted data/schema changes
- `software-delivery-pipeline`: the contract is confirmed and ready to implement

Follow `docs/workflow-contracts.zh-CN.md` `Execution Mode Contract`; record `executionMode` as `lightweight`, `standard`, or `full` in state and summary.


## Execution Mode Selection

Choose and record `executionMode` as `lightweight`, `standard`, or `full` before creating workflow artifacts. Follow `docs/prompt-modules/lightweight-mode.zh-CN.md` for selection rules, produced/skipped artifacts, and upgrade conditions.

## Prompt Modules

This skill keeps workflow-specific rules here and delegates shared execution discipline to:

- `docs/prompt-modules/clarification.zh-CN.md` — 契约目标、调用方和兼容边界澄清
- `docs/prompt-modules/implementation-plan.zh-CN.md` — 契约到实现的计划结构
- `docs/prompt-modules/lightweight-mode.zh-CN.md` — 轻量/标准/完整契约产物边界
- `docs/prompt-modules/handoff.zh-CN.md` — API 契约到 delivery 的交接
- `docs/prompt-modules/minimal-change.zh-CN.md` — 只调整契约范围内字段和行为
- `docs/prompt-modules/verification-gate.zh-CN.md` — 契约覆盖 UI/异常/兼容状态的 Verification

- `docs/prompt-modules/write-guard.zh-CN.md` — 写入、删除、覆盖、安装和迁移门禁
- `docs/prompt-modules/risk-gate.zh-CN.md` — low/medium/high 风险等级、确认和回滚要求

## Domain Module: Java / Spring

If `domainModules` contains `java-spring-microservice`, API contracts must additionally define:

- Controller endpoint path and HTTP method
- Request DTO name and field validation rules
- Response VO name and field semantics
- Error code and message behavior
- enum values and fallback value such as `UNKNOWN`
- `null` / empty string / empty array / missing field semantics
- Backward compatibility for old clients and historical data
- Whether a version field is required
- Whether front-end rendering needs fallback logic
- Whether Entity, Mongo document, or internal Feign DTO is leaking into public response

Any deletion or semantic change of a response field must be marked as high risk.

Load `docs/domain-modules/java-spring-microservice.zh-CN.md` for the full checklist.

## Core Rules

- Follow the `Prompt Modules` section for shared clarification, execution mode, handoff, minimal-change, and verification discipline.

- Contract design is a confirmation gate before implementation.
- Preserve exact response shape unless the user explicitly approves a change.
- Prefer typed DTOs and explicit fields over loose containers.
- Record compatibility, versioning, and old-client behavior explicitly.
- All generated documents must be Simplified Chinese, except code identifiers, commands, paths, error text, API names, and quoted user text.
- Follow `docs/workflow-contracts.zh-CN.md` `Stop and Confirmation Contract`; when it triggers, update state and stop for human confirmation.
- `workflow-state.json` must strictly match `docs/workflow-state-schema.json`: include `schemaVersion`, `runPath`, `executionMode`, `modePath`, risk and confirmation fields, and `updatedAt`; do not write ad hoc extra fields such as `projectRoot`, `runDir`, `branch`, `commit`, `producedArtifacts`, `skippedArtifacts`, or `verification`.
- Hand off confirmed contracts to `software-delivery-pipeline` for implementation.
- If the user provides an existing contract artifact path or asks to continue a prior contract run, resume that run instead of creating a new one unless a reset is explicitly requested.

## Contract Clarification Gate

Before proposing a target contract, clarify:

- business/API goal
- callers and consumers
- affected endpoints, DTOs, schemas, and validation points
- compatibility boundary and forbidden changes
- UI states, empty states, error states, and abnormal states that the contract must cover
- acceptance criteria for examples and validation behavior

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
1. `10-api-contract-scope.md`
2. `11-api-current-proposed.md`
3. `12-api-rules-examples.md`
4. `13-api-summary.md`
5. `api-to-delivery-handoff.md` (optional, when implementation should continue in `software-delivery-pipeline`)
6. `workflow-state.json` (machine-readable state, maintained alongside `api-contract-workflow-state.md`)

Expanded files (only when the contract surface is broad, compatibility is sensitive, or the human explicitly wants a fully split package):
- `02-api-current-contract.md`
- `03-api-proposed-contract.md`
- `04-api-compatibility.md`
- `05-api-validation-errors.md`
- `06-api-examples.md`
- `07-api-summary.md`

Use the templates in `assets/api-contract-templates/`.

After each stage document is written or updated, update `api-contract-workflow-state.md` and `workflow-state.json` with current stage, status, latest document, next action, blockers, and whether code edits are allowed. If `workflow/index.md` exists in the project root, update the run entry as well.

## Default Slim Flow

### Stage 1 — Scope
Goal: define what contract surface is being designed and what is intentionally out of scope.

Actions:
- identify target endpoint, API group, DTO set, response shape, or caller chain
- identify requested focus: request fields, response fields, validation, error codes, versioning, compatibility, or frontend/backend alignment
- define in-scope and out-of-scope changes
- write `10-api-contract-scope.md`

If the task is too broad, do a bounded first pass and document the boundary. If the contract target is ambiguous in a way that blocks safe design, ask one concise question.

### Stage 2 — Current + Proposed Contract
Goal: record the current contract and converge on the target contract in one reusable main artifact.

Actions:
- inspect controllers/routes, DTOs, schemas, serializers, validators, tests, docs, and consumers
- write `11-api-current-proposed.md`
- separate `事实`, `推断`, and `待确认`
- define current request/response and validation behavior
- define the proposed contract: field names, field locations, types, nullability, defaults, enum/domain constraints, ownership boundaries, and rejected alternatives when relevant
- stop and ask the human to confirm or revise the proposed contract before finalizing handoff-ready outputs

### Stage 3 — Rules + Examples
Goal: make compatibility and failure behavior executable, not implicit.

Actions:
- write `12-api-rules-examples.md`
- state whether existing clients keep working unchanged
- document compatibility strategy, versioning, fallback behavior, rollout constraints, validation conditions, error code/shape, special edge cases, and representative request/response examples
- include invalid examples and compatibility examples when relevant
- record unresolved validation ambiguities as `待确认`

### Stage 4 — Summary and Handoff
Goal: produce the reusable final contract package and route to the next workflow when needed.

Actions:
- write `13-api-summary.md`
- summarize scope, current contract, final proposed contract, compatibility decision, validation behavior, and open questions
- include `Verification`: checked callers/DTOs/examples, UI/error states covered, unverified assumptions, and completion judgment
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
- `examples/standard-run.md` — canonical miniature run shape for contract proposal, examples, state, and handoff output
