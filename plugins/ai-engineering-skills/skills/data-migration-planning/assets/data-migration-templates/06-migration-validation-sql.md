---
workflow: data-migration-planning
runId: <YYYYMMDD-slug>
runPath: workflow/data-migrations/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: verification
status: draft
source: user-request
allowsCodeEdit: false
nextAction: run_or_record_verification
---
# 验证 SQL / 检查项

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- 来源文档：
- 文档状态：

## 迁移前检查
```sql
-- 填写迁移前基线检查 SQL，例如总量、空值、重复值、外键/引用完整性、业务状态分布。
```

## 迁移后检查
```sql
-- 填写迁移后目标状态检查 SQL，例如新旧字段映射、回填完成率、索引/约束状态、兼容读取结果。
```

## 数据一致性检查
```sql
-- 填写迁移前后对账 SQL，例如按主键抽样、聚合校验、差异行定位和可回滚性检查。
```

## 验证矩阵
| 验收项 | 验证方式 | 命令或步骤 | 结果 | 证据 | 未覆盖原因 |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |
