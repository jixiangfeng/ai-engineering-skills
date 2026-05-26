# 01-review-scope

## 文档元信息
- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- 分支: `main`
- 提交: `25284f0`
- Agent: `codex`
- 状态: completed

## Review 目标
对 `ai-engineering-skills` 仓库做一次**仓库级一致性 review**，重点审查 skill 边界、文档契约、自恢复规则、产物要求与仓库级说明之间是否存在冲突、缺口或会导致下游执行失败的地方。

## 重点关注维度
- skill 是否满足 `docs/skill-consistency-checklist.md` 的最低要求
- `SKILL.md`、`references/*.md`、仓库级 docs 之间是否存在规则漂移
- 必需模板/产物/命名契约是否有“声明了但仓库里没有”的情况
- 会不会导致下游 agent 无法恢复、无法交接或误入实现阶段

## 范围内
- `plugins/ai-engineering-skills/skills/**/SKILL.md`
- `plugins/ai-engineering-skills/skills/**/references/*.md`
- `docs/skills-guide.zh-CN.md`
- `docs/workflow-contracts.zh-CN.md`
- `docs/skill-consistency-checklist.md`
- plugin / marketplace 元数据在必要时作为辅助证据

## 范围外
- 不评审业务代码质量（本仓库也基本无业务代码）
- 不执行真实 plugin 安装与宿主侧集成测试
- 不以“我更喜欢某种写法”作为 finding
- 不修改 skill 内容，本轮只读

## 说明
本次 review 目标不是否定这套设计；相反，这个仓库整体方向是清晰的。重点是找出那些**会影响可执行性、可维护性或一致性**的真实问题。
