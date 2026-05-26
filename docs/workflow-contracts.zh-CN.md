# Workflow Contracts

本文件定义 `ai-engineering-skills` 中跨 workflow 共享的最小契约，目的是让不同 skill 之间的路由、恢复、交接、总结和验证保持一致，避免命名漂移、字段缺失和 run 中断后的状态丢失。

## Shared Artifact Templates

共享 artifact 模板位于 `docs/artifact-templates/`，作为各 workflow 模板的 canonical 参考：

- `state.md`
- `stage-document.md`
- `summary.md`
- `handoff.md`
- `stop-record.md`

各 skill 可以保留自己的领域字段，但不能删除共享模板要求的核心信息：文档元信息、scope、证据、事实/推断/待确认、决策记录、验证关注点、下一步、handoff 范围和约束。

新增或修改 workflow 模板时，应先检查共享模板，再添加领域字段，避免每个 skill 自行发明一套 state / summary / handoff / stage document 格式。

## Stop and Confirmation Contract

所有 workflow 遇到以下情况必须暂停，并向用户确认后再继续：

- 准备修改代码、配置、生成文件或安装目录，但当前 workflow / stage 未明确允许改动。
- 需要扩大已确认 scope，或要处理用户未选择的 finding / hypothesis / plan item。
- 需要执行 destructive、高成本、不可轻易回滚或会影响真实本地环境的命令。
- 存在多个可行修复、设计或迁移方向，且选择会影响接口、数据、行为或后续维护。
- Markdown state 与 `workflow-state.json`、`workflow/index.md` 或最新阶段文档互相冲突。
- handoff 缺失、不完整，或上游 artifact 不能支撑当前 workflow 继续执行。
- 已选择的 scope 不足以继续，例如发现前置需求、契约、数据条件或权限信息缺失。
- 验证被阻塞、失败或只能跳过，而下一步依赖验证结论。
- 用户请求与代码证据、已批准计划或 workflow 契约冲突。
- 当前 worktree 存在可能被本轮改动影响的预存变更。
- 恢复 workflow 时找到多个候选 run，或最新候选为 `completed` / `abandoned`。

暂停时必须说明：

- 触发暂停的条件。
- 已确认事实和证据。
- 可选继续方向及主要影响。
- 推荐选择（如能给出）和原因。
- 暂停期间不得执行的动作。

如果已有 run 目录，应把暂停记录写入当前阶段文档的“停止 / 确认记录”，或单独写入 `stop-record.md`。同时更新 `*-workflow-state.md` 和 `workflow-state.json`：`status` 应设为 `pending_human_confirmation` 或 `blocked`，`nextAction` 应明确等待用户确认的事项。

## Execution Mode Contract

workflow 可以按任务风险选择轻量模式或完整模式，但必须在 state 和 summary 中记录选择理由。

轻量模式适用于：

- scope 很小，且用户不需要完整阶段产物。
- 不涉及代码编辑，或只需要 orientation / review / debug / contract 的结论摘要。
- 不涉及跨模块改动、数据迁移、接口兼容、生产风险或多个修复方向。

轻量模式至少产出：

- `*-workflow-state.md`
- `workflow-state.json`
- summary 或当前阶段结论文档

完整模式适用于：

- 需要实现、修复、迁移、接口契约落地或跨 workflow handoff。
- 用户要求完整流程、可审计产物或后续恢复。
- 任务有较高风险、多个阶段门禁、多个可行方向或验证成本。

完整模式应按对应 workflow 的 required files 产出阶段文档。用户没有明确要求“轻量”时，review、debug、contract、migration、delivery 默认按完整模式推进；orientation 可以先轻量熟悉，必要时再补完整阶段。

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

## Machine-Readable State Contract

每个 workflow run 除 Markdown state 文件外，推荐同时维护 `workflow-state.json`，用于 agent 自动恢复、脚本校验和统计。

新建 run 时可以用 `scripts/generate-workflow-state.py` 生成初始 `workflow-state.json`，再用 `scripts/validate-workflow-state.py` 或 `scripts/check-workflow-state.sh` 校验。

`workflow-state.json` 必须符合 `docs/workflow-state-schema.json` 的最小字段：

- `schemaVersion`: 当前为 `1.0`
- `workflow`: workflow 名称，例如 `codebase-orientation`
- `runPath`: 当前 run 路径
- `sourceArtifact`: 上游输入文档或 `null`
- `status`: `not_started` / `in_progress` / `blocked` / `pending_human_confirmation` / `handoff_ready` / `completed` / `abandoned`
- `currentStage`: 当前阶段
- `latestDocument`: 最新阶段文档或 `null`
- `nextAction`: 下一步
- `codeEditsAllowed`: 是否允许改代码
- `blockers`: 阻塞项数组
- `selectedScope`: 当前确认范围或 `null`
- `updatedAt`: 更新时间

