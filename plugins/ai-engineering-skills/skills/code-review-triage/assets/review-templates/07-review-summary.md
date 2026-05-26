---
workflow: code-review-triage
runId: <YYYYMMDD-slug>
runPath: workflow/reviews/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: summary
status: draft
source: user-request
allowsCodeEdit: false
nextAction: wait_for_user_acceptance
---
# Review 修复交付摘要

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- 来源文档：
- 文档状态：

## 交付类型
- 仅审查无修复 | 已修复选中 Findings

## Execution Mode
- executionMode：lightweight | standard | full
- 模式选择理由：
- 已生成产物：
- 已跳过产物及原因：

## 结果
-

## 已修复 Findings
-

## 未修复 Findings
-

## 修改文件
-

## 验证摘要
-

## Verification

### 已验证
-

### 验证方式
- 命令：
- 文件：
- 证据：
- 结果：

### 未验证
-

### 未验证原因
-

### 完成判断
- completed | analysis-only | blocked | needs-user-confirmation

## 剩余风险
-

## 验证矩阵
| 验收项 / Finding | 验证方式 | 命令或步骤 | 结果 | 证据 | 未覆盖原因 |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
|  | `path/to/file:line` | 事实 / 推断 / 待确认 | 高 / 中 / 低 |  |

## 用户验收
- 待用户确认是否接受交付结果，或提出后续修改。

## No-Fix Closure
- 如果用户选择不修复或仅记录 review，在这里说明关闭原因、保留的问题和后续触发条件。
