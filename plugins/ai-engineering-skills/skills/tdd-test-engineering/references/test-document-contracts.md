# 测试工程文档契约

用于约束 `tdd-test-engineering` 产物最少应沉淀哪些信息，确保测试用例、执行证据、问题结论和下游 handoff 不依赖聊天上下文。

## 目标

测试工程文档应回答：
- 本轮到底验证什么行为
- 验收标准是什么
- 哪些测试用例经过确认
- 环境和测试数据是否可用
- 实际执行了哪些命令
- 哪些通过、失败、阻塞或跳过
- 是否需要进入 debug 或 delivery

## 默认瘦身路径

`standard` 模式优先使用 5 份主文档：
- `00-environment-safety-gate.md`
- `10-test-scope-criteria.md`
- `11-test-plan-cases.md`
- `12-test-execution-evidence.md`
- `13-test-summary.md`

只有在发布级回归、高风险权限/资金/医疗/数据/MQ、或用户明确要求 full trail 时，才展开更多细分文档。

设计文档中的需求理解、验收标准、影响范围、测试策略、数据计划、环境检查、问题记录、修复记录、回归报告和风险报告，在 `standard` 模式下应归并到这 5 份主文档；在 `full` 模式下可以拆分，但不能少于这些信息。
环境检查的最小前置文档是 `00-environment-safety-gate.md`，它必须先于任何连接 MySQL、MongoDB、Redis、MQ、Nacos、Elasticsearch 或外部 API 的动作。

## 最低要求

### 1. `test-workflow-state.md`

至少记录：
- 当前阶段
- 当前状态
- 下一步动作
- 阻塞项
- 是否允许改测试代码和生产代码
- 测试用例确认状态和修复确认状态
- 已批准用例基线版本
- `workflow-state.json` 同步状态

### 1a. `00-environment-safety-gate.md`

至少记录：
- 环境 Profile
- 环境类型
- 连接目标
- 允许的 smoke check
- 禁止操作
- 写边界
- 凭证策略
- gate 结果

### 2. `10-test-scope-criteria.md`

至少记录：
- 测试目标
- 来源需求、缺陷、契约或 handoff
- 范围内 / 范围外
- 验收标准
- 影响入口、业务链路、数据、外部依赖和高风险点
- 待确认问题

### 3. `11-test-plan-cases.md`

至少记录：
- 影响范围
- 测试层级选择
- 测试矩阵
- 测试数据和清理方案
- 环境依赖
- 需要人工确认的测试用例
- 确认后的测试用例基线：版本、确认依据、确认时间、批准用例、跳过用例、人工用例

### 4. `12-test-execution-evidence.md`

至少记录：
- 环境验证结果
- 执行命令
- 执行结果
- 报告路径
- 失败分类
- 问题列表
- Red / Green / Regression 记录
- 生产代码修复是否已获确认
- 回归结果

### 5. `13-test-summary.md` / handoff

至少记录：
- 测试结论
- 已覆盖和未覆盖范围
- 通过、失败、阻塞和跳过统计
- 未解决风险
- 发布建议或下游 workflow 建议
- 完成条件逐项判断

## 输出纪律

- 不把“代码看起来没问题”当作测试证据。
- 不把编译成功当作测试通过。
- 不把单个正常场景测试当作完整回归。
- 不隐藏失败测试。
- 不把上游 handoff 当成修改生产代码的直接授权。
