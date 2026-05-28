---
workflow: software-delivery-pipeline
runId: <YYYYMMDD-slug>
runPath: workflow/runs/<YYYY-MM-DD>-<slug>
executionMode: lightweight
stage: summary
status: completed
source: user-request
allowsCodeEdit: true
nextAction: none
---
# Fast Patch Summary

## Goal
-

## Scope
- 范围内：
- 范围外：

## Assumptions
-

## Minimal Plan
1.
2.

## Changed Files
-

## Skipped Gates
| Gate | 结果 | 原因 |
| --- | --- | --- |
| Requirements document | skipped |  |
| Architecture | skipped |  |
| Change Review | skipped |  |

## Verification
| 验收项 | 命令 / 方式 | 结果 |
| --- | --- | --- |
|  |  |  |

## Remaining Risk
-

## Upgrade Conditions
- 如果发现需要改变 API / DTO / 数据 / 权限 / MQ / 调度 / 跨服务契约，升级到 guarded 或 audited。
- 如果验证失败或无法执行，记录阻塞并请求用户确认。
