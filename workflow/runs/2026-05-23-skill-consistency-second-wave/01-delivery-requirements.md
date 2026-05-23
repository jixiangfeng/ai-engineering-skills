# 01-delivery-requirements

- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- run 目录: `workflow/runs/2026-05-23-skill-consistency-second-wave`
- 生成时间: `2026-05-23 09:06:39 CST`
- 分支: `main`
- 基线提交: `0ab01a3`
- 执行代理: `codex`
- 当前状态: `pending_confirmation`

## 1. 原始任务

在第一波 skill 一致性补齐完成后，继续推进第二波增强工作。

## 2. 本轮建议目标

基于上一轮 review 结论，本轮聚焦第二波中最顺手、最有复用价值的 3 项：

1. 为非 delivery skill 补齐更明确的 document-contracts / artifact contract 参考文档。
2. 增强 `workflow-bootstrap`，让它对“继续已有 run / 使用 handoff / 不建 workflow 的概念问答”有更清晰规则。
3. 增加仓库级 `skill consistency checklist`，作为后续新增/修改 skill 的统一自检标准。

## 3. 范围内

- 允许修改：
  - `plugins/ai-engineering-skills/skills/workflow-bootstrap/**`
  - `plugins/ai-engineering-skills/skills/codebase-orientation/**`
  - `plugins/ai-engineering-skills/skills/code-review-triage/**`
  - `plugins/ai-engineering-skills/skills/debug-root-cause/**`
  - `plugins/ai-engineering-skills/skills/api-contract-design/**`
  - `plugins/ai-engineering-skills/skills/data-migration-planning/**`
  - `README.md`
  - `docs/skills-guide.zh-CN.md`
  - `docs/` 下新增少量仓库级约束文档（如 checklist）
- 允许新增：
  - references / contract 文档
  - skill consistency checklist

## 4. 范围外

- 不重构 `software-delivery-pipeline` 正文。
- 不处理 `workflow/` 的 git 策略。
- 不做 plugin marketplace 结构改造。
- 不改运行时/安装机制。
- 不回滚或覆盖第一波已产生的修改。

## 5. 约束

- 本轮应承认当前 worktree 已存在第一波未提交修改；不得混淆两轮目标。
- 第二波改动应建立在第一波之上，不得破坏第一波新引入的 state/restore 机制。
- 新增 contract/checklist 文档应尽量短、可复用、可交叉引用，避免把规则复制到多个地方形成分叉。
- `workflow-bootstrap` 增强应偏“路由纪律”和“继续已有 run 的优先级”，不要升级成新的复杂执行引擎。

## 6. 验收标准

- [ ] 至少为非 delivery skill 补出一套更清晰的 contract/reference 约束，且引用关系明确。
- [ ] `workflow-bootstrap/SKILL.md` 对继续已有 run、handoff 优先、概念问答不落 workflow 的规则更清楚。
- [ ] 仓库中存在一份可复用的 skill consistency checklist。
- [ ] README 或 `docs/skills-guide.zh-CN.md` 在必要处做小范围同步，避免新规则“只埋在 skill 内部”。
- [ ] 第二波 diff 范围清晰，不和第一波目标混淆。

## 7. 已识别风险

- 当前工作区已经带着第一波未提交修改，第二波如果直接大改，review 和提交边界会变模糊。
- 若 document-contracts 做得太散，会造成“规则写更多、但更难维护”。
- 若 `workflow-bootstrap` 写得太厚，可能和其“轻量路由器”定位冲突。

## 8. 需要主人确认的点

1. 本轮是否按我建议的这 3 项推进，而**暂不处理** `workflow/` git 策略与 `software-delivery-pipeline` 拆分？
   - 我建议：**是**，这样边界最稳。
2. skill consistency checklist 你更偏向：
   - A. 放在 `docs/` 作为仓库级规范文档
   - B. 放在某个 skill 的 references 里
   - 我建议：**A，放 `docs/`**，更像仓库标准而不是单个 skill 附件。

## 9. 证据依据

- `plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md` 当前偏轻，已有路由优先级和冲突规则，但对“继续已有 run / handoff 优先 / 何时不建 workflow”的执行约束仍较少。
- 当前只有 `software-delivery-pipeline/references/document-contracts.md` 具备较完整的文档契约表达；其它 skill 的 contract 约束仍主要散落在 `SKILL.md` 中。
- 第一波已补齐 state/restore 机制，第二波现在适合进一步统一约束层，而不是继续扩状态模板。

## 10. 当前工作区状态

当前存在第一波未提交改动：
- 已跟踪修改：
  - `docs/skills-guide.zh-CN.md`
  - `plugins/ai-engineering-skills/skills/api-contract-design/SKILL.md`
  - `plugins/ai-engineering-skills/skills/data-migration-planning/SKILL.md`
- 未跟踪新增：
  - `plugins/ai-engineering-skills/skills/api-contract-design/assets/api-contract-templates/api-contract-workflow-state.md`
  - `plugins/ai-engineering-skills/skills/data-migration-planning/assets/data-migration-templates/migration-workflow-state.md`
  - `plugins/ai-engineering-skills/skills/codebase-orientation/assets/orientation-templates/orientation-workflow-state.md`
  - `plugins/ai-engineering-skills/skills/debug-root-cause/assets/debug-templates/debug-workflow-state.md`
- 以及本轮/上轮 `workflow/` 产物

## 11. 下一步

等待主人确认本轮需求；确认后再进入计划阶段，不直接改代码。
