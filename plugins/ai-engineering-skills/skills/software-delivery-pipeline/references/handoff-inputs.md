# 上游 Handoff 输入规则

本文承接 `software-delivery-pipeline` 的上游 handoff 读取细则。主 `SKILL.md` 保留入口锚点；具体字段、停止条件和 requirements 写入规则以本文为准。

通用规则：
- 使用 `docs/handoff-routing-matrix.json` 作为允许路由、共享 YAML key、路由专属 key 和 required source artifacts 的机器可读源。
- 消费 handoff 前先校验 source workflow -> target workflow 是否声明在矩阵中。
- 如果 handoff route 未声明、YAML 缺少矩阵要求字段、或 source_of_truth_artifacts 缺失，应停止并请求用户确认。
- 不从聊天记忆补齐 handoff 缺口；缺口应写入 `01-delivery-requirements.md` 并进入确认门禁。
- 上游 handoff 不能直接等同于生产代码修改授权；delivery requirements 和 plan gates 仍需满足当前执行模式要求。

## Review Handoff Input

触发：用户要求从 review 继续、修复 selected findings、提供 `workflow/reviews/...` 路径，或在 review handoff 后说“按这个修 / 继续 / 落地 / 修复选中的问题”。

优先读取：
1. `workflow/reviews/<run>/review-to-delivery-handoff.md`
2. `workflow/reviews/<run>/12-review-fix-plan.md`
3. `workflow/reviews/<run>/11-review-findings.md` only for evidence lookup
4. legacy compatibility only: `workflow/reviews/<run>/03-review-fix-selection.md` + `workflow/reviews/<run>/04-review-fix-plan.md`
5. legacy evidence lookup only: `workflow/reviews/<run>/02-review-findings.md`

解释规则：
- 读取 handoff 后再写 `01-delivery-requirements.md`。
- 校验 shared 和 review-specific YAML fields。
- 从 YAML 中确认 selected findings、excluded findings、constraints、verification requirements 和 forbidden scope。
- 如果没有 handoff，但 review run 有 confirmed `12-review-fix-plan.md`，可从该文件重建 requirements，并明确记录“未找到 handoff 文件”。
- 如果没有 handoff 且没有 confirmed selection/plan，停止并要求用户先完成 `code-review-triage`。
- `01-delivery-requirements.md` 必须列出 source review run、selected finding IDs、excluded finding IDs、user constraints、每个 selected finding 的 acceptance criteria，以及影响范围的 pre-existing workspace diffs。
- `02-delivery-plan.md` 必须把每个 selected finding ID 映射到实施步骤和验证步骤。
- 不实现 unselected findings；如果 unselected finding 阻塞 selected fix，应暂停请求扩大 scope。
- 交付完成后，写或更新 `workflow/reviews/<run>/review-delivery-result.md`，记录 fixed/unfixed finding IDs、verification summary、delivery run path 和 remaining risks。

## Orientation Handoff Input

触发：用户提供 `workflow/orientation/.../orientation-to-delivery-handoff.md`，或要求直接从 orientation 进入实现。

规则：
- 读取 `orientation-to-delivery-handoff.md` 后再写 `01-delivery-requirements.md`。
- 校验 shared YAML fields 和 source-of-truth artifacts。
- 至少提取 accepted scope、excluded scope、constraints、unresolved questions、verification focus、source of truth artifacts 和 why direct delivery is appropriate。
- 如果这些最小字段缺失，停止并请求确认。
- `01-delivery-requirements.md` 必须记录 source orientation run path、affected modules、locked scope、unresolved questions 和 architecture gate recommendation。

## Debug Handoff Input

触发：用户提供 `workflow/debug/.../debug-to-delivery-handoff.md`，或要求从 confirmed debug result 实现。

规则：
- 读取 `debug-to-delivery-handoff.md` 后再写 `01-delivery-requirements.md`。
- 校验 shared YAML fields 和 source-of-truth artifacts。
- 至少提取 accepted scope、excluded scope、root cause、selected fix direction、constraints、verification focus 和 source of truth artifacts。
- 如果 root cause、scope lock 或 verification focus 缺失，停止并请求确认，不猜 intended fix。
- `01-delivery-requirements.md` 必须记录 source debug run path、confirmed root cause、allowed modification scope、forbidden scope 和 required verification signals。

## Test Handoff Input

触发：用户提供 `workflow/tests/.../test-to-delivery-handoff.md`，或要求从 confirmed failing tests 实现。

规则：
- 读取 `test-to-delivery-handoff.md` 后再写 `01-delivery-requirements.md`。
- 校验 shared 和 test-specific YAML fields。
- 至少提取 approved failing tests、fix scope、forbidden scope、required regression、constraints、verification focus 和 source of truth artifacts。
- 如果 approved failing tests、allowed fix scope 或 required regression 缺失，停止并请求确认。
- `01-delivery-requirements.md` 必须记录 source test run path、approved failing tests、allowed and forbidden modification scope、required regression 和影响本轮 fix 的 pre-existing workspace diffs。
- 不把 test handoff 视为直接 production-code edit approval；delivery requirements 和 plan gates 仍然适用。

## API Contract Handoff Input

触发：用户提供 `workflow/api-contracts/.../api-to-delivery-handoff.md`，或要求从 confirmed API contract 实现。

规则：
- 读取 `api-to-delivery-handoff.md` 后再写 `01-delivery-requirements.md`。
- 校验 shared YAML fields 和 source-of-truth artifacts。
- 至少提取 accepted scope、excluded scope、contract decisions、compatibility decision、validation/error behavior、constraints、verification focus 和 source of truth artifacts。
- 如果 field semantics、compatibility rules 或 forbidden changes 缺失，停止并请求确认。
- `01-delivery-requirements.md` 必须记录 source API contract run path、DTO / endpoint / response boundaries、compatibility commitments、forbidden changes 和 verification examples。

## Migration Handoff Input

触发：用户提供 `workflow/data-migrations/.../migration-to-delivery-handoff.md`，或要求从 confirmed migration plan 实现。

规则：
- 读取 `migration-to-delivery-handoff.md` 后再写 `01-delivery-requirements.md`。
- 校验 shared YAML fields 和 source-of-truth artifacts。
- 至少提取 accepted scope、excluded scope、schema/data changes、compatibility window、rollback requirements、validation SQL/checks、constraints 和 source of truth artifacts。
- 如果 rollback requirements、compatibility window 或 validation checks 缺失，停止并请求确认。
- `01-delivery-requirements.md` 必须记录 source migration run path、migration phases、rollback / recovery obligations、destructive-operation boundaries 和 verification checks。
