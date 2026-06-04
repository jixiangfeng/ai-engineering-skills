---
workflow: codebase-orientation
runId: <YYYYMMDD-slug>
runPath: workflow/orientation/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: handoff
status: handoff_ready
source: workflow-handoff
allowsCodeEdit: false
nextAction: start_target_workflow
fromWorkflow: codebase-orientation
toWorkflow: code-review-triage
selectedItems: []
verificationRequired: true
---
# 熟悉结果到 Review 交接单

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- 来源文档：
- 文档状态：

## 来源 Orientation Run
- 路径：`workflow/orientation/<YYYY-MM-DD>-<slug>/`

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
- `10-orientation-scope.md`
- `11-orientation-map.md`
- `12-orientation-summary.md`

## Recommended Next Workflow
- `code-review-triage`

## Why Next Workflow Is Appropriate
-
## Downstream Execution Hint
- 建议下游执行模式：`standard`
- `handoff_approval_basis_allowed`: false
- 说明：本 handoff 提供 source of truth，但不直接构成下游开始实现的批准依据。


## 后续可 review 的线索
-

## 关键上下文
-

## 不应扩大范围
-

## 待确认
-

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
|  | `path/to/file:line` | 事实 / 推断 / 待确认 | 高 / 中 / 低 |  |

## 决策记录
| 决策项 | 选择 | 不选方案 | 原因 | 确认记录 |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

## 范围锁定
- 允许修改 / 关注的目录或文件：
- 禁止修改 / 不关注的目录或文件：
- 允许改变的行为：
- 不允许改变的行为：
- 超出范围时的处理：暂停并请求用户确认。

## 机器可读摘要

```yaml
source_run_path: "workflow/orientation/<YYYY-MM-DD>-<slug>"
source_workflow: "codebase-orientation"
target_workflow: "code-review-triage"
accepted_scope: []
excluded_scope: []
constraints: []
unresolved_questions: []
verification_focus: []
source_of_truth_artifacts:
  - "10-orientation-scope.md"
  - "11-orientation-map.md"
  - "12-orientation-summary.md"
recommended_next_workflow: "code-review-triage"
target_execution_hint: "standard"
handoff_approval_basis_allowed: false
```
