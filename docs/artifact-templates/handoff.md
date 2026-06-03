---
workflow: <workflow>
runId: <YYYYMMDD-slug>
runPath: workflow/<run>
executionMode: standard
stage: handoff
status: handoff_ready
source: workflow-handoff
allowsCodeEdit: false
nextAction: start_target_workflow
fromWorkflow: <source-workflow>
toWorkflow: <target-workflow>
selectedItems: []
verificationRequired: true
---
# <Source Workflow> to <Target Workflow> Handoff

## 文档元信息
- Source run path：
- Source workflow：
- Target workflow：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- 当前状态：

## Accepted Scope

## Excluded Scope

## Evidence

| 来源 | 结论 |
| --- | --- |
|  |  |

## Constraints

## Unresolved Questions

## Verification Focus

## Source of Truth Artifacts
- `path/to/document.md`

## Recommended Next Workflow
- `<target-workflow>`

## Why Next Workflow Is Appropriate

## Machine-Readable Summary

```yaml
source_run_path:
source_workflow:
target_workflow:
accepted_scope: []
excluded_scope: []
constraints: []
unresolved_questions: []
verification_focus: []
source_of_truth_artifacts:
  - "path/to/document.md"
recommended_next_workflow: "<target-workflow>"
```
