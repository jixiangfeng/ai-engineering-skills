# Software Delivery Pipeline Standard Run

## Run
- Workflow: `software-delivery-pipeline`
- Mode: standard
- Run path: `workflow/runs/2026-05-26-order-idempotency`
- Status: `completed`
- Code edits allowed: `true` after approved requirements and plan

## State Snapshot
- 当前阶段：`summary`
- 最新文档：`06-delivery-summary.md` 或 `08-delivery-summary.md`
- 下一步：无
- Selected scope：修复订单重复提交
- `workflow-state.json`：与 Markdown state 同步 `workflow`、`runPath`、`status`、`currentStage`、`latestDocument`、`nextAction`、`codeEditsAllowed`

## Slim Artifact Shape
- `10-guarded-scope-plan.md`：合并 requirements / scope lock / implementation plan / verification targets
- `11-guarded-execution.md`：合并 implementation / verification / 偏差记录
- `12-guarded-summary.md`：记录完成情况、风险、验证结果和后续建议
- 如风险升高或用户要求完整链路，再升级到 audited / full 文档集

## Implementation Strategy

- Strategy: test_first
- Reason: bug 修复涉及幂等业务规则，已有 service 测试基础。
- Expected behavior: 相同幂等键重复提交只创建一笔订单。
- Test / verification cases:
  - 重复提交返回同一订单。
  - 新幂等键正常创建新订单。

## Implementation Plan

### 1. 修改目标
- 修复订单重复提交。

### 2. 修改范围
- 涉及模块：order service
- 涉及文件：`OrderService`、`OrderServiceTest`
- 不修改范围：支付回调、退款状态机

### 3. 执行步骤
1. 先补重复提交失败测试。
2. 增加幂等键检查。
3. 跑订单 service 测试。

### 4. 数据 / 配置影响
- 数据库：复用现有订单唯一索引。
- Redis：无。
- MQ：无。
- 配置项：无。
- 外部接口：响应 shape 不变。

### 5. 风险点
- 不能影响正常首单提交。

### 6. 验证方式
- 单元测试：`OrderServiceTest`
- 集成测试：订单提交 API smoke test
- 手工验证：重复点击提交按钮
- 回归范围：订单创建、订单查询

### 7. 回滚方式
- 回滚 service 幂等检查和对应测试。

## Task Decomposition

### 是否需要拆分
- no

### 子任务
| 子任务 | 类型 | 是否可并行 | 输出 |
| --- | --- | --- | --- |
| 幂等测试补充 | write | no | failing test |
| service 最小修复 | write | no | patch |

## Worktree Recommendation

当前任务建议使用独立 worktree：no

原因：
- 单模块、小范围修复，当前计划只触碰 service 和测试。

## Handoff Input Shape
从 review/debug/api/migration handoff 继续时，handoff 是 source of truth；不得修复未选择 finding 或扩大 scope。

## Verification

### 已验证
- 已运行订单 service 单元测试。
- 已检查 git diff 只包含计划内文件。

### 验证方式
- 命令：`mvn -pl order test -Dtest=OrderServiceTest`
- 文件：`OrderService`、`OrderServiceTest`
- 证据：重复提交和正常提交测试通过。
- 结果：行为满足验收标准。

### 未验证
- 未运行全量回归。

### 未验证原因
- 本次变更为单模块修复，全量回归成本较高。

### 完成判断
- completed

## Finish Checklist

- [x] 已检查 git diff
- [x] 已检查无关改动
- [x] 已运行必要测试
- [ ] 已更新必要文档
- [x] 已说明未验证项
- [x] 已给出回滚方式
- [x] 已给出 PR / merge 建议
