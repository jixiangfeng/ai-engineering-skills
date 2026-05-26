# Release Checklist

本文记录 `ai-engineering-skills` 发布或本地安装前的检查清单。目标是确认 workflow 契约、安装脚本、plugin metadata 和本地工作树状态都处于可交付状态。

## 1. 工作树确认

```bash
git status --short
```

确认：

- 当前未提交改动都是本次发布预期内容。
- 没有无关格式化、换行归一化或临时文件。
- 没有重新引入根目录 `skills/` 源码副本。

## 2. 静态一致性检查

推荐直接运行完整发布检查：

```bash
bash scripts/release-check.sh
bash scripts/release-check.sh --ci
```

或分步运行：

```bash
bash scripts/check-consistency.sh
bash scripts/check-workflow-state.sh
bash scripts/check-workflow-index.sh
```

确认：

- README、使用说明、skill 目录一致。
- `SKILL.md` 声明的 required files 都有模板。
- Codex / Claude metadata 存在。
- Codex / Claude manifest 版本与 `CHANGELOG.md` 当前版本一致。
- 安装脚本支持 `--dry-run`、`--force`、`--backup`。
- 命名契约、handoff 流转、执行模式、恢复规则和文档职责边界仍存在。
- `workflow-state.json` schema 有有效/无效样例验证，生成器输出与固定样例一致。
- `workflow/index.md` 更新脚本输出与固定样例一致。

## 2.1 最小发布检查清单

发布前至少确认：

- manifest：Codex / Claude plugin manifest 存在，skills 路径指向 `plugins/ai-engineering-skills/skills/`。
- marketplace：根目录 Claude marketplace metadata 存在并指向当前 plugin。
- 版本号：Codex manifest、Claude manifest、`CHANGELOG.md` 当前版本一致。
- 文档：README、`docs/skills-guide.zh-CN.md`、`docs/workflow-contracts.zh-CN.md`、`docs/testing.zh-CN.md` 已同步。
- 示例：每个实际 workflow 都有 `examples/standard-run.md`。
- 模板：`SKILL.md` required files 均有对应 `assets/` 模板。
- 安装脚本：Codex / Claude 安装脚本默认不覆盖，且保留 `--dry-run`、`--force`、`--backup`。
- 测试脚本：`scripts/check-consistency.sh`、`scripts/check-workflow-state.sh` 和 `scripts/smoke-install-local.sh` 可执行并通过。
- 发布说明：影响 agent 行为、workflow contract、产物路径、触发规则或安装方式的变化已写入 `CHANGELOG.md`。

## 3. 隔离安装冒烟

```bash
bash scripts/smoke-install-local.sh
```

确认：

- Codex skills 能安装到临时 `CODEX_SKILLS_DIR`。
- Claude plugin 能安装到临时 `CLAUDE_PLUGINS_DIR`。
- 安装后的关键 `SKILL.md` 和 plugin metadata 存在。
- 脚本结束后临时目录会自动清理。

## 4. 真实安装前预览

不要直接覆盖真实本地目录。先运行：

```bash
bash scripts/install-codex-skills.sh --dry-run --backup
bash scripts/install-claude-plugin.sh --dry-run --backup
```

确认 source、target、backup root 和即将安装的 skill/plugin 符合预期。

## 5. 文档同步检查

确认以下文件的说明没有互相漂移：

- `README.md`
- `docs/skills-guide.zh-CN.md`
- `docs/testing.zh-CN.md`
- `docs/install-smoke-test.zh-CN.md`
- `docs/bootstrap-examples.zh-CN.md`
- `docs/examples-policy.zh-CN.md`
- `docs/compatibility.zh-CN.md`
- `docs/workflow-contracts.zh-CN.md`
- `plugins/ai-engineering-skills/skills/*/examples/standard-run.md`
- `plugins/ai-engineering-skills/.codex-plugin/plugin.json`
- `plugins/ai-engineering-skills/.claude-plugin/plugin.json`
- `CHANGELOG.md`
- `docs/versioning.zh-CN.md`

## 6. 冒烟提示词

安装并重启 Codex 或 Claude Code 后，至少手工验证：

```text
$workflow-bootstrap 熟悉下当前项目
$workflow-bootstrap 排查这个启动失败
$workflow-bootstrap 按这个 handoff 落地
```

确认：

- agent 明确说明路由到哪个 workflow。
- 没有跳过只读、设计、review 或交付确认门禁。
- workflow 产物写入当前项目根目录的 `workflow/`。

## 7. 换行策略

仓库使用 `.gitattributes` 约束后续文本文件换行。不要为了发布单独做全仓换行归一化；如果某次确实要统一换行，应作为独立提交处理。
