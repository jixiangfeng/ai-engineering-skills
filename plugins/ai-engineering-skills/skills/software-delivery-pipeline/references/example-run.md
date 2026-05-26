# 示例执行

示例运行目录：

`<project-root>/workflow/runs/2026-05-21-fix-login-timeout/`

文件（简单任务、无独立架构文档时）：

- `01-delivery-requirements.md`
- `02-delivery-plan.md`
- `03-delivery-implementation.md`
- `04-delivery-debugging.md`
- `05-delivery-verification.md`
- `06-delivery-summary.md`

## 示例流程

1. 需求确认记录登录超时失败行为和验收标准。
2. 实施计划拆分测试覆盖、实现和验证步骤。
3. 实施记录说明新增失败测试、更新超时处理逻辑，并记录修改文件。
4. 调试记录说明一次由环境配置不一致导致的失败尝试。
5. 验证记录保存定向测试和 smoke check 的结果。
6. 交付摘要给出结果、风险和后续事项。

## 示例最终回复

“已完成。我按 software-delivery-pipeline 工作流完成了修复。中间产物在 `<project-root>/workflow/runs/2026-05-21-fix-login-timeout/`，建议优先看 `06-delivery-summary.md` 的摘要和 `05-delivery-verification.md` 的验证证据。”
