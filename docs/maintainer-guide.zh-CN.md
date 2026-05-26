# Maintainer Guide

本文是 `ai-engineering-skills` 的维护者入口，说明仓库结构、常见维护任务、应修改的文件和应运行的检查命令。

## 仓库结构

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
docs/
scripts/
tests/
```

`plugins/ai-engineering-skills/skills/` 是唯一 skill 源码目录。不要在仓库根目录重新创建 `skills/` 副本。

## 常见任务

| 任务 | 主要文件 | 必跑检查 |
| --- | --- | --- |
| 修改 skill 行为 | `plugins/ai-engineering-skills/skills/<skill>/SKILL.md` | `bash scripts/check-consistency.sh` |
| 修改共享 prompt module | `docs/prompt-modules/`、引用它的 `SKILL.md`、`docs/superpowers-inspired-rules.zh-CN.md` | `bash scripts/check-consistency.sh` |
| 修改 skill 触发边界 | 对应 `SKILL.md` 的 `Usage Boundary`、`workflow-bootstrap/SKILL.md`、`docs/bootstrap-examples.zh-CN.md` | `bash scripts/check-consistency.sh` |
| 修改阶段模板 | `plugins/ai-engineering-skills/skills/<skill>/assets/` | `bash scripts/check-consistency.sh` |
| 修改标准 run 示例 | `plugins/ai-engineering-skills/skills/<skill>/examples/standard-run.md`、对应 `SKILL.md` | `bash scripts/check-consistency.sh` |
| 修改示例策略 | `docs/examples-policy.zh-CN.md`、相关 examples | `bash scripts/check-consistency.sh` |
| 修改兼容说明 | `docs/compatibility.zh-CN.md` | `bash scripts/check-consistency.sh` |
| 修改 handoff / state / summary 契约 | `docs/workflow-contracts.zh-CN.md`、对应 `references/` | `bash scripts/check-consistency.sh` |
| 修改 handoff 流转关系 | `docs/workflow-contracts.zh-CN.md`、`workflow-bootstrap/SKILL.md`、下游 workflow `SKILL.md` | `bash scripts/check-consistency.sh` |
| 修改 README / docs / SKILL.md 职责边界 | `docs/workflow-contracts.zh-CN.md`、README、相关 docs 或 skill | `bash scripts/check-consistency.sh` |
| 修改共享 artifact 模板 | `docs/artifact-templates/`、`docs/workflow-contracts.zh-CN.md` | `bash scripts/check-consistency.sh` |
| 修改停止条件或确认点 | `docs/workflow-contracts.zh-CN.md`、`docs/artifact-templates/stop-record.md`、相关 `SKILL.md` | `bash scripts/check-consistency.sh` |
| 修改轻量/完整模式 | `docs/workflow-contracts.zh-CN.md`、相关 `SKILL.md`、state/summary 模板 | `bash scripts/check-consistency.sh` |
| 修改机器可读 state 或 workflow index 契约 | `docs/workflow-state-schema.json`、`docs/workflow-index-template.md`、`docs/workflow-contracts.zh-CN.md`、`scripts/generate-workflow-state.py`、`scripts/update-workflow-index.py`、`scripts/validate-workflow-state.py`、`tests/workflow-state/`、`tests/workflow-index/` | `bash scripts/check-workflow-state.sh` + `bash scripts/check-workflow-index.sh` + `bash scripts/check-consistency.sh` |
| 修改命名规范或 run 路径 | `docs/workflow-contracts.zh-CN.md`、相关 `SKILL.md`、`docs/skills-guide.zh-CN.md`、示例 | `bash scripts/check-consistency.sh` |
| 修改路由规则 | `workflow-bootstrap/SKILL.md`、`docs/bootstrap-examples.zh-CN.md`、`tests/bootstrap-routing/cases.tsv` | `bash scripts/check-consistency.sh` |
| 修改安装脚本 | `scripts/install-codex-skills.sh`、`scripts/install-claude-plugin.sh` | `bash scripts/check-consistency.sh` + `bash scripts/smoke-install-local.sh` |
| 修改 plugin metadata | `.codex-plugin/plugin.json`、`.claude-plugin/plugin.json`、marketplace 文件 | `bash scripts/check-consistency.sh` + `bash scripts/smoke-install-local.sh` |
| 修改 plugin-only layout | `docs/repository-layout.md`、manifest、marketplace、安装脚本 | `bash scripts/check-consistency.sh` + `bash scripts/smoke-install-local.sh` |
| 修改版本或发布说明 | `CHANGELOG.md`、`docs/versioning.zh-CN.md`、plugin manifest | `bash scripts/check-consistency.sh` |
| 发布或真实安装前 | README、docs、scripts、plugin metadata | `bash scripts/release-check.sh` + 按 `docs/release-checklist.zh-CN.md` |

## 修改原则

- 优先改 source of truth，不复制同一规则到多个地方。
- 新增跨 workflow 行为底线时，优先放入 `docs/engineering-principles.zh-CN.md` 或 `docs/workflow-contracts.zh-CN.md`。
- 新增可复用提示词规则时，优先放入 `docs/prompt-modules/`，再由 `SKILL.md` 引用，避免每个 skill 复制一套长规则。
- 新增或调整产物格式时，优先更新 `docs/artifact-templates/`，再同步具体 workflow 模板。
- 修改恢复、索引或机器可读状态时，同步更新 `docs/workflow-state-schema.json` 和 `docs/workflow-index-template.md`。
- 新增某个 workflow 的细节规则时，优先放入该 skill 的 `references/`，再从 `SKILL.md` 引用。
- 新增或修改 required files 时，同步更新对应 `assets/*-templates/`。
- 修改安装脚本时，保持默认不覆盖真实本地目录，并保留 `--dry-run`、`--force`、`--backup`。
- 修改 skill 行为、workflow contract、触发规则、安装语义或 manifest 时，同步更新 `CHANGELOG.md`。
- 不做无关格式化或全仓换行归一化；换行策略由 `.gitattributes` 约束后续改动。

## 发布前最小命令

```bash
bash scripts/check-consistency.sh
bash scripts/check-workflow-state.sh
bash scripts/check-workflow-index.sh
bash scripts/smoke-install-local.sh
bash scripts/install-codex-skills.sh --dry-run --backup
bash scripts/install-claude-plugin.sh --dry-run --backup
```

等价的一键命令：

```bash
bash scripts/release-check.sh
bash scripts/release-check.sh --ci
```

## 相关文档

- `docs/skills-guide.zh-CN.md`
- `CHANGELOG.md`
- `docs/superpowers-inspired-rules.zh-CN.md`
- `docs/versioning.zh-CN.md`
- `docs/skill-consistency-checklist.md`
- `docs/testing.zh-CN.md`
- `docs/install-smoke-test.zh-CN.md`
- `docs/release-checklist.zh-CN.md`
- `scripts/README.md`
