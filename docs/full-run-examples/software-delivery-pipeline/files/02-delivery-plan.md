---
workflow: software-delivery-pipeline
runId: 2026-05-26-order-idempotency
runPath: workflow/runs/2026-05-26-order-idempotency
executionMode: full
stage: plan
status: completed
source: example
allowsCodeEdit: false
nextAction: continue_workflow
sourceArtifact: workflow/runs/2026-05-26-order-idempotency/01-delivery-requirements.md
---
# 实施计划

## 文档元信息
- 项目根目录：`/repo/order-service`
- 生成时间：2026-05-26 10:20:00
- 当前分支 / commit：`main` / `abc1234`
- 执行 agent：Codex
- 来源文档：`workflow/runs/2026-05-26-order-idempotency/01-delivery-requirements.md`
- 文档状态：已确认

## 文档状态
- 已确认，允许进入实现阶段；确认前未允许代码修改。

## 目标
- 按已确认需求修复 `F-001`：订单提交在相同用户、相同幂等键重复调用时只创建一笔订单。

## 输入
- `01-delivery-requirements.md`
- 无 `02-delivery-architecture.md`

## 架构设计说明
- 无需独立架构设计的原因：本轮不新增持久化结构、不改变 API contract、不引入外部依赖，只在既有订单提交 service 内补幂等判断。
- 如存在 `02-delivery-architecture.md`，必须遵循的架构约束：不适用。

## 需求承接检查
- 已读取并承接 `01-delivery-requirements.md`：是。
- 需求阶段的任务类型 / 路由检查结论：继续使用 `software-delivery-pipeline`，不转入 API 契约、迁移规划或 debug workflow。
- 需求阶段的范围锁定是否延续：是，仍只修改订单提交 service 和测试。
- 需求阶段的预存工作区变更处理策略：忽略 `docs/order-notes.md`，不得纳入本轮 diff。
- 如发现需求缺口、范围冲突或验证不可行：暂停并回到需求确认。

## 需求到计划映射
| 需求 / 验收项 / Finding | 计划步骤 | 涉及文件 / 模块 | 验证方式 | 未覆盖原因 |
| --- | --- | --- | --- | --- |
| `F-001` 重复提交只创建一笔订单 | 步骤 1、2、3 | `OrderService`、`OrderServiceTest` | `OrderServiceTest#submitSameIdempotencyKeyTwice` | 无 |
| 首单提交行为不变 | 步骤 1、2、3 | `OrderService`、`OrderServiceTest` | `OrderServiceTest#submitNewOrder` | 无 |
| 不触碰范围外模块 | 步骤 4 | git diff 检查 | `git diff --name-only` | 无 |

## 任务拆解
1. 在测试中补充重复幂等键提交的失败用例。
2. 在订单提交 service 中复用现有业务键做最小幂等检查。
3. 补充正常首单提交回归测试。
4. 运行测试并检查 diff 只包含范围内文件。

## Implementation Strategy
- Strategy: test_first
- Reason: 这是可复现的业务规则缺陷，先写失败测试能锁定重复创建订单的行为。
- Expected behavior: 相同用户、相同幂等键重复提交返回同一订单。
- Test / verification cases: 重复提交、正常提交、diff 范围检查。

## Implementation Plan

### 1. 修改目标
- 在订单提交入口增加幂等保护，保证重复提交不产生第二笔订单。

### 2. 修改范围
- 涉及模块：order service
- 涉及文件：`OrderService`、`OrderServiceTest`
- 不修改范围：退款、支付回调、前端页面、数据库 migration。

### 3. 执行步骤
1. 新增 `submitSameIdempotencyKeyTwice` 测试，先确认当前重复创建订单。
2. 在 `OrderService.submit` 查询相同用户和幂等键的既有订单，存在则直接返回。
3. 新增或保留 `submitNewOrder` 测试，确认首单提交行为不变。
4. 运行验证矩阵中的命令并记录结果。

### 4. 数据 / 配置影响
- 数据库：不新增表或字段，复用现有订单业务键。
- Redis：无。
- MQ：无。
- 配置项：无。
- 外部接口：响应 shape 不变。

### 5. 风险点
- 如果现有业务键不能唯一标识提交请求，需要暂停回到需求确认，不能自行新增字段。

