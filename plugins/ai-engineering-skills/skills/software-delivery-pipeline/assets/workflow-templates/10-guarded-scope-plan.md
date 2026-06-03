---
workflow: software-delivery-pipeline
runId: <YYYYMMDD-slug>
runPath: workflow/runs/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: scope_plan
status: draft
source: user-request
allowsCodeEdit: false
nextAction: confirm_scope_plan
---
# Guarded Scope + Plan

## Goal
-

## Scope
- 范围内：
- 范围外：

## Constraints
-

## Acceptance Criteria
- [ ]
- [ ]

## Requirement / Plan Mapping
| 验收项 / Finding | 计划步骤 | 目标文件 / 模块 | 验证方式 |
| --- | --- | --- | --- |
|  |  |  |  |

## Steps
1.
2.
3.

## Implementation Strategy
- test_first | minimal_patch | exploratory_fix
- 原因：

## Verification Matrix
| 验收项 | 命令 / 方式 | 预期结果 | 是否阻塞 |
| --- | --- | --- | --- |
|  |  |  | 是 / 否 |

## Skipped Gates
| Gate | 结果 | 原因 |
| --- | --- | --- |
| Architecture | skipped / required |  |
| Migration | skipped / required |  |
| Change Review | skipped / required |  |
| Debugging | skipped / expected_on_demand |  |

## Stop Conditions
- 如果实现需要改变 API / DTO / 数据 / 权限 / MQ / 调度 / 跨服务契约，暂停并升级到 audited 或转入对应 workflow。
- 如果计划中的验证无法执行，暂停并等待用户确认风险或补充环境。

## Open Questions
-

## Confirmation
- 待确认；确认前不得进入实现或代码修改阶段。
