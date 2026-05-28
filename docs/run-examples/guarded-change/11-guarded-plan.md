---
workflow: software-delivery-pipeline
runId: 2026-05-28-guarded-login-timeout
runPath: workflow/runs/2026-05-28-guarded-login-timeout
executionMode: standard
stage: plan
status: completed
source: example
allowsCodeEdit: false
nextAction: continue_implementation
---
# Guarded Plan

## Requirement Mapping
| 验收项 | 计划步骤 | 验证方式 |
| --- | --- | --- |
| 超时错误返回 `LOGIN_TIMEOUT` | 调整错误映射 | `LoginServiceTest#timeoutReturnsLoginTimeout` |
| 其他登录失败行为不变 | 保留原分支并补回归 | `LoginServiceTest#invalidPasswordUnchanged` |

## Steps
1. 先补超时失败测试。
2. 修改登录 service 错误映射。
3. 运行两个 service 测试。

## Stop Conditions
- 如果修复需要改变认证协议或响应结构，暂停并升级到 audited。
