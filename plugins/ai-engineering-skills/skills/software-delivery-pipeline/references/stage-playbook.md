# 阶段执行手册

本文说明如何按纪律执行每个阶段。所有阶段产物默认使用简体中文，代码标识符、命令、路径、错误输出、API 名称和用户原文可以保留原文。

## 澄清与收敛循环

- 需求、架构、计划三个确认门禁都是循环，不是一轮确认。
- 不把用户原话当成天然正确；必须结合代码证据、项目约束、风险和可行性判断。
- 发现矛盾、缺口、不可行、高风险或与代码现状冲突时，明确指出，提出选项，更新当前阶段文档，再请求确认。
- 用户反馈不能只停留在聊天里，必须写回当前阶段文档。
- 只有文档状态已确认且无未解决阻塞项，才能进入下一阶段。

## 需求确认

目标：把用户请求收敛成具体、可验证、可交接的工程目标。

动作：
- 如果继续自上游 handoff，先按 `references/handoff-inputs.md` 读取并校验来源文档。
- 用中文复述目标，记录为什么本轮应进入 `software-delivery-pipeline` 而不是其它 workflow。
- 分离用户明确要求、代码/文档证据推导出的必要要求、仍需确认的 AI 建议扩展项。
- 明确范围内、范围外、约束、假设和验收标准。
- 定义 verification matrix，把每个验收项映射到命令或检查方式。
- 记录 `git status` 中已存在的 workspace changes，并判断是否影响本轮范围。
- 写 `01-delivery-requirements.md`，状态设为 pending human confirmation。
- 向用户返回 run folder、需求摘要、缺口/风险/冲突、必要选项，并请求确认或修改。
- 用户提出补充或修改时，只更新 `01-delivery-requirements.md` 并再次请求确认。
- 只有用户明确确认需求且无阻塞问题，才允许进入计划；简单任务使用 `02-delivery-plan.md`，架构门禁任务使用 `03-delivery-plan.md`。

如果缺少关键信息会影响安全实现，先问一个简短问题，并把该问题记录到需求文档。

## 架构设计与技术选型

目标：判断是否需要独立架构/设计/技术选型确认。

触发条件：
- 跨模块或跨服务变更。
- 新增或改变持久化结构。
- 新增外部依赖、库、中间件或技术组件。
- API 或数据契约变化。
- 异步、MQ、调度、工作流或并发变化。
- 权限、安全、隐私、数据一致性或迁移风险。
- review handoff 标记 selected finding 为 architecture-level。
- 用户明确要求 design、architecture、technology selection 或方案。

动作：
- 小修复默认不写独立架构文档，只在计划中说明“无需独立架构设计”及理由。
- 触发时写 `02-delivery-architecture.md`，比较方案、说明取舍、定义边界、兼容策略和实施约束。
- 对 API、权限或跨服务设计，明确 provider-side logic、consumer-side logic、接口拆合取舍、权限/规则模型、数据查询边界和 acceptance mapping。
- 用户确认架构前，不允许进入实施计划或代码修改。
- 用户修改或质疑设计时，更新 `02-delivery-architecture.md` 并重复确认门禁。

## 计划

目标：把已确认需求/架构转换为可执行计划。

动作：
- 读取 `01-delivery-requirements.md`。
- 如果存在 `02-delivery-architecture.md`，读取并遵守其确认约束。
- 如果没有独立架构文档，记录原因。
- 继承 route decision、scope lock、acceptance criteria、verification matrix 和 pre-existing workspace-change strategy。
- API、权限或跨服务任务必须把 provider-side 和 consumer-side logic 映射到具体步骤；缺任一侧时回到架构门禁。
- 每个阻塞验收项或 selected finding 都要映射到 plan step、target file/module 和 verification method。
- 若需求无法映射到实施或验证，暂停并回到需求确认，不发明新 scope。
- 记录 Implementation Strategy、Implementation Plan、Task Decomposition（复杂时）、Worktree Recommendation（风险/脏工作区/多模块/长任务时）、风险、依赖和验证策略。
- 写 `02-delivery-plan.md`，或架构后写 `03-delivery-plan.md`。
- 计划必须具体到另一个 agent 可以按文档实施。
- 写完计划后向用户返回 run folder、计划摘要、风险、验证策略、未解决假设，并请求确认或修改。
- 用户修改计划或计划与需求/架构/代码证据冲突时，更新当前计划文档并重复确认门禁。

用户确认计划前，不允许进入实现或修改代码。

## 测试优先实施

目标：按已确认计划用测试优先纪律实施。

动作：
- 读取已批准计划：简单任务读 `02-delivery-plan.md`，架构后读 `03-delivery-plan.md`。
- 按记录的 Implementation Strategy 和 Implementation Plan 执行，并更新 Execution Status。
- 记录 plan execution mapping：每个 plan step、acceptance item 或 selected finding 是 completed、blocked 还是 deviated。
- 找到最小且有意义的 failing test 或 failing reproduction。
- 行为变更默认 fail-first；确认失败原因正确后再实现最小改动。
- 增量重复：测试/复现 -> 最小改动 -> 验证。
- 记录 changed files、tests added 和 deviations from plan。
- 如果需要实质偏离计划或扩大范围，先写入当前 implementation report，并暂停请求用户确认。
- 写 implementation report：简单路径为 `03-delivery-implementation.md`，架构后为 `04-delivery-implementation.md`。

默认规则：不要把“稍后补测试”当成常规路径。

如果严格 fail-first 不现实，implementation report 必须记录：
- 为什么无法 fail-first。
- 使用了什么替代验证策略。
- 后续补了什么回归覆盖。
- 因未完整 fail-first 留下的 residual risk。

## 失败升级

