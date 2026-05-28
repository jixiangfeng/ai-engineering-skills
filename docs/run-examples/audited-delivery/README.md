---
workflow: software-delivery-pipeline
runId: 2026-05-28-audited-review-handoff
runPath: workflow/runs/2026-05-28-audited-review-handoff
executionMode: full
stage: summary
status: completed
source: example
allowsCodeEdit: false
nextAction: none
sourceArtifact: workflow/reviews/2026-05-28-order-review/review-to-delivery-handoff.md
---
# Audited Delivery Example

## Scenario
- 来自 `code-review-triage` 的 handoff，需要修复已选择 finding。
- 因为存在 handoff、scope lock、verification matrix 和 change review，使用 `full` / audited。

## Required Chain
| 阶段 | 文档 | 说明 |
| --- | --- | --- |
| run map | `20-audited-run-map.md` | 记录 audited trigger、risk gate、handoff、skipped reason |
| requirements | `01-delivery-requirements.md` | 读取 handoff，锁定 selected / excluded findings |
| architecture | `02-delivery-architecture.md` | 如触发架构门禁则生成，否则在 plan 写 skipped reason |
| plan | `02-delivery-plan.md` / `03-delivery-plan.md` | 每个 finding 映射到步骤和验证 |
| implementation | `03-delivery-implementation.md` / `04-delivery-implementation.md` | 逐项记录执行状态 |
| change review | `05-delivery-change-review.md` | handoff 修复默认触发 |
| debugging | `04-delivery-debugging.md` / `06-delivery-debugging.md` | 如未触发，写短 note |
| verification | `05-delivery-verification.md` / `07-delivery-verification.md` | 回填验证矩阵和 diff 范围 |
| summary | `06-delivery-summary.md` / `08-delivery-summary.md` | 结果、风险、review 回写 |

## Verification Matrix
- 每个 selected finding 必须映射到验证命令、结果和证据。
- 未覆盖项必须记录原因，并标记为阻塞或请求用户确认风险。

## Risk Gate
- audited 默认要求 `verificationRequired: true`。
- 如果涉及数据、权限、资金、医疗健康建议、MQ 或跨服务一致性，必须记录 rollback 和 confirmation。

## Skipped Reason
- 未生成 `02-delivery-architecture.md`、`05-delivery-change-review.md` 或 debugging 文档时，必须写 skipped reason。
- skipped reason 必须由 scope、diff 或代码证据支撑。

## Completion Rule
- 没有验证证据或 change review 未通过时，不能声明 completed。
