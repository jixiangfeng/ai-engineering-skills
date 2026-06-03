# Debug 文档契约

用于约束 `debug-root-cause` 产物最少应沉淀哪些信息，确保根因分析不会退化成聊天里的零散猜测。

## 目标

debug 文档应回答：
- 具体问题是什么
- 是否复现、如何复现
- 有哪些证据
- 哪些假设被排除
- 确认根因是什么
- 下一步是修复、继续调查，还是暂停确认

## 默认瘦身路径

`standard` 模式优先使用 4 份主文档：
- `10-debug-scope-reproduction.md`
- `11-debug-evidence.md`
- `12-debug-root-cause.md`
- `13-debug-summary.md`

只有在 case 高风险、争议大、或用户明确要求完整调试轨迹时，才展开为 `02~08` 的细分文档。

## 最低要求

### 1. `debug-workflow-state.md`
至少记录：
- 当前阶段
- 当前状态
- 复现状态
- 下一步动作
- 阻塞项
- 是否允许改代码（默认否）

### 2. `10-debug-scope-reproduction.md`
至少覆盖：
- 问题范围
- 复现步骤或复现受阻原因
- 当前影响面

### 3. `11-debug-evidence.md`
至少覆盖：
- 日志、堆栈、配置、代码路径等证据
- 保留假设
- 已排除假设
- 还需补证据的假设

### 4. `12-debug-root-cause.md`
至少记录：
- 确认根因
- 证据链
- 置信度
- 修复选项与取舍
- 验证思路
- 是否需要升级为架构/契约/生命周期问题

### 5. `13-debug-summary.md`
至少覆盖：
- 总结与下一步 workflow
- rejected hypotheses
- 残余风险或未决问题

## 输出纪律

- 未形成证据支撑的根因前，不应直接提出代码修复
- 修复建议必须区分 symptom relief 与 root-cause fix
- handoff 若生成，必须带上根因、范围、风险与验证要求
