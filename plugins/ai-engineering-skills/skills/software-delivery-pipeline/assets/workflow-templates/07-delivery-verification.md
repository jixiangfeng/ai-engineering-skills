---
workflow: software-delivery-pipeline
runId: <YYYYMMDD-slug>
runPath: workflow/runs/<YYYY-MM-DD>-<slug>
executionMode: full
stage: verification
status: draft
source: user-request
allowsCodeEdit: true
nextAction: run_or_record_verification
---
# 验证记录（复杂路径）

## Template Usage
- mode: audited only
- fast 使用 `00-fast-patch-summary.md`
- guarded 使用 `10-guarded-*`

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

## 计划验证承接
- 来源计划文档：`03-delivery-plan.md`
- 已复制计划验证矩阵：是 / 否
- 所有阻塞性验收项是否都有结果：是 / 否
- 若存在未覆盖项：必须记录原因，并标记为阻塞或请求用户确认风险。

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

## 范围与 Diff 验证
- `git diff --name-only` 摘要：
- 是否只包含计划允许的文件：是 / 否
- 是否存在格式化、换行或无关 diff：无 / 有，说明：

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
|  | `path/to/file:line` | 事实 / 推断 / 待确认 | 高 / 中 / 低 |  |
