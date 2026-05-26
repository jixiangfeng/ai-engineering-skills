# 02-orientation-project-map

## 文档元信息
- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- 分支: `main`
- 提交: `25284f0`
- 状态: completed

## 仓库结构总览
```text
ai-engineering-skills/
├─ README.md
├─ docs/
│  ├─ repository-layout.md
│  ├─ skill-consistency-checklist.md
│  ├─ skills-guide.zh-CN.md
│  └─ workflow-contracts.zh-CN.md
├─ .claude-plugin/marketplace.json
├─ .agents/plugins/marketplace.json
├─ plugins/ai-engineering-skills/
│  ├─ .claude-plugin/plugin.json
│  ├─ .codex-plugin/plugin.json
│  └─ skills/
│     ├─ workflow-bootstrap/
│     ├─ codebase-orientation/
│     ├─ code-review-triage/
│     ├─ debug-root-cause/
│     ├─ api-contract-design/
│     ├─ data-migration-planning/
│     └─ software-delivery-pipeline/
└─ workflow/
   ├─ runs/
   └─ orientation/
```

## 关键目录职责

### 1. `plugins/ai-engineering-skills/skills/`
**事实**：这是唯一 skill 源码目录，README 与 `docs/repository-layout.md` 都明确声明这里是 source of truth。

**作用**：
- 每个 skill 以独立目录存在。
- 每个 skill 至少有 `SKILL.md`。
- 大多数 skill 还带 `references/`，部分带 `assets/`，用于承载模板、契约和补充规则。

### 2. `docs/`
**事实**：这里承载仓库级解释文档，而不是具体 skill 的执行内容。

**作用**：
- `skills-guide.zh-CN.md`：仓库使用总说明与 workflow 哲学。
- `workflow-contracts.zh-CN.md`：跨 workflow 的命名、state、handoff、summary、resume 最小契约。
- `repository-layout.md`：说明为什么 skill 只有一份 canonical copy。
- `skill-consistency-checklist.md`：对 skill 成熟度做统一检查。

### 3. `plugins/ai-engineering-skills/.codex-plugin/plugin.json`
**事实**：Codex 安装入口元数据在这里，声明 `skills: "./skills/"`。

**作用**：
- 面向 Codex 暴露 skill 集合。
- 携带名称、版本、描述、仓库地址、分类、capabilities 等信息。

### 4. `.claude-plugin/marketplace.json` 与 `.agents/plugins/marketplace.json`
**事实**：仓库同时兼容 Claude plugin marketplace 与 OpenClaw/Codex 风格的 marketplace 索引。

**作用**：
- 在不同宿主里把同一套 plugin 暴露出去。
- 两边都把实际 source 指向 `./plugins/ai-engineering-skills`。

### 5. `workflow/`
**事实**：这是仓库自己的 workflow 历史产物目录，已经存在多个 `workflow/runs/...` 交付记录。

**作用**：
- 记录过去几轮对 skill 仓库本身的实现工作。
- 验证这套 skill 不只是文档，还被拿来驱动自身演进。

## 推断
- 这个仓库的核心不是“程序运行逻辑”，而是“给编码代理提供结构化研发流程”。
- 它更像一个方法论/插件产品仓库，而不是普通业务代码仓库。

## 待确认
- 后续是否需要补充更强的自动化校验脚本，目前可见资料以文档契约和人工流程约束为主。
