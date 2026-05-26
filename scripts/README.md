# Scripts

本目录包含仓库维护、安装和冒烟验证脚本。

## `check-consistency.sh`

轻量静态一致性检查。用于确认 skill 目录、README、使用说明、模板、workflow contract、plugin metadata 和安装脚本没有明显漂移。

常用命令：

```bash
bash scripts/check-consistency.sh
```

## `smoke-install-local.sh`

隔离安装冒烟测试。脚本会创建临时目录，分别安装 Codex skills 和 Claude plugin，然后检查关键文件是否存在，最后自动清理。

常用命令：

```bash
bash scripts/smoke-install-local.sh
```

## `check-workflow-state.sh`

验证 `workflow-state.json` schema、测试样例和生成器输出。该脚本调用 Python 标准库工具，不需要额外依赖。

常用命令：

```bash
bash scripts/check-workflow-state.sh
```

也可以直接校验某个真实 state 文件：

```bash
python3 scripts/validate-workflow-state.py workflow/<run>/workflow-state.json
python3 scripts/validate-workflow-state.py --strict-jsonschema workflow/<run>/workflow-state.json
```

## `generate-workflow-state.py`

生成符合 schema 的 `workflow-state.json`。默认不覆盖已有文件；需要覆盖时显式传 `--force`。

示例：

```bash
python3 scripts/generate-workflow-state.py \
  --workflow software-delivery-pipeline \
  --run-path workflow/runs/2026-05-26-example \
  --current-stage requirements \
  --latest-document 01-delivery-requirements.md \
  --next-action "Wait for requirements confirmation." \
  --output workflow/runs/2026-05-26-example/workflow-state.json
```

## `update-workflow-index.py`

根据某个 `workflow-state.json` upsert 当前项目的 `workflow/index.md`。同一个 `runPath` 会更新原行，不存在则追加。

示例：

```bash
python3 scripts/update-workflow-index.py \
  --state workflow/runs/2026-05-26-example/workflow-state.json \
  --index workflow/index.md \
  --summary workflow/runs/2026-05-26-example/06-delivery-summary.md
```

对应检查：

```bash
bash scripts/check-workflow-index.sh
```

## `release-check.sh`

发布或真实安装前的一键非破坏性检查。它会依次运行静态一致性检查、workflow state schema 校验、workflow index 校验、隔离安装冒烟，以及 Codex/Claude 真实安装 dry-run 预览。

常用命令：

```bash
bash scripts/release-check.sh
bash scripts/release-check.sh --ci
bash scripts/release-check.sh --no-smoke --skip-dry-run
python3 scripts/check-markdown.py README.md docs plugins/ai-engineering-skills/skills
python3 scripts/check-artifact-metadata.py --schema docs/artifact-metadata-schema.json docs/artifact-templates plugins/ai-engineering-skills/skills/*/assets/*-templates docs/full-run-examples tests/artifact-metadata/valid-artifact.md
python3 scripts/check-bootstrap-routing.py --cases tests/bootstrap-routing/cases.tsv
python3 scripts/check-bootstrap-routing.py --cases tests/bootstrap-routing/cases.tsv --runtime-command tests/bootstrap-routing/fake-agent-runtime.py
```

## `install-codex-skills.sh`

把 `plugins/ai-engineering-skills/skills` 安装到 `~/.codex/skills` 或 `CODEX_SKILLS_DIR`。

默认不覆盖已有 skill。先用 dry-run 查看计划：

```bash
bash scripts/install-codex-skills.sh --dry-run
bash scripts/install-codex-skills.sh --dry-run --backup
```

确认后再选择：

```bash
bash scripts/install-codex-skills.sh --backup
bash scripts/install-codex-skills.sh --force
```

## `install-claude-plugin.sh`

把 `plugins/ai-engineering-skills` 安装到 `~/.claude/plugins/ai-engineering-skills` 或 `CLAUDE_PLUGINS_DIR`。

默认不覆盖已有 plugin。先用 dry-run 查看计划：

```bash
bash scripts/install-claude-plugin.sh --dry-run
bash scripts/install-claude-plugin.sh --dry-run --backup
```

确认后再选择：

```bash
bash scripts/install-claude-plugin.sh --backup
bash scripts/install-claude-plugin.sh --force
```
