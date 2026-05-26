# Changelog

本项目记录会影响 agent 行为、workflow contract、产物路径、触发规则、安装方式和发布流程的变化。

格式参考 Keep a Changelog，版本号遵循 `docs/versioning.zh-CN.md`。

## [0.1.0] - 2026-05-26

### Added

- 初始 plugin-only layout：`plugins/ai-engineering-skills/skills/` 是唯一 skill 源码目录。
- 7 个 workflow skill：
  - `workflow-bootstrap`
  - `codebase-orientation`
  - `code-review-triage`
  - `debug-root-cause`
  - `api-contract-design`
  - `data-migration-planning`
  - `software-delivery-pipeline`
- 跨 workflow 工程原则：`docs/engineering-principles.zh-CN.md`。
- Bootstrap 路由示例与结构化用例：`docs/bootstrap-examples.zh-CN.md`、`tests/bootstrap-routing/cases.tsv`。
- 安装与一致性脚本：
  - `scripts/check-consistency.sh`
  - `scripts/check-workflow-state.sh`
  - `scripts/check-workflow-index.sh`
  - `scripts/install-codex-skills.sh`
  - `scripts/install-claude-plugin.sh`
  - `scripts/release-check.sh`
  - `scripts/smoke-install-local.sh`
- Codex / Claude 安装脚本的 `--dry-run`、`--force`、`--backup` 安全语义。
- 安装冒烟、发布检查、维护者指南、脚本说明文档。
- `.gitattributes` 约束后续文本文件换行。
- 机器可读 workflow state schema：`docs/workflow-state-schema.json`。
- 机器可读 workflow state 生成/校验脚本和样例：`scripts/generate-workflow-state.py`、`scripts/validate-workflow-state.py`、`tests/workflow-state/`。
- 一键发布检查脚本：`scripts/release-check.sh`。
- 示例维护策略：`docs/examples-policy.zh-CN.md`。
- 用户决策型兼容说明：`docs/compatibility.zh-CN.md`。
- workflow index 推荐模板：`docs/workflow-index-template.md`。
- workflow index 更新脚本和固定样例：`scripts/update-workflow-index.py`、`tests/workflow-index/`。
- 共享 artifact 模板：`docs/artifact-templates/`。
- Superpowers 方法论吸收说明与共享 prompt modules：`docs/superpowers-inspired-rules.zh-CN.md`、`docs/prompt-modules/`。
- Full run 示例：`docs/full-run-examples/`。
- Artifact metadata JSON Schema：`docs/artifact-metadata-schema.json`。
- Markdown、artifact metadata、bootstrap routing harness 检查脚本：`scripts/check-markdown.py`、`scripts/check-artifact-metadata.py`、`scripts/check-bootstrap-routing.py`。
- 统一停止与确认契约：`Stop and Confirmation Contract` 与 `docs/artifact-templates/stop-record.md`。
- 统一执行模式契约：`Execution Mode Contract`，区分轻量模式与完整模式。
- 各 workflow 标准 run 示例：`examples/standard-run.md`。
- 统一 handoff 流转契约：`Handoff Flow Contract`。
- README / docs / SKILL.md 职责边界契约：`Documentation Boundary Contract`。

### Changed

- `workflow-bootstrap` 强化为非平凡软件工程任务的推荐入口。
- 各 workflow `SKILL.md` 补齐 `Use when` / `Do not use when` / `Prefer another skill when` 触发边界。
- `software-delivery-pipeline` 强化完成前验证与失败阻塞规则。
- `workflow-bootstrap` 增加需求澄清和任务大小判断规则。
- `software-delivery-pipeline` 增加 `Implementation Plan`、`Implementation Strategy`、`Task Decomposition`、`Worktree Recommendation` 和 `Finish Checklist`。
- `debug-root-cause` 增加 `Debug Analysis` 结构化排查规则。
- `code-review-triage` 增加标准 `Review Findings` 与 `Fix Handoff` 闭环格式。
- 所有 workflow 接入 `Verification` 完成前验证门禁。
- prompt modules 补充正例和反例。
- `release-check.sh` 接入 markdown、artifact metadata 和 bootstrap routing harness 检查。
- `check-bootstrap-routing.py` 支持 `--runtime-command`，可接外部 Codex/Claude routing wrapper 做真实运行时验收。
- `docs/full-run-examples/<workflow>/files/` 展开每个 workflow 的完整阶段文件示例。
- 各 workflow state 模板增加 `workflow-state.json` 和 `workflow/index.md` 同步要求。
- 一致性检查强化 plugin-only layout、manifest/marketplace 路径、命名契约和 release checklist 校验。
- 一致性检查接入 `workflow-state.json` schema 校验。
- `release-check.sh` 支持 `--ci`、`--no-smoke`、`--skip-dry-run`。
- `validate-workflow-state.py` 支持可选 `--strict-jsonschema`。
- `software-delivery-pipeline` 标准示例统一使用 canonical `workflow/runs/<YYYY-MM-DD>-<slug>/` 路径。

### Verification

- `bash scripts/check-consistency.sh`
- `bash scripts/smoke-install-local.sh`
