---
workflow: code-review-triage
runId: <YYYYMMDD-slug>
runPath: workflow/reviews/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: findings
status: draft
source: user-request
allowsCodeEdit: false
nextAction: continue_analysis
---
# Review 问题清单

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- 来源文档：
- 文档状态：

## 总览
- 阻塞：0
- 高：0
- 中：0
- 低：0

## 阻塞问题

## Review Findings

### F-001 标题
- Severity: critical | high | medium | low | suggestion
- Evidence:
- Impact:
- Suggested fix:
- Confidence: high | medium | low
- Requires user decision: yes | no

## 高优先级问题

## 中优先级问题

## 低优先级问题

## 不建议本次处理
-

## 测试缺口 / 剩余风险
-

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
|  | `path/to/file:line` | 事实 / 推断 / 待确认 | 高 / 中 / 低 |  |

## 影响分析
- 影响模块：
- 影响 API / 接口：
- 影响数据表 / 实体 / DTO：
- 影响配置 / 环境：
- 影响异步任务 / MQ / 调度：
- 影响测试：
- 兼容性影响：
- 回滚影响：

## 决策记录
| 决策项 | 选择 | 不选方案 | 原因 | 确认记录 |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

## 等待用户选择
- 请确认要修复的问题 ID，例如：`F-001, F-003`，或说明“只修高优先级”。确认前不得进入修复计划或代码修改。
