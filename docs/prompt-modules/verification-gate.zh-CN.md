# Verification Gate 模块

本模块用于所有 workflow 的最终输出。agent 不能没有验证就说“完成”。

## 输出结构

```md
## Verification

### 已验证
- ...

### 验证方式
- 命令：
- 文件：
- 证据：
- 结果：

### 未验证
- ...

### 未验证原因
- ...

### 完成判断
- completed / analysis-only / blocked / needs-user-confirmation
```

## 完成声明规则

- 如果已经运行测试、检查命令或有明确文件/代码/文档证据，可以说 `completed`。
- 如果只是阅读、分析、设计，没有运行实现验证，只能说 `analysis-only`。
- 如果缺少信息、权限、环境或用户决策，必须说 `blocked` 或 `needs-user-confirmation`。
- 如果没有验证，不能说“已完成”；应说“分析完成，尚未执行验证”。

## 证据要求

验证证据应尽量包含：

- 命令和结果。
- 文件路径和关键位置。
- 测试、构建、lint、类型检查、脚本校验或手工检查。
- 未覆盖范围和剩余风险。

## 正例

- “已运行 `mvn test -Dtest=OrderServiceTest`，结果通过；未运行全量回归，原因是成本高，剩余风险为跨模块回归未覆盖。”
- “只读分析完成，完成判断为 `analysis-only`。”

## 反例

- 没跑任何验证却写“已完成”。
- 只说“应该没问题”，没有命令、文件或证据。
