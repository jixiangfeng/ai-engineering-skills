# API Contract Design Standard Run

## Run
- Workflow: `api-contract-design`
- Mode: full
- Run path: `workflow/api-contracts/2026-05-26-order-current`
- Status: `handoff_ready`
- Code edits allowed: `false`

## State Snapshot
- 当前阶段：`summary`
- 最新文档：`07-api-summary.md`
- 下一步：使用 `api-to-delivery-handoff.md` 落地
- `workflow-state.json`：与 Markdown state 同步 `workflow`、`runPath`、`status`、`currentStage`、`latestDocument`、`nextAction`、`codeEditsAllowed`

## Contract Shape
- endpoint: `GET /api/orders/current`
- callers: Web order page and mobile order card
- current response: `{ "id": "...", "status": "..." }`
- proposed response: `{ "id": "...", "status": "...", "hasRefund": false }`
- compatibility: 新增字段，不删除旧字段
- validation/errors: 参数缺失返回业务错误码，不返回 500
- UI states covered: normal order, refunded order, empty current order, permission denied

## Examples Shape
```json
{
  "id": "O-1",
  "status": "PAID",
  "hasRefund": false
}
```

## Handoff Shape
`api-to-delivery-handoff.md` 必须包含 endpoint、DTO fields、compatibility decision、validation behavior、examples、verification focus 和 unresolved questions。

## Verification

### 已验证
- 已检查 controller、response DTO、前端调用方和错误码文档。

### 验证方式
- 文件：`OrderController`、`OrderCurrentResponse`、订单页面调用方。
- 证据：新增字段不替换旧字段，异常状态有样例。
- 结果：契约可 handoff 到 `software-delivery-pipeline`。

### 未验证
- 未运行接口测试。

### 未验证原因
- 本 workflow 只做契约设计，不执行实现验证。

### 完成判断
- analysis-only
