---
workflow: data-migration-planning
runId: 2026-05-26-order-status
runPath: workflow/data-migrations/2026-05-26-order-status
executionMode: full
stage: summary
status: handoff_ready
source: example
allowsCodeEdit: false
nextAction: none
---
# Data Migration Planning Full Run


## Migration Package

- current model: `orders.status` 缺少 `REFUNDING`。
- target model: 增加 `REFUNDING`。
- migration plan: 兼容代码、数据回填、验证、清理旧逻辑。
- rollback plan: 回滚前把 `REFUNDING` 映射回 `PAID`。
- validation SQL: 检查目标状态数量和异常状态数量。

## Worktree Recommendation

当前任务建议使用独立 worktree：yes

原因：
- 涉及 schema、代码兼容、回填和回滚。

## Verification

### 完成判断
- analysis-only
