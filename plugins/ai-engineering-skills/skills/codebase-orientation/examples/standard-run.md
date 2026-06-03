# Codebase Orientation Standard Run

## Run
- Workflow: `codebase-orientation`
- Mode: standard
- Run path: `workflow/orientation/2026-05-26-order-module`
- Status: `completed`
- Code edits allowed: `false`

## State Snapshot
- 当前阶段：`summary`
- 最新文档：`12-orientation-summary.md`
- 下一步：如需审查，使用 `orientation-to-review-handoff.md`
- `workflow-state.json`：与 Markdown state 同步 `workflow`、`runPath`、`status`、`currentStage`、`latestDocument`、`nextAction`、`codeEditsAllowed`

## Slim Artifact Shape
- `10-orientation-scope.md`：记录熟悉目标、关注点、范围内 / 范围外
- `11-orientation-map.md`：合并项目结构、业务流、技术流、数据契约和 open questions
- `12-orientation-summary.md`：给出本轮结论、关键文件、风险、推荐下一步 workflow
- `orientation-to-review-handoff.md` / `orientation-to-delivery-handoff.md`：仅在需要下游 workflow 时生成

## Task Decomposition
- 先确认订单模块边界和入口文件
- 再梳理业务流和技术调用链
- 最后收敛为风险、open questions 和推荐下一步 workflow

## Summary Shape
- 当前结论：订单模块负责创建、支付状态同步和退款入口编排。
- 已确认 Scope：`src/order/**`、订单相关路由、订单表结构。
- 未解决问题：支付回调幂等策略需要 review 验证。
- 主要风险：订单状态机分散在 service 和 listener 中。
- 推荐下一步：`code-review-triage`，聚焦幂等和状态流转。

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
