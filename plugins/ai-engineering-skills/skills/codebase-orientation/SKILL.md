---
name: codebase-orientation
description: >-
  Read-only orientation workflow for quickly understanding a codebase, module, business domain, or execution flow. Produces Chinese project maps, business flow notes, technical call paths, data contracts, open questions, and optional handoff documents for code-review-triage or software-delivery-pipeline.
---

# Codebase Orientation

Use this skill when the user asks to become familiar with a project, module, package, endpoint, business flow, or existing implementation before reviewing or changing code.

## Usage Boundary

Use when:
- the user asks to become familiar with a project, module, endpoint, package, or workflow
- the goal is read-only understanding before review, debugging, or delivery
- the output should map business flow, call paths, data contracts, risks, and next-step options

Do not use when:
- the user asks for a code review with findings and severity
- there is a concrete bug, failing test, exception, or regression to debug
- implementation scope is already confirmed and ready for delivery

Prefer another skill when:
- `code-review-triage`: the user wants issues, risk ranking, or fix selection
- `debug-root-cause`: the user reports an error or unexpected behavior
- `api-contract-design`: the focus is request/response/DTO/error contract
- `data-migration-planning`: the focus is schema or persisted data changes
- `software-delivery-pipeline`: the user asks to implement an approved change

Follow `docs/workflow-contracts.zh-CN.md` `Execution Mode Contract`; record `executionMode` as `lightweight`, `standard`, or `full` in state and summary.


## Execution Mode Selection

Choose and record `executionMode` as `lightweight`, `standard`, or `full` before creating workflow artifacts. Follow `docs/prompt-modules/lightweight-mode.zh-CN.md` for selection rules, produced/skipped artifacts, and upgrade conditions.

## Prompt Modules

This skill keeps workflow-specific rules here and delegates shared execution discipline to:

- `docs/prompt-modules/task-decomposition.zh-CN.md` — 只读熟悉任务拆分
- `docs/prompt-modules/lightweight-mode.zh-CN.md` — 轻量/标准/完整熟悉产物边界
- `docs/prompt-modules/handoff.zh-CN.md` — orientation 到 review / delivery 的交接
- `docs/prompt-modules/minimal-change.zh-CN.md` — 保持只读，不做无关改动
- `docs/prompt-modules/verification-gate.zh-CN.md` — 证据覆盖和 analysis-only 判断

- `docs/prompt-modules/write-guard.zh-CN.md` — 写入、删除、覆盖、安装和迁移门禁
- `docs/prompt-modules/risk-gate.zh-CN.md` — low/medium/high 风险等级、确认和回滚要求

## Domain Module: Java / Spring

If `domainModules` contains `java-spring-microservice`, this workflow must additionally identify and summarize:

- Maven / Gradle module structure
- Spring Boot entrypoints
- Controller / Service / Mapper / Repository layering
- Feign / OpenFeign clients and remote service dependencies
- MQ topics / exchanges / queues and consumers
- Redis keys / Redisson locks
- MySQL tables / MongoDB collections
- Nacos / YAML configuration keys
- Security context sources, such as JWT claims, `SecurityUtils`, `login_scene`, `patientId`, `storeId`, `tenantId`
- High-risk modules and cross-service boundaries

All conclusions must cite evidence such as file path, class name, method name, annotation, endpoint path, table name, collection name, topic name, or config key.

Load `docs/domain-modules/java-spring-microservice.zh-CN.md` for the full checklist.

## Core Rules

- Follow the `Prompt Modules` section for shared clarification, execution mode, handoff, minimal-change, and verification discipline.

- Orientation mode is read-only. Do not modify code, configs, generated files, or docs unless the user explicitly changes the task.
- All generated workflow documents must be written in Simplified Chinese, except code identifiers, commands, file paths, error text, API names, and quoted user text.
- Prefer code, config, tests, routes, schemas, logs, and docs as evidence. Do not infer from framework conventions when files can verify the fact.
- Separate confirmed facts from AI inferences. Mark uncertain items as `待确认`.
- If the user names a module, package, endpoint, or path, stay there first and do not widen scope until necessary.
- Follow `docs/workflow-contracts.zh-CN.md` `Stop and Confirmation Contract`; when it triggers, update state and stop for human confirmation.
- `workflow-state.json` must strictly match `docs/workflow-state-schema.json`: include `schemaVersion`, `runPath`, `executionMode`, `modePath`, risk and confirmation fields, and `updatedAt`; do not write ad hoc extra fields such as `projectRoot`, `runDir`, `branch`, `commit`, `producedArtifacts`, `skippedArtifacts`, or `verification`.
- Do not produce a shallow file listing. Explain what each important component does in the business and runtime flow.
- Do not turn suspicious code into review findings inside this skill. Put them under “后续可 review 的线索”.
- If the user later asks to review or fix issues, hand off to `code-review-triage` or `software-delivery-pipeline` using the orientation artifacts as context.
- If the human provides an existing orientation artifact path or asks to continue a prior orientation run, continue that run instead of starting a new one unless a reset is explicitly requested.

