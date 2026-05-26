# Testing and Consistency Checks

本仓库的主要产物是 skill、模板、reference 和 plugin metadata。测试重点不是运行业务代码，而是防止 workflow 契约、文档、模板和 manifest 漂移。

## 推荐检查

```bash
bash scripts/check-consistency.sh
```

更细的专项检查：

```bash
python3 scripts/check-markdown.py README.md docs plugins/ai-engineering-skills/skills
python3 scripts/check-artifact-metadata.py --schema docs/artifact-metadata-schema.json docs/full-run-examples tests/artifact-metadata/valid-artifact.md
python3 scripts/check-bootstrap-routing.py --cases tests/bootstrap-routing/cases.tsv
python3 scripts/check-bootstrap-routing.py --cases tests/bootstrap-routing/cases.tsv --runtime-command tests/bootstrap-routing/fake-agent-runtime.py
```

发布或真实安装前，推荐直接运行：

```bash
bash scripts/release-check.sh
bash scripts/release-check.sh --ci
```

修改安装脚本或发布前，额外运行隔离安装冒烟测试：

```bash
bash scripts/smoke-install-local.sh
```

修改 `workflow-state.json` schema 或机器可读 state 规则时，运行：

```bash
bash scripts/check-workflow-state.sh
bash scripts/check-workflow-index.sh
```

## 常见任务到检查命令

| 任务 | 推荐检查 |
| --- | --- |
| 修改 README 或 docs | `bash scripts/check-consistency.sh` |
| 修改 `SKILL.md` | `bash scripts/check-consistency.sh` |
| 修改模板或 reference | `bash scripts/check-consistency.sh` |
| 修改 `workflow-bootstrap` 路由 | `bash scripts/check-consistency.sh` + `python3 scripts/check-bootstrap-routing.py --cases tests/bootstrap-routing/cases.tsv` |
| 修改安装脚本 | `bash scripts/check-consistency.sh` + `bash scripts/smoke-install-local.sh` |
| 修改 plugin metadata | `bash scripts/check-consistency.sh` + `bash scripts/smoke-install-local.sh` |
| 修改 `workflow-state.json` schema | `bash scripts/check-workflow-state.sh` + `bash scripts/check-workflow-index.sh` + `bash scripts/check-consistency.sh` |
| 发布或真实安装前 | `bash scripts/release-check.sh`，并按 `docs/release-checklist.zh-CN.md` 人工确认 |

该脚本做轻量静态检查：

- plugin 源目录存在
- `.codex-plugin/plugin.json` 中声明的 `skills` 路径存在
- README 中列出的 skill 在源码目录中存在
- 每个 skill 都有 `SKILL.md`
- 非路由 skill 都有 `assets/` 和 `references/`
- `SKILL.md` 中声明的 required files 在对应 template 目录中存在
- `docs/workflow-contracts.zh-CN.md` 中的关键 contract 字段仍存在
- `workflow-bootstrap` 覆盖所有 workflow skill
- Codex plugin `defaultPrompt` 推荐使用 `workflow-bootstrap`
- `tests/bootstrap-routing/cases.tsv` 中的期望 workflow 在 skill 目录中存在
- bootstrap routing harness 对结构化用例做确定性规则检查
- markdown fence、尾随空格和标题层级检查
- full-run artifact metadata YAML 块检查
- `docs/bootstrap-examples.zh-CN.md` 覆盖路由验收说明
- 安装脚本存在、可执行、支持 `--dry-run` / `--force` / `--backup`
- Claude 安装脚本存在、可执行、支持 `--dry-run` / `--force` / `--backup`
- 安装脚本仍使用唯一 skill 源目录 `plugins/ai-engineering-skills/skills`
- Claude 安装脚本仍使用唯一 plugin 源目录 `plugins/ai-engineering-skills`
- 本地安装冒烟脚本存在、可执行，并使用临时目录隔离 Codex/Claude 安装目标
- 仓库根目录没有重新引入 `skills/` 源码副本
- `workflow-state.json` schema 能接受有效样例并拒绝无效样例

