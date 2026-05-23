# 01-delivery-requirements

- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- run 目录: `workflow/runs/2026-05-23-skill-consistency-first-wave`
- 生成时间: `2026-05-23 08:40:24 CST`
- 分支: `main`
- 基线提交: `0ab01a3`
- 执行代理: `codex`
- 当前状态: `pending_confirmation`

## 1. 原始任务

基于上一轮仓库 review，先落地第一波最值得做的改进点，提高各 skill 的一致性与可恢复性。

## 2. 本轮目标

本轮只做第一波 4 项改动：

1. 为 `api-contract-design` 补齐 workflow state / resume protocol / 分阶段执行说明。
2. 为 `data-migration-planning` 补齐 workflow state / resume protocol / 分阶段执行说明。
3. 为 `codebase-orientation` 补齐缺失的 `orientation-workflow-state.md` 模板。
4. 为 `debug-root-cause` 补齐缺失的 `debug-workflow-state.md` 模板。

## 3. 范围内

- 允许修改：
  - `plugins/ai-engineering-skills/skills/api-contract-design/**`
  - `plugins/ai-engineering-skills/skills/data-migration-planning/**`
  - `plugins/ai-engineering-skills/skills/codebase-orientation/assets/orientation-templates/**`
  - `plugins/ai-engineering-skills/skills/debug-root-cause/assets/debug-templates/**`
  - 如有必要，可同步更新 `README.md` 或 `docs/skills-guide.zh-CN.md`，但仅限反映本轮新增能力。
- 允许新增：缺失的 workflow state 模板、必要的 reference/contract 文档。

## 4. 范围外

- 不做新的 skill 增删。
- 不重构 `software-delivery-pipeline`。
- 不处理 `workflow/` 的 git 策略。
- 不做第二波的 bootstrap 增强或全仓一致性 checklist。
- 不修改与本轮无关的示例 run 文档。

## 5. 约束

- 遵守仓库当前设计哲学：文档驱动、阶段门禁、可恢复执行。
- 新增内容默认使用简体中文；代码标识符、路径、命令保留原文。
- 以“补齐一致性”为目标，不凭空扩张设计复杂度。
- 改动应尽量最小且清晰，让现有 skill 风格保持一致。

## 6. 验收标准

- [ ] `api-contract-design/SKILL.md` 明确包含与其它主 workflow 接近的 preflight、resume、stage、handoff 规则。
- [ ] `data-migration-planning/SKILL.md` 明确包含与其它主 workflow 接近的 preflight、resume、stage、handoff 规则。
- [ ] `codebase-orientation` 资产目录新增可直接使用的 `orientation-workflow-state.md` 模板。
- [ ] `debug-root-cause` 资产目录新增可直接使用的 `debug-workflow-state.md` 模板。
- [ ] 新增或修改内容与 README / guide / 现有 naming conventions 不冲突。

## 7. 风险与待确认点

### 已识别风险
- `api-contract-design` 与 `data-migration-planning` 目前较轻，补强时如果写得过厚，可能与仓库其它 skill 的语气或复杂度失衡。
- 是否需要为这两个 skill 同时新增独立的 workflow-state 模板文件，目前需求中未强制写死；但若 SKILL.md 引入 state 文件要求，通常应同步补模板，避免再次出现“规范存在但模板缺失”的不一致。

### 需要主人确认的点
1. 本轮是否允许我 **顺手为 `api-contract-design` 与 `data-migration-planning` 同步新增各自的 workflow-state 模板**？
   - 我建议：**允许**。这样不会留下新的半一致状态。
2. README / `docs/skills-guide.zh-CN.md` 是否要在本轮同步补一句这两个 skill 已具备更完整的恢复/阶段机制？
   - 我建议：**若改动很小则顺手同步**；若会引入大段改写，则留到第二轮。

## 8. 证据依据

- `plugins/ai-engineering-skills/skills/api-contract-design/SKILL.md`：只有轻量 preflight，没有 workflow state / resume / 分阶段执行定义。
- `plugins/ai-engineering-skills/skills/data-migration-planning/SKILL.md`：同样缺少 workflow state / resume / stage 定义。
- `plugins/ai-engineering-skills/skills/codebase-orientation/SKILL.md`：要求使用 `orientation-workflow-state.md`，但 `assets/orientation-templates/` 中缺少对应模板。
- `plugins/ai-engineering-skills/skills/debug-root-cause/SKILL.md`：要求使用 `debug-workflow-state.md`，但 `assets/debug-templates/` 中缺少对应模板。

## 9. 当前工作区状态

- 当前 `git status` 显示存在未跟踪目录：`workflow/`
- 本 run 也会写入 `workflow/runs/2026-05-23-skill-consistency-first-wave/`
- 在未确认计划前，不会修改 skill 正文或模板资产之外的代码/文档

## 10. 下一步

等待主人确认需求；确认后再进入计划阶段，不直接改代码。
