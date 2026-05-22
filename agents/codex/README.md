# Codex Usage

Run from the repository root:

```bash
./scripts/install-codex.sh
```

默认会删除已有同名真实目录，并改为链接到本仓库的 skill；如需备份可使用 `--backup-existing`，如需保守模式可使用 `--strict`。

The script symlinks each directory under `skills/` into `~/.codex/skills`.

## Marketplace Plugin

This repository also includes Codex plugin marketplace metadata:

```text
.agents/plugins/marketplace.json
plugins/ai-engineering-skills/.codex-plugin/plugin.json
```

The plugin exposes the canonical root `skills/` directory through symlinks under
`plugins/ai-engineering-skills/skills/`.

Use in Codex:

```text
$codebase-orientation
$code-review-triage
$software-delivery-pipeline
$debug-root-cause
$api-contract-design
$data-migration-planning
```
