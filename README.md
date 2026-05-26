# AI Engineering Skills

面向软件研发流程的七套 agent skill，Codex 和 Claude 都可以使用。

## 文档

- [CHANGELOG](./CHANGELOG.md)：记录 skill、workflow contract、产物路径、触发规则和安装流程变化。
- [完整中文使用说明](./docs/skills-guide.zh-CN.md)：所有 skill 的定位、使用方式、产物、联动和防误用规则。
- [仓库结构说明](./docs/repository-layout.md)：说明 plugin 内 `skills/` 和 marketplace 元数据之间的关系。
- [版本管理规则](./docs/versioning.zh-CN.md)：说明版本号、CHANGELOG 和 manifest 同步规则。
- [工程行为原则](./docs/engineering-principles.zh-CN.md)：跨 workflow 的澄清、简单、精准修改和验证底线。
- [Superpowers 方法论吸收说明](./docs/superpowers-inspired-rules.zh-CN.md)：把澄清、计划、测试、debug、review、验证和收尾纪律改造成中文 workflow 规则。
- [Workflow 契约](./docs/workflow-contracts.zh-CN.md)：统一 state、summary、handoff、恢复、执行模式和文档职责边界。
- [Bootstrap 路由示例](./docs/bootstrap-examples.zh-CN.md)：典型中文提示词到 workflow 的期望路由。
- [示例维护策略](./docs/examples-policy.zh-CN.md)：说明 `examples/standard-run.md` 的边界和完整示例取舍。
- [Full Run 示例](./docs/full-run-examples/README.zh-CN.md)：展示完整阶段产物、机器可读元数据和 Verification 形态。
- [兼容说明](./docs/compatibility.zh-CN.md)：说明与其他 skill 套件同装时由用户自主决策。
- [安装冒烟验证](./docs/install-smoke-test.zh-CN.md)：本地安装、覆盖策略和安装后路由验证步骤。
- [发布前检查清单](./docs/release-checklist.zh-CN.md)：发布或真实安装前的检查步骤。
- [维护者指南](./docs/maintainer-guide.zh-CN.md)：仓库结构、常见维护任务和检查命令。
- [Skill 一致性清单](./docs/skill-consistency-checklist.md)：新增或修改 skill 时的仓库级自检标准。
- [测试与一致性检查](./docs/testing.zh-CN.md)：说明如何检查 skill、模板、文档和 plugin metadata 是否漂移。

## Skills

- [`workflow-bootstrap`](./plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md)：软件研发任务的统一入口分流，先判断该走熟悉、review、debug、契约设计、迁移规划还是直接交付实现。
- [`codebase-orientation`](./plugins/ai-engineering-skills/skills/codebase-orientation/SKILL.md)：只读熟悉项目/模块/业务流程，输出业务与技术理解文档，并可交接到 review 或交付流程。
- [`software-delivery-pipeline`](./plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md)：需求确认、架构/选型门禁、实施计划、实现、调试、验证、交付的闭环流程。
- [`code-review-triage`](./plugins/ai-engineering-skills/skills/code-review-triage/SKILL.md)：只读代码审查、问题清单、修复项选择、修复计划、handoff 到交付流程。
- [`debug-root-cause`](./plugins/ai-engineering-skills/skills/debug-root-cause/SKILL.md)：错误、失败测试、启动异常、运行时问题的证据优先根因分析。
- [`api-contract-design`](./plugins/ai-engineering-skills/skills/api-contract-design/SKILL.md)：接口、DTO、响应结构、错误码、兼容策略的契约设计。
- [`data-migration-planning`](./plugins/ai-engineering-skills/skills/data-migration-planning/SKILL.md)：表结构、数据回填、清理、兼容、验证 SQL、回滚恢复的迁移计划。

## 推荐使用入口

对于软件研发类任务，建议优先从 `workflow-bootstrap` 开始，由它判断当前任务最适合进入哪条 workflow：

- 熟悉项目 → `codebase-orientation`
- 代码审查 → `code-review-triage`
- 问题排查 → `debug-root-cause`
- 契约设计 → `api-contract-design`
- 迁移规划 → `data-migration-planning`
- 功能实现 / 修复交付 → `software-delivery-pipeline`

简单概念问答不强制进入 workflow。

所有 workflow 都应遵守 [工程行为原则](./docs/engineering-principles.zh-CN.md)：先澄清关键假设，保持方案简单，只做可追溯的精准修改，并用实际验证结果支撑完成声明。

## 目录结构

```text
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
```

`plugins/ai-engineering-skills/skills/` 是唯一 skill 源码目录；仓库根目录不再保留第二份 `skills/`。

## Codex 使用

作为 Codex plugin marketplace 安装。发布到 GitHub 后，在 Codex 里添加 marketplace 并安装 `ai-engineering-skills` plugin。

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

## Claude 使用

作为 Claude Code plugin marketplace 安装。发布到 GitHub 后执行：

```bash
claude plugin marketplace add <owner>/ai-engineering-skills
claude plugin install ai-engineering-skills@ai-engineering-skills
```

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

详细 workflow 契约、handoff 流转、状态文件、索引、命名和恢复规则见 [Workflow 契约](./docs/workflow-contracts.zh-CN.md)。README 只保留入口说明，避免和 `docs/` / `SKILL.md` 重复。

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

## 自检

修改 skill、模板、reference、README、workflow contract 或 plugin metadata 后，建议运行：

```bash
bash scripts/check-consistency.sh
```

修改安装脚本或发布前，再运行：

```bash
bash scripts/smoke-install-local.sh
```

发布或真实安装前可直接运行：

```bash
bash scripts/release-check.sh
```

维护任务入口见 [维护者指南](./docs/maintainer-guide.zh-CN.md) 和 [脚本说明](./scripts/README.md)。

发布或真实安装前按 [发布前检查清单](./docs/release-checklist.zh-CN.md) 逐项确认。

安装后可用 [Bootstrap 路由示例](./docs/bootstrap-examples.zh-CN.md) 中的提示词做冒烟测试。

本地安装前建议先运行：

```bash
bash scripts/install-codex-skills.sh --dry-run
bash scripts/install-claude-plugin.sh --dry-run
```
