---
name: codebase-orientation
description: >-
  Read-only orientation workflow for quickly understanding a codebase, module, business domain, or execution flow. Produces Chinese project maps, business flow notes, technical call paths, data contracts, open questions, and optional handoff documents for code-review-triage or software-delivery-pipeline.
---

# Codebase Orientation

Use this skill when the user asks to become familiar with a project, module, package, endpoint, business flow, or existing implementation before reviewing or changing code.

## Core Rules

- Orientation mode is read-only. Do not modify code, configs, generated files, or docs unless the user explicitly changes the task.
- All generated workflow documents must be written in Simplified Chinese, except code identifiers, commands, file paths, error text, API names, and quoted user text.
- Prefer code, config, tests, routes, schemas, logs, and docs as evidence. Do not infer from framework conventions when files can verify the fact.
- Separate confirmed facts from AI inferences. Mark uncertain items as `待确认`.
- If the user names a module, package, endpoint, or path, stay there first and do not widen scope until necessary.
- Do not produce a shallow file listing. Explain what each important component does in the business and runtime flow.
- Do not turn suspicious code into review findings inside this skill. Put them under “后续可 review 的线索”.
- If the user later asks to review or fix issues, hand off to `code-review-triage` or `software-delivery-pipeline` using the orientation artifacts as context.
- If the human provides an existing orientation artifact path or asks to continue a prior orientation run, continue that run instead of starting a new one unless a reset is explicitly requested.

## Output Discipline

- Distinguish clearly between `事实`, `推断`, and `待确认`.
- Do not present an inference as a confirmed conclusion without evidence.
- If a possible risk or code smell is noticed, record it as a follow-up review clue rather than a confirmed finding.
- The final summary should recommend the most suitable next workflow when enough evidence exists.
- Orientation is not code review.
- Do not label a behavior as a bug, defect, or finding unless the task explicitly switches into `code-review-triage` or `debug-root-cause`.
- Suspicions should be recorded as review/debug leads, not as confirmed issues.


## Document Quality Rules

Orientation artifacts should be reusable by later review or delivery work:
- 文档元信息: project root, generation time, branch/commit, agent, source document, status.
- 证据引用: map business/technical conclusions to code, config, docs, tests, or mark as 推断/待确认.
- 决策记录: capture orientation scope decisions and later handoff choices.
- 范围锁定: clarify what was inspected and what was intentionally not inspected.

## Preflight Checklist

Before writing artifacts:
- confirm current `cwd` and project root
- inspect whether the worktree already has changes if the result may hand off to implementation
- create artifacts under the project root, not under the skill directory
- keep the skill read-only unless the human explicitly changes the task


## Filename Compatibility

New runs must use the prefixed artifact filenames documented above. If an older run already exists with legacy names such as `01-requirements.md` or `handoff-to-delivery.md`, read those files for compatibility, but do not create new legacy-named files.

## Workflow Artifacts

Create the run directory under the current project root, not under the skill installation directory.

Project root resolution:
1. Prefer the current workspace's git root: `git rev-parse --show-toplevel` from the active working directory.
2. If the active working directory is not inside a git repository, use the active working directory itself.
3. Create artifacts at `<project-root>/workflow/orientation/<YYYY-MM-DD>-<slug>/`.

Required files:

1. `01-orientation-scope.md`
2. `02-orientation-project-map.md`
3. `03-orientation-business-flow.md`
4. `04-orientation-technical-flow.md`
5. `05-orientation-data-contracts.md`
6. `06-orientation-open-questions.md`
7. `07-orientation-summary.md`
8. `orientation-to-review-handoff.md` (optional, when the next step is `code-review-triage`)
9. `orientation-to-delivery-handoff.md` (optional, when the next step is `software-delivery-pipeline`)

Use the templates in `assets/orientation-templates/`.

## Stage 1 — Scope

Goal: define what to understand and how deep to go.

Actions:
- identify target: repo, module, package, endpoint, feature, business flow, or files
- identify focus: business meaning, call path, data model, integration, deployment, or tests
- write `01-orientation-scope.md`

If the user asks “熟悉当前项目” and no module is specified, do a bounded top-level pass first. If the repo is too large, document the boundary and ask what area to deepen next.

## Stage 2 — Project Map

Goal: identify important modules and ownership boundaries.

Actions:
- inspect directory structure, build files, route/controller/entrypoint files, configs, and existing docs
- write `02-orientation-project-map.md`
- explain components by role, not just names

## Stage 3 — Business Flow

Goal: explain the business process in domain terms.

Actions:
- identify core entities, actors, states, and user/system workflows
- write `03-orientation-business-flow.md`
- separate confirmed business rules from inferred rules

## Stage 4 — Technical Flow

Goal: trace runtime behavior through code.

Actions:
- identify entrypoints, service calls, persistence, external integrations, async jobs, and error handling
- write `04-orientation-technical-flow.md`
- include key file references and call paths

## Stage 5 — Data Contracts

Goal: record important data shapes and contracts.

Actions:
- inspect DTOs, entities, schemas, API responses, MQ payloads, config structures, and external contracts
- write `05-orientation-data-contracts.md`
- mark schema or contract uncertainty as `待确认`

## Stage 6 — Open Questions

Goal: capture what remains unclear or risky.

Actions:
- write `06-orientation-open-questions.md`
- include unknowns, assumptions, suspicious areas, missing docs/tests, and suggested next steps
- keep possible defects as review leads, not confirmed findings unless evidence is strong and user asked for review

## Stage 7 — Summary and Handoff

Goal: give the human a concise reusable understanding.

Actions:
- write `07-orientation-summary.md`
- include architecture overview, business flow summary, technical flow summary, key files, risks, and recommended next step
- explicitly recommend the next best workflow when appropriate, for example: `code-review-triage`, `software-delivery-pipeline`, `debug-root-cause`, `api-contract-design`, or `data-migration-planning`, and state why
- if the user wants review next, write `orientation-to-review-handoff.md`
- if the user wants implementation next, write `orientation-to-delivery-handoff.md`

## Handoff Rules

- `orientation-to-review-handoff.md` should tell `code-review-triage` what scope to review and which review leads to inspect. It should include confirmed scope, key modules and flows, suspicious areas worth reviewing, recommended review starting points, and known evidence sources.
- `orientation-to-delivery-handoff.md` should tell `software-delivery-pipeline` what confirmed context, constraints, and unresolved questions should shape requirements. It should include confirmed business goal, affected modules, key constraints, unresolved questions, and why direct delivery is appropriate without a separate review/debug stage.
- Handoffs must not invent decisions. If something is uncertain, mark it `待确认`.

## References

Read when doing actual orientation:
- `references/orientation-guidelines.md` — evidence, fact/inference labels, and output quality rules
