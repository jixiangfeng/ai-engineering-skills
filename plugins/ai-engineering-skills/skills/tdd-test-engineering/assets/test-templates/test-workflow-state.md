---
workflow: tdd-test-engineering
runId: <YYYYMMDD-slug>
runPath: workflow/tests/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: state
status: in_progress
source: workflow-state
allowsCodeEdit: false
nextAction: continue_workflow
verificationRequired: true
---
# 测试工程状态

## 文档元信息
- 项目根目录：
- Run 路径：`workflow/tests/<YYYY-MM-DD>-<slug>/`
- executionMode：`standard`
- modePath：`guarded`
- 模式选择理由：
- 当前分支 / commit：
- 更新时间：

## 当前状态
- 当前阶段：
- 当前状态：
- 最新文档：
- 下一步：
- 是否允许改测试代码：
- 是否允许改生产代码：
- 阻塞项：
- 已批准测试用例基线：
- 修复确认状态：

## workflow-state.json
- JSON 状态文件：`workflow-state.json`
- 同步字段：`workflow`、`runPath`、`executionMode`、`modePath`、`status`、`currentStage`、`latestDocument`、`nextAction`、`codeEditsAllowed`

## 生命周期阶段
| 阶段 | 文档 | 状态 | 确认记录 |
| --- | --- | --- | --- |
| environment_safety_gate | `00-environment-safety-gate.md` |  |  |
| requirement_analysis | `10-test-scope-criteria.md` |  |  |
| acceptance_definition | `10-test-scope-criteria.md` |  |  |
| impact_analysis | `10-test-scope-criteria.md` / `11-test-plan-cases.md` |  |  |
| test_case_design | `11-test-plan-cases.md` |  |  |
| test_case_review | `11-test-plan-cases.md` |  |  |
| environment_validation | `12-test-execution-evidence.md` |  |  |
| test_implementation | `12-test-execution-evidence.md` |  |  |
| test_execution | `12-test-execution-evidence.md` |  |  |
| issue_review | `12-test-execution-evidence.md` |  |  |
| issue_fix | `12-test-execution-evidence.md` |  |  |
| regression | `12-test-execution-evidence.md` / `13-test-summary.md` |  |  |
| final_summary | `13-test-summary.md` |  |  |

## workflow/index.md
- 如项目存在 `workflow/index.md`，更新当前 run 条目。

## 决策记录
-

## Resume 记录
-