## Task Decomposition

For complex repositories, split orientation into bounded read-only tracks:

| 子任务 | 类型 | 是否可并行 | 输出 |
| --- | --- | --- | --- |
| 代码结构分析 | read-only | yes | project map |
| 业务流分析 | read-only | yes | business flow notes |
| 数据契约分析 | read-only | yes | contract notes |
| 风险线索分析 | read-only | yes | review/debug leads |

Code edits are not allowed in this workflow. If the user asks to implement after orientation, create a handoff and route to the correct downstream workflow.

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
- locate or create the current run directory
- read `orientation-workflow-state.md` if it exists
- read the latest required stage document before continuing
- create artifacts under the project root, not under the skill directory
- keep the skill read-only unless the human explicitly changes the task

## Resume Protocol

When resuming after interruption, compaction, or a new agent turn:
1. read `orientation-workflow-state.md`
2. read the latest stage document listed there
3. inspect current git diff/status if later handoff may affect implementation
4. state the current stage, blockers, and whether code edits are allowed
5. continue only from the recorded next action

## Filename Compatibility

New runs must use the prefixed artifact filenames documented above. If an older run already exists with legacy names such as `01-requirements.md` or `handoff-to-delivery.md`, read those files for compatibility, but do not create new legacy-named files.

## Workflow Artifacts

Create the run directory under the current project root, not under the skill installation directory.

Project root resolution:
1. Prefer the current workspace's git root: `git rev-parse --show-toplevel` from the active working directory.
2. If the active working directory is not inside a git repository, use the active working directory itself.
3. Create artifacts at `<project-root>/workflow/orientation/<YYYY-MM-DD>-<slug>/`.

Required files:

0. `orientation-workflow-state.md`
1. `10-orientation-scope.md`
2. `11-orientation-map.md`
3. `12-orientation-summary.md`
4. `orientation-to-review-handoff.md` (optional, when the next step is `code-review-triage`)
5. `orientation-to-delivery-handoff.md` (optional, when the next step is `software-delivery-pipeline`)
6. `workflow-state.json` (machine-readable state, maintained alongside `orientation-workflow-state.md`)

Expanded files (only when the repo is large, the human explicitly wants deep decomposition, or the domain really benefits from separate artifacts):
- `02-orientation-project-map.md`
- `03-orientation-business-flow.md`
- `04-orientation-technical-flow.md`
- `05-orientation-data-contracts.md`
- `06-orientation-open-questions.md`
- `07-orientation-summary.md`

Use the templates in `assets/orientation-templates/`.

After each stage document is written or updated, update `orientation-workflow-state.md` and `workflow-state.json` with current stage, status, latest document, next action, blockers, and whether code edits are allowed. If `workflow/index.md` exists in the project root, update the run entry as well.

## Default Slim Flow

### Stage 1 — Scope
Goal: define what to understand and how deep to go.

Actions:
- identify target: repo, module, package, endpoint, feature, business flow, or files
- identify focus: business meaning, call path, data model, integration, deployment, or tests
- write `10-orientation-scope.md`

If the user asks “熟悉当前项目” and no module is specified, do a bounded top-level pass first. If the repo is too large, document the boundary and ask what area to deepen next.

### Stage 2 — Orientation Map
Goal: give one reusable core document instead of four thin stage files.

Actions:
- inspect directory structure, build files, route/controller/entrypoint files, configs, docs, DTOs, entities, schemas, API responses, MQ payloads, config structures, and external contracts as needed
- write `11-orientation-map.md`
- merge project/module role, business flow, technical flow, important data contracts, key file references, and open questions into one structured document
- separate `事实`、`推断`、`待确认`
- keep possible defects as review leads, not confirmed findings unless evidence is strong and the user asked for review

### Stage 3 — Summary and Handoff
Goal: give the human a concise reusable understanding.

Actions:
- write `12-orientation-summary.md`
- include architecture overview, business flow summary, technical flow summary, key files, risks, unresolved questions, and recommended next step
- include `Verification`: files/evidence read, areas not covered, unverified assumptions, and completion judgment
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
- `examples/standard-run.md` — canonical miniature run shape for state, summary, and optional handoff output
