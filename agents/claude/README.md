# Claude Usage

Run from the repository root:

```bash
./scripts/install-claude.sh
```

默认会删除已有同名真实目录，并改为链接到本仓库的 skill；如需备份可使用 `--backup-existing`，如需保守模式可使用 `--strict`。

The script symlinks each directory under `skills/` into `~/.claude/skills`.

## Marketplace Plugin

This repository also includes Claude Code plugin marketplace metadata.
The canonical skill content remains under the repository root `skills/`
directory; `plugins/` only contains plugin metadata.

After publishing the repository to GitHub:

```bash
claude plugin marketplace add <owner>/ai-engineering-skills
claude plugin install ai-engineering-skills@ai-engineering-skills
```

For local development, prefer `./scripts/install-claude.sh` because it links
directly to this working tree.

Use in Claude by naming the skill in the prompt, for example:

```text
Use the codebase-orientation skill to understand this module first.
Use the code-review-triage skill to review this module first.
Use the software-delivery-pipeline skill to implement the confirmed handoff.
Use the debug-root-cause skill to investigate this failure first.
Use the api-contract-design skill to design this endpoint contract.
Use the data-migration-planning skill to plan this schema/data migration.
```
