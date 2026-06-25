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
toWorkflow: debug-root-cause
selectedItems: []
verificationRequired: true
---
# 测试工程到根因排查交接单

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
- `debug-root-cause`

## Why Next Workflow Is Appropriate
-

## Downstream Execution Hint
- 建议下游执行模式：`standard`
- `handoff_approval_basis_allowed`: false
- 说明：本 handoff 提供失败证据与复现入口，不直接构成下游开始修改代码的批准依据。

## 失败现象
-

## 已执行命令
-

## 已排除方向
-

## 需要排查的问题
-

## 机器可读摘要

```yaml
source_run_path: "workflow/tests/<YYYY-MM-DD>-<slug>"
source_workflow: "tdd-test-engineering"
target_workflow: "debug-root-cause"
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
recommended_next_workflow: "debug-root-cause"
target_execution_hint: "standard"
handoff_approval_basis_allowed: false
failure_symptoms: []
executed_commands: []
rejected_explanations: []
debug_questions: []
```
