---
workflow: software-delivery-pipeline
runId: <YYYYMMDD-slug>
runPath: workflow/runs/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: state
status: in_progress
source: user-request
allowsCodeEdit: false
nextAction: continue_current_stage
---
# Workflow State

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- Run 目录：

## Execution Mode
- executionMode：lightweight | standard | full
- mode path：fast | guarded | audited
- 模式选择理由：
- 本模式产物：
- 本模式跳过的产物：

## Mode Artifact Plan
| 模式 | 必需产物 | 跳过产物 | 升级条件 |
| --- | --- | --- | --- |
| fast | `workflow-state.json` + `00-fast-patch-summary.md` / concise note | 完整 01-08 阶段文档 | 发现契约、数据、权限、跨模块或验证阻塞 |
| guarded | `10-guarded-scope-plan.md` + `11-guarded-execution.md` + `12-guarded-summary.md` | 未触发的 architecture / change review / debugging | 风险升高或需要 handoff / 审计 |
| audited | `20-audited-run-map.md` + 完整门禁链路 | 无风险触发项可写 skipped reason | 不降级，除非用户明确重置 scope |

## 当前状态
- 阶段：
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
- 更新要求：每次阶段文档更新后同步 `currentStage`、`status`、`latestDocument`、`nextAction`、`blockers`、`selectedScope`、`domainModules`、`affectedServices`、`affectedControllers`、`affectedTables`、`affectedCollections`、`affectedTopics`、`affectedConfigKeys`、`codeEditsAllowed`、`riskLevel`、`riskReason`、`confirmationRequired`、`rollbackRequired`、`updatedAt`
- 索引更新：如果项目根目录存在 `workflow/index.md`，同步当前 run 条目

## 阶段状态
| 阶段 | 文档 | 状态 | 确认记录 |
| --- | --- | --- | --- |
| scope + plan | `10-guarded-scope-plan.md` / `01-delivery-requirements.md` + plan doc | pending / approved / skipped |  |
| architecture | `02-delivery-architecture.md` | pending / approved / skipped |  |
| execution | `11-guarded-execution.md` / implementation + verification reports | not_allowed / allowed / done / blocked |  |
| delivery | `00-fast-patch-summary.md` / `12-guarded-summary.md` / delivery report | pending / done |  |

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
