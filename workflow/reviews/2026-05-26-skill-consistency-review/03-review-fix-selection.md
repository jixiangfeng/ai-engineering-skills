# 03-review-fix-selection

## 文档元信息
- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- 生成时间: `2026-05-26`
- 当前分支 / commit: `main` / `25284f0`
- 执行 agent: `codex`
- 来源文档: `02-review-findings.md`
- 文档状态: 已确认

## 文档状态
- 已由主人确认：全修

## 已选择修复的问题
- `F-001`：修复 `software-delivery-pipeline` 的文档/模板文件名契约不一致问题
- `F-002`：修复 `code-review-triage` 的 `review-workflow-state` 模板误用 delivery 阶段表问题
- `F-003`：清理 `workflow-bootstrap` 中重复的输出契约章节

## 明确不修的问题
- 无

## 用户约束
- 当前以仓库内 workflow 文档与 skill 元数据为依据推进
- 本轮目标是修复已记录 findings，不额外扩大为全仓库重写
- 若修复过程中发现必须扩大范围，需暂停并重新确认

## 选择依据
- 主人明确选择“全修”
- `F-001` 与 `F-002` 会影响执行一致性、恢复协议或模板发现，属于优先级较高的问题
- `F-003` 虽不阻塞执行，但与本轮“统一仓库契约、减少分叉”的目标一致，纳入本次一起处理是合理的

## 澄清与收敛记录
- AI 发现的矛盾 / 缺口 / 风险 / 与代码现状冲突：`F-001` 涉及“补模板”与“收敛编号体系”两种修法，进入计划阶段需要先明确偏好路径
- 提出的选项或替代方案：倾向优先选择“收敛到一套真实存在的编号/模板体系”，因为改动面更小，也更容易与现有示例和历史 run 对齐
- 用户反馈：主人明确要求“全修”
- 本轮更新结果：已锁定 `F-001`、`F-002`、`F-003` 全部进入计划范围
- 未解决阻塞项：`F-001` 的具体修法仍需在计划中给出并确认

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
| 主人选择全修 | 当前对话：“全修” | 事实 | 高 | 作为 fix selection 的直接依据 |
| `F-001`、`F-002`、`F-003` 为当前 findings 范围 | `workflow/reviews/2026-05-26-skill-consistency-review/02-review-findings.md` | 事实 | 高 |  |

## 决策记录
| 决策项 | 选择 | 不选方案 | 原因 | 确认记录 |
| --- | --- | --- | --- | --- |
| 修复范围 | `F-001` + `F-002` + `F-003` | 仅修高优先级 / 只记录不修 | 主人明确要求全修 | 当前对话：“全修” |

## 范围锁定
- 允许修改 / 关注的目录或文件：
  - `plugins/ai-engineering-skills/skills/software-delivery-pipeline/**`
  - `plugins/ai-engineering-skills/skills/code-review-triage/**`
  - `plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md`
  - `docs/skills-guide.zh-CN.md`
  - 如为消除 `F-001` 所必需，可同步修改与其直接相关的 `references/document-contracts.md`、`references/example-run.md`、`references/stage-playbook.md`
- 禁止修改 / 不关注的目录或文件：
  - 其他 skill 的行为规则与模板正文，除非被证明必须联动
  - plugin marketplace 元数据
  - 与本次 findings 无关的历史 `workflow/runs/` 产物
- 允许改变的行为：
  - 统一文档编号/模板契约
  - 修正 review state 模板阶段表
  - 清理重复说明，降低维护分叉
- 不允许改变的行为：
  - 新增与本轮 findings 无关的 workflow 机制
  - 借机重写整套 delivery/review 方法论
- 超出范围时的处理：暂停并请求用户确认。

## 变更记录
| 轮次 | 用户反馈 | 文档更新 | 当前状态 |
| --- | --- | --- | --- |
| 1 | 全修 | 锁定 `F-001`/`F-002`/`F-003` 为修复范围 | 已确认 |

## 用户确认记录
- 主人已确认：全修。
