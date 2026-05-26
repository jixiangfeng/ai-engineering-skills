# Debug Root Cause Standard Run

## Run
- Workflow: `debug-root-cause`
- Mode: full
- Run path: `workflow/debug/2026-05-26-submit-timeout`
- Status: `handoff_ready`
- Code edits allowed: `false`

## State Snapshot
- 当前阶段：`summary`
- 最新文档：`08-debug-summary.md`
- 下一步：如需修复，使用 `debug-to-delivery-handoff.md`
- Reproduction status：`reproduced`
- `workflow-state.json`：与 Markdown state 同步 `workflow`、`runPath`、`status`、`currentStage`、`latestDocument`、`nextAction`、`codeEditsAllowed`

## Debug Analysis

### 1. 现象复述
- 重复调用提交接口时第二次请求超时。

### 2. 影响范围
- 影响订单提交接口；查询接口不受影响。

### 3. 已知证据
- 日志：第二次请求等待锁直到超时。
- 代码：trace 指向 `SubmitService.acquireLock(...)`。
- 配置：锁超时时间为 30 秒。
- 数据：同一用户、同一订单草稿复现。
- 复现步骤：连续两次提交相同 payload。

### 4. 初始假设
| 假设 | 支持证据 | 反证 | 当前状态 |
| --- | --- | --- | --- |
| 异常分支未释放锁 | catch 分支提前返回 | 正常分支会 unlock | confirmed |

### 5. 排除过程
1. 排除数据库慢查询：SQL 日志无慢查询。
2. 排除网关超时：本地 service 单测可复现。

### 6. 根因判断
- Root cause: catch 分支提前返回，跳过 unlock。
- Confidence: high
- Evidence: `SubmitService.submit(...)` 异常路径缺少 finally 释放。

### 7. 最小修复点
- 使用 finally 释放锁，不改提交流程其他逻辑。

### 8. 验证方案
- 增加异常分支释放锁测试。
- 重复提交复现脚本应不再超时。

## Fix Options Shape
| Option | Impact | Risk | Recommendation |
| --- | --- | --- | --- |
| finally 释放锁 | 局部修复 | 低 | recommended |

## Handoff Shape
`debug-to-delivery-handoff.md` 必须包含 root cause、selected fix option、affected files、scope lock、verification requirements、risks 和 unresolved questions。

## Verification

### 已验证
- 已复现问题，已用日志和代码路径确认异常分支缺少 unlock。

### 验证方式
- 命令：重复提交复现脚本。
- 文件：`SubmitService.submit(...)`、锁配置。
- 证据：异常路径跳过释放逻辑。
- 结果：根因可 handoff 到 `software-delivery-pipeline`。

### 未验证
- 未实现修复，未运行修复后测试。

### 未验证原因
- debug workflow 默认只确认根因和修复方向。

### 完成判断
- analysis-only
