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

## Claude 安装后文件检查

确认以下文件存在：

```text
~/.claude/plugins/ai-engineering-skills/.claude-plugin/plugin.json
~/.claude/plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md
~/.claude/plugins/ai-engineering-skills/skills/codebase-orientation/SKILL.md
~/.claude/plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md
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
- 先写需求/计划文档并等待确认，不直接改代码

## 判定标准

冒烟验证通过需要满足：

- agent 明确说明路由到哪个 workflow
- 没有跳过只读、设计、review 或交付确认门禁
- 产物写入当前项目根目录的 `workflow/`
- 如果无法继续，明确说明阻塞项
