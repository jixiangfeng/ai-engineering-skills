---
name: tdd-test-engineering
description: >-
  Test engineering workflow for requirements-to-tests, acceptance criteria, test case approval, environment validation, TDD or regression test implementation, execution evidence, issue reporting, and regression summaries. Use when the user asks to write or补充测试, run TDD, design test cases, produce testing evidence, perform regression testing, validate a feature before release, or turn a bug/finding/contract into executable tests.
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [testing, tdd, regression, evidence, handoff]
    related_skills: [workflow-bootstrap, codebase-orientation, code-review-triage, debug-root-cause, api-contract-design, data-migration-planning, software-delivery-pipeline]
---

# TDD Test Engineering

Use this skill to drive a testing-first workflow. It can run independently, or receive context from orientation, review, debug, API contract, migration, or delivery workflows.

## Usage Boundary

Use when:
- the user asks for TDD, test-first work, regression testing, or executable test evidence
- a feature needs acceptance criteria, test cases, test data, and execution proof before release
- a bug, review finding, API contract, or migration plan needs tests before or after implementation
- the task is primarily about validating behavior rather than changing production code

Do not use when:
- the user only asks to understand a project without test design
- the user reports a runtime failure but root cause is still unknown
- the user asks for broad code review and finding ranking
- the task is mainly API/DTO/error contract design
- the task is mainly schema/data migration planning
- the user already confirmed a production-code implementation plan and only needs delivery

Prefer another skill when:
- `codebase-orientation`: the user needs code or business context before testing scope can be defined
- `debug-root-cause`: a failure needs reproduction, evidence, and root cause before test or fix work
- `code-review-triage`: the user wants findings ranked before deciding which behavior to test
- `api-contract-design`: request/response/DTO/error behavior is not yet agreed
- `data-migration-planning`: schema, persisted data, rollout, rollback, or validation SQL is not yet planned
- `software-delivery-pipeline`: production-code implementation is already approved and testing is only one verification step

Follow `docs/workflow-contracts.zh-CN.md` `Execution Mode Contract`; record `executionMode` as `lightweight`, `standard`, or `full` in state and summary.

## Execution Mode Selection

Choose and record `executionMode` as `lightweight`, `standard`, or `full` before creating workflow artifacts. Follow `docs/prompt-modules/lightweight-mode.zh-CN.md` for mode selection, skipped artifacts, and upgrade conditions.

- `lightweight`: one focused test, one failing reproduction, or one quick regression command.
- `standard`: one feature/module test design with approved cases, test implementation, execution evidence, and summary.
- `full`: high-risk release validation, permissions/payment/medical/data/MQ coverage, multi-environment validation, or handoff-driven testing.

Use `standard` as the default slim path. It folds requirement understanding, acceptance criteria, impact analysis, test strategy, data plan, execution evidence, issue records, regression, and summary into the four main test documents. Use `full` only when risk, auditability, resume needs, or the user requires a more expanded trail.

## Prompt Modules

This skill keeps workflow-specific rules here and delegates shared execution discipline to:

- `docs/prompt-modules/test-strategy.zh-CN.md` — test-first, minimal patch, and regression strategy
- `docs/prompt-modules/lightweight-mode.zh-CN.md` — lightweight/standard/full artifact boundary
- `docs/prompt-modules/handoff.zh-CN.md` — upstream and downstream handoff handling
- `docs/prompt-modules/minimal-change.zh-CN.md` — test scope guard and no unrelated edits
- `docs/prompt-modules/verification-gate.zh-CN.md` — completion evidence and blocked verification rules

- `docs/prompt-modules/write-guard.zh-CN.md` — write, delete, install, migration, and environment guards
- `docs/prompt-modules/risk-gate.zh-CN.md` — risk level, confirmation, rollback, and safety gates

## Domain Module: Java / Spring

If `domainModules` contains `java-spring-microservice`, test planning must identify:

- Maven / Gradle module and targeted test command
- Spring Boot test style already used by the project
- JUnit / Mockito / SpringBootTest / MockMvc / MyBatis test patterns
- Controller / Service / Mapper layers covered by each test
- MySQL tables, Redis keys, MQ topics, Nacos keys, Feign clients, and external dependencies touched
- test data setup, cleanup, rollback, or isolated schema strategy
- security context, login scene, patientId/storeId/tenantId/deptId, and permission claims needed by tests
- minimum regression range after production-code changes

For high-risk Java/Spring testing, do not execute environment-mutating integration tests until the user confirms the test data and environment plan.

Load `docs/domain-modules/java-spring-microservice.zh-CN.md` for the full checklist.

