# Risk Gate 模块

本模块用于所有 workflow 的风险分级、暂停条件和恢复/回滚要求。

## 风险等级

- `low`: 小范围只读分析、小文档调整、低影响确定性修改。
- `medium`: 影响多个文件、API/DTO 行为、业务规则、测试策略、跨模块调用或用户可见行为。
- `high`: 数据迁移/回填、支付/收益、医疗健康计划、权限认证、隐私、安全、MQ/异步、不可逆操作、生产发布、批量删除或难以回滚的改动。

## 状态字段

workflow state 和 summary 应记录：

```yaml
riskLevel: low | medium | high
riskReason: <why>
confirmationRequired: true | false
rollbackRequired: true | false
```

## 门禁规则

1. `high` 风险必须暂停并请求用户确认。
2. `medium` 风险如果涉及写入、接口、数据或行为改变，必须在计划中记录验证和回滚。
3. `low` 风险可以直接执行合理假设，但仍要记录验证证据。
4. 风险等级上升时，必须更新 state / summary，并重新判断是否需要 confirmation。
5. 无法验证或无法回滚的 high 风险，不得声明 completed。

## 正例

- 涉及数据回填时标记 `high`，要求回滚方案和用户确认。
- API 响应字段调整标记 `medium`，记录兼容性和前端状态覆盖。

## 反例

- 医疗健康计划生成逻辑改动仍标记 `low`。
- 有数据库迁移但没有 `rollbackRequired: true`。
