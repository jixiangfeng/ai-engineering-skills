# 03-orientation-business-flow

## 文档元信息
- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- 分支: `main`
- 提交: `25284f0`
- 状态: completed

## 仓库在“业务”上的核心目标

### 事实
该仓库想解决的不是某个行业业务问题，而是**软件研发任务如何被 AI 以可审查、可恢复、可交接的方式执行**。

根 README 与 `docs/skills-guide.zh-CN.md` 反复强调三件事：
1. 先分流，再执行
2. 先证据，再结论
3. 先确认，再改代码

## 主要参与者
- **用户/主人**：提出“熟悉、review、debug、设计、迁移、实现”等研发任务。
- **workflow-bootstrap**：作为入口路由器，判断该走哪条 workflow。
- **具体 skill**：按职责完成只读理解、审查、排障、契约设计、迁移规划或交付实现。
- **下游 workflow**：接收上游 handoff 文档继续执行，而不是依赖聊天上下文硬接。

## 核心流程图（按业务意图）

### 1. 熟悉型任务
用户说“熟悉当前项目 / 看懂模块 / 梳理调用链”
→ `workflow-bootstrap`
→ `codebase-orientation`
→ 产出 orientation 文档
→ 如有需要，再 handoff 到 review 或 delivery

### 2. 审查型任务
用户说“review 一下 / 找问题 / 列出风险”
→ `workflow-bootstrap`
→ `code-review-triage`
→ 产出 findings / fix selection / fix plan
→ 用户选定修复范围
→ handoff 到 `software-delivery-pipeline`

### 3. 排障型任务
用户说“排查报错 / 看失败测试 / 找根因”
→ `workflow-bootstrap`
→ `debug-root-cause`
→ 产出根因、修复选项、验证计划
→ 如需落地修复，再 handoff 到 delivery

### 4. 设计型任务
用户说“设计接口 / DTO / 错误码 / 数据迁移方案”
→ `workflow-bootstrap`
→ `api-contract-design` 或 `data-migration-planning`
→ 文档确认后 handoff 到 delivery

### 5. 实现型任务
用户说“实现 / 修复 / 按 handoff 落地”
→ `workflow-bootstrap`
→ `software-delivery-pipeline`
→ requirements / architecture / plan / implementation / change review / verification / summary

## 关键业务规则

### 规则 1：不同类型工作不混做
**事实**：文档明确要求 review 不默认实现、debug 不默认修复、design 不默认落地，只有 delivery 默认允许改代码。

### 规则 2：确认是 gate，不是走形式
**事实**：requirements、architecture、plan 等阶段都要求“澄清与收敛循环”，而不是生成一次文档就直接往下走。

### 规则 3：聊天不是长期记忆，文档才是
**事实**：多个 skill 都要求把状态、范围、证据、确认结果、handoff 写进项目根目录下的 `workflow/`。

## 推断
- 这套仓库的“业务对象”其实是**AI 驱动的软件研发过程本身**。
- 它试图把代理式编程从“即时对话”升级为“文档化状态机”。

## 后续可 review 的线索
- 各 skill 的边界虽然总体清晰，但是否存在命名、阶段设计、模板覆盖度不一致，还需要正式 review 才能下结论。