## Core Rules

- Follow the `Prompt Modules` section for shared clarification, execution mode, handoff, minimal-change, and verification discipline.
- Testing starts from requirements and acceptance criteria, not from arbitrary assertions.
- Test cases must map to acceptance criteria or documented defects.
- Test cases require human approval before writing broad automated tests or changing production code.
- Default `codeEditsAllowed` is test-code-only after test case approval; production-code edits are not allowed unless the user explicitly approves a TDD implementation/fix path.
- If tests reveal a production-code defect and the fix is not explicitly approved, create `test-to-delivery-handoff.md` for `software-delivery-pipeline`.
- If failures are confusing or root cause is not clear, create `test-to-debug-handoff.md` for `debug-root-cause`.
- Do not change test expectations to match broken behavior without explicit requirement evidence.
- Do not disable, delete, weaken, or bypass failing tests to claim success.
- Do not claim "tests passed" without command, result, scope, and evidence.
- Separate product defects, test bugs, test data issues, environment blockers, external dependency failures, and unclear requirements.
- Default to masked credentials and credential sources. If the user explicitly says the run is personal/local and allows plaintext, full test-environment credentials may be recorded in the environment profile or current test run document, with the credential policy and risk noted. Do not record production credentials, private keys, or real sensitive user data unless the user explicitly requests it for a private local document.
- P0/P1 approved cases cannot be skipped without a recorded blocker and user confirmation.
- Environment validation is required before integration tests that depend on databases, Redis, MQ, config centers, external services, or AI model endpoints.
- Environment safety gate must run before any external connection attempt. Do not connect to MySQL, MongoDB, Redis, MQ, Nacos, Elasticsearch, model endpoints, or third-party services until `00-environment-safety-gate.md` confirms the environment profile, allowed operations, forbidden operations, credential policy, and write boundary.
- All generated workflow documents must be written in Simplified Chinese, except code identifiers, commands, paths, error text, API names, and quoted user text.
- Follow `docs/workflow-contracts.zh-CN.md` `Stop and Confirmation Contract`; when it triggers, update state and stop for human confirmation.
- `workflow-state.json` must strictly match `docs/workflow-state-schema.json`: include `schemaVersion`, `runPath`, `executionMode`, `modePath`, risk and confirmation fields, and `updatedAt`; do not write ad hoc extra fields.
- Use `examples/standard-run.md` as the compact reference for the default standard path.

## Approval and Completion Gates

- Test case gate: after writing `11-test-plan-cases.md`, set status to `pending_human_confirmation`, keep `codeEditsAllowed=false`, and wait for user approval before broad test implementation or environment-mutating integration tests.
- Test baseline: once approved, record baseline version, approval source, approved time, approved case IDs, skipped cases, and manual-only cases in `11-test-plan-cases.md` and state.
- Issue gate: when tests reveal a production defect, record severity, impact, related cases, evidence, likely cause, suggested fix scope, risk, and release blocking status before any production-code edit.
- Fix approval: do not edit production code unless the user explicitly approves the TDD implementation/fix path. Without approval, create `test-to-delivery-handoff.md`; if root cause is unclear, create `test-to-debug-handoff.md`.
- Regression gate: after an approved fix, run the original failing case, adjacent scenarios, current module tests, and all approved cases unless a blocker is recorded and confirmed.
- Completion gate: only mark `completed` when all approved cases ran or have confirmed blockers, P0/P1 cases are not silently skipped, failures are classified, environment/data state is clear, cleanup is handled or documented, and command/result/report evidence is complete. Otherwise mark `blocked` or `handoff_ready`.

## Environment Profiles and Credentials

- Prefer stable environment profiles for repeated test environments: `workflow/env-profiles/<env>.yaml` or `workflow/env-profiles/<env>.md`.
- In each test run, reference the environment profile and record only run-specific overrides in `11-test-plan-cases.md`.
- In `12-test-execution-evidence.md`, record which profile was used, whether credentials were plaintext or masked, and the validation result.
- If plaintext credentials are used, mark `credentialPolicy=plaintext_user_approved`, record the user's approval basis, and avoid copying those credentials into handoff files unless the downstream workflow truly needs them.
- `workflow-state.json` must not store credentials because its schema is workflow state only.
- The first executable step is the environment safety gate. It permits read-only smoke checks such as `SELECT 1`, MongoDB `ping`, Redis `PING`, Nacos read-only config fetch, and HTTP health checks. It must explicitly forbid destructive SQL, bulk writes, collection drops, Redis flushes, production MQ publishes, config mutations, real payments, real SMS, and real user pushes unless the user gives explicit one-off approval for a private local environment.

