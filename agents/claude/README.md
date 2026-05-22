# Claude Usage

Run from the repository root:

```bash
./scripts/install-claude.sh
```

The script symlinks each directory under `skills/` into `~/.claude/skills`.

Use in Claude by naming the skill in the prompt, for example:

```text
Use the codebase-orientation skill to understand this module first.
Use the code-review-triage skill to review this module first.
Use the software-delivery-pipeline skill to implement the confirmed handoff.
Use the debug-root-cause skill to investigate this failure first.
Use the api-contract-design skill to design this endpoint contract.
Use the data-migration-planning skill to plan this schema/data migration.
```
