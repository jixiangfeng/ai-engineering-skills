# 02-delivery-plan

- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- run 目录: `workflow/runs/2026-05-23-skill-consistency-second-wave`
- 生成时间: `2026-05-23 09:16:00 CST`
- 分支: `main`
- 基线提交: `0ab01a3`
- 执行代理: `codex`
- 当前状态: `pending_confirmation`

## 1. 计划目标

在第一波 state / resume / stage 补齐的基础上，推进第二波约束层统一：
- 为非 delivery skill 增加更清晰的 contract/reference 承载点
- 增强 `workflow-bootstrap` 的路由纪律
- 增加仓库级 skill consistency checklist

## 2. 输入依据

- `workflow/runs/2026-05-23-skill-consistency-second-wave/01-delivery-requirements.md`
- 当前已有的 `software-delivery-pipeline/references/document-contracts.md`
- 当前各 skill 的 `SKILL.md` 与 `references/` 目录
- 第一波已新增的 state 模板与两份补强后的轻量 skill 文档

## 3. 架构设计说明

- 无需独立架构设计。
- 原因：本轮仍然只涉及 skill 规范、reference 文档和仓库文档，不引入新运行机制、依赖或插件结构变化。
- 关键约束：
  - 不把 `workflow-bootstrap` 做成复杂执行器
  - 新增 contract/checklist 应尽量集中，避免把规则复制进多个 skill 形成维护分叉
  - 第二波改动要与第一波的新增 state/restore 规则兼容

## 4. 实施步骤

1. 盘点当前 references 与 contract 缺口：
   - 哪些 skill 已有 references 但缺少“文档契约式表达”
   - 哪些规则应放仓库级 checklist，而不是分散复制
2. 设计最小 contract 分层：
   - 为 orientation / review / debug / design / migration 明确是“各自独立 contract”还是“少量共用 checklist + skill-specific guideline”
   - 优先复用现有 `document-contracts.md` 的结构语言，但避免机械复制 delivery 特有内容
3. 新增仓库级 checklist 文档（放 `docs/`）：
   - 定义一个 skill 在仓库内达到“一致性合格线”至少应具备哪些要素
   - 覆盖：适用场景、只读/可改、preflight、resume、state template、stage、gate、handoff、reference、兼容旧命名、范围锁定等
4. 补充非 delivery skill 的 contract/reference 承载：
   - 优先采用“小而明确”的 contract 文档或 guideline 增强
   - 避免为每个 skill 复制超长大模板
5. 增强 `workflow-bootstrap/SKILL.md`：
   - 明确已有 artifact path / handoff path / continue prior run 的优先级
   - 明确简单概念问答不建 workflow
   - 明确路由后的最小动作和输出边界
6. 按需同步 README / `docs/skills-guide.zh-CN.md`：
   - 只补足新的仓库级规范入口和 bootstrap 行为变化
7. 验证：
   - 引用一致性检查
   - 新文档可发现性检查
   - 变更范围检查
   - 人工 diff review

## 5. 计划中的关键设计选择

### 选择 A：checklist 放 `docs/`
- 结论：采用
- 原因：这是仓库级标准，不属于某个单独 skill

### 选择 B：contract 文档尽量短，不复制 delivery 大模板
- 结论：采用
- 原因：第二波目标是“建立承载点”，不是把每个 skill 都膨胀成 delivery 的重量级文档体系

### 选择 C：bootstrap 只增强路由纪律，不扩成 orchestrator
- 结论：采用
- 原因：保持其入口定位，避免职责漂移

## 6. 预期修改文件

高概率修改：
- `plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md`
- `docs/skills-guide.zh-CN.md`
- `README.md`（可能小改）

高概率新增：
- `docs/skill-consistency-checklist.md`
- 若采用 skill-specific contract 承载，则可能新增：
  - `plugins/ai-engineering-skills/skills/codebase-orientation/references/orientation-document-contracts.md`
  - `plugins/ai-engineering-skills/skills/code-review-triage/references/review-document-contracts.md`
  - `plugins/ai-engineering-skills/skills/debug-root-cause/references/debug-document-contracts.md`
  - 或对已有 guideline 文档做补强替代

中概率修改：
- `plugins/ai-engineering-skills/skills/codebase-orientation/references/orientation-guidelines.md`
- `plugins/ai-engineering-skills/skills/code-review-triage/references/review-guidelines.md`
- `plugins/ai-engineering-skills/skills/debug-root-cause/references/debug-guidelines.md`
- `plugins/ai-engineering-skills/skills/api-contract-design/references/api-contract-guidelines.md`
- `plugins/ai-engineering-skills/skills/data-migration-planning/references/data-migration-guidelines.md`

## 7. 风险与控制

### 风险
- 在第一波未提交的前提下继续改，提交边界会变厚。
- 如果 contract 文档新增太多，仓库会突然显得很重。
- 如果 checklist 写得太抽象，起不到实际约束作用。

### 控制策略
- 只补最小必要 contract 承载点。
- checklist 以“可逐项核对”为目标，不写成泛泛原则。
- bootstrap 只增强 decision rules，不扩实现细节。
- 明确保留第一波和第二波 run 分离，方便后续 review / split commit。

## 8. 验证策略

- `rg` / `find` 检查新文档与 skill 引用关系
- `git diff --stat` / `git status --short` 检查范围
- 人工核对 bootstrap 规则是否与 README / guide 一致
- 人工核对 checklist 是否能覆盖第一波 review 中提到的成熟度差异

## 9. 退出标准

- [ ] 仓库中存在一份可复用的 skill consistency checklist
- [ ] `workflow-bootstrap/SKILL.md` 的 continue/handoff/no-workflow 规则显著更清晰
- [ ] 非 delivery skill 的 contract/reference 承载更明确，至少形成一套稳定入口
- [ ] README / guide 在必要处同步，不留“只有源码里知道”的新规则
- [ ] 变更范围未扩散到本轮范围外目标

## 10. 当前结论

计划已收敛，可以进入实现阶段；实现时优先采用“少量高价值新增文档 + 小范围 skill 修改”的策略。
