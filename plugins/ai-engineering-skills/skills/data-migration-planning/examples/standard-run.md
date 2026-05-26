# Data Migration Planning Standard Run

## Run
- Workflow: `data-migration-planning`
- Mode: full
- Run path: `workflow/data-migrations/2026-05-26-order-status`
- Status: `handoff_ready`
- Code edits allowed: `false`

## State Snapshot
- 当前阶段：`summary`
- 最新文档：`07-migration-summary.md`
- 下一步：使用 `migration-to-delivery-handoff.md` 落地
- `workflow-state.json`：与 Markdown state 同步 `workflow`、`runPath`、`status`、`currentStage`、`latestDocument`、`nextAction`、`codeEditsAllowed`

## Migration Shape
- current model: `orders.status` 缺少退款中状态
- target model: 增加 `REFUNDING`
- migration plan: 先发布兼容代码，再执行数据回填，最后清理旧判断
- rollback plan: 回滚代码前将 `REFUNDING` 映射回 `PAID`
- validation SQL: 统计目标状态数量和异常状态数量

## Worktree Recommendation

当前任务建议使用独立 worktree：yes

原因：
- 涉及实体、SQL、服务判断和回滚脚本。
- 当前迁移有数据兼容窗口和回填风险。

建议命令：
```bash
git worktree add ../order-status-migration -b migration/order-status
```

## Handoff Shape
`migration-to-delivery-handoff.md` 必须包含 schema/data changes、compatibility window、rollback requirements、validation SQL、rollout phases 和 unresolved questions。

## Verification

### 已验证
- 已检查当前 schema、实体枚举、读写路径和历史迁移。

### 验证方式
- 文件：订单表 DDL、订单实体、状态判断 service、迁移目录。
- 证据：迁移计划包含兼容发布、回填、验证和回滚。
- 结果：迁移方案可 handoff 到 `software-delivery-pipeline`。

### 未验证
- 未在真实数据库执行 validation SQL。

### 未验证原因
- 本 workflow 只规划迁移，默认不执行数据变更。

### 完成判断
- analysis-only
