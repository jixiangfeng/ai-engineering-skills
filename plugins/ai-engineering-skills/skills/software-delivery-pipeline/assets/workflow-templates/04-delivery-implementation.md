---
workflow: software-delivery-pipeline
runId: <YYYYMMDD-slug>
runPath: workflow/runs/<YYYY-MM-DD>-<slug>
executionMode: full
stage: implementation
status: in_progress
source: user-request
allowsCodeEdit: true
nextAction: continue_implementation
---
# 实施记录（架构确认后）

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

## 计划引用
- `03-delivery-plan.md`

## 计划执行映射
| 计划步骤 / 验收项 / Finding | 实施状态 | 实际修改 | 测试 / 验证状态 | 偏差说明 |
| --- | --- | --- | --- | --- |
|  | 未开始 / 进行中 / 完成 / 阻塞 |  |  |  |

## Test-First 记录
- 是否先写失败测试 / 复现：是 / 否
- 失败测试 / 复现命令：
- 失败原因是否符合预期：是 / 否 / 不适用
- 未采用 fail-first 的原因：

## 已完成变更
-

## 修改文件
- `path/to/file`

## 新增或更新的测试
-

## 与计划的偏差
-
- 是否需要回到需求 / 架构 / 计划：否 / 是，目标阶段：

## 当前状态
- 完成 | 部分完成 | 阻塞

## 备注
-

## 暂停确认记录
- 如发生范围扩大或明显偏离已确认计划，记录原因并等待用户确认后继续。

## 范围锁定
- 允许修改 / 关注的目录或文件：
- 禁止修改 / 不关注的目录或文件：
- 允许改变的行为：
- 不允许改变的行为：
- 超出范围时的处理：暂停并请求用户确认。

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
|  | `path/to/file:line` | 事实 / 推断 / 待确认 | 高 / 中 / 低 |  |

## 变更记录
| 轮次 | 用户反馈 | 文档更新 | 当前状态 |
| --- | --- | --- | --- |
|  |  |  |  |
