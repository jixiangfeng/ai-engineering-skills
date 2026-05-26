---
workflow: api-contract-design
runId: <YYYYMMDD-slug>
runPath: workflow/api-contracts/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: state
status: in_progress
source: user-request
allowsCodeEdit: false
nextAction: continue_current_stage
---
# API Contract Workflow State

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
- 风险等级：low | medium | high
- 风险原因：
- 是否需要用户确认：是 / 否
- 是否需要回滚方案：是 / 否
- 下一步动作：
- 阻塞项：

## 机器可读状态
- 同步文件：`workflow-state.json`
- Schema：`docs/workflow-state-schema.json`
- 更新要求：每次阶段文档更新后同步 `currentStage`、`status`、`latestDocument`、`nextAction`、`blockers`、`domainModules`、`affectedServices`、`codeEditsAllowed`、`riskLevel`、`riskReason`、`confirmationRequired`、`rollbackRequired`、`updatedAt`
- 索引更新：如果项目根目录存在 `workflow/index.md`，同步当前 run 条目

## 阶段状态
| 阶段 | 文档 | 状态 | 确认记录 |
| --- | --- | --- | --- |
| scope | `01-api-contract-scope.md` | pending / approved / skipped |  |
| current_contract | `02-api-current-contract.md` | pending / approved / skipped |  |
| proposed_contract | `03-api-proposed-contract.md` | pending / approved / skipped |  |
| compatibility | `04-api-compatibility.md` | pending / approved / skipped |  |
| validation_and_errors | `05-api-validation-errors.md` | pending / approved / skipped |  |
| examples | `06-api-examples.md` | pending / approved / skipped |  |
| summary | `07-api-summary.md` | pending / done |  |
| handoff | `api-to-delivery-handoff.md` | optional / pending / done |  |

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
