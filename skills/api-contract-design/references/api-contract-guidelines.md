# API 契约准则

- 字段位置、字段名、类型和空值语义必须明确。
- Java 后端优先强类型 DTO，不用 `Map<String,Object>` / raw `Object` / `JSONObject` 作为契约。
- 明确兼容旧客户端与否。
- 契约样例必须覆盖成功、失败和边界场景。
