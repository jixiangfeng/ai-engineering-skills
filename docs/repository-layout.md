# Repository Layout

This repository keeps one canonical copy of every skill.

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
      <skill-name>/
        SKILL.md
        assets/
        references/
```

`plugins/ai-engineering-skills/skills/` is the source of truth for Codex and
Claude plugin installs. It contains the only copy of the skill content; there is
no root-level `skills/` directory and no symlinked duplicate.
