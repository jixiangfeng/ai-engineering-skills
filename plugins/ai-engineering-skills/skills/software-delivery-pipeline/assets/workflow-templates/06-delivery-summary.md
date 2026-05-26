---
workflow: software-delivery-pipeline
runId: <YYYYMMDD-slug>
runPath: workflow/runs/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: summary
status: draft
source: user-request
allowsCodeEdit: true
nextAction: wait_for_user_acceptance
---
# 交付摘要

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- 来源文档：
- 文档状态：

## Execution Mode
- executionMode：lightweight | standard | full
- 模式选择理由：
- 已生成产物：
- 已跳过产物及原因：

## 结果
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

## Finish Checklist

- [ ] 已检查 git diff
- [ ] 已检查无关改动
- [ ] 已运行必要测试
- [ ] 已更新必要文档
- [ ] 已说明未验证项
- [ ] 已给出回滚方式
- [ ] 已给出 PR / merge 建议

## 剩余风险
-

## 后续建议
-

## 是否可供人工审查
- 是 | 否

## 验证矩阵
| 验收项 / Finding | 验证方式 | 命令或步骤 | 结果 | 证据 | 未覆盖原因 |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
|  | `path/to/file:line` | 事实 / 推断 / 待确认 | 高 / 中 / 低 |  |

## 决策记录
| 决策项 | 选择 | 不选方案 | 原因 | 确认记录 |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

## 用户验收
- 待用户确认是否接受交付结果，或提出后续修改。

## Review 回写
- 来源 review run：
- review-delivery-result.md：
- 已回写 Findings 状态：
