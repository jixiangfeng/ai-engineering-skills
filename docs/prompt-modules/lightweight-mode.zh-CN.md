# Lightweight Mode 模块

本模块用于控制 workflow 产物数量，避免小任务生成完整阶段文档。详细模式语义见 `docs/execution-modes.zh-CN.md`。

## 模式选择

- `lightweight` / fast: 小改、快速看下、简单修复、轻量问答后的最小 workflow；只生成 `workflow-state.json` 和 summary / verification note。
- `standard` / guarded: 普通 review/debug/design/planning/delivery；生成 scope、plan、implementation、verification 等关键阶段文档。
- `full` / audited: 用户要求完整、深度、形成文档、handoff、可恢复，或任务风险较高；生成完整阶段链路。

## 执行规则

1. 每个 workflow 开始前必须选择并记录 `executionMode`。
2. 小任务默认 `lightweight`，除非证据、风险或用户要求需要升级。
3. `lightweight` 不等于无状态；仍必须有严格符合 `docs/workflow-state-schema.json` 的机器可读 state 和 summary。
4. 任务扩大、出现 handoff、需要恢复或需要审计时，先说明原因，再升级为 `standard` 或 `full`。
5. summary 必须记录已生成和已跳过的产物。
6. 跳过重阶段时优先使用 `docs/prompt-modules/conditional-blocks.zh-CN.md` 的 skipped reason，而不是保留空模板。

## 输出要求

```md
## Execution Mode

- executionMode: lightweight / standard / full
- modePath: fast / guarded / audited
- Reason:
- Produced artifacts:
- Skipped artifacts:
- Upgrade condition:
```

`workflow-state.json` 必须包含 `schemaVersion`、`workflow`、`runPath`、`executionMode`、`modePath`、`status`、`currentStage`、`nextAction`、`codeEditsAllowed`、`riskLevel`、`riskReason`、`confirmationRequired`、`rollbackRequired`、`updatedAt`，且不得包含 schema 未声明的额外字段。

## 正例

- “简单修复一个文案”使用 `lightweight`，只产出 state 和 summary。
- “深度 review 并形成文档”使用 `full`。

## 反例

- 小改也默认生成 01-07 全部阶段文档。
- 跳过阶段文档但不记录跳过原因。
