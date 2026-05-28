---
workflow: software-delivery-pipeline
runId: <YYYYMMDD-slug>
runPath: workflow/runs/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: plan
status: draft
source: user-request
allowsCodeEdit: false
nextAction: confirm_plan
---
# Guarded Plan

## Inputs
- `10-guarded-scope.md`

## Requirement Mapping
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

## Stop Conditions
- 如果实现需要改变 API / DTO / 数据 / 权限 / MQ / 调度 / 跨服务契约，暂停并升级到 audited 或转入对应 workflow。

## Verification Plan
| 验收项 | 命令 / 方式 | 预期结果 |
| --- | --- | --- |
|  |  |  |

## Confirmation
- 待确认；确认前不得进入实现或代码修改阶段。
