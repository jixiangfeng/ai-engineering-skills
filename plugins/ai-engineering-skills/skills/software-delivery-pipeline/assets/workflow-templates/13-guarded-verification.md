---
workflow: software-delivery-pipeline
runId: <YYYYMMDD-slug>
runPath: workflow/runs/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: verification
status: draft
source: user-request
allowsCodeEdit: false
nextAction: continue_summary
---
# Guarded Verification

## Plan Verification
- 来源计划：`11-guarded-plan.md`
- 所有阻塞性验收项是否都有结果：是 / 否

## Verification Matrix
| 验收项 | 命令 / 方式 | 结果 | 证据 | 未覆盖原因 |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

## Diff Scope Check
- `git diff --name-only` 摘要：
- 是否只包含计划允许的文件：是 / 否
- 是否存在格式化、换行或无关 diff：无 / 有：

## Skipped Checks
-

## Completion Judgment
- completed | blocked | needs-user-confirmation
