# 02-delivery-plan

- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- run 目录: `workflow/runs/2026-05-23-skill-consistency-first-wave`
- 生成时间: `2026-05-23 08:51:00 CST`
- 分支: `main`
- 基线提交: `0ab01a3`
- 执行代理: `codex`
- 当前状态: `pending_confirmation`

## 1. 计划目标

在不扩大范围的前提下，完成第一波 skill 一致性补齐，让 `api-contract-design`、`data-migration-planning`、`codebase-orientation`、`debug-root-cause` 在状态管理与文档模板层面更一致。

## 2. 输入依据

- `workflow/runs/2026-05-23-skill-consistency-first-wave/01-delivery-requirements.md`
- 当前仓库中已存在的成熟 skill 作为对照：
  - `plugins/ai-engineering-skills/skills/codebase-orientation/SKILL.md`
  - `plugins/ai-engineering-skills/skills/code-review-triage/SKILL.md`
  - `plugins/ai-engineering-skills/skills/debug-root-cause/SKILL.md`
  - `plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md`

## 3. 架构设计说明

- 无需独立架构设计。
- 原因：本轮只涉及 skill 文档、模板与引用规范补齐，不引入新的插件机制、运行时、依赖或跨模块架构变化。
- 约束：新增规则必须尽量复用现有主 workflow 的写法与结构，不发明新的风格体系。

## 4. 实施步骤

1. 对照现有成熟 skill，整理最小一致性基线：
   - preflight checklist
   - resume protocol
   - workflow-state 约定
   - stage 定义
   - handoff 规则
2. 修改 `api-contract-design/SKILL.md`：
   - 补 state / resume / stage / handoff 规则
   - 若引入 state 文件要求，则同步补模板资产
   - 必要时补简短 reference 文档
3. 修改 `data-migration-planning/SKILL.md`：
   - 补 state / resume / stage / handoff 规则
   - 若引入 state 文件要求，则同步补模板资产
   - 必要时补简短 reference 文档
4. 为 `codebase-orientation` 新增 `orientation-workflow-state.md` 模板，字段风格对齐已有 `delivery-workflow-state.md` / `review-workflow-state.md`
5. 为 `debug-root-cause` 新增 `debug-workflow-state.md` 模板，字段包含当前阶段、状态、复现状态、下一步、写代码许可
6. 如改动很小且确有必要，同步微调 `README.md` 或 `docs/skills-guide.zh-CN.md`，只反映新增的一致性能力，不展开大段重写
7. 自检与验证：
   - 检查新旧文件路径、命名、模板引用是否一致
   - 检查新增 state 模板是否与 SKILL.md 中的文件名完全一致
   - 检查是否引入与现有 guide/README 冲突的描述

## 5. 风险与控制

### 风险
- 写得过重，会把轻量 skill 变成过度复杂的流程文档。
- 写得过轻，又无法真正解决“不一致”问题。
- 如果新增 state 规则但漏掉模板，会重复制造当前缺口。

### 控制策略
- 只补最小必要纪律，不扩展到第二波改进项。
- 尽量复用现有 skill 中已经被验证过的结构。
- 每个新增规则都要能在对应 assets 中找到承接模板，避免“只写规范不补资产”。

## 6. 计划后的预期修改文件

高概率修改：
- `plugins/ai-engineering-skills/skills/api-contract-design/SKILL.md`
- `plugins/ai-engineering-skills/skills/data-migration-planning/SKILL.md`
- `plugins/ai-engineering-skills/skills/codebase-orientation/assets/orientation-templates/orientation-workflow-state.md`
- `plugins/ai-engineering-skills/skills/debug-root-cause/assets/debug-templates/debug-workflow-state.md`

可能新增：
- `plugins/ai-engineering-skills/skills/api-contract-design/assets/api-contract-templates/api-contract-workflow-state.md`
- `plugins/ai-engineering-skills/skills/data-migration-planning/assets/data-migration-templates/migration-workflow-state.md`
- `plugins/ai-engineering-skills/skills/api-contract-design/references/api-contract-guidelines.md` 的补强
- `plugins/ai-engineering-skills/skills/data-migration-planning/references/data-migration-guidelines.md` 的补强

低概率微调：
- `README.md`
- `docs/skills-guide.zh-CN.md`

## 7. 验证策略

本轮是文档/模板改动，采用最小但有证明力的验证：

- 路径存在性检查
- 命名一致性检查
- `SKILL.md` 与 assets/reference 文件的交叉引用检查
- 变更范围检查（确保未扩散到无关 skill）
- 人工 diff review

如有可行，再补一轮基于 `grep/find` 的一致性扫描。

## 8. 退出标准

- [ ] 两个轻量 skill 的 `SKILL.md` 已补齐最小一致性骨架
- [ ] 四个 workflow-state 模板缺口全部关闭（含新引入者）
- [ ] 引用路径与文件名全部一致
- [ ] README / guide 若被修改，仅做小范围同步且无冲突
- [ ] 最终 diff 仅覆盖本轮确认范围

## 9. 当前结论

计划已收敛，可进入实现阶段；实现将严格限制在已确认范围内。
