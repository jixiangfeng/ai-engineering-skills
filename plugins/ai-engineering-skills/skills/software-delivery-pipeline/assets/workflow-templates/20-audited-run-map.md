---
workflow: software-delivery-pipeline
runId: <YYYYMMDD-slug>
runPath: workflow/runs/<YYYY-MM-DD>-<slug>
executionMode: full
stage: run-map
status: draft
source: user-request
allowsCodeEdit: false
nextAction: confirm_audited_path
---
# Audited Run Map

## Audited Trigger
| 触发项 | 是否触发 | 证据 / 原因 |
| --- | --- | --- |
| review handoff | 是 / 否 |  |
| API / DTO / 数据契约变更 | 是 / 否 |  |
| migration / 字段删除 / 历史数据 | 是 / 否 |  |
| 权限 / 安全 / 资金 / 医疗健康建议 | 是 / 否 |  |
| 跨服务 / MQ / 调度 / 并发一致性 | 是 / 否 |  |
| 用户要求完整审计 / 可恢复 | 是 / 否 |  |

## Source Of Truth
- handoff：
- 用户确认：
- 上游文档：

## Risk Gate
- riskLevel：medium / high
- rollbackRequired：是 / 否
- verificationRequired：是
- confirmationRequired：是

## Gate Map
| Gate | 文档 | 状态 | skipped reason / confirmation |
| --- | --- | --- | --- |
| Requirements | `01-delivery-requirements.md` | pending / approved |  |
| Architecture | `02-delivery-architecture.md` | required / skipped |  |
| Plan | `02-delivery-plan.md` / `03-delivery-plan.md` | pending / approved |  |
| Implementation | `03-delivery-implementation.md` / `04-delivery-implementation.md` | not_started / done |  |
| Change Review | `05-delivery-change-review.md` | required / skipped |  |
| Debugging | `04-delivery-debugging.md` / `06-delivery-debugging.md` | required / skipped |  |
| Verification | `05-delivery-verification.md` / `07-delivery-verification.md` | pending / done / blocked |  |
| Summary | `06-delivery-summary.md` / `08-delivery-summary.md` | pending / done |  |

## Verification Matrix Rule
- 每个 selected finding / 验收项都必须映射到验证命令、结果和证据。
- 未覆盖项必须写未覆盖原因，并标记为 blocked 或 needs-user-confirmation。

## Skipped Reason Rule
- Architecture / Change Review / Debugging 如未生成对应文档，必须在 run map 或相邻阶段写 skipped reason。
- 如果 skipped reason 不能被证据支撑，暂停并请求用户确认。

## Downgrade Rule
- audited 不应自动降级。
- 只有用户明确重置 scope，且风险触发项全部消失，才允许改为 guarded。
