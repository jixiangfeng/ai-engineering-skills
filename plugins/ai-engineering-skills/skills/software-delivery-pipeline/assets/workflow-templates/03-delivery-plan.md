---
workflow: software-delivery-pipeline
runId: <YYYYMMDD-slug>
runPath: workflow/runs/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: plan
status: draft
source: user-request
allowsCodeEdit: false
nextAction: confirm_plan
---
# 实施计划（架构确认后）

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- 来源文档：
- 文档状态：

## 文档状态
- 待用户确认

## 目标
-

## 输入
- `01-delivery-requirements.md`
- `02-delivery-architecture.md`（如存在）

## 架构设计说明
- 无需独立架构设计的原因：
- 如存在 `02-delivery-architecture.md`，必须遵循的架构约束：

## 任务拆解
1.
2.
3.

## Implementation Strategy
- Strategy: test_first | minimal_patch | exploratory_fix
- Reason:
- Expected behavior:
- Test / verification cases:

## Implementation Plan

### 1. 修改目标
-

### 2. 修改范围
- 涉及模块：
- 涉及文件：
- 不修改范围：

### 3. 执行步骤
1.
2.
3.

### 4. 数据 / 配置影响
- 数据库：
- Redis：
- MQ：
- 配置项：
- 外部接口：

### 5. 风险点
-

### 6. 验证方式
- 单元测试：
- 集成测试：
- 手工验证：
- 回归范围：

### 7. 回滚方式
-

## Task Decomposition

### 是否需要拆分
- yes | no

### 子任务
| 子任务 | 类型 | 是否可并行 | 输出 |
| --- | --- | --- | --- |
|  | read-only / write | yes / no |  |

## Worktree Recommendation

当前任务建议使用独立 worktree：yes | no

原因：
-

建议命令：
```bash
git worktree add ../<repo>-<task-slug> -b <branch-name>
```

## Findings 修复映射
- F-001：实现步骤；验证方式；不做范围。

## 风险
-

## 测试策略
-

## 验证策略
-

## 退出标准
- [ ]
- [ ]


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

## 影响分析
- 影响模块：
- 影响 API / 接口：
- 影响数据表 / 实体 / DTO：
- 影响配置 / 环境：
- 影响异步任务 / MQ / 调度：
- 影响测试：
- 兼容性影响：
- 回滚影响：

## 验证矩阵
| 验收项 / Finding | 验证方式 | 命令或步骤 | 结果 | 证据 | 未覆盖原因 |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |

## 变更记录
| 轮次 | 用户反馈 | 文档更新 | 当前状态 |
| --- | --- | --- | --- |
|  |  |  |  |

## 用户确认记录
- 待确认；确认前不得进入实现或代码修改阶段。