Markdown state 面向人类阅读；`workflow-state.json` 面向自动恢复和校验。两者内容冲突时，必须暂停并要求人工确认，而不是静默选择其中一个。

新 workflow 或模板更新时，应优先保持 JSON 字段稳定；如果必须变更字段，需同步更新 schema、示例、README/测试说明和发布检查清单。

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

## Handoff Flow Contract

允许的跨 workflow handoff：

| Source | Target | Handoff file | 必须携带 |
| --- | --- | --- | --- |
| `codebase-orientation` | `code-review-triage` | `orientation-to-review-handoff.md` | confirmed scope、key modules、review leads、evidence sources、unresolved questions |
| `codebase-orientation` | `software-delivery-pipeline` | `orientation-to-delivery-handoff.md` | business goal、affected modules、constraints、unresolved questions、why direct delivery is appropriate |
| `code-review-triage` | `software-delivery-pipeline` | `review-to-delivery-handoff.md` | selected findings、excluded findings、evidence、constraints、fix plan summary、verification focus |
| `debug-root-cause` | `software-delivery-pipeline` | `debug-to-delivery-handoff.md` | root cause、selected fix option、affected files、scope lock、risks、verification focus |
| `api-contract-design` | `software-delivery-pipeline` | `api-to-delivery-handoff.md` | endpoint/DTO decisions、compatibility decision、validation/error behavior、examples、forbidden changes |
| `data-migration-planning` | `software-delivery-pipeline` | `migration-to-delivery-handoff.md` | schema/data changes、rollout phases、compatibility window、rollback requirements、validation SQL |

handoff 接收规则：

- 下游 workflow 必须先读取 handoff，再写自己的 `01-*` 阶段文档。
- handoff 是 source of truth；不得依赖聊天上下文补范围。
- 下游不得处理 handoff 明确 excluded 的 scope。
- 如果 handoff 缺失关键字段，下游必须按 `Stop and Confirmation Contract` 暂停确认。
- 如果用户要求“按 handoff 落地”，默认进入 `software-delivery-pipeline`，除非 handoff 指向其他 target workflow。

非上述流转关系需要用户明确确认，并在当前阶段文档记录原因。

## Documentation Boundary Contract

仓库文档职责边界：

- `README.md`：只讲项目定位、安装入口、核心 skill 列表、最小使用路径和检查命令。
- `docs/`：承载规范、契约、维护、测试、版本、发布和详细使用说明。
- `SKILL.md`：只写 agent 执行规则、触发边界、阶段流程、产物列表和必要 reference/example 链接。
- `assets/`：只放 workflow 产物模板。
- `references/`：放领域内较长的指南、质量规则、文档契约。
- `examples/`：放标准 run 示例，不替代模板和契约。

同一规则应优先只有一个 source of truth。README 可以链接规则但不复制细节；SKILL.md 可以引用 `docs/` 或 `references/`，但不应复制长篇通用契约。

## Workflow Index Contract

每个项目根目录可以维护 `workflow/index.md`，用于登记 workflow run。推荐格式见 `docs/workflow-index-template.md`。

`workflow/index.md` 至少应记录：

- Updated At
- Workflow
- Status
- Scope
- Run Path
- Summary
- Next Action

创建新 run 时应新增索引行；状态变化、handoff 生成、summary 完成时应更新索引行。

可以用 `scripts/update-workflow-index.py` 根据 `workflow-state.json` 新增或更新 `workflow/index.md`。同一 `runPath` 重复写入时必须更新原行，而不是追加重复记录。

如果索引不存在，agent 可以扫描 `workflow/` 下的 state 文件作为 fallback，但扫描结果只能作为候选，不能跳过确认。

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

1. 如果用户提供 run 路径或 state 文件路径，优先读取该路径。
2. 如果用户未提供路径，先查当前项目根目录的 `workflow/index.md`。
3. 如果 `workflow/index.md` 不存在，再扫描 `workflow/` 下的 `workflow-state.json` 和 `*-workflow-state.md`。
4. 如果找到多个未完成候选，列出候选 run path、workflow、status、scope、updatedAt，让用户确认。
5. 读取 Markdown state 和 `workflow-state.json`（如存在），检查二者是否冲突。
6. 读取 state 中记录的最新阶段文档。
7. 检查当前 git diff/status（如任务与代码变更相关）。
8. 明确当前阶段、阻塞项、是否允许改代码。
9. 只从 state 记录的下一步继续。

`completed` run 默认不自动继续。用户说“继续上次 workflow”且最新候选为 `completed` 时，应说明该 run 已完成，并询问是 reopen 该 run、基于该 summary 开启新 workflow，还是查看结果。

`abandoned` run 不应自动恢复。除非用户明确指定该 run 并要求恢复，否则只作为历史记录展示。
