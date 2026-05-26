# Full Run 示例

本目录保存比 `examples/standard-run.md` 更完整的 workflow 产物示例，用于展示完整阶段串联、机器可读元数据、Verification gate、handoff 和收尾纪律。

维护原则：

- `standard-run.md` 是每个 skill 的最小标准样例。
- `docs/full-run-examples/` 是完整参考样例，不要求每次规则小改都复制大量文本。
- 新增 workflow contract 字段时，优先更新 `software-delivery-pipeline/full-run.md`，再按需要更新其他 workflow 骨架。
- 示例只表达产物形态，不代表真实业务代码。

## 当前示例

- `software-delivery-pipeline/full-run.md`：完整 delivery run，从需求、计划、实现、验证到总结。
- `codebase-orientation/full-run.md`：完整只读熟悉 run 骨架。
- `code-review-triage/full-run.md`：完整 review 到 delivery handoff 骨架。
- `debug-root-cause/full-run.md`：完整 debug 到 delivery handoff 骨架。
- `api-contract-design/full-run.md`：完整 API 契约到 delivery handoff 骨架。
- `data-migration-planning/full-run.md`：完整迁移规划到 delivery handoff 骨架。

每个 workflow 目录下的 `files/` 包含按该 workflow required files 展开的阶段文件示例，用于检查完整 run 文件集是否仍能跟随模板和 contract 演进。
