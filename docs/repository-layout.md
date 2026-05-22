# Repository Layout

This repository keeps one canonical copy of every skill.

```text
skills/
  <skill-name>/
    SKILL.md
    assets/
    references/
```

`skills/` is the source of truth for Codex, Claude local installs, and GitHub
directory-based installs.

```text
scripts/
  install-codex.sh
  install-claude.sh
```

The local install scripts link every directory under `skills/` into the target
agent's local skill directory.

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
      <skill-name> -> ../../../skills/<skill-name>
```

These files are marketplace metadata for Claude Code and Codex. The
`plugins/ai-engineering-skills/skills/` entries are symlinks to the canonical
skill directories. Do not duplicate or edit skill content under `plugins/`; edit
the canonical skill under `skills/`.
