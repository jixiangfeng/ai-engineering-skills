---
workflow: api-contract-design
runId: 2026-05-26-order-current
runPath: workflow/api-contracts/2026-05-26-order-current
executionMode: full
stage: summary
status: handoff_ready
source: example
allowsCodeEdit: false
nextAction: none
---
# API Contract Design Full Run

> 这是 audited / full 路径的教学示例，用于展示 expanded contract package 和 handoff 形态；不代表新 run 的默认执行路径。
> 新 run 默认应优先使用 `10-api-contract-scope.md`、`11-api-current-proposed.md`、`12-api-rules-examples.md`、`13-api-summary.md` 这条 slim path。

## Contract Package

- endpoint: `GET /api/orders/current`
- current response: `{ "id": "...", "status": "..." }`
- proposed response: `{ "id": "...", "status": "...", "hasRefund": false }`
- compatibility: 新增字段，不删除旧字段。
- validation/errors: 参数缺失返回业务错误码。
- UI states: normal、empty、permission denied、refunded。

## Verification

### 已验证
- 已检查 DTO、controller、调用方和错误码文档。

### 完成判断
- analysis-only
