# Review 到交付流程交接单

## 文档元信息
- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- 生成时间: `2026-05-26`
- 当前分支 / commit: `main` / `25284f0`
- 执行 agent: `codex`
- 来源文档: `04-review-fix-plan.md`
- 文档状态: 待 software-delivery-pipeline 读取

## 文档状态
- 待 software-delivery-pipeline 读取

## 来源 Review Run
- 路径：`workflow/reviews/2026-05-26-skill-consistency-review/`

## 用户已确认的修复范围
- 已选 Findings：`F-001`、`F-002`、`F-003`
- 明确不修 Findings：无

## 修复目标摘要
- 修复 `software-delivery-pipeline` 在文件编号、模板集与仓库级文档之间的契约不一致问题。
- 修复 `code-review-triage` 的 `review-workflow-state` 模板误用 delivery 阶段表、误写 review 文件名的问题。
- 清理 `workflow-bootstrap` 的重复输出契约章节，降低维护分叉风险。

## Findings 明细

### F-001
- 严重级别：高
- 问题摘要：`software-delivery-pipeline` 的 `SKILL.md`、`docs/skills-guide.zh-CN.md`、references 与 `assets/workflow-templates/` 之间存在文件编号和模板文件名不一致；文档声称复杂路径会使用的若干模板在 assets 中并不存在。
- 证据位置：
  - `plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md:168-180`
  - `docs/skills-guide.zh-CN.md:296-316`
  - `plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates/`
  - `workflow/reviews/2026-05-26-skill-consistency-review/02-review-findings.md`
- 影响：复杂 delivery run 容易出现“按说明应使用某模板，但仓库里找不到”的情况，破坏文档驱动 workflow 的可执行性与一致性。
- 已确认修复方向：收敛到一套真实存在、可闭合的编号/模板体系，并同步更新相关 skill/docs/references，避免继续保留不存在的复杂后续模板路径。
- 验收标准：
  - `SKILL.md`、`docs/skills-guide.zh-CN.md`、`references/document-contracts.md`、`references/example-run.md`、`references/stage-playbook.md` 与 `assets/workflow-templates/` 的文件名契约一致。
  - 简单路径与有架构门禁路径都能纸面闭合，不再引用缺失模板。

### F-002
- 严重级别：高
- 问题摘要：`code-review-triage/assets/review-templates/review-workflow-state.md` 混入 delivery workflow 的阶段名和文件名，且把 `01-review-scope.md` 误写为 `01-review_scope.md`。
- 证据位置：
  - `plugins/ai-engineering-skills/skills/code-review-triage/SKILL.md:88-103`
  - `plugins/ai-engineering-skills/skills/code-review-triage/assets/review-templates/review-workflow-state.md:16-24`
  - `workflow/reviews/2026-05-26-skill-consistency-review/02-review-findings.md`
- 影响：review run 的 state / resume 协议会读取错误的阶段或文档名，导致恢复路径不可靠。
- 已确认修复方向：将 `review-workflow-state.md` 改为 review 专用阶段表，并让文件名与 `SKILL.md` 严格一致。
- 验收标准：
  - `review-workflow-state.md` 只引用 review workflow 自身产物。
  - 文件名统一为 `01-review-scope.md` 等 review 命名。
  - 模板能自然支持 findings → selection → plan → handoff/closure 的恢复语义。

### F-003
- 严重级别：中
- 问题摘要：`workflow-bootstrap/SKILL.md` 中 `Routing Output Contract` 与 `Output Behavior` 两段表达高度重复。
- 证据位置：
  - `plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md:123-139`
  - `workflow/reviews/2026-05-26-skill-consistency-review/02-review-findings.md`
- 影响：短期不阻塞执行，但增加后续维护时只改一处、另一处遗忘的分叉风险。
- 已确认修复方向：合并为单一输出契约章节，保留必要示例。
- 验收标准：
  - `workflow-bootstrap/SKILL.md` 中仅保留一处主输出契约。
  - 关键约束（说明 workflow、继续旧 run、避免重复开 workflow）仍完整保留。

## 用户约束
- 当前以仓库内 workflow 文档与 skill 元数据为依据推进。
- 本轮目标是修复已记录 findings，不额外扩大为全仓库重写。
- 若修复过程中发现必须扩大范围，需暂停并重新确认。

## 架构门禁建议
- 是否建议进入 `software-delivery-pipeline` 的架构设计阶段：否
- 原因：本次为文档契约与模板一致性修复，不涉及运行时架构、持久化结构、外部依赖、API 契约或并发模型变化；更像中小规模的仓库内文档/模板收敛任务。

## 修复计划摘要
1. 先以“收敛现有模板体系”为原则，统一 `software-delivery-pipeline` 的文件编号和模板说明。
2. 修正 `code-review-triage` 的 `review-workflow-state.md` 阶段表与文件名。
3. 清理 `workflow-bootstrap` 的重复输出契约章节。
4. 用仓库内 `rg` / 人工比对做一致性验证，确保相关文件名和阶段术语不再互相冲突。

## 验证要求
- 检索并核对所有 `delivery` 相关阶段文件名，确保 docs / references / assets / `SKILL.md` 一致。
- 检索 `01-review_scope.md`、`02-delivery-architecture.md` 等误写或混入项，确认 review state 模板已改正。
- 审阅 `workflow-bootstrap/SKILL.md`，确认输出契约去重后没有丢失必要约束。

## 禁止事项 / 不做范围
- 不新增新的 workflow 类型或产品级能力。
- 不改 plugin marketplace / plugin.json。
- 不重写与本次 findings 无关的其他 skill。
- 不修改历史 `workflow/runs/**` 产物。

