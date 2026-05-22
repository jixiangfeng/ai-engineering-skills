# AI Engineering Skills

面向软件研发流程的六套 agent skill，Codex 和 Claude 都可以使用。

## 文档

- [完整中文使用说明](./docs/skills-guide.zh-CN.md)：所有 skill 的定位、使用方式、产物、联动和防误用规则。

## Skills

- [`codebase-orientation`](./skills/codebase-orientation/SKILL.md)：只读熟悉项目/模块/业务流程，输出业务与技术理解文档，并可交接到 review 或交付流程。
- [`software-delivery-pipeline`](./skills/software-delivery-pipeline/SKILL.md)：需求确认、架构/选型门禁、实施计划、实现、调试、验证、交付的闭环流程。
- [`code-review-triage`](./skills/code-review-triage/SKILL.md)：只读代码审查、问题清单、修复项选择、修复计划、handoff 到交付流程。
- [`debug-root-cause`](./skills/debug-root-cause/SKILL.md)：错误、失败测试、启动异常、运行时问题的证据优先根因分析。
- [`api-contract-design`](./skills/api-contract-design/SKILL.md)：接口、DTO、响应结构、错误码、兼容策略的契约设计。
- [`data-migration-planning`](./skills/data-migration-planning/SKILL.md)：表结构、数据回填、清理、兼容、验证 SQL、回滚恢复的迁移计划。

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
agents/
  codex/README.md
  claude/README.md
```

## Codex 使用

安装到本机 Codex：

```bash
./scripts/install-codex.sh
```

安装后可在 Codex 中使用：

```text
$codebase-orientation
$code-review-triage
$software-delivery-pipeline
$debug-root-cause
$api-contract-design
$data-migration-planning
```

## Claude 使用

安装到本机 Claude：

```bash
./scripts/install-claude.sh
```

安装后在 Claude 中按 skill 名称调用，或在提示词中明确引用：

```text
Use the codebase-orientation skill...
Use the code-review-triage skill...
Use the software-delivery-pipeline skill...
Use the debug-root-cause skill...
Use the api-contract-design skill...
Use the data-migration-planning skill...
```

## 工作流关系

典型链路：

1. `codebase-orientation` 先只读熟悉项目/模块，产出 `workflow/orientation/<run>/07-summary.md`。
2. `code-review-triage` 基于理解结果做只读 review，产出 `workflow/reviews/<run>/02-findings.md`。
3. 用户选择要修复的 findings。
4. 生成 `handoff-to-delivery.md`。
5. `software-delivery-pipeline` 读取 handoff，进入需求确认、架构门禁、计划、实现、验证、交付。
6. 修复完成后回写 `workflow/reviews/<run>/delivery-result.md`。

所有中间文档默认使用简体中文。


其他常用链路：

- `debug-root-cause` 找到根因后，生成 handoff 给 `software-delivery-pipeline` 修复。
- `api-contract-design` 确认 API 契约后，生成 handoff 给 `software-delivery-pipeline` 实现。
- `data-migration-planning` 确认迁移/回滚方案后，生成 handoff 给 `software-delivery-pipeline` 落地。
