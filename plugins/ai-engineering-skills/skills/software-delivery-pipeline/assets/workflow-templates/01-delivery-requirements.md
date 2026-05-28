---
workflow: software-delivery-pipeline
runId: <YYYYMMDD-slug>
runPath: workflow/runs/<YYYY-MM-DD>-<slug>
executionMode: full
stage: scope
status: draft
source: user-request
allowsCodeEdit: false
nextAction: confirm_scope
---
# 需求确认

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

## 文档状态
- 待用户确认

## 原始请求
- 用户原始任务：

## Review 交接来源
- 来源 review run：
- handoff 文件：
- 已选 Findings：
- 明确不修 Findings：

## 任务类型 / 路由检查
- 当前任务类型：
- 继续使用 `software-delivery-pipeline` 的原因：
- 是否应转入其他 workflow：否 / 是，目标 workflow：
- 判断依据：

## 目标结果
-

## 范围
- 范围内：
- 范围外：

## 需求来源分层
- 用户明确要求：
- 由代码 / 文档证据推导出的必要要求：
- AI 建议但未确认的扩展项：

## 约束
-

## 假设
-

## 验收标准
- [ ]
- [ ]

## 验证矩阵
| 验收项 | 验证命令 / 方式 | 预期结果 | 是否阻塞交付 |
| --- | --- | --- | --- |
|  |  |  | 是 / 否 |

## 未知项 / 问题
-

## 预存工作区变更
- `git status` 摘要：
- 是否影响本轮范围：否 / 是，说明：
- 处理策略：忽略 / 纳入范围 / 暂停确认


## 澄清与收敛记录
- AI 发现的矛盾 / 缺口 / 风险 / 与代码现状冲突：
- 提出的选项或替代方案：
- 用户反馈：
- 本轮更新结果：
- 未解决阻塞项：无 | 列表

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
|  | `path/to/file:line` | 事实 / 推断 / 待确认 | 高 / 中 / 低 |  |

## 范围锁定
- 允许修改 / 关注的目录或文件：
- 禁止修改 / 不关注的目录或文件：
- 允许改变的行为：
- 不允许改变的行为：
- 超出范围时的处理：暂停并请求用户确认。

## 验收样例
| 场景 | 前置条件 / 输入 | 操作 | 预期结果 | 关联需求 / Finding |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

## 决策记录
| 决策项 | 选择 | 不选方案 | 原因 | 确认记录 |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

## 变更记录
| 轮次 | 用户反馈 | 文档更新 | 当前状态 |
| --- | --- | --- | --- |
|  |  |  |  |

## 用户确认记录
- 待确认；确认前不得进入计划或实现阶段。
