---
workflow: tdd-test-engineering
runId: <YYYYMMDD-slug>
runPath: workflow/tests/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: handoff
status: handoff_ready
source: workflow-handoff
allowsCodeEdit: false
nextAction: start_target_workflow
fromWorkflow: tdd-test-engineering
toWorkflow: software-delivery-pipeline
selectedItems: []
verificationRequired: true
---
# 测试工程到交付流程交接单

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- 来源文档：
- 文档状态：

## 来源 Test Run
- 路径：`workflow/tests/<YYYY-MM-DD>-<slug>/`

## Accepted Scope
-

## Excluded Scope
-

## Evidence
-

## Constraints
-

## Unresolved Questions
-

## Verification Focus
-

## Source of Truth Artifacts
- `10-test-scope-criteria.md`
- `11-test-plan-cases.md`
- `12-test-execution-evidence.md`
- `13-test-summary.md`

## Recommended Next Workflow
- `software-delivery-pipeline`

## Why Next Workflow Is Appropriate
-

## Downstream Execution Hint
- 建议下游执行模式：`standard`
- `handoff_approval_basis_allowed`: false
- 说明：本 handoff 提供测试证据与修复范围，不直接构成下游开始修改生产代码的批准依据。

## 已批准失败测试
-

## 建议修复范围
-

## 禁止范围
-

## 必须回归
-

## 机器可读摘要

```yaml
source_run_path: "workflow/tests/<YYYY-MM-DD>-<slug>"
source_workflow: "tdd-test-engineering"
target_workflow: "software-delivery-pipeline"
accepted_scope: []
excluded_scope: []
constraints: []
unresolved_questions: []
verification_focus: []
source_of_truth_artifacts:
  - "10-test-scope-criteria.md"
  - "11-test-plan-cases.md"
  - "12-test-execution-evidence.md"
  - "13-test-summary.md"
recommended_next_workflow: "software-delivery-pipeline"
target_execution_hint: "standard"
handoff_approval_basis_allowed: false
approved_failing_tests: []
fix_scope: []
forbidden_scope: []
required_regression: []
```
