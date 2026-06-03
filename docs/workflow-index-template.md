# Workflow Index

本文是当前项目根目录下 `workflow/index.md` 的推荐格式，用于登记 workflow run，帮助 agent 和维护者查找历史产物、恢复未完成任务、判断下一步。

## Runs

| Updated At | Workflow | Status | Scope | Run Path | Summary | Next Action |
| --- | --- | --- | --- | --- | --- | --- |
| 2026-05-26T00:00:00+08:00 | `codebase-orientation` | `completed` | 示例 scope | `workflow/orientation/2026-05-26-example` | `workflow/orientation/2026-05-26-example/12-orientation-summary.md` | 无 |

## 状态枚举

- `not_started`
- `in_progress`
- `blocked`
- `pending_human_confirmation`
- `handoff_ready`
- `completed`
- `abandoned`

## 维护规则

- 每次创建 workflow run 时，应新增一行。
- 每次 workflow 状态变化时，应更新对应行的 `Updated At`、`Status`、`Summary`、`Next Action`。
- 如果同一 scope 有多个未完成 run，不要自动选择；列出候选让用户确认。
- `completed` run 默认不继续，除非用户明确要求 reopen 或基于该 run 开启新 workflow。
