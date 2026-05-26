# 需求确认

## 文档元信息
- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- 生成时间: `2026-05-26`
- 当前分支 / commit: `main` / `25284f0`
- 执行 agent: `codex`
- 来源文档: `workflow/reviews/2026-05-26-skill-consistency-review/review-to-delivery-handoff.md`
- 文档状态: 待用户确认

## 文档状态
- 待用户确认

## 原始请求
- 用户原始任务：熟悉 `ai-engineering-skills` 仓库后，对仓库做正式 review，并在确认后修复选中的 findings。

## Review 交接来源
- 来源 review run：`workflow/reviews/2026-05-26-skill-consistency-review/`
- handoff 文件：`workflow/reviews/2026-05-26-skill-consistency-review/review-to-delivery-handoff.md`
- 已选 Findings：`F-001`、`F-002`、`F-003`
- 明确不修 Findings：无

## 目标结果
- 修复 `software-delivery-pipeline` 的文档编号/模板契约不一致问题，使 `SKILL.md`、docs、references 与 assets 的文件名说明闭合一致。
- 修复 `code-review-triage` 的 `review-workflow-state.md` 模板，使其与 review workflow 的真实阶段和文件名一致。
- 清理 `workflow-bootstrap/SKILL.md` 中重复的输出契约说明，保留一套清晰规则。

## 范围
- 范围内：
  - `plugins/ai-engineering-skills/skills/software-delivery-pipeline/**`
  - `plugins/ai-engineering-skills/skills/code-review-triage/**`
  - `plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md`
  - `docs/skills-guide.zh-CN.md`
- 范围外：
  - 其他 skill 的主要流程
  - plugin marketplace / plugin.json
  - 历史 `workflow/runs/**` 产物
  - 与本次 findings 无关的全仓库措辞统一

## 约束
- 只修 `F-001`、`F-002`、`F-003`，不得扩大为新的 review 批次。
- `F-001` 采用“收敛到一套真实存在的编号/模板体系”的修法，不走“补齐第二套复杂模板分支”的方向。
- 当前 worktree 已有未提交的 `workflow/orientation/`、`workflow/reviews/` 文档，本次实现不得误改这些并行产物。
- 需求确认前不进入计划或代码修改阶段。

## 假设
- `software-delivery-pipeline` 当前的模板文件集代表仓库已有的主路径，收敛到该路径比扩展一套复杂分支更符合现状。
- 本次不需要独立架构设计文档，因为不涉及运行时架构、API 契约、持久化结构或外部依赖变化。

## 验收标准
- [ ] `software-delivery-pipeline` 的 `SKILL.md`、`docs/skills-guide.zh-CN.md`、`references/document-contracts.md`、`references/stage-playbook.md`、`references/example-run.md` 与 `assets/workflow-templates/` 的文件名契约一致，不再引用缺失模板。
- [ ] `code-review-triage/assets/review-templates/review-workflow-state.md` 只引用 review 自身阶段与文件名，且修正 `01-review-scope.md` 的命名。
- [ ] `workflow-bootstrap/SKILL.md` 中仅保留一处输出契约主规则，且没有丢失“说明 workflow / 继续旧 run / 不重复开并行 workflow”等关键约束。
- [ ] 修改后可通过 grep / 人工比对证明相关文件名与阶段术语不再互相冲突。

## 未知项 / 问题
- 无阻塞未知项。
- 在计划阶段仍需明确：对于 `software-delivery-pipeline`，具体保留哪些“双路径编号”说明、哪些应删除或改写，以避免和 assets 冲突。

## 澄清与收敛记录
- AI 发现的矛盾 / 缺口 / 风险 / 与代码现状冲突：`F-001` 的关键风险在于多处文档都写了不同编号路径，若只改一部分，会留下新的不一致。
- 提出的选项或替代方案：采用“以现有 assets 为锚点收敛命名契约”的方案，而不是再扩充第二套模板文件。
- 用户反馈：已确认 review 修复计划。
- 本轮更新结果：形成 delivery 需求文档，并锁定实现范围与验收标准。
- 未解决阻塞项：无。

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
| 本次输入来自 review handoff | `workflow/reviews/2026-05-26-skill-consistency-review/review-to-delivery-handoff.md` | 事实 | 高 |  |
| 已选 Findings 为 `F-001`、`F-002`、`F-003` | `workflow/reviews/2026-05-26-skill-consistency-review/03-review-fix-selection.md` | 事实 | 高 |  |
| `F-001` 修法选择“收敛契约” | `workflow/reviews/2026-05-26-skill-consistency-review/04-review-fix-plan.md` | 事实 | 高 |  |
| 当前 worktree 已有并行 workflow 文档 | 当前 `git status --short` 输出 | 事实 | 高 | `workflow/orientation/`、`workflow/reviews/` 未提交 |

## 范围锁定
- 允许修改 / 关注的目录或文件：
  - `plugins/ai-engineering-skills/skills/software-delivery-pipeline/**`
  - `plugins/ai-engineering-skills/skills/code-review-triage/**`
  - `plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md`
  - `docs/skills-guide.zh-CN.md`
- 禁止修改 / 不关注的目录或文件：
  - 其他 skill 的主要流程
  - plugin marketplace / plugin.json
  - 已存在的历史 `workflow/runs/**`
  - `workflow/orientation/**`、`workflow/reviews/**` 作为本次实现对象之外的并行/上游产物
- 允许改变的行为：
  - 调整文档契约与模板命名一致性
  - 修复 review state 模板恢复语义
  - 删除重复说明
- 不允许改变的行为：
  - 引入新的 workflow 类型或运行时能力
  - 扩展到未选 findings
- 超出范围时的处理：暂停并请求用户确认。

## 验收样例
| 场景 | 前置条件 / 输入 | 操作 | 预期结果 | 关联需求 / Finding |
| --- | --- | --- | --- | --- |
| delivery 模板核对 | 读取 `SKILL.md`、docs、references、assets | 比对文件名全集 | 各处不再引用不存在的模板 | F-001 |
| review state 恢复模板核对 | 读取 `review-workflow-state.md` 与 `code-review-triage/SKILL.md` | 比对阶段表与文件名 | 仅包含 review workflow 的阶段与文件名 | F-002 |
| bootstrap 输出契约核对 | 读取 `workflow-bootstrap/SKILL.md` | 检查重复章节 | 只保留一套输出契约规则 | F-003 |

## 决策记录
| 决策项 | 选择 | 不选方案 | 原因 | 确认记录 |
| --- | --- | --- | --- | --- |
| `F-001` 修法 | 收敛到一套真实存在的编号/模板体系 | 补齐一整套复杂路径模板 | 改动更聚焦，与现有 assets 更一致 | review 计划已确认 |
| 是否进入架构门禁 | 否 | 是 | 不涉及运行时架构变化 | review handoff 结论 |

## 变更记录
| 轮次 | 用户反馈 | 文档更新 | 当前状态 |
| --- | --- | --- | --- |
| 1 | 确认 review 修复计划 | 写入 delivery 需求、锁定范围和验收标准 | 待确认 |

## 用户确认记录
- 待确认；确认前不得进入计划或实现阶段。
