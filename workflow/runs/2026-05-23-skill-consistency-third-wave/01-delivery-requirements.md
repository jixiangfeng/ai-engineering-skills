# 01-delivery-requirements

- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- run 目录: `workflow/runs/2026-05-23-skill-consistency-third-wave`
- 生成时间: `2026-05-23 09:28:10 CST`
- 分支: `main`
- 基线提交: `0ab01a3`
- 执行代理: `codex`
- 当前状态: `pending_confirmation`

## 1. 原始任务

在第一波与第二波完成后，继续第三波补齐，使 design / migration 侧也具备独立的 document-contracts 承载层。

## 2. 本轮目标

本轮只做两项：

1. 为 `api-contract-design` 增加独立的 `document-contracts` 文档。
2. 为 `data-migration-planning` 增加独立的 `document-contracts` 文档。

并在必要处补最小范围同步，使 `SKILL.md`、`references/`、guide/README 的关系更清楚。

## 3. 范围内

- 允许修改：
  - `plugins/ai-engineering-skills/skills/api-contract-design/**`
  - `plugins/ai-engineering-skills/skills/data-migration-planning/**`
  - `docs/skills-guide.zh-CN.md`
  - `README.md`（仅当确有必要）
- 允许新增：
  - `api-contract-design/references/api-contract-document-contracts.md`
  - `data-migration-planning/references/data-migration-document-contracts.md`

## 4. 范围外

- 不再扩展 orientation / review / debug 的 contract 文档。
- 不重改第一波 state/resume/stage 结构。
- 不继续增强 `workflow-bootstrap`。
- 不处理 `workflow/` git 策略。
- 不做提交整理。

## 5. 约束

- 本轮目标是把第二波留下的 design/migration contract 缺口补齐，不额外发明一套更重体系。
- contract 文档应当和第二波新增的 orientation/review/debug contract 风格一致：
  - 简洁
  - 最小必要
  - 以“文档至少要回答什么”为核心
- 不要把 delivery 的大模板原样复制过来。
- 若新增 document-contracts 文档，需要让 `SKILL.md` 的 References 段或相关位置能自然指向它。

## 6. 验收标准

- [ ] `api-contract-design` 有独立的 document-contracts 文档
- [ ] `data-migration-planning` 有独立的 document-contracts 文档
- [ ] 两份文档风格与第二波新增 contract 文档相容
- [ ] `SKILL.md` 或 guide 中对这些 contract 承载点的可发现性比现在更清楚
- [ ] 本轮改动不扩散到范围外目标

## 7. 已识别风险

- 由于当前 worktree 叠加着前两波未提交修改，第三波如果顺手继续改太多，很容易让提交边界继续变厚。
- 如果 document-contracts 写得太细，会和 guideline / SKILL.md 出现重复；写得太少，则无法起到稳定承载作用。

## 8. 需要主人确认的点

1. 本轮是否就按“仅补 design/migration document-contracts + 最小同步”推进？
   - 我建议：**是**，这样第三波边界最清楚。
2. 若 `README.md` 已有 checklist 和 guide 入口，本轮是否可以只同步 `docs/skills-guide.zh-CN.md`，而不强制再动 README？
   - 我建议：**可以**，除非做完后发现 README 缺入口才再补。

## 9. 证据依据

- 第二波已新增：
  - `orientation-document-contracts.md`
  - `review-document-contracts.md`
  - `debug-document-contracts.md`
- 但 `api-contract-design` 与 `data-migration-planning` 目前仍只有 guideline / SKILL 规则，没有独立的 document-contracts 承载点。
- 第一波已为这两个 skill 补了 state / resume / stages，因此现在继续补 contract 层是自然收尾。

## 10. 当前工作区状态

当前 worktree 已叠加：
- 第一波修改（state/resume/stage 补齐）
- 第二波修改（bootstrap/checklist/部分 contract 文档）
- 本轮 `workflow/` 产物

第三波会在此基础上继续，但只处理 design/migration contract 缺口。

## 11. 下一步

等待主人确认需求；确认后再进入计划阶段，不直接改代码。