## 何时运行

- 修改任意 `SKILL.md` 后
- 修改任意 `assets/*-templates/` 后
- 修改 `docs/skills-guide.zh-CN.md`、`docs/workflow-contracts.zh-CN.md` 或 README 后
- 修改 plugin manifest 或 marketplace metadata 后
- 修改 `workflow-bootstrap` 路由规则或 bootstrap 示例后
- 修改安装脚本或安装冒烟文档后
- 发布或安装前

发布或真实安装前，按 [`docs/release-checklist.zh-CN.md`](./release-checklist.zh-CN.md) 做完整检查。

## 检查边界

该脚本只做结构和契约一致性检查，不验证 agent 实际触发效果，也不替代人工 review。若要验证真实调用行为，需要在 Codex 或 Claude 中安装 plugin 后，用典型提示词手动检查路由和产物。

## Bootstrap 路由验收资产

- 人工说明: [`docs/bootstrap-examples.zh-CN.md`](./bootstrap-examples.zh-CN.md)
- 结构化用例: `tests/bootstrap-routing/cases.tsv`

`cases.tsv` 用于保存提示词、期望 workflow、是否应创建 workflow run。`scripts/check-bootstrap-routing.py` 会用确定性路由规则检查这些用例；真实 Codex / Claude skill 选择仍需要安装后人工或外部 agent harness 测试。

## Workflow State Schema 验证

`scripts/check-workflow-state.sh` 使用 Python 标准库运行 `scripts/validate-workflow-state.py` 和 `scripts/generate-workflow-state.py`，不依赖外部 `jsonschema` 包。

它会校验：

- `docs/workflow-state-schema.json` 的基本结构
- `tests/workflow-state/valid-state.json` 必须通过
- `tests/workflow-state/invalid-state.json` 必须失败
- 生成器输出必须匹配 `tests/workflow-state/generated-state.expected.json`

也可以手工验证真实 workflow state：

```bash
python3 scripts/validate-workflow-state.py workflow/<run>/workflow-state.json
python3 scripts/validate-workflow-state.py --strict-jsonschema workflow/<run>/workflow-state.json
```

`--strict-jsonschema` 是可选模式，只有本地安装了 `jsonschema` 包时才使用；仓库默认检查不依赖它。

也可以生成初始 state：

```bash
python3 scripts/generate-workflow-state.py \
  --workflow codebase-orientation \
  --run-path workflow/orientation/2026-05-26-example \
  --output workflow/orientation/2026-05-26-example/workflow-state.json
```

## Workflow Index 验证

`scripts/check-workflow-index.sh` 会用生成器创建临时 `workflow-state.json`，再运行 `scripts/update-workflow-index.py`，并与 `tests/workflow-index/expected-index.md` 做 diff。

也可以手工更新真实项目索引：

```bash
python3 scripts/update-workflow-index.py \
  --state workflow/<run>/workflow-state.json \
  --index workflow/index.md \
  --summary workflow/<run>/07-summary.md
```

## 安装冒烟验证

安装流程见 [`docs/install-smoke-test.zh-CN.md`](./install-smoke-test.zh-CN.md)。

推荐先运行：

```bash
bash scripts/install-codex-skills.sh --dry-run
```

确认 source、target 和即将安装的 skill 正确后，再用 `--backup` 或 `--force` 安装。

Claude plugin 也使用同样的安全语义：

```bash
bash scripts/install-claude-plugin.sh --dry-run
bash scripts/install-claude-plugin.sh --dry-run --backup
```

如果修改了安装脚本，继续运行：

```bash
bash scripts/smoke-install-local.sh
```

该脚本会把 Codex skills 和 Claude plugin 安装到 `mktemp -d` 创建的隔离目录，检查关键文件存在后自动清理，不写入真实 `~/.codex` 或 `~/.claude`。
