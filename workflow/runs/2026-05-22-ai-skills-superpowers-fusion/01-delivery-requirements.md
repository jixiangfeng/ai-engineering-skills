# 01-delivery-requirements

- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- run 目录: `workflow/runs/2026-05-22-ai-skills-superpowers-fusion`
- 生成时间: `2026-05-22 13:32:16 CST`
- 分支: `main`
- 基线提交: `bd4d71a`
- 执行代理: `codex`
- 来源: 主人要求对 `ai-engineering-skills` 吸收 `superpowers` 的优点，先输出逐文件修改草案，再在仓库中落地第一轮最小闭环改造
- 当前状态: `pending_human_confirmation`

## 1. 目标

在不把 `ai-engineering-skills` 改造成另一个 `superpowers` 的前提下，完成第一轮最小闭环融合改造：

1. 新增统一入口 skill：`workflow-bootstrap`
2. 强化 `software-delivery-pipeline` 的执行纪律
3. 强化 `debug-root-cause` 的根因优先与重复失败升级规则
4. 更新 README 和总说明文档，使新的入口和执行原则可见

## 2. 本轮范围

### 2.1 允许修改的文件

- `skills/workflow-bootstrap/SKILL.md`（新增）
- `skills/software-delivery-pipeline/SKILL.md`
- `skills/debug-root-cause/SKILL.md`
- `README.md`
- `docs/skills-guide.zh-CN.md`

### 2.2 本轮明确不做

- 不改现有 templates、assets、references 目录内容
- 不修改 `code-review-triage` / `codebase-orientation` 的正文
- 不新增子代理 prompt 模板体系
- 不引入安装脚本变化
- 不做大范围措辞统一或全文重写
- 不对其他 skill 做连带结构调整

## 3. 设计原则

### 3.1 保留的能力

保留 `ai-engineering-skills` 现有优势：
- 中文文档优先
- workflow 目录化产物
- requirements / plan / verification / delivery 的阶段化治理
- 按任务类型拆分 skill

### 3.2 吸收的能力

从 `superpowers` 吸收但不照搬：
- 统一入口与任务分流意识
- 更强的 fail-first / test-first 默认纪律
- 实现失败后的 debugging escalation
- 复杂任务优先采用 subagent execution 的思路
- 高风险任务建议隔离工作区

### 3.3 明确不照搬的点

- 不采用“1% 可能适用也必须调用 skill”的极端规则
- 不采用“先写代码必须删掉重来”的绝对化 TDD 表述
- 不把 subagent execution 设为唯一执行模式
- 不把整套仓库改成自动触发式方法论系统

## 4. 预期改动摘要

### 4.1 `workflow-bootstrap`

新增统一入口 skill，用于在研发类任务开始时选择：
- `codebase-orientation`
- `code-review-triage`
- `debug-root-cause`
- `api-contract-design`
- `data-migration-planning`
- `software-delivery-pipeline`

要求：
- 明确路由优先级
- 说明简单概念问答可不进入 workflow
- 说明不同冲突场景如何优先选择 workflow

### 4.2 `software-delivery-pipeline`

增强点：
- 增加 execution modes（inline / subagent）说明
- 明确默认对可测试行为变更采用 fail-first
- 明确“测试以后补”不是默认路径
- 增加失败升级到 debugging stage 的规则
- 增加 workspace isolation guidance
- 在 verification 前增加对 requirements / plan 偏离的回看要求

### 4.3 `debug-root-cause`

增强点：
- 明确未形成有证据支撑的根因假设前，不直接提出修复
- 区分 symptom relief 与 root-cause correction
- 增加 repeated failed fixes 的升级规则
- 强化 fix options / summary 的沉淀结构

### 4.4 `README.md` 与 `docs/skills-guide.zh-CN.md`

增强点：
- 把 `workflow-bootstrap` 列为推荐入口
- 更新 skill 总览与典型链路
- 明确新的设计哲学：先分流，再执行；先证据，再结论；先确认，再改代码

## 5. 验收标准

本轮完成后应满足：

1. 仓库内新增 `workflow-bootstrap` skill 且文档完整可读
2. `README.md` 和 `docs/skills-guide.zh-CN.md` 能说明新的推荐入口与工作流关系
3. `software-delivery-pipeline` 明确体现：
   - inline / subagent 两种执行模式
   - fail-first 默认纪律
   - repeated failure -> debugging escalation
   - workspace isolation guidance
4. `debug-root-cause` 明确体现：
   - root-cause before fix
   - repeated failed fixes escalation
   - symptom vs root-cause distinction
5. 本轮改动保持小范围、可审阅，不引入与目标无关的结构性重写

## 6. 风险与待确认点

### 6.1 风险

- `software-delivery-pipeline` 当前版本较轻，增强后可能出现风格不完全统一
- 若一次性写得过重，可能让 skill 偏离“最小闭环改造”的目标
- README 与总说明若改得太多，会让本轮 diff 变大，不利于审阅

### 6.2 待确认点

当前默认方案：
- 本轮先做最小闭环 5 文件改动
- 不额外改 `code-review-triage` / `codebase-orientation`
- 不新增 references 和模板细化文件

如果主人确认，则下一阶段进入 plan 与实际改动。

## 7. 建议下一步

确认本 requirements 文档后，进入实施计划阶段，拆成：
1. 新增 bootstrap skill
2. 同步 README / guide
3. 强化 delivery skill
4. 强化 debug skill
5. 做最小验证与 diff 检查
