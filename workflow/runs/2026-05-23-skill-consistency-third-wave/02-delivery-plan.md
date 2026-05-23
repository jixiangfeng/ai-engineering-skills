# 02-delivery-plan

- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- run 目录: `workflow/runs/2026-05-23-skill-consistency-third-wave`
- 生成时间: `2026-05-23 09:33:00 CST`
- 分支: `main`
- 基线提交: `0ab01a3`
- 执行代理: `codex`
- 当前状态: `pending_confirmation`

## 1. 计划目标

补齐 `api-contract-design` 与 `data-migration-planning` 的 document-contracts 承载层，让 design/migration 侧与第二波已补的 orientation/review/debug contract 体系闭环一致。

## 2. 输入依据

- `workflow/runs/2026-05-23-skill-consistency-third-wave/01-delivery-requirements.md`
- 第二波新增 contract 文档：
  - `plugins/ai-engineering-skills/skills/codebase-orientation/references/orientation-document-contracts.md`
  - `plugins/ai-engineering-skills/skills/code-review-triage/references/review-document-contracts.md`
  - `plugins/ai-engineering-skills/skills/debug-root-cause/references/debug-document-contracts.md`
- 第一波已补强后的：
  - `plugins/ai-engineering-skills/skills/api-contract-design/SKILL.md`
  - `plugins/ai-engineering-skills/skills/data-migration-planning/SKILL.md`

## 3. 架构设计说明

- 无需独立架构设计。
- 原因：本轮仍然只涉及 Markdown 规范文档和 references，不引入新执行机制、依赖或目录结构变化。
- 关键约束：
  - contract 文档保持简洁、结构化、可复用
  - 不复制 `software-delivery-pipeline` 的大模板
  - 只补 design/migration 缺口，不回头大改前两波内容

## 4. 实施步骤

1. 对照第二波已有的 3 份 document-contracts，抽取统一结构基线：
   - 目标
   - 最低要求
   - 各阶段文档至少应回答什么
   - 输出纪律
2. 新增 `api-contract-document-contracts.md`
   - 说明 contract workflow 至少应沉淀哪些信息
   - 覆盖：scope、current contract、proposed contract、compatibility、validation/errors、examples、summary/handoff
3. 新增 `data-migration-document-contracts.md`
   - 说明 migration workflow 至少应沉淀哪些信息
   - 覆盖：scope、current model、target model、migration plan、rollback/recovery、validation、summary/handoff
4. 小范围调整 `api-contract-design/SKILL.md` 与 `data-migration-planning/SKILL.md`
   - 在 References 段补 document-contracts 入口
   - 如有必要，在 Document Quality Rules 或 Workflow Artifacts 附近点明 contract 文档的用途
5. 按需同步 `docs/skills-guide.zh-CN.md`
   - 只补最小必要说明，确保 design/migration 也有独立 contract 承载点
6. 验证：
   - 新文档存在性检查
   - SKILL.md 引用一致性检查
   - 与第二波 contract 文档风格相容性人工 review
   - 范围检查

## 5. 关键设计选择

### 选择 A：沿用第二波 contract 文档风格
- 结论：采用
- 原因：保持整仓 contract 层的阅读体验一致

### 选择 B：只在 guide 做最小同步，不强制再改 README
- 结论：采用
- 原因：README 当前已经有 checklist 入口；本轮重点是补齐 contract 缺口，而不是继续扩 README

### 选择 C：SKILL.md 只补发现入口，不重写主流程
- 结论：采用
- 原因：第一波已经补了 state/resume/stages；第三波应聚焦 contract 承载层，不再重复扩主文

## 6. 预期修改文件

高概率新增：
- `plugins/ai-engineering-skills/skills/api-contract-design/references/api-contract-document-contracts.md`
- `plugins/ai-engineering-skills/skills/data-migration-planning/references/data-migration-document-contracts.md`

高概率修改：
- `plugins/ai-engineering-skills/skills/api-contract-design/SKILL.md`
- `plugins/ai-engineering-skills/skills/data-migration-planning/SKILL.md`
- `docs/skills-guide.zh-CN.md`

低概率修改：
- `plugins/ai-engineering-skills/skills/api-contract-design/references/api-contract-guidelines.md`
- `plugins/ai-engineering-skills/skills/data-migration-planning/references/data-migration-guidelines.md`

## 7. 风险与控制

### 风险
- 如果 contract 文档写得太细，会和 guideline 重复。
- 如果只补入口、不写清最低要求，又达不到“稳定承载点”的目的。
- worktree 已有前两波未提交修改，第三波应避免顺手继续扩散。

### 控制策略
- 每份 contract 文档只写“最低要求 + 输出纪律”，不复制长模板。
- SKILL.md 只做入口级引用补充。
- guide 只做一句级别的小同步。
- 不动范围外文件。

## 8. 验证策略

- `test -f` / `rg` 检查新 contract 文档存在与引用
- `git status --short` / `git diff --stat` 检查范围
- 人工核对两份新 contract 文档与第二波的风格一致性

## 9. 退出标准

- [ ] `api-contract-design` 已有独立 document-contracts 文档
- [ ] `data-migration-planning` 已有独立 document-contracts 文档
- [ ] 两个 `SKILL.md` 已能自然指向各自 contract 文档
- [ ] guide 已做最小必要同步
- [ ] 本轮没有扩展到范围外修改

## 10. 当前结论

计划已收敛，可以进入实现阶段；实现将保持最小增量，不再扩大设计范围。
