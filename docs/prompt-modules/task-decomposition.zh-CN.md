# 任务拆分模块

本模块用于复杂任务拆分。目标是把分析、设计、实现、验证分开，使只读分析可以并行，代码修改保持可控。

## 输出结构

```md
## Task Decomposition

### 是否需要拆分
- yes / no

### 子任务
| 子任务 | 类型 | 是否可并行 | 输出 |
| --- | --- | --- | --- |
| 代码结构分析 | read-only | yes | findings |
| 数据契约分析 | read-only | yes | contract notes |
| 风险点分析 | read-only | yes | risk list |
| 实现修改 | write | no | patch |
```

## 强规则

- 只读分析可以并行。
- 代码修改默认不并行。
- 涉及同一文件的修改不并行。
- 并行子任务必须有清晰、独立的输出边界。
- 子任务结果进入主 workflow 后，仍以主 workflow 的 state、summary、handoff 为准。

## 正例

- 结构分析、数据契约分析、风险分析可并行，最后汇总到一个 review 文档。
- 实现修改按文件 ownership 串行或明确分离。

## 反例

- 两个写任务同时修改同一个 service。
- 子任务各自生成一套不一致的最终结论。
