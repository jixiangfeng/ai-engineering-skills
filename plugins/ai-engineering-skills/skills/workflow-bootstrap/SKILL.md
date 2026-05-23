---
name: workflow-bootstrap
description: >-
  Route software-engineering tasks into the correct workflow skill before acting.
  Use when a user asks to understand a codebase, review code, debug a failure,
  design an API contract, plan a data migration, or implement a feature/fix.
---

# Workflow Bootstrap

Use this skill at the start of software engineering tasks to choose the correct workflow before taking action.

## Core Purpose

This skill is the routing layer for the AI Engineering Skills workflow set.

It helps decide whether the task should begin with:

- `codebase-orientation`
- `code-review-triage`
- `debug-root-cause`
- `api-contract-design`
- `data-migration-planning`
- `software-delivery-pipeline`

## Core Rules

- If the task clearly matches one of the workflow skills, route to that workflow before acting.
- Do not jump directly into code edits when a design, review, debugging, or orientation workflow should happen first.
- Prefer the narrowest correct workflow.
- Simple conceptual Q&A does not require a workflow run.
- If the task is both ambiguous and risky, ask one concise blocking question after identifying the most likely workflow.
- If the user provides an existing workflow artifact path or asks to continue a prior run, prefer continuing that workflow rather than starting a new routing decision.
- If the user provides a handoff artifact, treat the handoff as higher priority than generic re-routing.
- Do not create a new parallel workflow when a single existing run can be resumed safely.

## Routing Priority

When multiple workflows could apply and the user has not already made the sequence explicit, prefer this order:

1. `debug-root-cause`
2. `api-contract-design`
3. `data-migration-planning`
4. `code-review-triage`
5. `codebase-orientation`
6. `software-delivery-pipeline`

Use the more specific workflow before the more general one.

## Routing Guide

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
- If the user asks to “review and then fix”, start with `code-review-triage`.
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
- if continuing an existing run, say so explicitly
- if using a handoff, mention that the handoff is the source of truth
- proceed into that workflow
- do not create duplicate parallel workflows for the same request unless the user explicitly asks

The routing response should be short and decisive, not a long meta-discussion.

## Output Behavior

After routing:
- state which workflow is being used and why
- proceed into that workflow
- do not create duplicate parallel workflows for the same request unless the user explicitly asks

## Recommended Language

A concise routing message is enough, for example:

- “这个任务先走 `debug-root-cause`，因为当前目标是先定位失败根因，再决定修复方案。”
- “这个任务先走 `api-contract-design`，先把契约定稳，再进入实现。”
- “这个任务已经是明确实现范围，直接进入 `software-delivery-pipeline`。”
