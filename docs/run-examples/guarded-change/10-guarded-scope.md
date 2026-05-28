---
workflow: software-delivery-pipeline
runId: 2026-05-28-guarded-login-timeout
runPath: workflow/runs/2026-05-28-guarded-login-timeout
executionMode: standard
stage: scope
status: completed
source: example
allowsCodeEdit: false
nextAction: continue_plan
---
# Guarded Scope

## Goal
- 修复登录超时后错误提示不准确的问题。

## Scope
- 范围内：登录 service 的超时错误映射和对应测试。
- 范围外：认证协议、token 刷新、前端路由。

## Acceptance Criteria
- [x] 超时错误返回 `LOGIN_TIMEOUT`。
- [x] 其他登录失败行为不变。

## Verification Matrix
| 验收项 | 验证方式 | 是否阻塞 |
| --- | --- | --- |
| 超时错误返回 `LOGIN_TIMEOUT` | service test | 是 |
| 其他登录失败行为不变 | regression test | 是 |

## Skipped Gates
| Gate | 结果 | 原因 |
| --- | --- | --- |
| Architecture | skipped | 不改认证协议、数据结构或跨服务契约 |
| Migration | skipped | 不改持久化结构 |
| Change Review | skipped | diff 预计限定在 service 和 test |
