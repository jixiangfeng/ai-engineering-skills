---
workflow: data-migration-planning
runId: <YYYYMMDD-slug>
runPath: workflow/data-migrations/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: handoff
status: handoff_ready
source: workflow-handoff
allowsCodeEdit: false
nextAction: start_target_workflow
fromWorkflow: data-migration-planning
toWorkflow: software-delivery-pipeline
selectedItems: []
verificationRequired: true
---
# 数据迁移到交付流程交接单

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- 来源文档：
- 文档状态：

## 来源 Migration Run
- 路径：`workflow/data-migrations/<YYYY-MM-DD>-<slug>/`

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
- `10-migration-scope-current.md`
- `11-migration-target-plan.md`
- `12-migration-rollback-validation.md`
- `13-migration-summary.md`

## Recommended Next Workflow
- `software-delivery-pipeline`

## Why Next Workflow Is Appropriate
-
## Downstream Execution Hint
- 建议下游执行模式：`full`
- `handoff_approval_basis_allowed`: false
- 说明：本 handoff 提供 source of truth，但不直接构成下游开始实现的批准依据。


## 已确认迁移方案
-

## 回滚 / 恢复策略
-

## Worktree Recommendation

当前任务建议使用独立 worktree：yes | no

原因：
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
- 不得执行未确认的破坏性数据操作。

## 机器可读摘要

```yaml
source_run_path: "workflow/data-migrations/<YYYY-MM-DD>-<slug>"
source_workflow: "data-migration-planning"
target_workflow: "software-delivery-pipeline"
accepted_scope: []
excluded_scope: []
constraints: []
unresolved_questions: []
verification_focus: []
source_of_truth_artifacts:
  - "10-migration-scope-current.md"
  - "11-migration-target-plan.md"
  - "12-migration-rollback-validation.md"
  - "13-migration-summary.md"
recommended_next_workflow: "software-delivery-pipeline"
target_execution_hint: "full"
handoff_approval_basis_allowed: false
```
