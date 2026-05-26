# Versioning Policy

本文定义 `ai-engineering-skills` 的版本管理规则。版本号记录在：

- `plugins/ai-engineering-skills/.codex-plugin/plugin.json`
- `plugins/ai-engineering-skills/.claude-plugin/plugin.json`
- `CHANGELOG.md`

发布前必须确认三处版本一致。

## 版本号语义

使用 `MAJOR.MINOR.PATCH`。

### MAJOR

出现以下变化时提升 MAJOR：

- workflow 目录结构或产物路径发生不兼容变化
- 删除或重命名已有 skill
- 删除已有阶段文档或 handoff 文件
- `workflow-state.json` schema 不兼容
- 安装方式发生不兼容变化

### MINOR

出现以下变化时提升 MINOR：

- 新增 skill
- 新增 workflow 阶段、模板、handoff 类型
- 新增机器可读字段且保持向后兼容
- 新增安装、校验、冒烟脚本能力
- 强化触发规则、resume 规则、发布检查规则但不破坏已有产物

### PATCH

出现以下变化时提升 PATCH：

- 文档澄清
- 示例补充
- 校验脚本 bugfix
- 不改变行为契约的措辞调整
- 安装脚本错误提示优化

## 必须记录到 CHANGELOG 的变化

- skill 行为规则变化
- workflow contract、state schema、handoff contract 变化
- 产物路径、文件命名、目录 slug 变化
- `workflow-bootstrap` 触发或路由规则变化
- 安装脚本语义变化
- plugin manifest 或 marketplace metadata 变化
- 与其他 skill 套件兼容策略变化

## 发布前检查

发布前运行：

```bash
bash scripts/check-consistency.sh
bash scripts/smoke-install-local.sh
```

并按 `docs/release-checklist.zh-CN.md` 检查真实安装前 dry-run。
