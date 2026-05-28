# 条件块模块

本模块用于减少固定模板负担。workflow 文档只保留核心块，风险触发时再加入条件块；未触发的重阶段要写 skipped reason。

## 核心块

所有 delivery 模式都应覆盖：
- Goal：目标结果。
- Scope：范围内、范围外、禁止扩展。
- Plan：执行步骤或最小修改路径。
- Verification：验证方式、结果、未验证风险。

## 条件块

| 条件块 | 触发条件 | 产物要求 |
| --- | --- | --- |
| Risk Gate | 影响接口、数据、权限、资金、医疗、跨服务、并发一致性 | 风险等级、回滚、确认记录 |
| Dirty Worktree | 当前 worktree 有可能被本轮影响的预存变更 | `git status` 摘要、处理策略 |
| API Contract | 请求、响应、DTO、错误码或兼容行为变化 | 转入或引用 `api-contract-design` |
| Migration | schema、实体、历史数据、回填或清理变化 | 转入或引用 `data-migration-planning` |
| Rollback | 高风险或可回滚性影响交付判断 | 回滚步骤、验证方式 |
| Change Review | review handoff、高风险 diff、契约/数据/权限变化 | `05-delivery-change-review.md` |
| Handoff | 上游 workflow 已确认范围并交给下游 | handoff 文件作为 source of truth |
| Verification Matrix | 行为变更或 handoff 修复 | 验收项到验证证据的映射 |

## Skipped Reason

未触发条件块时，不要保留大片空表格。用简短 skipped reason 说明：

```md
## Skipped Gates

| Gate | 结果 | 原因 |
| --- | --- | --- |
| Architecture | skipped | 无跨模块、契约、数据或技术选型变化 |
| Migration | skipped | 不改持久化结构 |
```

## 正例

- 单文件文案修复只写 Goal、Scope、Verification，跳过 architecture 和 change review。
- review handoff 修复必须启用 Handoff、Verification Matrix 和 Change Review。
- 数据字段变更必须转入 Migration，而不是在 delivery 里临时补 SQL。

## 反例

- 所有任务都填完整 01-08 模板。
- 未触发条件块但留下空表格。
- 发现需要迁移后仍在 delivery plan 中自行设计表结构。