如果实施失败、验证失败或行为与计划矛盾，不继续猜测式反复修改。

触发 debugging stage：
- 同一问题已有两次或以上 fix attempts。
- 当前修复依赖未验证假设。
- 失败跨多个层或组件。
- 当前计划无法解释观测到的行为。

升级时记录：
- attempted fixes so far。
- rejected hypotheses。
- current best root-cause hypothesis。
- 是否应回到 requirements、architecture 或 planning。

只有 debugging stage 产出有证据支撑的 root-cause hypothesis 和 updated fix direction 后，才返回 implementation。

## Change Review Gate

目标：在 verification 前审查实际代码变更是否符合 requirements、architecture、plan、scope lock 和质量标准。

触发条件：
- 继续自 `code-review-triage` handoff。
- 使用了 standalone architecture gate。
- 跨模块或跨服务变更。
- API、DTO、response shape 或 data contract 变化。
- 数据库、migration、entity 或 persistence structure 变化。
- async、MQ、scheduler、workflow 或 concurrency 变化。
- 权限、安全、隐私或数据一致性风险。
- 实施前 worktree dirty，或当前 diff broad/noisy。
- 用户明确要求 second review。

检查：
- 是否匹配 `01-delivery-requirements.md`。
- 是否遵守已确认 architecture 和 plan。
- 是否停留在 scope lock 内。
- 是否无 unrelated diff、broad formatting 或 line-ending pollution。
- 是否未破坏 API/DTO/data contracts 或 strong typing rules。
- verification plan 是否仍有效。

允许结论：
- `approved_for_verification`
- `approved_with_notes`
- `changes_required`
- `scope_violation`
- `blocked_needs_user_decision`

只有 `approved_for_verification` 和 `approved_with_notes` 允许进入 verification；其他结论必须回到实现、调试、计划、架构、需求，或暂停等待用户确认。

## 系统化调试

目标：通过 root-cause analysis 解决失败，而不是靠猜。

动作：
- 稳定复现失败。
- 捕获准确错误/output。
- 检查近期改动、配置差异和可能边界。
- 沿数据流和控制流向源头回溯。
- 先定位根因，再提出并应用修复。
- 如果修复会改变已确认范围、架构、持久化、兼容策略或高风险边界，先写入 active debugging report 并请求确认。
- 写 debugging report：简单路径为 `04-delivery-debugging.md`，复杂路径为 `06-delivery-debugging.md`。

如果不需要 debugging，也写一个简短中文 skipped/not-needed 说明到 active debugging report。

## 验证

目标：在报告成功前证明变更有效。

前置：如果 Change Review Gate 触发过，`05-delivery-change-review.md` 必须是 `approved_for_verification` 或 `approved_with_notes`。

动作：
- 确认实现仍匹配 approved requirements 和 plan，且没有不必要的 scope expansion 或 over-engineering。
- 复制或继承 approved plan 的 verification matrix，并填 actual results。
- 运行最小但有证明力的 verification gates。
- 优先项目原生命令：tests、build、lint、typecheck、smoke test、screenshot、diff inspection。
- 检查 final diff 仍在 approved scope lock 内。
- 准确记录运行了什么、结果是什么。
- 列出 skipped checks 和原因。
- 使用 shared Verification structure，给出 completed / analysis-only / blocked / needs-user-confirmation 判断。
- 如果 meaningful verification 被阻塞，写入 verification report，并让用户决定是否接受风险或补充环境/输入。
- 写 verification report：简单路径为 `05-delivery-verification.md`，复杂路径为 `07-delivery-verification.md`。

没有验证证据或明确 blocker，不得标记完成。

## 交付

目标：用一个简洁文档把结果交给用户并等待验收。

动作：
- 完成 Finish Checklist。
- 总结修改内容和 touched files。
- 汇总 verification results。
- 说明 remaining risks、follow-ups 或 decisions needed。
- 写 summary：简单低风险路径使用 `06-delivery-summary.md`，复杂路径使用 `08-delivery-summary.md`。
- 如果继续自 `code-review-triage`，写或更新源 review run 的 `review-delivery-result.md`。
- 回复用户 summary path，并请求验收或 follow-up feedback。

交付是摘要，不是流水账；保持足够短，方便人工快速扫描。

## Live Execution Pattern

1. 解析当前 project root。
2. 执行 preflight checklist。
3. 在 `<project-root>/workflow/runs/<YYYY-MM-DD>-<slug>/` 创建 run folder。
4. 创建或更新 `delivery-workflow-state.md` 和 `workflow-state.json`。
5. `lightweight` / fast：执行低风险最小改动，写 `00-fast-patch-summary.md` 或简短 verification note。
6. `standard` / guarded：写 `10-guarded-scope-plan.md`；若 approval 未满足，询问确认并停止；确认后执行并写 `11-guarded-execution.md`、`12-guarded-summary.md`。
7. `full` / audited：写 `01-delivery-requirements.md` 并停等确认；确认后评估 architecture gate。
8. 若 architecture 触发，写 `02-delivery-architecture.md` 并停等确认。
9. 写实施计划：有 architecture 时用 `03-delivery-plan.md`，否则用 `02-delivery-plan.md`；停等确认。
10. 确认后实施，写 implementation report。
11. 实施、调试或验证期间如 scope 扩大、plan/architecture 实质改变、验证被阻塞或需要破坏性/高风险操作，暂停确认。
12. 实施后评估 Change Review Gate；触发时写 `05-delivery-change-review.md`，只有 approved 结论才能进入验证。
13. 必要时调试并写 debugging report；否则写 not-needed 说明。
14. 验证并写 verification report。
15. 写 delivery summary，回复关键结果、run folder 和验收请求。