### 6. 验证方式
- 单元测试：`OrderServiceTest#submitSameIdempotencyKeyTwice`、`OrderServiceTest#submitNewOrder`
- 集成测试：不新增。
- 手工验证：不需要。
- 回归范围：订单提交、订单查询。

### 7. 回滚方式
- 回滚 `OrderService` 的幂等判断和对应测试。

## Task Decomposition

### 是否需要拆分
- no

### 子任务
| 子任务 | 类型 | 是否可并行 | 输出 |
| --- | --- | --- | --- |
| 订单提交幂等修复 | write | no | service 和测试修改 |

## Worktree Recommendation

当前任务建议使用独立 worktree：no

原因：
- 范围小，限定在订单提交 service 和测试，不涉及跨模块或高风险迁移。

建议命令：
```bash
git worktree add ../order-service-idempotency -b fix/order-idempotency
```

## Findings 修复映射
- `F-001`：步骤 1-4；验证方式为两个 service 测试和 diff 范围检查；不做 `F-002` / `F-003`。

## 风险
- 现有业务键如果不足以表达幂等语义，必须暂停，不得扩大为数据库迁移。

## 测试策略
- test_first：先补失败测试，再做最小实现。

## 验证策略
- 执行需求阶段验证矩阵中的所有阻塞项。
- 若测试环境无法运行，记录阻塞原因和替代证据，不得声称完成。

## 退出标准
- [x] `F-001` 有明确实现步骤。
- [x] 每个阻塞性交付验收项均有验证方式。
- [x] `01-delivery-requirements.md` 中每个阻塞性交付验收项均已映射到计划步骤和验证方式。

## 澄清与收敛记录
- AI 发现的矛盾 / 缺口 / 风险 / 与代码现状冲突：现有业务键是否足够需实现前代码确认。
- 提出的选项或替代方案：先复用现有键；若不足，暂停回需求确认。
- 用户反馈：确认不新增数据库结构。
- 本轮更新结果：计划不包含 migration。
- 未解决阻塞项：无。

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
| 只修 `F-001` | `01-delivery-requirements.md` | 事实 | 高 | 需求范围锁定 |
| 不新增数据库字段 | `01-delivery-requirements.md` | 事实 | 高 | 用户确认约束 |

## 决策记录
| 决策项 | 选择 | 不选方案 | 原因 | 确认记录 |
| --- | --- | --- | --- | --- |
| 实施策略 | test_first | 直接实现 | 行为缺陷可测试复现 | 计划确认 |
| 是否创建架构文档 | 不创建 | 创建 `02-delivery-architecture.md` | 无架构触发条件 | 计划确认 |

## 范围锁定
- 允许修改 / 关注的目录或文件：订单提交 service、订单提交测试。
- 禁止修改 / 不关注的目录或文件：退款、支付回调、前端页面、数据库 migration。
- 允许改变的行为：重复提交返回既有订单。
- 不允许改变的行为：首单提交、订单查询、支付回调、退款流程。
- 超出范围时的处理：暂停并请求用户确认。

## 影响分析
- 影响模块：订单提交。
- 影响 API / 接口：响应 shape 不变。
- 影响数据表 / 实体 / DTO：不变。
- 影响配置 / 环境：不变。
- 影响异步任务 / MQ / 调度：不变。
- 影响测试：新增或更新订单提交 service 测试。
- 兼容性影响：预期无。
- 回滚影响：回滚 service 和测试修改。

## 验证矩阵
| 验收项 / Finding | 验证方式 | 命令或步骤 | 结果 | 证据 | 未覆盖原因 |
| --- | --- | --- | --- | --- | --- |
| 重复提交只创建一笔订单 | 单元测试 | `mvn -pl order-service -Dtest=OrderServiceTest#submitSameIdempotencyKeyTwice test` | 待执行 | 待记录 | 无 |
| 首单提交行为不变 | 单元测试 | `mvn -pl order-service -Dtest=OrderServiceTest#submitNewOrder test` | 待执行 | 待记录 | 无 |
| 未触碰范围外模块 | diff 检查 | `git diff --name-only` | 待执行 | 待记录 | 无 |

## 变更记录
| 轮次 | 用户反馈 | 文档更新 | 当前状态 |
| --- | --- | --- | --- |
| 1 | 确认需求后进入计划 | 写入需求承接检查和映射 | 已确认 |

## 用户确认记录
- 用户已确认计划，可以进入实现阶段。
