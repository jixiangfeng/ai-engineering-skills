---
workflow: codebase-orientation
runId: <YYYYMMDD-slug>
runPath: workflow/orientation/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: state
status: in_progress
source: user-request
allowsCodeEdit: false
nextAction: continue_current_stage
---
# Orientation Workflow State

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- Run 目录：

## Execution Mode
- executionMode：lightweight | standard | full
- 模式选择理由：
- 本模式产物：
- 本模式跳过的产物：

## 当前状态
- 当前阶段：
- 当前状态：pending | in_progress | pending_confirmation | completed | blocked
- 是否允许改代码：否
- 下一步动作：
- 阻塞项：

## 机器可读状态
- 同步文件：`workflow-state.json`
- Schema：`docs/workflow-state-schema.json`
- 更新要求：每次阶段文档更新后同步 `currentStage`、`status`、`latestDocument`、`nextAction`、`blockers`、`codeEditsAllowed`、`updatedAt`
- 索引更新：如果项目根目录存在 `workflow/index.md`，同步当前 run 条目

## 阶段状态
| 阶段 | 文档 | 状态 | 确认记录 |
| --- | --- | --- | --- |
| scope | `01-orientation-scope.md` | pending / approved / skipped |  |
| project_map | `02-orientation-project-map.md` | pending / approved / skipped |  |
| business_flow | `03-orientation-business-flow.md` | pending / approved / skipped |  |
| technical_flow | `04-orientation-technical-flow.md` | pending / approved / skipped |  |
| data_contracts | `05-orientation-data-contracts.md` | pending / approved / skipped |  |
| open_questions | `06-orientation-open-questions.md` | pending / approved / skipped |  |
| summary | `07-orientation-summary.md` | pending / done |  |
| handoff_to_review | `orientation-to-review-handoff.md` | optional / pending / done |  |
| handoff_to_delivery | `orientation-to-delivery-handoff.md` | optional / pending / done |  |

## Preflight 记录
- cwd：
- git root：
- worktree 状态摘要：
- 当前 run 目录：
- 上一阶段文档：
- 写代码许可：否

## Resume 记录
| 时间 | 恢复时读取的文档 | git diff 摘要 | 恢复结论 |
| --- | --- | --- | --- |
|  |  |  |  |
