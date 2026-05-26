# Examples Policy

本文定义标准示例的维护边界，避免示例过重导致后续漂移。

## 当前策略

每个实际 workflow 必须维护一个 `examples/standard-run.md`，用于展示：

- run 基本信息
- state snapshot
- `workflow-state.json` 同步要求
- summary / handoff / verification 的标准形态
- 该 workflow 最容易被 agent 模仿的关键输出

## 不默认维护完整 01-07/08 示例

完整阶段产物示例会显著增加维护成本。除非某个 workflow 的输出稳定性明显不足，否则不为所有 workflow 复制完整阶段文件。

跨 workflow 的完整参考示例放在 `docs/full-run-examples/`。其中 `software-delivery-pipeline/full-run.md` 是最完整的端到端样例，其余 workflow 提供 full-run 骨架和 handoff 形态。

如果未来需要更细的完整示例，优先只给目标 workflow 扩展 `docs/full-run-examples/<workflow>/`，并同步：

- `SKILL.md` references
- `scripts/check-consistency.sh`
- `CHANGELOG.md`

## 质量要求

标准示例必须短小、可模仿、不过度规定业务细节。它应表达结构和约束，而不是替代 `assets/` 模板或 `docs/workflow-contracts.zh-CN.md` 契约。
