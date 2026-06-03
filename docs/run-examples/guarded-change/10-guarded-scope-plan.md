---
workflow: software-delivery-pipeline
runId: 2026-05-28-guarded-login-timeout
runPath: workflow/runs/2026-05-28-guarded-login-timeout
executionMode: standard
stage: scope_plan
status: completed
source: user-request
allowsCodeEdit: false
nextAction: start_execution
---
# Guarded Scope + Plan

## Goal
- 修复登录页超时提示缺少重试建议的问题，并补充最小验证。

## Scope
- 范围内：`web/login/timeout.tsx`、对应文案测试。
- 范围外：认证接口、超时策略、监控埋点。

## Constraints
- 不修改 API 行为。
- 不调整重试次数，只补充提示信息和测试。

## Acceptance Criteria
- [x] 超时提示增加“稍后重试”说明。
- [x] 文案测试覆盖新提示内容。

## Requirement / Plan Mapping
| 验收项 / Finding | 计划步骤 | 目标文件 / 模块 | 验证方式 |
| --- | --- | --- | --- |
| 超时提示补充重试建议 | 更新组件文案 | `web/login/timeout.tsx` | `pnpm test login-timeout` |
| 测试覆盖新文案 | 更新快照 / 断言 | `web/login/timeout.test.tsx` | `pnpm test login-timeout` |

## Steps
1. 更新超时提示文案。
2. 补充或更新测试断言。
3. 运行局部测试并记录结果。

## Implementation Strategy
- minimal_patch
- 原因：只改文案和对应测试，不涉及行为逻辑。

## Verification Matrix
| 验收项 | 命令 / 方式 | 预期结果 | 是否阻塞 |
| --- | --- | --- | --- |
| 超时提示补充重试建议 | UI 组件断言 | 渲染文本包含“稍后重试” | 是 |
| 测试覆盖新文案 | `pnpm test login-timeout` | 测试通过 | 是 |

## Skipped Gates
| Gate | 结果 | 原因 |
| --- | --- | --- |
| Architecture | skipped | 不涉及架构、契约或技术选型变化 |
| Migration | skipped | 不改持久化结构 |
| Change Review | skipped | 预计 diff 限定在单组件和单测 |
| Debugging | skipped | 当前无复现异常，按需触发 |

## Stop Conditions
- 如果发现提示文案由服务端返回，暂停并升级评估。
- 如果测试环境缺失，暂停并请求补充。

## Open Questions
- 无。

## Confirmation
- 已确认；可以进入实现阶段。
