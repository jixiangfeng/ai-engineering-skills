---
workflow: software-delivery-pipeline
runId: 2026-05-26-order-idempotency
runPath: workflow/runs/2026-05-26-order-idempotency
executionMode: full
stage: scope
status: completed
source: example
allowsCodeEdit: false
nextAction: continue_workflow
sourceArtifact: workflow/reviews/2026-05-26-order-review/review-to-delivery-handoff.md
---
# 需求确认

## 文档元信息
- 项目根目录：`/repo/order-service`
- 生成时间：2026-05-26 10:00:00
- 当前分支 / commit：`main` / `abc1234`
- 执行 agent：Codex
- 来源文档：`workflow/reviews/2026-05-26-order-review/review-to-delivery-handoff.md`
- 文档状态：已确认

## 文档状态
- 已确认，允许进入计划阶段；确认前未允许代码修改。

## 原始请求
- 用户原始任务：按 review handoff 修复订单重复提交导致重复订单的问题，只修选中的 `F-001`。

## Review 交接来源
- 来源 review run：`workflow/reviews/2026-05-26-order-review`
- handoff 文件：`workflow/reviews/2026-05-26-order-review/review-to-delivery-handoff.md`
- 已选 Findings：`F-001` 订单提交缺少幂等保护
- 明确不修 Findings：`F-002` 退款状态机边界、`F-003` 支付回调日志字段

## 任务类型 / 路由检查
- 当前任务类型：已确认 review finding 的修复交付。
- 继续使用 `software-delivery-pipeline` 的原因：已有 review handoff、修复范围和验收方向，需要进入计划、实现和验证闭环。
- 是否应转入其他 workflow：否。
- 判断依据：问题已由 review 阶段确认，不是新接口契约设计、数据迁移规划或未知根因排查。

## 目标结果
- 同一用户使用相同幂等键重复提交订单时，只创建一笔订单，并返回同一订单结果。
- 正常首单提交、订单查询和支付后续流程保持原有行为。

## 范围
- 范围内：订单提交入口的幂等保护、对应 service 测试、必要的验证记录。
- 范围外：退款状态机、支付回调重构、订单详情响应结构调整、数据库结构变更。

## 需求来源分层
- 用户明确要求：只修 review handoff 中选中的 `F-001`。
- 由代码 / 文档证据推导出的必要要求：实现必须覆盖重复提交和正常提交两个路径，否则无法证明未破坏首单行为。
- AI 建议但未确认的扩展项：增加接口级压测或前端防重复点击，不纳入本轮。

## 约束
- 不改变订单提交 API 的响应 shape。
- 不新增数据库表或字段。
- 不修复未选择 finding；若实现发现 `F-002` 阻塞 `F-001`，暂停确认。

## 假设
- 现有订单表已有可复用的唯一业务键或幂等键字段；若代码证据不支持，计划阶段必须暂停或调整方案。

## 验收标准
- [x] 相同用户、相同幂等键重复提交只创建一笔订单。
- [x] 重复提交返回已创建订单，不产生第二条订单记录。
- [x] 不传幂等键或首次提交时的正常下单行为不变。
- [x] 不修改退款、支付回调和订单详情响应。

## 验证矩阵
| 验收项 | 验证命令 / 方式 | 预期结果 | 是否阻塞交付 |
| --- | --- | --- | --- |
| 重复提交只创建一笔订单 | `mvn -pl order-service -Dtest=OrderServiceTest#submitSameIdempotencyKeyTwice test` | 测试通过，断言订单数为 1 | 是 |
| 首单提交行为不变 | `mvn -pl order-service -Dtest=OrderServiceTest#submitNewOrder test` | 测试通过，返回新订单 | 是 |
| 未触碰范围外模块 | `git diff --name-only` | diff 仅包含订单提交实现和测试 | 是 |

## 未知项 / 问题
- 无阻塞问题；计划阶段需用代码确认幂等键字段位置。

## 预存工作区变更
- `git status` 摘要：存在 `docs/order-notes.md` 未跟踪文件。
- 是否影响本轮范围：否，文档文件不在订单提交实现范围内。
- 处理策略：忽略；不得格式化、删除或纳入本轮提交。

## 澄清与收敛记录
- AI 发现的矛盾 / 缺口 / 风险 / 与代码现状冲突：review handoff 未说明是否允许数据库变更。
- 提出的选项或替代方案：优先复用现有唯一业务键；若必须新增字段，暂停转入迁移规划。
- 用户反馈：确认不做数据库结构变更。
- 本轮更新结果：把“不新增数据库表或字段”加入约束。
- 未解决阻塞项：无。

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
| 只修 `F-001` | `workflow/reviews/2026-05-26-order-review/review-to-delivery-handoff.md` | 事实 | 高 | handoff 明确 selected findings |
| API 响应 shape 不变 | 用户确认记录 | 事实 | 高 | 作为本轮约束 |
| 幂等键字段需计划阶段确认 | `OrderSubmitRequest` | 待确认 | 中 | 需求阶段尚未读取实现细节 |

## 范围锁定
- 允许修改 / 关注的目录或文件：订单提交 service、订单提交测试。
- 禁止修改 / 不关注的目录或文件：退款、支付回调、前端页面、数据库 migration。
- 允许改变的行为：相同幂等键重复提交时返回既有订单。
- 不允许改变的行为：首单提交、订单查询、支付回调、退款流程。
- 超出范围时的处理：暂停并请求用户确认。

## 验收样例
| 场景 | 前置条件 / 输入 | 操作 | 预期结果 | 关联需求 / Finding |
| --- | --- | --- | --- | --- |
| 重复提交 | 同一用户、同一商品、同一幂等键 | 连续调用两次提交订单 | 只创建一笔订单，第二次返回同一订单 | `F-001` |
| 正常提交 | 新用户或新幂等键 | 调用提交订单 | 创建新订单，响应结构不变 | `F-001` |

## 决策记录
| 决策项 | 选择 | 不选方案 | 原因 | 确认记录 |
| --- | --- | --- | --- | --- |
| 是否新增数据库字段 | 不新增 | 新增 `idempotency_key` 字段 | 用户要求本轮不做数据迁移，优先复用现有结构 | 用户确认 |
| 是否修复未选 findings | 不修复 | 顺手修 `F-002` / `F-003` | delivery 只能执行已选 scope | review handoff |

## 变更记录
| 轮次 | 用户反馈 | 文档更新 | 当前状态 |
| --- | --- | --- | --- |
| 1 | 确认只修 `F-001`，不改数据库结构 | 更新范围、约束和验证矩阵 | 已确认 |

## 用户确认记录
- 用户已确认本需求文档，可以进入计划阶段；确认前不得修改代码。
