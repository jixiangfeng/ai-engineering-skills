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
