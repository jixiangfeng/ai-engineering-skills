---
workflow: debug-root-cause
runId: 2026-05-26-submit-timeout
runPath: workflow/debug/2026-05-26-submit-timeout
executionMode: full
stage: summary
status: handoff_ready
source: example
allowsCodeEdit: false
nextAction: none
---
# Debug Root Cause Full Run

> 这是 audited / full 路径的教学示例，用于展示 expanded debug trail 和 handoff 形态；不代表新 run 的默认执行路径。
> 新 run 默认应优先使用 `10-debug-scope-reproduction.md`、`11-debug-evidence.md`、`12-debug-root-cause.md`、`13-debug-summary.md` 这条 slim path。

## Debug Analysis

### 1. 现象复述
- 重复提交第二次请求超时。

### 2. 影响范围
- 影响订单提交。

### 3. 已知证据
- 日志：等待锁超时。
- 代码：异常分支跳过 unlock。
- 复现步骤：连续提交相同 payload。

### 4. 初始假设
| 假设 | 支持证据 | 反证 | 当前状态 |
| --- | --- | --- | --- |
| 异常分支未释放锁 | 日志和代码路径一致 | 正常分支会释放 | confirmed |

### 5. 排除过程
1. 排除数据库慢查询。
2. 排除网关超时。

### 6. 根因判断
- Root cause: catch 分支提前返回跳过 unlock。
- Confidence: high
- Evidence: `SubmitService.submit(...)`

### 7. 最小修复点
- 用 finally 释放锁。

### 8. 验证方案
- 异常分支释放锁测试。

## Verification

### 完成判断
- analysis-only
