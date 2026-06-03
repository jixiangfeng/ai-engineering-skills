# Orientation 文档契约

用于约束 `codebase-orientation` 产物至少应包含哪些信息，确保后续 review 或 delivery 可以复用这些文档，而不需要重新从聊天上下文猜测范围。

## 目标

orientation 文档应回答：
- 看了什么
- 为什么看这些
- 业务与技术上看到了什么
- 哪些是事实，哪些只是推断
- 下一步最适合进入哪个 workflow

## 默认瘦身路径

`standard` 模式优先使用 3 份主文档：
- `10-orientation-scope.md`
- `11-orientation-map.md`
- `12-orientation-summary.md`

只有在 repo 很大、需要强分层讲解、或用户明确要求 deep decomposition 时，才展开为 `02~07` 的细分文档。

## 最低要求

### 1. `orientation-workflow-state.md`
至少记录：
- 当前阶段
- 当前状态
- 下一步动作
- 阻塞项
- 是否允许改代码（默认否）

### 2. `10-orientation-scope.md`
至少记录：
- 熟悉目标（repo / 模块 / 接口 / 流程）
- 本轮关注点
- 范围内 / 范围外
- 若范围过大，当前边界如何裁剪

### 3. `11-orientation-map.md`
至少能够覆盖：
- 项目/模块角色
- 业务流程
- 技术调用链
- 数据契约或重要数据结构
- open questions / review leads
- `事实 / 推断 / 待确认` 区分

### 4. `12-orientation-summary.md`
至少记录：
- 本轮结论摘要
- 关键文件/模块
- 风险或不确定点
- 推荐下一步 workflow

## 输出纪律

- 不把“疑似问题”直接写成 confirmed finding
- 重要结论尽量标记 `事实 / 推断 / 待确认`
- handoff 若生成，必须说明范围、关键模块、证据来源、未决问题
