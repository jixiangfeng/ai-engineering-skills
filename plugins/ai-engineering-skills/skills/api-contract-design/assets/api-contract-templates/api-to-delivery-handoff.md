---
workflow: api-contract-design
runId: <YYYYMMDD-slug>
runPath: workflow/api-contracts/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: handoff
status: handoff_ready
source: workflow-handoff
allowsCodeEdit: false
nextAction: start_target_workflow
fromWorkflow: api-contract-design
toWorkflow: software-delivery-pipeline
selectedItems: []
verificationRequired: true
---
# API 契约到交付流程交接单

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- 来源文档：
- 文档状态：

## 来源 API Contract Run
- 路径：`workflow/api-contracts/<YYYY-MM-DD>-<slug>/`

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
- `10-api-contract-scope.md`
- `11-api-current-proposed.md`
- `12-api-rules-examples.md`
- `13-api-summary.md`

## Recommended Next Workflow
- `software-delivery-pipeline`

## Why Next Workflow Is Appropriate
-
## Downstream Execution Hint
- 建议下游执行模式：`full`
- `handoff_approval_basis_allowed`: false
- 说明：本 handoff 提供 source of truth，但不直接构成下游开始实现的批准依据。


## 已确认契约
-

## 范围锁定
- 允许修改 / 关注的目录或文件：
- 禁止修改 / 不关注的目录或文件：
- 允许改变的行为：
- 不允许改变的行为：
- 超出范围时的处理：暂停并请求用户确认。

## 验证矩阵
| 验收项 | 验证方式 | 命令或步骤 | 结果 | 证据 | 未覆盖原因 |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |

## 禁止事项
- 不得改变未确认的请求/响应字段。

## 机器可读摘要

```yaml
source_run_path: "workflow/api-contracts/<YYYY-MM-DD>-<slug>"
source_workflow: "api-contract-design"
target_workflow: "software-delivery-pipeline"
accepted_scope: []
excluded_scope: []
constraints: []
unresolved_questions: []
verification_focus: []
source_of_truth_artifacts:
  - "10-api-contract-scope.md"
  - "11-api-current-proposed.md"
  - "12-api-rules-examples.md"
  - "13-api-summary.md"
recommended_next_workflow: "software-delivery-pipeline"
target_execution_hint: "full"
handoff_approval_basis_allowed: false
```
