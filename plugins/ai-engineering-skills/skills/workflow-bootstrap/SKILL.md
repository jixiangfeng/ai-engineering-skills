---
name: workflow-bootstrap
description: >-
  Route software-engineering tasks into the correct workflow skill before acting.
  Use when a user asks to understand a codebase, review code, debug a failure,
  design an API contract, plan a data migration, or implement a feature/fix.
---

# Workflow Bootstrap

Use this skill at the start of software engineering tasks to choose the correct workflow before taking action.

## Usage Boundary

Use when:
- the user asks to understand, review, debug, design, migrate, implement, or resume software engineering work
- the correct workflow is not yet explicit
- a handoff or prior run needs routing to the next workflow

Do not use when:
- the user asks a simple conceptual question that can be answered directly
- the user already explicitly invoked a specific workflow skill and no routing choice is needed
- the task is unrelated to software engineering workflows

Prefer another skill when:
- `debug-root-cause`: there is a concrete failure, error, regression, or bad runtime behavior
- `api-contract-design`: the main decision is endpoint, DTO, response shape, validation, or error contract
- `data-migration-planning`: the task changes schema, persisted data, migrations, cleanup scripts, or backfills
- `code-review-triage`: the user asks to review or find issues before implementation
- `codebase-orientation`: the user asks to become familiar with code before judging or changing it
- `software-delivery-pipeline`: requirements and scope are already implementation-ready

## Core Purpose

This skill is the routing layer for the AI Engineering Skills workflow set.

It helps decide whether the task should begin with:

- `codebase-orientation`
- `code-review-triage`
- `debug-root-cause`
- `api-contract-design`
- `data-migration-planning`
- `software-delivery-pipeline`


## Execution Mode Selection

Choose and record `executionMode` as `lightweight`, `standard`, or `full` before creating workflow artifacts. Follow `docs/prompt-modules/lightweight-mode.zh-CN.md` for selection rules, produced/skipped artifacts, and upgrade conditions.

## Prompt Modules

This skill keeps workflow-specific rules here and delegates shared execution discipline to:

- `docs/prompt-modules/clarification.zh-CN.md` — 需求澄清、任务大小判断和路由假设
- `docs/prompt-modules/lightweight-mode.zh-CN.md` — executionMode 选择和轻量产物边界
- `docs/prompt-modules/handoff.zh-CN.md` — 已有 run / handoff 的恢复和流转判断
- `docs/prompt-modules/minimal-change.zh-CN.md` — 路由阶段不扩大 scope、不引入无关变更
- `docs/prompt-modules/verification-gate.zh-CN.md` — 路由结果和停止条件的 Verification

- `docs/prompt-modules/write-guard.zh-CN.md` — 写入、删除、覆盖、安装和迁移门禁
- `docs/prompt-modules/risk-gate.zh-CN.md` — low/medium/high 风险等级、确认和回滚要求

## Domain Module Routing

When a task involves Java / Spring Boot / Spring Cloud / MyBatis / Mongo / Redis / MQ / Nacos / XXL-JOB / Feign / Spring Security:

1. Do not create a new workflow.
2. Choose the main workflow with the normal routing rules.
3. Also load `docs/domain-modules/java-spring-microservice.zh-CN.md`.
4. Record `domainModules: [java-spring-microservice]` in workflow state when a workflow run is created.

## Core Rules

- Follow the `Prompt Modules` section for shared clarification, execution mode, handoff, minimal-change, and verification discipline.

- Apply the shared engineering principles before routing: clarify assumptions, prefer simple scope, avoid unrelated changes, and require verifiable completion criteria.
- If the task clearly matches one of the workflow skills, route to that workflow before acting.
- Do not jump directly into code edits when a design, review, debugging, or orientation workflow should happen first.
- Prefer the narrowest correct workflow.
- Simple conceptual Q&A does not require a workflow run.
- If the task is both ambiguous and risky, ask one concise blocking question after identifying the most likely workflow.
- If the user provides an existing workflow artifact path or asks to continue a prior run, prefer continuing that workflow rather than starting a new routing decision.
- If the user provides a handoff artifact, treat the handoff as higher priority than generic re-routing.
- Follow `docs/workflow-contracts.zh-CN.md` `Handoff Flow Contract` when deciding downstream workflow from a handoff.
- Do not create a new parallel workflow when a single existing run can be resumed safely.

## Clarification Rules

Before choosing a workflow, decide whether the request is small, medium, or large:

- Small: make reasonable assumptions, state them explicitly, and route directly.
- Medium: ask at most 1-3 key questions only when they affect scope, target behavior, acceptance criteria, or risk.
- Large: first produce a `需求澄清` section covering confirmed goals, unclear points, default assumptions, and recommended workflow.

Use this structure when clarification is needed:

```md
## 需求澄清

### 已明确
- ...

### 仍不明确
- ...

### 本次默认假设
- ...

### 推荐进入的 workflow
- ...
```

