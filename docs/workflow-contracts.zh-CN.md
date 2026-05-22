# Workflow Contracts

本文件定义 `ai-engineering-skills` 中跨 workflow 共享的最小契约，目的是让不同 skill 之间的路由、恢复、交接、总结和验证保持一致，避免命名漂移、字段缺失和 run 中断后的状态丢失。

## State File Contract

所有 workflow state 文件统一采用 `*-workflow-state.md` 命名，例如：

- `orientation-workflow-state.md`
- `review-workflow-state.md`
- `debug-workflow-state.md`
- `delivery-workflow-state.md`

每个 state 文件至少应包含：

- 当前阶段
- 当前状态
- 下一步
- 是否允许改代码
- 当前 run 路径
- 上游输入文档或 source artifact（如适用）
- 当前阻塞项（如有）

## Summary Contract

所有 workflow summary 文件至少应包含：

- 当前结论
- 已确认 scope
- 未解决问题
- 主要风险
- 推荐下一步
- 推荐下一个 workflow 及原因（如适用）

## Handoff Contract

所有 handoff 文件统一采用 `*-to-*-handoff.md` 命名。

handoff 文件至少应包含：

- source run path
- accepted scope
- excluded scope
- evidence
- constraints
- unresolved questions
- verification focus
- why the next workflow is appropriate

如果 handoff 来自 findings、debug hypothesis、contract proposal 或 migration plan，应该尽可能保留结构化字段，而不是只写自然语言段落。

## Naming Contract

新 run 必须使用带 workflow 前缀的产物文件名，不再生成无前缀旧命名文件。

统一规则包括：

- state 文件：`*-workflow-state.md`
- handoff 文件：`*-to-*-handoff.md`
- summary 文件：`07-*-summary.md` 或该 workflow 已定义的末阶段 summary 文件
- review 回写结果：`review-delivery-result.md`
- 其余阶段文件：`NN-<workflow>-<stage>.md`

## Resume Contract

所有 workflow 在恢复执行时应遵循统一顺序：

1. 读取 workflow state 文件
2. 读取 state 中记录的最新阶段文档
3. 检查当前 git diff/status（如任务与代码变更相关）
4. 明确当前阶段、阻塞项、是否允许改代码
5. 只从 state 记录的下一步继续
