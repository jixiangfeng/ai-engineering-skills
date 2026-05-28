# Changelog

本项目记录会影响 agent 行为、workflow contract、产物路径、触发规则、安装方式和发布流程的变化。

格式参考 Keep a Changelog，版本号遵循 `docs/versioning.zh-CN.md`。

## [Unreleased]

### Added

- 新增 `docs/execution-modes.zh-CN.md`，将 `lightweight` / `standard` / `full` 明确映射为 fast / guarded / audited 三条自适应重量路径。
- 新增 `docs/prompt-modules/conditional-blocks.zh-CN.md`，定义 Risk Gate、Dirty Worktree、API Contract、Migration、Rollback、Change Review、Handoff、Verification Matrix 等条件块和 skipped reason 规则。
- 新增 `docs/run-examples/`，提供 fast patch、guarded change、audited delivery 三类示例。
- 新增 delivery 模板：
  - `00-fast-patch-summary.md`
  - `10-guarded-scope.md`
  - `11-guarded-plan.md`
  - `12-guarded-implementation.md`
  - `13-guarded-verification.md`
  - `14-guarded-summary.md`
  - `20-audited-run-map.md`
- 新增 `scripts/check-execution-mode-contract.sh`，校验 fast / guarded / audited 文档、模板和示例约束。
- 新增 `scripts/check-python.sh` 和 `scripts/check-structured.sh`，让日常检查优先使用 shell 入口，Python 仅作为结构化检查内部实现。
- `workflow-state.json` schema 新增 `modePath` 字段，支持 `fast` / `guarded` / `audited` 机器可恢复路径。
- 新增 `.gitignore`，忽略本地 `workflow/` run 产物和 Python runtime artifacts。
- 安装冒烟文档新增 fast / guarded / audited 三档真实 agent 行为抽查提示词。

### Changed

- `software-delivery-pipeline` 从单一重流程 Required files 改为三条路径：
  - Fast Patch：低风险小改，只需 `workflow-state.json` 和 `00-fast-patch-summary.md` / concise note。
  - Guarded Change：普通开发变更使用 `10-guarded-*` 轻量阶段模板。
  - Audited Delivery：高风险、handoff、契约、数据、权限或可审计交付使用 `20-audited-run-map.md` + 完整门禁链路。
- 旧 `01-08 delivery` 模板标记为 `audited only`，并将 front matter `executionMode` 调整为 `full`，避免普通任务误用。
- `delivery-workflow-state.md` 增加 `mode path` 和 `Mode Artifact Plan`，明确 fast / guarded / audited 各自的产物和升级条件。
- `docs/run-examples/README.zh-CN.md` 明确 full-run 示例不是默认路径，只代表 audited 场景。
- `docs/workflow-contracts.zh-CN.md` 和 `document-contracts.md` 增加 mode path / template taxonomy 说明。
- `generate-workflow-state.py` 增加 `--mode-path`，未传时根据 `executionMode` 自动推导。
- `validate-workflow-state.py` 增加 `executionMode` 与 `modePath` 映射一致性校验。
- `release-check.sh` 接入 `check-execution-mode-contract.sh` 和 `check-structured.sh`。
- README、使用说明、测试说明和脚本说明同步改为 shell 入口优先。
- `install-codex-skills.sh` 和 `install-claude-plugin.sh` 的 dry-run 行为输出增加 `DRY-RUN:` 前缀，避免把预览误读为真实写入。
- 本地 Codex / Claude 安装脚本会同步复制共享 `docs/`，避免安装后 `SKILL.md` 中的 `docs/...` 引用失效。

### Removed

- 移除已跟踪的 `scripts/__pycache__/check-bootstrap-routing.cpython-312.pyc`，避免每次运行检查产生无关 diff。

### Verification

- `bash scripts/check-workflow-state.sh`
- `bash scripts/check-execution-mode-contract.sh`
- `bash scripts/check-structured.sh`
- `bash scripts/check-consistency.sh`
- `bash scripts/release-check.sh --ci`

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
- 统一执行模式契约：`Execution Mode Contract`，区分 `lightweight`、`standard`、`full` 三档模式。
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
- `Execution Mode Contract` 升级为 `lightweight`、`standard`、`full` 三档，并要求 `workflow-state.json` 记录 `executionMode`。
- 各 workflow state 模板增加 `workflow-state.json` 和 `workflow/index.md` 同步要求。
- 一致性检查强化 plugin-only layout、manifest/marketplace 路径、命名契约和 release checklist 校验。
- 一致性检查接入 `workflow-state.json` schema 校验。
- `release-check.sh` 支持 `--ci`、`--no-smoke`、`--skip-dry-run`。
- `validate-workflow-state.py` 支持可选 `--strict-jsonschema`。
- `software-delivery-pipeline` 标准示例统一使用 canonical `workflow/runs/<YYYY-MM-DD>-<slug>/` 路径。

### Verification

- `bash scripts/check-consistency.sh`
- `bash scripts/smoke-install-local.sh`
