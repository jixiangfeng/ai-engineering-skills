# Execution Modes

本文件定义 workflow 的自适应重量规则。目标不是让所有任务都进入完整流程，而是让 agent 根据风险选择最小必要流程。

## 模式映射

| 兼容名 | 产品语义 | 适用场景 | 默认产物 |
| --- | --- | --- | --- |
| `lightweight` | fast | 小修、小范围低风险改动、简单验证即可闭环 | `workflow-state.json` + summary / verification note |
| `standard` | guarded | 普通 bugfix、局部重构、需要 scope 和 plan 的实现 | `10-guarded-scope-plan.md` + `11-guarded-execution.md` + `12-guarded-summary.md` |
| `full` | audited | 高风险、跨模块、handoff、契约、数据、权限、可审计交付 | 完整阶段文档、确认门禁、必要 handoff / change review / debugging |

## 选择原则

- 默认从最轻模式开始判断，而不是默认进入完整流程。
- 风险触发优先于任务大小；只要触发 audited 条件，不得因为 scope 小而降级为 guarded 或 fast。
- 没有风险触发时，不生成完整 01-08 文档。
- 缺少验证证据时不能降级为 fast。
- 任务中途风险升高时必须说明原因，并升级到 guarded 或 audited。
- 用户明确要求“完整、深度、形成文档、handoff、可恢复”时使用 audited。

## fast

适用条件：
- 单文件或小范围修改。
- 不改变 API / DTO / 数据 / 权限 / MQ / 调度 / 跨服务契约。
- 不来自 review handoff。
- worktree 变更不会被本轮修改影响。
- 有明确可执行的验证方式。

最小输出：
- 当前假设。
- 修改摘要。
- 验证命令和结果。
- 未验证项和剩余风险。

禁止：
- 生成完整阶段文档。
- 在发现契约、数据、权限或跨模块影响后继续 fast。

## guarded

适用条件：
- 普通实现、bugfix 或局部重构。
- 需要明确 scope、plan 和 verification，但不需要完整审计链路。
- 未触发 audited 硬条件。

最小输出：
- 合并的 requirements / scope / implementation plan。
- 合并的 implementation / verification execution record。
- summary。

允许跳过：
- architecture gate，前提是记录 skipped reason。
- change review，前提是 diff 小且不触发风险门禁。
- debugging，前提是实现和验证没有异常。

推荐收缩：
- `scope` 与 `plan` 默认合并在 `10-guarded-scope-plan.md`，用一次确认门禁锁定范围、计划和验证目标。
- `implementation` 与 `verification` 默认合并在 `11-guarded-execution.md`，避免把“实现完成”和“验证完成”拆成两份重复文档。
- 只有需要审计、handoff 或风险升级时，才展开为 audited 的独立阶段文档。

## audited

适用条件：
- review handoff 修复。
- API / DTO / 数据契约变更。
- 数据迁移、回填、字段删除、破坏性 SQL。
- 权限、安全、隐私、资金、医疗健康建议。
- 跨服务、MQ、调度、并发或一致性风险。
- 用户要求完整可审计产物。

要求：
- 保留完整阶段链路。
- 所有确认门禁必须停。
- 验证矩阵必须逐项回填证据。
- 若验证阻塞，不能声明完成。
- audited 触发条件一旦成立，不允许因“改动很小”降级。

## Skipped Gates

所有跳过的重阶段都要记录原因，推荐格式：

| Gate | 结果 | 原因 |
| --- | --- | --- |
| Architecture | skipped | 无跨模块、契约、数据或技术选型变化 |
| Migration | skipped | 不改持久化结构 |
| Change Review | skipped | diff 限定在计划文件内且无风险触发 |

## 升级条件

出现以下任一情况必须升级：
- 需要修改未确认 scope。
- 需要改变 API / DTO / 数据 / 权限 / MQ / 调度。
- 验证方式不可执行或结果失败。
- 发现上游 handoff 缺失关键字段。
- worktree 预存变更可能被影响。
- 用户要求更完整的文档、审计或恢复能力。
