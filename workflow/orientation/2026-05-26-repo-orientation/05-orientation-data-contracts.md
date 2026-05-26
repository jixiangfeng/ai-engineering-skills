# 05-orientation-data-contracts

## 文档元信息
- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- 分支: `main`
- 提交: `25284f0`
- 状态: completed

## 关键契约面

### 1. Marketplace 契约
**事实**：
- `.claude-plugin/marketplace.json` 定义 Claude 侧 marketplace 暴露方式。
- `.agents/plugins/marketplace.json` 定义 OpenClaw/Codex 风格 marketplace 暴露方式。
- 两边都把 plugin source 指向 `./plugins/ai-engineering-skills`。

**数据形态**：
- 仓库级 marketplace 文件主要包含 owner/name/plugins/source/category/policy 等元数据。

### 2. Plugin 元数据契约
**事实**：
- `plugins/ai-engineering-skills/.claude-plugin/plugin.json` 提供最小 plugin 描述。
- `plugins/ai-engineering-skills/.codex-plugin/plugin.json` 提供更完整的面向 Codex 的展示与能力元数据。

**关键字段**：
- `name`
- `version`
- `description`
- `skills`
- `interface.displayName`
- `interface.capabilities`
- `defaultPrompt`

### 3. Workflow 命名契约
**事实**：`docs/workflow-contracts.zh-CN.md` 明确了跨 skill 统一契约：
- state: `*-workflow-state.md`
- handoff: `*-to-*-handoff.md`
- summary: `07-*-summary.md` 或该 workflow 末阶段 summary
- 阶段文件: `NN-<workflow>-<stage>.md`

### 4. Skill 自身文档契约
**事实**：各 skill 在 `references/` 下还有自己的文档契约文件，例如：
- `orientation-document-contracts.md`
- `review-document-contracts.md`
- `debug-document-contracts.md`
- `api-contract-document-contracts.md`
- `data-migration-document-contracts.md`
- `software-delivery-pipeline/references/document-contracts.md`

**推断**：
仓库采用“SKILL.md 负责流程主规则 + references 负责稳定契约”的双层结构，便于复用和收敛。

## 当前没有看到的契约
- 未见 package manager、构建产物、测试脚本等常规应用仓库契约。
- 未见数据库 schema、HTTP API、消息队列 payload 之类业务运行时数据契约。

## 结论
这个仓库的“数据契约”主体不是业务数据模型，而是：
1. plugin 元数据契约
2. workflow 文档命名与恢复契约
3. 各 skill 的文档结构契约

## 待确认
- 是否需要后续为这些契约补一层自动 lint/check 脚本，减少靠人工 checklist 维护的一致性成本。
