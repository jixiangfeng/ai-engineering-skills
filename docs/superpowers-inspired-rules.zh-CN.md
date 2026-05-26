# Superpowers 方法论吸收说明

本文记录 `ai-engineering-skills` 对 superpowers 式工程方法论的吸收边界。这里不复制 superpowers 原文，也不迁移其 skill 集合；只把适合中文工程 workflow 的执行纪律沉淀为 prompt modules，并由现有 workflow skill 引用。

## 吸收原则

- 保留 `ai-engineering-skills` 的中文工程 workflow 边界。
- 只吸收方法论：澄清、计划、测试、debug、review、验证、收尾、隔离和拆分。
- 不新增复杂 runtime。
- 不默认增加大量阶段文档；由轻量/完整模式决定产物规模。
- 如果规则冲突，优先遵守 `docs/workflow-contracts.zh-CN.md` 的 workflow 契约。

## 能力映射

| superpowers 能力 | 植入位置 | 改造方式 |
| --- | --- | --- |
| brainstorming | `workflow-bootstrap`、`docs/prompt-modules/clarification.zh-CN.md` | 路由前做需求清晰度判断、任务大小分类和默认假设说明 |
| writing-plans | `software-delivery-pipeline`、`api-contract-design`、`data-migration-planning`、`docs/prompt-modules/implementation-plan.zh-CN.md` | 代码修改前必须有 Implementation Plan |
| executing-plans | `software-delivery-pipeline`、`code-review-triage`、`debug-root-cause`、`docs/prompt-modules/execution-discipline.zh-CN.md` | 按计划执行，扩 scope 必须暂停确认 |
| test-driven-development | `software-delivery-pipeline`、`debug-root-cause`、`docs/prompt-modules/test-strategy.zh-CN.md` | 引入 `test_first` / `minimal_patch` / `exploratory_fix` 策略 |
| systematic-debugging | `debug-root-cause`、`docs/prompt-modules/debug-discipline.zh-CN.md` | 证据、假设、排除、根因、最小修复、验证方案结构化 |
| verification-before-completion | 全部 workflow、`docs/prompt-modules/verification-gate.zh-CN.md` | 最终输出必须包含 Verification，未验证不能说 completed |
| requesting-code-review | `code-review-triage`、`docs/prompt-modules/review-loop.zh-CN.md` | findings 标准格式、严重级别、证据和用户决策 |
| receiving-code-review | `code-review-triage`、`software-delivery-pipeline` | accepted scope 后生成 handoff，再进入 delivery |
| using-git-worktrees | `software-delivery-pipeline`、`data-migration-planning`、`docs/prompt-modules/worktree-recommendation.zh-CN.md` | 高风险或 dirty worktree 时建议隔离，不默认执行 |
| subagent-driven-development | `software-delivery-pipeline`、`codebase-orientation`、`code-review-triage`、`docs/prompt-modules/task-decomposition.zh-CN.md` | 复杂任务可拆分，只读可并行，写代码默认不并行 |
| finishing-a-development-branch | `software-delivery-pipeline`、`docs/prompt-modules/finish-checklist.zh-CN.md` | 收尾检查 diff、测试、文档、未验证项、回滚和 PR/merge 建议 |

## Prompt Modules

统一模块位于 `docs/prompt-modules/`：

- `clarification.zh-CN.md`：需求澄清和任务大小判断。
- `implementation-plan.zh-CN.md`：实现前计划。
- `execution-discipline.zh-CN.md`：按计划执行和 scope 控制。
- `test-strategy.zh-CN.md`：测试先行和实现策略选择。
- `debug-discipline.zh-CN.md`：系统化 debug。
- `verification-gate.zh-CN.md`：完成前验证门禁。
- `review-loop.zh-CN.md`：review findings、accepted scope 和 fix handoff。
- `worktree-recommendation.zh-CN.md`：大型任务 worktree 建议。
- `task-decomposition.zh-CN.md`：复杂任务拆分和并行边界。
- `finish-checklist.zh-CN.md`：交付收尾清单。