If missing information would change routing, scope, data/API behavior, verification, or rollback, stop and ask for confirmation instead of guessing.

## Routing Priority

First decide whether the user is asking for a workflow action or only asking a question:

- Open a workflow only when the user asks to modify, debug, review, design, migrate, orient, implement, or continue a confirmed workflow/handoff.
- Do not open a workflow for concept explanation, status lookup, comparison, summary, or lightweight recommendation unless the user explicitly asks to execute repository work.
- Negative Q&A intent must not override explicit action intent. For example, “排查这个报错” enters `debug-root-cause`; “这个报错是什么意思” can be answered directly.

When multiple workflows could apply and the user has not already made the sequence explicit, prefer this order:

1. `code-review-triage` when the wording is review-first, such as “review 后修复”, “先 review 再改”, or “审查后修复”.
2. `debug-root-cause` for failures, exceptions, startup issues, broken tests, regressions, or root-cause work.
3. `api-contract-design` for interface, DTO/VO, field placement, response shape, validation, or compatibility contracts.
4. `data-migration-planning` for schema, stored data, backfill, cleanup, compatibility, rollout, or rollback.
5. `software-delivery-pipeline` for implementation-ready work or an explicitly confirmed handoff.
6. `codebase-orientation` for project/module understanding, call paths, maps, and read-only familiarization.

Use the more specific workflow before the more general one.

## Routing Guide

Before choosing a workflow, identify:
- confirmed user intent
- assumptions or ambiguity that could change the route
- whether the task is read-only, design-only, debug-first, review-first, migration-related, or implementation-ready
- the expected verification signal if the task reaches delivery

### Route to `codebase-orientation` when the user asks to:
- 熟悉项目
- 看懂模块
- 梳理调用链
- 分析业务流程
- 先了解再说

### Route to `code-review-triage` when the user asks to:
- review 代码
- 找问题
- 审查模块
- 评估风险
- 列出需要修复的问题

### Route to `debug-root-cause` when the user asks to:
- 排查报错
- 看失败测试
- 分析启动失败
- 解释异常行为
- 找根因

### Route to `api-contract-design` when the user asks to:
- 设计接口
- 设计 DTO / VO / 请求响应
- 梳理错误码
- 讨论字段语义或兼容性
- 明确前后端契约

### Route to `data-migration-planning` when the user asks to:
- 改表结构
- 做数据迁移
- 回填数据
- 清理旧字段
- 设计回滚/恢复方案

### Route to `software-delivery-pipeline` when the user asks to:
- 实现功能
- 修复 bug
- 按 handoff 落地
- 完成开发并验证交付

## Conflict Resolution

Use these rules when the task could fit more than one workflow:

- If the user mentions a failure, exception, or broken behavior, start with `debug-root-cause` before implementation.
- If the user wants to change an API shape or data contract, start with `api-contract-design` before implementation.
- If the user wants to change schema or stored data behavior, start with `data-migration-planning` before implementation.
- If the user asks to “review and then fix”, “review 后修复”, or “先 review 再改”, start with `code-review-triage`; only enter delivery after accepted scope is confirmed.
- If the user asks to “先熟悉一下”, start with `codebase-orientation`.
- If the task is already well-defined implementation work with no missing design/debugging/review gate, use `software-delivery-pipeline`.

## Existing Run / Handoff Priority

Apply these rules before ordinary routing:

1. If the user gives a concrete workflow artifact path, continue that workflow first.
2. If the user gives a handoff file such as review/debug/api/migration handoff, continue in the downstream workflow expected by that handoff.
3. If the user says “继续”, “按这个修”, “接着上次”, or equivalent and a clearly relevant prior workflow run is already in play, prefer resuming that run over opening a new one.
4. Only open a new workflow when no safe, relevant prior run or handoff exists.

## When Not to Open a Workflow

Do not open a workflow run when the user is only asking for:
- a simple conceptual explanation
- a terminology question
- a lightweight comparison or recommendation that does not require repository work
- a status confirmation about an already-finished workflow artifact

In those cases, answer directly unless the user explicitly asks to start or continue a workflow.

## Routing Output Contract

After routing:
- state which workflow is being used and why
- include a short `Verification` note for the routing decision: checked intent, chosen workflow, unresolved ambiguity, and completion judgment
- if continuing an existing run, say so explicitly
- if using a handoff, mention that the handoff is the source of truth
- proceed into that workflow
- do not create duplicate parallel workflows for the same request unless the user explicitly asks

The routing response should be short and decisive, not a long meta-discussion.

## Recommended Language

A concise routing message is enough, for example:

- “这个任务先走 `debug-root-cause`，因为当前目标是先定位失败根因，再决定修复方案。”
- “这个任务先走 `api-contract-design`，先把契约定稳，再进入实现。”
- “这个任务已经是明确实现范围，直接进入 `software-delivery-pipeline`。”

## References

- `docs/engineering-principles.zh-CN.md` — shared engineering behavior guardrails for all workflows
