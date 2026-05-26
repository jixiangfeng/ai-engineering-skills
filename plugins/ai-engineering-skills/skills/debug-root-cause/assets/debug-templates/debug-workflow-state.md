# Debug Workflow State

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- Run 目录：

## 当前状态
- 当前阶段：
- 当前状态：pending | in_progress | pending_confirmation | completed | blocked
- 复现状态：not_started | reproduced | blocked | not_reproducible_yet
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
| scope | `01-debug-scope.md` | pending / approved / skipped |  |
| reproduction | `02-debug-reproduction.md` | pending / approved / skipped |  |
| evidence | `03-debug-evidence.md` | pending / approved / skipped |  |
| hypotheses | `04-debug-hypotheses.md` | pending / approved / skipped |  |
| root_cause | `05-debug-root-cause.md` | pending / approved / skipped |  |
| fix_options | `06-debug-fix-options.md` | pending / approved / skipped |  |
| verification_plan | `07-debug-verification-plan.md` | pending / approved / skipped |  |
| summary | `08-debug-summary.md` | pending / done |  |
| handoff | `debug-to-delivery-handoff.md` | optional / pending / done |  |

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
