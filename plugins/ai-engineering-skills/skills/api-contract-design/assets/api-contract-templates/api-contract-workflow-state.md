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
# api-contract-workflow-state

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- Workflow：`api-contract-design`
- Run 目录：

## Execution Mode
- executionMode：lightweight | standard | full
- 模式选择理由：
- 本模式产物：`10-api-contract-scope.md`、`11-api-current-proposed.md`、`12-api-rules-examples.md`、`13-api-summary.md`
- 本模式跳过的产物：未触发的 `02~07` 细分文档

## 当前状态
- 当前阶段：scope | current_proposed | rules_examples | summary
- 当前状态：not_started | in_progress | blocked | pending_human_confirmation | handoff_ready | completed | abandoned
- 最新阶段文档：
- 是否允许改代码：否
- 风险等级：low | medium | high
- 风险原因：
- 是否需要用户确认：是 / 否
- 是否需要回滚方案：否
- 下一步动作：
- 阻塞项：
- 当前确认范围：

## 机器可读状态
- 同步文件：`workflow-state.json`
- Schema：`docs/workflow-state-schema.json`
- 索引更新：如果项目根目录存在 `workflow/index.md`，同步当前 run 条目

## 阶段状态
| 阶段 | 文档 | 状态 | 确认记录 |
| --- | --- | --- | --- |
| scope | `10-api-contract-scope.md` | pending / approved / skipped / done / blocked |  |
| current_proposed | `11-api-current-proposed.md` | pending / approved / skipped / done / blocked |  |
| rules_examples | `12-api-rules-examples.md` | pending / approved / skipped / done / blocked |  |
| summary | `13-api-summary.md` | pending / approved / skipped / done / blocked |  |
