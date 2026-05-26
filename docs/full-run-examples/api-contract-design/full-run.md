# API Contract Design Full Run

```yaml
artifact:
  schema: ai-engineering-skills.artifact.v1
  workflow: api-contract-design
  run_path: workflow/api-contracts/2026-05-26-order-current
  mode: full
  status: handoff_ready
  code_edits_allowed: false
```

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
