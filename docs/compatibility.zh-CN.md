# Compatibility Notes

本文只说明 `ai-engineering-skills` 与其他 skill 套件同时安装时的决策边界，不规定全局优先级。

## 用户自主决策原则

当 `ai-engineering-skills` 与 `superpowers`、`andrej-karpathy-skills` 或其他 skill 套件同时安装时，默认不假设谁覆盖谁。

用户或当前项目可以按任务指定：

- 以哪个 workflow skill 作为主流程
- 哪些行为准则作为底层工程约束
- 是否跳过文档化 workflow，直接使用其他套件的轻量技巧

## 推荐用法

- 需要文档化、可恢复、可 handoff 的工程任务时，可选择 `workflow-bootstrap` 作为入口。
- 需要轻量编码行为准则时，可把其他 guideline 类 skill 当作补充约束。
- 如果两个 skill 给出冲突规则，先遵守用户最新指令；仍冲突时暂停确认。

## 不做的事

- 不声明 `ai-engineering-skills` 必须优先于其他套件。
- 不自动接管其他套件的 workflow。
- 不要求用户按固定组合安装。
