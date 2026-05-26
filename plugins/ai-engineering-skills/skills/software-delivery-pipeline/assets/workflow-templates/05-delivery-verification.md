---
workflow: software-delivery-pipeline
runId: <YYYYMMDD-slug>
runPath: workflow/runs/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: verification
status: draft
source: user-request
allowsCodeEdit: true
nextAction: run_or_record_verification
---
# 验证记录

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- 来源文档：
- 文档状态：

## 已运行检查
- [ ] tests：
- [ ] lint：
- [ ] build：
- [ ] typecheck：
- [ ] smoke/manual：

## 结果
-

## 证据
- 命令：
- 输出摘要：

## 跳过的检查
-

## 最终验证状态
- 通过 | 部分通过 | 失败 | 阻塞

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

## 验证阻塞确认
- 如关键验证无法运行，记录阻塞原因，并等待用户决定是否接受风险或补充环境/输入。

## 验证矩阵
| 验收项 / Finding | 验证方式 | 命令或步骤 | 结果 | 证据 | 未覆盖原因 |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
|  | `path/to/file:line` | 事实 / 推断 / 待确认 | 高 / 中 / 低 |  |