## 澄清与收敛记录
- AI 发现的矛盾 / 缺口 / 风险 / 与代码现状冲突：`F-001` 有“补模板”与“收敛模板契约”两种修法。
- 提出的选项或替代方案：推荐收敛到一套真实存在、可闭合的编号/模板体系。
- 用户反馈：已确认“全修”，并确认按当前修复计划推进。
- 本轮更新结果：形成 review → delivery 的结构化 handoff。
- 未解决阻塞项：无。

## 交接说明
- `software-delivery-pipeline` 必须以本文件、`03-review-fix-selection.md`、`04-review-fix-plan.md` 作为需求输入，不得扩大到未选择的 Findings。

## 机器可读摘要

```yaml
source_review_run: "workflow/reviews/2026-05-26-skill-consistency-review"
selected_findings:
  - id: "F-001"
    severity: "high"
    evidence:
      - "plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md:168-180"
      - "docs/skills-guide.zh-CN.md:296-316"
      - "plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates/"
    accepted_scope:
      - "plugins/ai-engineering-skills/skills/software-delivery-pipeline/**"
      - "docs/skills-guide.zh-CN.md"
    excluded_scope:
      - "history workflow/runs/**"
    implementation_constraints:
      - "prefer contract convergence over adding a second full template branch"
      - "do not expand into unrelated skill rewrites"
    spec_compliance_review_required: false
    code_quality_review_required: true
    architecture_gate_recommended: false
    special_verification_focus:
      - "template filenames declared by skill/docs/references/assets must match"
    acceptance_criteria:
      - "declared delivery artifact filenames are consistent across skill/docs/references/assets"
      - "no missing template is referenced by the chosen numbering scheme"
  - id: "F-002"
    severity: "high"
    evidence:
      - "plugins/ai-engineering-skills/skills/code-review-triage/SKILL.md:88-103"
      - "plugins/ai-engineering-skills/skills/code-review-triage/assets/review-templates/review-workflow-state.md:16-24"
    accepted_scope:
      - "plugins/ai-engineering-skills/skills/code-review-triage/**"
    excluded_scope:
      - "review workflow core boundaries"
    implementation_constraints:
      - "keep review workflow read-only by default"
      - "state template must align with review stage names and artifact names"
    spec_compliance_review_required: false
    code_quality_review_required: true
    architecture_gate_recommended: false
    special_verification_focus:
      - "resume semantics after findings stage"
    acceptance_criteria:
      - "review state template references only review artifacts"
      - "review filenames use hyphenated names such as 01-review-scope.md"
  - id: "F-003"
    severity: "medium"
    evidence:
      - "plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md:123-139"
    accepted_scope:
      - "plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md"
    excluded_scope:
      - "routing logic changes beyond duplicate-text cleanup"
    implementation_constraints:
      - "retain routing output requirements while removing duplication"
    spec_compliance_review_required: false
    code_quality_review_required: true
    architecture_gate_recommended: false
    special_verification_focus:
      - "only one primary output contract remains"
    acceptance_criteria:
      - "duplicate output-contract sections are consolidated without losing key rules"
excluded_findings: []
constraints:
  - "fix only F-001/F-002/F-003"
  - "pause if scope expansion becomes necessary"
verification:
  - "grep and manually compare delivery artifact filenames across skill/docs/references/assets"
  - "check review-workflow-state template stage/file alignment"
  - "inspect workflow-bootstrap SKILL for duplicate output-contract removal"
architecture_gate:
  required: false
  reason: "documentation/template consistency repair only; no runtime architecture change"
forbidden_scope:
  - "plugin marketplace metadata"
  - "historical workflow/runs artifacts"
  - "unrelated skill rewrites"
```

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
| 本次仅修 `F-001`、`F-002`、`F-003` | `03-review-fix-selection.md` | 事实 | 高 | 主人已确认全修 |
| `F-001` 修法选择“收敛模板契约” | `04-review-fix-plan.md` | 事实 | 高 | 主人已确认计划 |
| 本次无需架构门禁 | `04-review-fix-plan.md` | 推断 | 中 | 基于当前修复类型判断 |

## 决策记录
| 决策项 | 选择 | 不选方案 | 原因 | 确认记录 |
| --- | --- | --- | --- | --- |
| `F-001` 修法 | 收敛到一套真实存在的编号/模板体系 | 补齐一整套复杂路径模板 | 改动更聚焦、维护成本更低 | 主人已确认计划 |
| 本次是否进入架构门禁 | 否 | 是 | 不涉及运行时架构变更 | 当前 handoff 结论 |

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
- 允许改变的行为：
  - 调整文档契约与模板命名一致性
  - 修复 review state 模板的恢复语义
  - 删除重复说明
- 不允许改变的行为：
  - 引入新的产品级能力或运行时逻辑
  - 借机修改本轮未审出的其他设计边界
- 超出范围时的处理：暂停并请求用户确认。

## 验证矩阵
| 验收项 / Finding | 验证方式 | 命令或步骤 | 结果 | 证据 | 未覆盖原因 |
| --- | --- | --- | --- | --- | --- |
| F-001 | 文件名全集一致性核对 | `rg` 搜索 `delivery` 阶段文件名并人工比对 assets / docs / references / skill | 待执行 | 修改后的 grep 输出 | 需在 delivery 中执行 |
| F-002 | review state 模板对齐检查 | 检查阶段表与 `SKILL.md` 文件名/阶段名是否一一对应 | 待执行 | 修改后的模板内容 | 需在 delivery 中执行 |
| F-003 | 文档去重检查 | 检查 `workflow-bootstrap/SKILL.md` 仅保留一处输出契约 | 待执行 | 修改后的 SKILL diff | 需在 delivery 中执行 |
