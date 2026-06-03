---
workflow: codebase-orientation
runId: 2026-05-26-order-module
runPath: workflow/orientation/2026-05-26-order-module
executionMode: full
stage: summary
status: completed
source: example
allowsCodeEdit: false
nextAction: none
---
# Codebase Orientation Full Run

> 这是 audited / full 路径的教学示例，用于展示 expanded orientation trail；不代表新 run 的默认执行路径。
> 新 run 默认应优先使用 `10-orientation-scope.md`、`11-orientation-map.md`、`12-orientation-summary.md` 这条 slim path。

## Stage Documents

- `01-orientation-scope.md`：确认熟悉 `src/order/**`，不进入代码修改。
- `02-orientation-project-map.md`：记录 controller、service、listener、repository 边界。
- `03-orientation-business-flow.md`：记录订单创建、支付、退款入口。
- `04-orientation-technical-flow.md`：记录调用链和异步流。
- `05-orientation-data-contracts.md`：记录 DTO、entity、表结构。
- `06-orientation-open-questions.md`：记录后续 review/debug 线索。
- `07-orientation-summary.md`：包含 `Task Decomposition` 和 `Verification`。

## Verification

### 已验证
- 已阅读目标目录、路由、实体和配置。

### 未验证
- 未运行测试。

### 完成判断
- analysis-only
