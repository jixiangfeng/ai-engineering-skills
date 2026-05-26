---
workflow: code-review-triage
runId: <YYYYMMDD-slug>
runPath: workflow/reviews/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: handoff
status: handoff_ready
source: workflow-handoff
allowsCodeEdit: false
nextAction: start_target_workflow
fromWorkflow: code-review-triage
toWorkflow: software-delivery-pipeline
selectedItems: []
verificationRequired: true
---
# Review 修复结果回写

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- 来源文档：
- 文档状态：

## 来源 Review Run
- 路径：`workflow/reviews/<YYYY-MM-DD>-<slug>/`

## 来源 Delivery Run
- 路径：`workflow/runs/<YYYY-MM-DD>-<slug>/`

## Finding 状态

### F-001
- 状态：已修复 | 验证通过 | 验证阻塞 | 未修复 | 延期
- 证据：
- 备注：

## 已修复 Findings
-

## 未修复 Findings
-

## 验证摘要
-

## 剩余风险
-

## 验证矩阵
| 验收项 / Finding | 验证方式 | 命令或步骤 | 结果 | 证据 | 未覆盖原因 |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
|  | `path/to/file:line` | 事实 / 推断 / 待确认 | 高 / 中 / 低 |  |

## 用户验收
- 待用户确认是否接受交付结果，或提出后续修改。
