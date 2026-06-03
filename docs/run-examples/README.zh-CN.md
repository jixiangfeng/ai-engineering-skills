# Run Examples

本目录展示 `software-delivery-pipeline` 在不同 executionMode 下的推荐产物形态。

- `fast-patch/`: `lightweight` / fast，小范围低风险修改，只保留最小说明和验证证据。
- `guarded-change/`: `standard` / guarded，普通实现或 bugfix，默认收缩为 `scope+plan`、`execution`、`summary` 三份主文档。
- `audited-delivery/`: `full` / audited，高风险或 handoff 交付，保留完整门禁链路。

这些示例用于说明“自适应重量”而不是替代 `docs/full-run-examples/` 的完整 artifact 示例。不要把 full-run 示例当作默认路径；full-run 只代表 audited 场景。
