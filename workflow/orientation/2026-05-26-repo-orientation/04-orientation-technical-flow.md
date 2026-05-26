# 04-orientation-technical-flow

## 文档元信息
- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- 分支: `main`
- 提交: `25284f0`
- 状态: completed

## 技术执行主线

### 1. 插件发现与安装入口
**事实**：
- Claude marketplace 入口：`.claude-plugin/marketplace.json`
- OpenClaw/Codex 风格 marketplace 入口：`.agents/plugins/marketplace.json`
- 实际 plugin 元数据：`plugins/ai-engineering-skills/.claude-plugin/plugin.json`、`plugins/ai-engineering-skills/.codex-plugin/plugin.json`

**调用链理解**：
宿主（Claude/Codex/OpenClaw）先读取 marketplace 元数据 → 定位 plugin source → 再读取 plugin.json → 再暴露 `skills/` 目录中的 skill。

### 2. Skill 装载方式
**事实**：
- Codex plugin.json 中 `skills: "./skills/"`，说明 skill 目录被整体注册。
- 每个 skill 的执行规则集中写在各自 `SKILL.md`。
- 多个 skill 搭配 `references/*.md` 作为稳定补充规范。

**推断**：
运行时真正“被 agent 读到”的核心内容是 `SKILL.md`，而 references/contract 文档作为可复用约束，降低不同 skill 之间的规则分叉。

### 3. Workflow 状态与恢复机制
**事实**：
`docs/workflow-contracts.zh-CN.md` 统一规定：
- state 文件命名：`*-workflow-state.md`
- handoff 文件命名：`*-to-*-handoff.md`
- resume 顺序：先读 state → 再读最新阶段文档 → 再看 git status/diff → 再继续

**作用**：
- 让长任务在跨回合、中断、换 agent 后还能恢复。
- 让不同 skill 之间交接时不靠“聊天上下文记忆”。

### 4. 具体 skill 的技术边界
- `workflow-bootstrap`：只路由，不承担完整执行。
- `codebase-orientation`：只读熟悉，产出项目理解文档。
- `code-review-triage`：只读审查，产出 findings 与修复选择。
- `debug-root-cause`：只读排障，产出根因和修复选项。
- `api-contract-design`：只做契约设计，不实现。
- `data-migration-planning`：只做迁移规划，不执行。
- `software-delivery-pipeline`：唯一默认允许改代码的主流程 skill。

### 5. 仓库自举特征
**事实**：
`workflow/runs/` 下已有多轮 `delivery` 产物，如：
- `2026-05-22-ai-skills-superpowers-fusion`
- `2026-05-23-skill-consistency-first-wave`
- `2026-05-23-skill-consistency-second-wave`
- `2026-05-23-skill-consistency-third-wave`

**推断**：
这个仓库已经在用自己的文档化流程持续演进自己，具备一定“自举”特征。

## 待确认
- 是否还有外部 CI / 自动校验来检查 skill 文档完整性；目前本次只看到了文档契约与人工流程线索，未见脚本级入口。
