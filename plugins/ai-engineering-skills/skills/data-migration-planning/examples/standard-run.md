# Data Migration Planning Standard Run

## Run
- Workflow: `data-migration-planning`
- Mode: standard
- Run path: `workflow/data-migrations/2026-05-26-order-status`
- Status: `handoff_ready`
- Code edits allowed: `false`

## State Snapshot
- 当前阶段：`summary`
- 最新文档：`13-migration-summary.md`
- 下一步：使用 `migration-to-delivery-handoff.md` 落地
- `workflow-state.json`：与 Markdown state 同步 `workflow`、`runPath`、`status`、`currentStage`、`latestDocument`、`nextAction`、`codeEditsAllowed`

## Slim Artifact Shape
- `10-migration-scope-current.md`：合并 scope 和 current schema / read-write path
- `11-migration-target-plan.md`：合并 target model 和 phased migration plan
- `12-migration-rollback-validation.md`：合并 rollback / recovery 和 validation SQL / checks
- `13-migration-summary.md`：给出最终迁移方案、风险和 open questions
- `migration-to-delivery-handoff.md`：仅在需要进入实现时生成

## Migration Shape
- current model: `orders.status` 缺少退款中状态
- target model: 增加 `REFUNDING`
- migration plan: 先发布兼容代码，再执行数据回填，最后清理旧判断
- rollback plan: 回滚代码前将 `REFUNDING` 映射回 `PAID`
- validation SQL: 统计目标状态数量和异常状态数量

## Worktree Recommendation
- 对涉及 schema、回填脚本和兼容代码的迁移，优先在独立分支或 worktree 中落地，避免和并行业务改动混在一起。

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