## Test Engineering Analysis

Every test run must be able to produce this structure across its stage documents or summary:

```md
## Test Engineering Analysis

### 1. 需求与验收标准
- ...

### 2. 影响范围
- 入口：
- 业务链路：
- 数据：
- 外部依赖：

### 3. 测试策略
| 层级 | 覆盖目标 | 选择理由 | 是否自动化 |
| --- | --- | --- | --- |

### 4. 已批准测试用例
| Case ID | 验收标准 | 优先级 | 类型 | 预期 |
| --- | --- | --- | --- | --- |

### 5. 环境与测试数据
- 环境：
- 数据：
- 清理：
- 阻塞项：

### 6. 执行证据
- 命令：
- 结果：
- 报告：
- 失败分类：

### 7. 问题与回归
- 问题：
- 修复确认：
- 回归范围：
- 剩余风险：
```

## Workflow Artifacts

Create the run directory under the current project root.

Project root resolution:
1. Prefer the current workspace's git root: `git rev-parse --show-toplevel`.
2. If not inside a git repository, use the active working directory.
3. Create artifacts at `<project-root>/workflow/tests/<YYYY-MM-DD>-<slug>/`.

Required files:

0. `test-workflow-state.md`
1. `00-environment-safety-gate.md`
2. `10-test-scope-criteria.md`
3. `11-test-plan-cases.md`
4. `12-test-execution-evidence.md`
5. `13-test-summary.md`
6. `test-to-delivery-handoff.md` (optional, when production-code fix is needed)
7. `test-to-debug-handoff.md` (optional, when root cause is unclear)
8. `workflow-state.json`

Use the templates in `assets/test-templates/`.

After each stage document is written or updated, update `test-workflow-state.md` and `workflow-state.json` with current stage, status, latest document, next action, blockers, and whether code edits are allowed. If `workflow/index.md` exists in the project root, update the run entry as well.

## Default Slim Flow

### Stage 0 — Environment Safety Gate

Goal: prevent unsafe external operations before any environment connection.

Actions:
- read or create the referenced environment profile
- classify the environment as local, test, staging, or production
- record connection targets for MySQL, MongoDB, Redis, MQ, Nacos, Elasticsearch, external APIs, and model endpoints when used
- record credential policy, including whether plaintext credentials are user-approved
- list allowed smoke checks and forbidden operations per service
- write `00-environment-safety-gate.md`
- block environment validation and test execution if the profile is missing, the environment looks production-like, write boundaries are unclear, or any destructive operation is requested without explicit one-off approval

### Stage 1 — Scope and Criteria

Goal: identify the tested behavior and acceptance criteria.

Actions:
- read requirements, design docs, diffs, code, existing tests, contracts, and upstream handoff when present
- define in-scope and out-of-scope behavior
- write `10-test-scope-criteria.md`
- stop for clarification if expected behavior is unclear

### Stage 2 — Test Plan and Cases

Goal: turn acceptance criteria into approved test cases.

Actions:
- analyze direct and indirect impact
- choose test layers and regression range
- define test data, environment needs, and cleanup strategy
- write `11-test-plan-cases.md`
- wait for test case approval before broad test implementation or environment-mutating tests

### Stage 3 — Execution Evidence

Goal: implement and run approved tests with traceable evidence.

Actions:
- validate environment and dependencies before integration tests
- implement approved tests using project patterns
- run the narrowest meaningful command first, then expand regression
- classify failures and blockers
- write `12-test-execution-evidence.md`

### Stage 4 — Summary and Handoff

Goal: state what passed, what failed, and what should happen next.

Actions:
- write `13-test-summary.md`
- include tested scope, commands, results, issues, blockers, cleanup, and release recommendation
- if production fix is needed, write `test-to-delivery-handoff.md`
- if root cause is unclear, write `test-to-debug-handoff.md`

## Handoff Rules

- `test-to-delivery-handoff.md` must include approved failing tests, affected behavior, evidence, allowed fix scope, forbidden scope, and required regression.
- `test-to-debug-handoff.md` must include symptoms, commands, failures, environment/data evidence, rejected explanations, and questions for root-cause analysis.
- Handoffs provide source of truth, not direct approval for downstream code edits.
- Downstream workflows must not process excluded scope or unapproved test expectations.

## References

Read when doing actual test engineering:
- `references/test-engineering-guidelines.md` — test lifecycle, safety rules, TDD execution, evidence, and completion gates
- `references/test-document-contracts.md` — required artifact shape and slim/full boundaries
