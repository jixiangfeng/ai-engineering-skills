# AI Engineering Skills

面向软件研发流程的七套 agent skill，Codex 和 Claude 都可以使用。

## 文档

- [完整中文使用说明](./docs/skills-guide.zh-CN.md)：所有 skill 的定位、使用方式、产物、联动和防误用规则。
- [仓库结构说明](./docs/repository-layout.md)：说明 `skills/`、安装脚本和 Claude marketplace 元数据之间的关系。

## Skills

- [`workflow-bootstrap`](./skills/workflow-bootstrap/SKILL.md)：软件研发任务的统一入口分流，先判断该走熟悉、review、debug、契约设计、迁移规划还是直接交付实现。
- [`codebase-orientation`](./skills/codebase-orientation/SKILL.md)：只读熟悉项目/模块/业务流程，输出业务与技术理解文档，并可交接到 review 或交付流程。
- [`software-delivery-pipeline`](./skills/software-delivery-pipeline/SKILL.md)：需求确认、架构/选型门禁、实施计划、实现、调试、验证、交付的闭环流程。
- [`code-review-triage`](./skills/code-review-triage/SKILL.md)：只读代码审查、问题清单、修复项选择、修复计划、handoff 到交付流程。
- [`debug-root-cause`](./skills/debug-root-cause/SKILL.md)：错误、失败测试、启动异常、运行时问题的证据优先根因分析。
- [`api-contract-design`](./skills/api-contract-design/SKILL.md)：接口、DTO、响应结构、错误码、兼容策略的契约设计。
- [`data-migration-planning`](./skills/data-migration-planning/SKILL.md)：表结构、数据回填、清理、兼容、验证 SQL、回滚恢复的迁移计划。

## 推荐使用入口

对于软件研发类任务，建议优先从 `workflow-bootstrap` 开始，由它判断当前任务最适合进入哪条 workflow：

- 熟悉项目 → `codebase-orientation`
- 代码审查 → `code-review-triage`
- 问题排查 → `debug-root-cause`
- 契约设计 → `api-contract-design`
- 迁移规划 → `data-migration-planning`
- 功能实现 / 修复交付 → `software-delivery-pipeline`

简单概念问答不强制进入 workflow。

## 目录结构

```text
skills/
  software-delivery-pipeline/
    SKILL.md
    assets/
    references/
  code-review-triage/
    SKILL.md
    assets/
    references/
  codebase-orientation/
    SKILL.md
    assets/
    references/
scripts/
  install-codex.sh
  install-claude.sh
.claude-plugin/
  marketplace.json
.agents/
  plugins/
    marketplace.json
plugins/
  ai-engineering-skills/
    .claude-plugin/
      plugin.json
    .codex-plugin/
      plugin.json
    skills/
      <skill-name> -> ../../../skills/<skill-name>
```

`skills/` 是唯一 skill 源码目录；`plugins/ai-engineering-skills/skills/` 只放指向根目录 `skills/` 的软链接，用于 Codex plugin 读取，不维护第二份 skill 内容。

## Codex 使用

安装到本机 Codex：

```bash
./scripts/install-codex.sh
```

默认会删除已有同名真实目录，并改为链接到本仓库的 skill；如需备份可使用 `--backup-existing`，如需保守模式可使用 `--strict`。

安装后可在 Codex 中使用：

```text
$workflow-bootstrap
$codebase-orientation
$code-review-triage
$software-delivery-pipeline
$debug-root-cause
$api-contract-design
$data-migration-planning
```

也可以作为 Codex plugin marketplace 安装。发布到 GitHub 后，在 Codex 里添加 marketplace 并安装 `ai-engineering-skills` plugin。

## Claude 使用

安装到本机 Claude：

```bash
./scripts/install-claude.sh
```

默认会删除已有同名真实目录，并改为链接到本仓库的 skill；如需备份可使用 `--backup-existing`，如需保守模式可使用 `--strict`。

也可以作为 Claude Code plugin marketplace 安装。发布到 GitHub 后执行：

```bash
claude plugin marketplace add <owner>/ai-engineering-skills
claude plugin install ai-engineering-skills@ai-engineering-skills
```

本地开发时仍建议使用 `./scripts/install-claude.sh`，因为它会直接链接到当前工作区，修改 skill 后不需要重新安装 plugin。

安装后在 Claude 中按 skill 名称调用，或在提示词中明确引用：

```text
Use the workflow-bootstrap skill first for software engineering tasks...
Use the codebase-orientation skill...
Use the code-review-triage skill...
Use the software-delivery-pipeline skill...
Use the debug-root-cause skill...
Use the api-contract-design skill...
Use the data-migration-planning skill...
```

## 工作流关系

设计哲学：

- 先分流，再执行
- 先证据，再结论
- 先确认，再改代码

典型链路：

1. `workflow-bootstrap` 先识别任务类型。
2. 若是“先熟悉”，进入 `codebase-orientation`，产出 `workflow/orientation/<run>/07-orientation-summary.md`。
3. 若是“先 review”，进入 `code-review-triage`，产出 `workflow/reviews/<run>/02-review-findings.md`。
4. 用户选择要修复的 findings。
5. 生成 `review-to-delivery-handoff.md`。
6. `software-delivery-pipeline` 读取 handoff，进入需求确认、架构门禁、计划、实现、验证、交付。
7. 修复完成后回写 `workflow/reviews/<run>/review-delivery-result.md`。

所有中间文档默认使用简体中文。

其他常用链路：

- `workflow-bootstrap` → `debug-root-cause` → `software-delivery-pipeline`
- `workflow-bootstrap` → `api-contract-design` → `software-delivery-pipeline`
- `workflow-bootstrap` → `data-migration-planning` → `software-delivery-pipeline`
- 对于已经范围明确的实现任务，也可以由 `workflow-bootstrap` 直接路由到 `software-delivery-pipeline`
