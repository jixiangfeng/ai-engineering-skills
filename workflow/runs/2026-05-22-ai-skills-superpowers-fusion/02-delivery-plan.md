# 02-delivery-plan

- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- run 目录: `workflow/runs/2026-05-22-ai-skills-superpowers-fusion`
- 生成时间: `2026-05-22 13:34:00 CST`
- 分支: `main`
- 基线提交: `bd4d71a`
- 执行代理: `codex`
- 来源文档: `01-delivery-requirements.md`
- 当前状态: `pending_human_confirmation`

## 1. 计划概览

本轮按“先入口、后说明、再执行纪律”的顺序做最小闭环改造，避免一上来重写核心 skill。

由于本轮不涉及跨模块运行时代码、外部依赖、持久化结构、接口契约变更或并发机制变更，**无需独立架构设计文档**。本次属于仓库内 skill 文档和说明文档的小范围演进，可直接进入实施计划。

## 2. 实施步骤

### 步骤 1：新增统一入口 skill

目标：新增 `skills/workflow-bootstrap/SKILL.md`，作为研发类任务的统一入口分流层。

计划改动：
- 新建 `skills/workflow-bootstrap/`
- 编写 `SKILL.md`
- 内容包括：
  - skill 作用
  - 路由目标 skill 列表
  - 路由优先级
  - 冲突场景下的分流规则
  - 简单概念问答不强制进入 workflow 的说明
  - 推荐的简短对外表述

验证点：
- 文件存在且结构完整
- 内容能覆盖 6 类现有 workflow 的分流场景
- 不引入“极端强制 skill 调用”的表述

### 步骤 2：更新 `README.md`

目标：让仓库入口文档能看见新的推荐入口和整体设计哲学。

计划改动：
- 在 Skills 列表中加入 `workflow-bootstrap`
- 增加“推荐使用入口”章节
- 更新“工作流关系”章节，使其先经过 bootstrap 分流
- 增加简短“设计哲学”或等效说明：
  - 先分流，再执行
  - 先证据，再结论
  - 先确认，再改代码

验证点：
- README 能独立解释 bootstrap 的用途
- 主链路描述与当前 skill 结构一致
- diff 控制在局部可审阅范围内

### 步骤 3：更新 `docs/skills-guide.zh-CN.md`

目标：让总说明文档同步新的入口规则和执行纪律。

计划改动：
- 在 Skill 总览表新增 `workflow-bootstrap`
- 增加“统一入口与路由”章节
- 在 `software-delivery-pipeline` 小节补充：
  - inline / subagent 两种执行模式
  - fail-first 默认纪律
  - repeated failure -> debugging escalation
  - workspace isolation guidance
- 在 `debug-root-cause` 小节补充：
  - root-cause before fix
  - repeated failed fixes escalation

验证点：
- 总说明与 README 口径一致
- 新增内容不与现有规则冲突
- 章节编号和目录结构保持清晰

### 步骤 4：增强 `skills/software-delivery-pipeline/SKILL.md`

目标：在保留现有文档驱动交付骨架的前提下，引入更强的执行纪律。

计划改动：
- 增加 `Execution Modes` 章节：
  - `Inline Execution`
  - `Subagent Execution`
- 强化 `Stage 3 — Test-First Implementation`：
  - 默认对可测试行为采用 fail-first
  - “测试以后补”不是默认路径
  - 若不能严格 fail-first，必须记录原因、替代验证和残余风险
- 增加 `Failure Escalation` 章节：
  - 两轮以上修复尝试失败时切换 debugging stage
  - 记录已尝试修复、已排除假设、当前最佳根因假设、是否需回退到 requirements/plan
- 增加 `Workspace Isolation Guidance`：
  - worktree/branch 的推荐触发场景
- 在 verification 前增加对 requirement/plan 偏离与过度实现的回看要求

验证点：
- skill 仍保持当前 delivery 主流程骨架
- 增强项与已有 requirements/plan/change-review gate 不冲突
- 没有把流程写成 superpowers 式绝对命令系统

### 步骤 5：增强 `skills/debug-root-cause/SKILL.md`

目标：让调试 skill 更明确地坚持“先根因、后修复”。

计划改动：
- 在 `Core Rules` 中补充：
  - 未形成有证据支撑的根因假设前，不直接提出修复
  - 不混淆 symptom relief 与 root-cause correction
  - 两到三轮修复失败后要检查架构/边界/生命周期/契约问题
- 增加 `Escalation After Repeated Failed Fixes` 章节
- 强化 fix options 输出要求：
  - symptom relief
  - root-cause fix
  - monitoring/logging/guardrail improvements
- 强化 summary 的沉淀项：
  - attempted fixes
  - rejected hypotheses
  - confirmed root cause
  - recommended next workflow

验证点：
- skill 仍保持只读优先
- 规则比当前更硬，但不过度扩展到实现流程
- handoff 语义仍指向 `software-delivery-pipeline`

### 步骤 6：最小验证与差异检查

目标：确认本轮改动满足 requirements，且 diff 可审阅。

计划改动：
- 检查新增文件路径和内容存在
- 使用 `git diff --stat` / `git diff -- <files>` 复核改动范围
- 核对 5 个验收标准是否都已覆盖
- 记录未做项与后续建议

验证点：
- 仅修改 5 个目标文件（含 1 个新增）
- 无无关文件被带入 diff
- 可向主人清晰展示最终差异与后续增强方向

## 3. 风险与应对

### 风险 1：`software-delivery-pipeline` 再次膨胀
应对：只加入本轮 requirements 明确要求的增强项，不追加 references、templates、extra gates。

### 风险 2：README / guide 改得过多
应对：只做入口、链路和原则层面的局部增补，不全文改写。

### 风险 3：bootstrap 语气过硬，偏离仓库气质
应对：明确“简单概念问答不强制 workflow”，避免 superpowers 式极端命令语气。

## 4. 验证策略

本轮以文档与 diff 验证为主，不涉及代码编译或测试运行。

最小验证包括：
1. `read` 关键文件，确认新增/修改内容已落盘
2. `git diff --stat` 查看改动规模
3. `git diff -- <target files>` 复核是否仅限目标文件
4. 对照 `01-delivery-requirements.md` 的 5 条验收标准逐项检查

## 5. 需要主人确认的点

请确认本实施计划是否按以下顺序执行：

1. 新增 bootstrap skill
2. 更新 README
3. 更新总说明 guide
4. 强化 delivery skill
5. 强化 debug skill
6. 做最小验证与 diff 检查

确认后，我再进入实际改动阶段。