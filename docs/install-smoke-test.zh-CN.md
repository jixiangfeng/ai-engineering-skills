# Install Smoke Test

本文记录 `ai-engineering-skills` 的本地安装和冒烟验证步骤。目标是确认 skill/plugin 能安装到 Codex 或 Claude 本地目录，并且安装后有可执行的手工路由验证路径。

## Codex skill 安装

先查看将要安装的内容：

```bash
bash scripts/install-codex-skills.sh --dry-run
```

如果目标目录已有同名 skill，默认不会覆盖。可选择：

```bash
bash scripts/install-codex-skills.sh --dry-run --backup
bash scripts/install-codex-skills.sh --backup
```

或显式覆盖：

```bash
bash scripts/install-codex-skills.sh --dry-run --force
bash scripts/install-codex-skills.sh --force
```

默认目标目录是 `~/.codex/skills`。如需安装到临时目录：

```bash
CODEX_SKILLS_DIR=/tmp/codex-skills-test bash scripts/install-codex-skills.sh --force
```

安装脚本会把仓库级共享文档 `docs/` 一并复制到每个 skill 目录下，确保 `SKILL.md` 中的 `docs/...` 引用在本地 Codex 安装后仍可读取。

## 安装后文件检查

确认以下文件存在：

```text
~/.codex/skills/workflow-bootstrap/SKILL.md
~/.codex/skills/codebase-orientation/SKILL.md
~/.codex/skills/code-review-triage/SKILL.md
~/.codex/skills/software-delivery-pipeline/SKILL.md
~/.codex/skills/debug-root-cause/SKILL.md
~/.codex/skills/api-contract-design/SKILL.md
~/.codex/skills/data-migration-planning/SKILL.md
~/.codex/skills/software-delivery-pipeline/docs/workflow-contracts.zh-CN.md
```

安装后需要重启 Codex，让新 skill 被重新发现。

## Claude plugin 安装

先查看将要安装的内容：

```bash
bash scripts/install-claude-plugin.sh --dry-run
```

如果目标目录已有同名 plugin，默认不会覆盖。可选择：

```bash
bash scripts/install-claude-plugin.sh --dry-run --backup
bash scripts/install-claude-plugin.sh --backup
```

或显式覆盖：

```bash
bash scripts/install-claude-plugin.sh --dry-run --force
bash scripts/install-claude-plugin.sh --force
```

默认目标目录是 `~/.claude/plugins/ai-engineering-skills`。如需安装到临时目录：

```bash
CLAUDE_PLUGINS_DIR=/tmp/claude-plugins-test bash scripts/install-claude-plugin.sh --force
```

安装脚本会把仓库级共享文档 `docs/` 复制到 Claude plugin 根目录下，确保 plugin 内 skill 的共享文档引用可读取。

## Claude 安装后文件检查

确认以下文件存在：

```text
~/.claude/plugins/ai-engineering-skills/.claude-plugin/plugin.json
~/.claude/plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md
~/.claude/plugins/ai-engineering-skills/skills/codebase-orientation/SKILL.md
~/.claude/plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md
~/.claude/plugins/ai-engineering-skills/docs/workflow-contracts.zh-CN.md
```

安装后需要重启 Claude Code，让 plugin 被重新发现。

## 冒烟提示词

重启 Codex 或 Claude Code 后，在一个测试项目中尝试：

```text
$workflow-bootstrap 熟悉下当前项目
```

Claude Code 中也可以使用自然语言：

```text
Use workflow-bootstrap to understand this project first.
```

期望：

- 路由到 `codebase-orientation`
- 不修改代码
- 在当前项目根目录下创建 `workflow/orientation/<run>/`

继续尝试：

```text
$workflow-bootstrap 排查这个启动失败
```

期望：

- 路由到 `debug-root-cause`
- 优先收集复现、日志、错误和证据
- 不直接猜修复

如已有 review/debug/api/migration handoff，可尝试：

```text
$workflow-bootstrap 按这个 handoff 落地
```

期望：

- 路由到 `software-delivery-pipeline`
- 读取 handoff 作为 source of truth
- 不把 handoff 视为直接开改的批准依据
- 先按下游 delivery 契约写需求/计划文档，并在需要的确认门禁处停下

## 三档执行模式冒烟

安装后还应人工抽查 `software-delivery-pipeline` 的三档执行模式，确认小任务不会进入完整重流程，高风险任务不会被降级。

### Fast / lightweight

```text
$workflow-bootstrap 帮我把 README 里一个错别字改掉，并说明验证结果
$workflow-bootstrap 直接把 README 里一个错别字改掉，改完告诉我验证结果
```

期望：

- 路由到 `software-delivery-pipeline`
- 选择 `executionMode=lightweight` / `modePath=fast`
- 不生成完整 `01-08` 阶段文档
- 记录目标、范围、最小计划、验证结果和 skipped gates
- 对第二条“直接改”提示词，不额外增加一轮低价值确认

### Guarded / standard

```text
$workflow-bootstrap 实现一个局部低风险 bugfix，需要先确认范围和计划
$workflow-bootstrap 把这个局部 bugfix 先锁范围后直接改，改完给我验证结果
```

期望：

- 路由到 `software-delivery-pipeline`
- 选择 `executionMode=standard` / `modePath=guarded`
- 使用 `10-guarded-scope-plan.md`、`11-guarded-execution.md`、`12-guarded-summary.md`
- `scope+plan` 需要确认，或在第二条提示词里把用户原话记录为 combined gate 的 approval basis
- execution 中的验证矩阵需要回填

### Audited / full

```text
$workflow-bootstrap 按这个 review handoff 修复涉及 API 响应结构的问题
```

期望：

- 路由到 `software-delivery-pipeline`
- 选择 `executionMode=full` / `modePath=audited`
- 使用 `20-audited-run-map.md` 和完整门禁链路
- review handoff、API / DTO / 数据契约等触发项不得因为改动小而降级

## 判定标准

冒烟验证通过需要满足：

- agent 明确说明路由到哪个 workflow
- 没有跳过只读、设计、review 或交付确认门禁
- 产物写入当前项目根目录的 `workflow/`
- execution mode 与任务风险匹配，且 `modePath` 映射正确
- 如果无法继续，明确说明阻塞项
