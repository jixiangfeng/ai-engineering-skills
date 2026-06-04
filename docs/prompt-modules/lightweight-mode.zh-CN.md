# Lightweight Mode 模块

本模块用于控制 workflow 产物数量，避免小任务生成完整阶段文档。详细模式语义见 `docs/execution-modes.zh-CN.md`。

## 模式选择

- `lightweight` / fast: 小改、快速看下、简单修复、轻量问答后的最小 workflow；只生成 `workflow-state.json` 和 summary / verification note。
- `standard` / guarded: 普通 review/debug/design/planning/delivery；默认生成 **workflow-specific slim default artifacts**，而不是所有 workflow 共用一套固定文件名。
- `full` / audited: 用户要求完整、深度、形成文档、handoff、可恢复，或任务风险较高；生成完整阶段链路。

### `standard` 的具体落地

- 对 `codebase-orientation`、`code-review-triage`、`debug-root-cause`、`api-contract-design`、`data-migration-planning`，`standard` 默认使用各自的 `10~13` slim 主文档。
- 对 `software-delivery-pipeline`，`standard` / `guarded` 可以使用合并后的交付文档，例如 `10-guarded-scope-plan.md`、`11-guarded-execution.md`、`12-guarded-summary.md`。
- old split / expanded trail 只用于 compatibility、resume、显式审计需求或用户明确要求，不作为新 run 默认产物。

## 执行规则

1. 每个 workflow 开始前必须选择并记录 `executionMode`。
2. 小任务默认 `lightweight`，除非证据、风险或用户要求需要升级。
3. `lightweight` 不等于无状态；仍必须有严格符合 `docs/workflow-state-schema.json` 的机器可读 state 和 summary。
4. 如果用户明确表达“直接改 / 直接做 / 改完告诉我验证结果 / 不要铺太多文档”，且任务仍满足 fast 条件，应优先保持 `lightweight`，不要为了流程感强行升级到 `standard`。
5. `standard` 可用于仍需 scope/plan 锁定但不值得展开完整审计链路的普通实现；若用户的初始指令已经明确批准该最小范围、计划方向和验证目标，可把这条初始指令记录为 combined gate 的 approval basis，避免额外往返一次低价值确认。
6. 任务扩大、出现 handoff、需要恢复或需要审计时，先说明原因，再升级为 `standard` 或 `full`。
7. summary 必须记录已生成和已跳过的产物。
8. 跳过重阶段时优先使用 `docs/prompt-modules/conditional-blocks.zh-CN.md` 的 skipped reason，而不是保留空模板。

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
- “直接把 README 里一个错别字改掉，改完告诉我验证结果”使用 `lightweight`，不再展开额外确认门禁。
- “普通 review 一个模块并给出修复范围”使用 `standard`，对 `code-review-triage` 产出 `10-review-scope.md`、`11-review-findings.md`、`12-review-fix-plan.md`、`13-review-summary.md`。
- “把这个局部 bugfix 先锁范围后直接改，改完给我验证结果”在低风险前提下可使用 `standard`，并把用户原话记录为 combined gate 的 approval basis。
- “深度 review 并形成文档”使用 `full`。

## 反例

- 小改也默认生成 01-07 全部阶段文档。
- 用户已经明确要求直接执行、风险也低，却因为“看起来更正规”强行升级到 guarded。
- 把所有 workflow 的 `standard` 都写成 `10-guarded-scope-plan.md`、`11-guarded-execution.md`、`12-guarded-summary.md`。
- 跳过阶段文档但不记录跳过原因。
