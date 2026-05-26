# Workflow State

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- Run 目录：

## 当前状态
- 阶段：
- 是否允许改代码：否
- 下一步动作：
- 阻塞项：

## 机器可读状态
- 同步文件：`workflow-state.json`
- Schema：`docs/workflow-state-schema.json`
- 更新要求：每次阶段文档更新后同步 `currentStage`、`status`、`latestDocument`、`nextAction`、`blockers`、`selectedScope`、`codeEditsAllowed`、`updatedAt`
- 索引更新：如果项目根目录存在 `workflow/index.md`，同步当前 run 条目

## 阶段状态
| 阶段 | 文档 | 状态 | 确认记录 |
| --- | --- | --- | --- |
| requirements | `01-delivery-requirements.md` | pending / approved / skipped |  |
| architecture | `02-delivery-architecture.md` | pending / approved / skipped |  |
| plan | `02-delivery-plan.md` / `03-delivery-plan.md` | pending / approved / skipped |  |
| implementation | implementation report | not_allowed / allowed / done |  |
| verification | verification report | pending / done / blocked |  |
| delivery | delivery report | pending / done |  |

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
