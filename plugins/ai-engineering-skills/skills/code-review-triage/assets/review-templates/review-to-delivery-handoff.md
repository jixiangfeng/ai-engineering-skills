---
workflow: code-review-triage
runId: <YYYYMMDD-slug>
runPath: workflow/reviews/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: handoff
status: handoff_ready
source: workflow-handoff
allowsCodeEdit: false
nextAction: start_target_workflow
fromWorkflow: code-review-triage
toWorkflow: software-delivery-pipeline
selectedItems: []
verificationRequired: true
---
# Review 到交付流程交接单

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- 来源文档：
- 文档状态：

## 文档状态
- 待 software-delivery-pipeline 读取

## 来源 Review Run
- 路径：`workflow/reviews/<YYYY-MM-DD>-<slug>/`

## 用户已确认的修复范围
- 已选 Findings：
- 明确不修 Findings：

## 修复目标摘要
-

## Fix Handoff

### Accepted scope
-

### Excluded scope
-

### Files likely affected
-

### Verification focus
-

### Recommended next workflow
- software-delivery-pipeline

## Findings 明细

### F-001
- 严重级别：
- 问题摘要：
- 证据位置：`path/to/file:line`
- 影响：
- 已确认修复方向：
- 验收标准：

## 用户约束
-

## 架构门禁建议
- 是否建议进入 `software-delivery-pipeline` 的架构设计阶段：是 | 否
- 原因：

## 修复计划摘要
-

## 验证要求
-

## 禁止事项 / 不做范围
-


## 澄清与收敛记录
- AI 发现的矛盾 / 缺口 / 风险 / 与代码现状冲突：
- 提出的选项或替代方案：
- 用户反馈：
- 本轮更新结果：
- 未解决阻塞项：无 | 列表

## 交接说明
- `software-delivery-pipeline` 必须以本文件、`03-review-fix-selection.md`、`04-review-fix-plan.md` 作为需求输入，不得扩大到未选择的 Findings。


## 机器可读摘要

```yaml
source_review_run: "workflow/reviews/<YYYY-MM-DD>-<slug>"
selected_findings:
  - id: "F-001"
    severity: "high"
    evidence:
      - "path/to/file:line"
    acceptance_criteria:
      - ""
excluded_findings:
  - "F-002"
constraints:
  - ""
verification:
  - ""
architecture_gate:
  required: false
  reason: ""
forbidden_scope:
  - ""
```

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
|  | `path/to/file:line` | 事实 / 推断 / 待确认 | 高 / 中 / 低 |  |

## 决策记录
| 决策项 | 选择 | 不选方案 | 原因 | 确认记录 |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

## 范围锁定
- 允许修改 / 关注的目录或文件：
- 禁止修改 / 不关注的目录或文件：
- 允许改变的行为：
- 不允许改变的行为：
- 超出范围时的处理：暂停并请求用户确认。

## 验证矩阵
| 验收项 / Finding | 验证方式 | 命令或步骤 | 结果 | 证据 | 未覆盖原因 |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |
