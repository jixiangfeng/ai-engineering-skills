# Review 文档契约

用于约束 `code-review-triage` 产物最少应提供哪些结构化信息，确保 findings、选择和 handoff 可审计、可继续、可收敛。

## 目标

review 文档应回答：
- review 了什么
- 发现了哪些问题
- 哪些问题要修，哪些明确不修
- 修复计划是什么
- 是否已经具备继续进入 delivery 的条件

## 最低要求

### 1. `review-workflow-state.md`
至少记录：
- 当前阶段
- 当前状态
- 下一步动作
- 阻塞项
- 是否允许改代码（默认否）

### 2. `01-review-scope.md`
至少记录：
- review 目标
- 重点关注维度
- 范围内 / 范围外

### 3. `02-review-findings.md`
每个 material finding 至少包含：
- ID
- 标题
- 严重级别
- 位置
- 证据
- 影响
- 修复方向
- 置信度

### 4. `03-review-fix-selection.md`
至少记录：
- 已选 findings
- 明确不修 findings
- 用户约束
- 是否存在依赖未选 finding 的情况

### 5. `04-review-fix-plan.md`
至少记录：
- 每个已选 finding 的实现方向
- 计划修改范围
- 风险
- 验证要求

### 6. `review-to-delivery-handoff.md`
至少记录：
- 来源 review run
- selected/excluded findings
- 证据位置
- 用户约束
- forbidden scope
- verification 要求

## 输出纪律

- 未确认 fix selection / fix plan 前不改代码
- handoff 不得依赖聊天补全范围
- 若无修复，summary 应明确这是 no-fix closure
