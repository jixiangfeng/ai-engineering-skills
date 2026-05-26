# Codebase Orientation Standard Run

## Run
- Workflow: `codebase-orientation`
- Mode: lightweight
- Run path: `workflow/orientation/2026-05-26-order-module`
- Status: `completed`
- Code edits allowed: `false`

## State Snapshot
- 当前阶段：`summary`
- 最新文档：`07-orientation-summary.md`
- 下一步：如需审查，使用 `orientation-to-review-handoff.md`
- `workflow-state.json`：与 Markdown state 同步 `workflow`、`runPath`、`status`、`currentStage`、`latestDocument`、`nextAction`、`codeEditsAllowed`

## Summary Shape
- 当前结论：订单模块负责创建、支付状态同步和退款入口编排。
- 已确认 Scope：`src/order/**`、订单相关路由、订单表结构。
- 未解决问题：支付回调幂等策略需要 review 验证。
- 主要风险：订单状态机分散在 service 和 listener 中。
- 推荐下一步：`code-review-triage`，聚焦幂等和状态流转。

## Task Decomposition

### 是否需要拆分
- yes

### 子任务
| 子任务 | 类型 | 是否可并行 | 输出 |
| --- | --- | --- | --- |
| 代码结构分析 | read-only | yes | `02-orientation-project-map.md` |
| 业务流分析 | read-only | yes | `03-orientation-business-flow.md` |
| 数据契约分析 | read-only | yes | `05-orientation-data-contracts.md` |
| 风险线索分析 | read-only | yes | `06-orientation-open-questions.md` |

## Handoff Shape
生成 `orientation-to-review-handoff.md` 时至少携带：
- confirmed scope
- key modules and flows
- review leads
- evidence sources
- unresolved questions

## Verification

### 已验证
- 已阅读订单路由、service、listener、entity 和相关配置。

### 验证方式
- 文件：`src/order/**`、订单表结构、订单路由定义。
- 证据：summary 中每个结论都有文件或调用链来源。
- 结果：orientation 结论可复用。

### 未验证
- 未运行测试，未确认支付网关外部行为。

### 未验证原因
- 本 workflow 为只读熟悉；外部网关不在本次 scope。

### 完成判断
- analysis-only
