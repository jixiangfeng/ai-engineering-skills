# Data Migration 文档契约

用于约束 `data-migration-planning` 产物最少应沉淀哪些结构化信息，确保后续落地不会回到聊天上下文里重新猜 schema、回填、验证和回滚边界。

## 目标

migration 文档应回答：
- 当前数据模型是什么
- 目标数据模型是什么
- 迁移分几步做
- 如何验证迁移结果
- 如何回滚或恢复
- 交给 delivery 时哪些边界已经确定

## 最低要求

### 1. `migration-workflow-state.md`
至少记录：
- 当前阶段
- 当前状态
- 下一步动作
- 阻塞项
- 是否允许改代码（默认否）

### 2. `01-migration-scope.md`
至少记录：
- 目标表/实体/脚本/读写链路
- 本轮关注点（schema、兼容、回填、清理、回滚等）
- 范围内 / 范围外

### 3. `02-migration-current-data-model.md`
至少记录：
- 当前 schema / 实体 / 存储结构
- 当前读写路径
- 当前迁移历史或约束
- 事实 / 推断 / 待确认 区分

### 4. `03-migration-target-data-model.md`
至少记录：
- 目标 schema / 实体 / 数据状态
- 兼容期要求
- 若存在多种迁移路径，当前选择与未选方案

### 5. `04-migration-plan.md`
至少记录：
- schema 变更步骤
- 代码兼容步骤
- 数据回填步骤
- 清理旧逻辑的时机

### 6. `05-migration-rollback-plan.md`
至少记录：
- 回滚策略或恢复策略
- 不可逆步骤
- 出错时的补救路径

### 7. `06-migration-validation-sql.md`
至少记录：
- 验证 SQL 或等价检查
- 行数/一致性/约束检查
- 关键验收信号

### 8. `07-migration-summary.md` / `migration-to-delivery-handoff.md`
至少记录：
- 最终迁移方案摘要
- 风险与未决问题
- 交给 delivery 时不得猜测的边界

## 输出纪律

- 不把“迁移大概这样做”当作可执行方案，除非步骤、验证和回滚已经写清
- schema、兼容、回填、验证、回滚必须分开写清，不要混成一句话
- handoff 若生成，必须说明范围、兼容窗口、回滚要求、验证重点和未决问题
