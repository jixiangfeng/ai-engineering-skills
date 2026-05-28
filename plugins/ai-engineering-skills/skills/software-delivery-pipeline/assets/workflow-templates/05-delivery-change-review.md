---
workflow: software-delivery-pipeline
runId: <YYYYMMDD-slug>
runPath: workflow/runs/<YYYY-MM-DD>-<slug>
executionMode: full
stage: stage
status: draft
source: user-request
allowsCodeEdit: false
nextAction: continue_workflow
---
# 交付变更二次 Review

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

## 是否触发 Change Review Gate
- 是 | 否

## 触发原因
- [ ] 来自 `code-review-triage` handoff
- [ ] 存在架构门禁
- [ ] 跨模块 / 跨服务
- [ ] 修改 API / DTO / 数据契约
- [ ] 修改数据表 / 迁移 / 持久化结构
- [ ] 修改异步 / MQ / 调度 / 并发
- [ ] 涉及权限 / 安全 / 数据一致性
- [ ] worktree 已经很脏或存在大量 diff
- [ ] 用户明确要求二次 review
- [ ] 其他：

## 输入文档
- `01-delivery-requirements.md`
- `02-delivery-architecture.md`（如存在）
- `02-delivery-plan.md` / `03-delivery-plan.md`
- `03-delivery-implementation.md` / `04-delivery-implementation.md`
- 当前 git diff / status

## Diff 摘要
- 修改文件：
- 新增文件：
- 删除文件：
- 可能的格式化 / 换行污染：

## 一致性检查
| 检查项 | 结论 | 证据 | 备注 |
| --- | --- | --- | --- |
| 是否符合需求 | 通过 / 不通过 / 待确认 |  |  |
| 是否符合架构 | 通过 / 不通过 / 不适用 / 待确认 |  |  |
| 是否符合计划 | 通过 / 不通过 / 待确认 |  |  |
| 是否遵守范围锁定 | 通过 / 不通过 / 待确认 |  |  |
| 是否存在无关 diff | 无 / 有 / 待确认 |  |  |
| 是否破坏 API / DTO / 数据契约 | 无 / 有 / 待确认 |  |  |
| 是否破坏强类型约束 | 无 / 有 / 待确认 |  |  |
| 测试 / 验证计划是否仍有效 | 是 / 否 / 待确认 |  |  |

## Review Findings

### CR-001
- 严重级别：阻塞 / 高 / 中 / 低
- 位置：`path/to/file:line`
- 问题：
- 影响：
- 建议处理：
- 是否阻塞进入验证：是 | 否

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
|  | `path/to/file:line` | 事实 / 推断 / 待确认 | 高 / 中 / 低 |  |

## 决策记录
| 决策项 | 选择 | 不选方案 | 原因 | 确认记录 |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

## 结论
- 状态：approved_for_verification | approved_with_notes | changes_required | scope_violation | blocked_needs_user_decision
- 是否允许进入验证：是 | 否
- 需要回到的阶段：无 | implementation | debugging | plan | architecture | requirements
- 用户确认需求：无 | 需要确认

## 后续动作
-
