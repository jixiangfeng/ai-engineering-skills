# 实施计划

## 文档元信息
- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- 生成时间: `2026-05-26`
- 当前分支 / commit: `main` / `25284f0`
- 执行 agent: `codex`
- 来源文档: `01-delivery-requirements.md`
- 文档状态: 待用户确认

## 文档状态
- 待用户确认

## 目标
- 在不扩大范围的前提下，修复 `F-001`、`F-002`、`F-003`，让 `software-delivery-pipeline`、`code-review-triage`、`workflow-bootstrap` 的文档契约与模板资产恢复一致、可恢复、可维护。

## 输入
- `01-delivery-requirements.md`
- `02-delivery-architecture.md`（如存在）

## 架构设计说明
- 无需独立架构设计的原因：本次仅修复 skill 文档、模板与 references 的一致性，不涉及运行时架构、持久化结构、API 契约或外部依赖变化。
- 如存在 `02-delivery-architecture.md`，必须遵循的架构约束：不适用。

## 任务拆解
1. **统一 `software-delivery-pipeline` 契约源**
   - 以 `assets/workflow-templates/` 当前真实存在的模板集为锚点。
   - 修改 `SKILL.md`、`references/document-contracts.md`、`references/stage-playbook.md`、`references/example-run.md`、`docs/skills-guide.zh-CN.md`，移除或改写对不存在模板文件的引用。
   - 保留“简单任务 vs 架构门禁任务”的阶段区分，但文件编号必须能落到真实模板上。
2. **修复 `code-review-triage` 的 state 模板**
   - 改写 `assets/review-templates/review-workflow-state.md` 的阶段表，使其与 `SKILL.md` 中的 review workflow 产物完全一致。
   - 修正 `01-review_scope.md` 为 `01-review-scope.md`，并让阶段语义覆盖 findings / fix selection / fix plan / handoff-or-closure。
3. **清理 `workflow-bootstrap` 重复章节**
   - 合并 `Routing Output Contract` 与 `Output Behavior`，保留唯一主规则。
   - 确保“说明所用 workflow / 说明是否续跑现有 run / 避免重复开平行 workflow”都还在。
4. **做一致性核对**
   - 用 `rg` 搜索相关文件名与阶段术语残留。
   - 人工检查目标文件 diff，确认没有误动范围外文件。

## Findings 修复映射
- **F-001**：
  - 实现步骤：统一 `software-delivery-pipeline` skill、docs、references、assets 的文件名契约；删除或改写对缺失模板的引用。
  - 验证方式：grep 文件名全集 + 人工 walkthrough 简单路径/架构门禁路径。
  - 不做范围：不新增第二套复杂模板分支，不重写历史 run。
- **F-002**：
  - 实现步骤：重写 `review-workflow-state.md` 阶段表与文件名。
  - 验证方式：对照 `code-review-triage/SKILL.md` 做一一映射检查。
  - 不做范围：不改变 review skill 的读写边界与总体流程。
- **F-003**：
  - 实现步骤：精简 `workflow-bootstrap/SKILL.md` 重复章节。
  - 验证方式：人工检查删重后保留的规则完整性。
  - 不做范围：不改路由优先级和路由逻辑本身。

## 风险
- `F-001` 涉及多文档联动，若漏改某个 references/doc 文件，容易产生新的不一致。
- `software-delivery-pipeline` 当前自身就存在编号说明混乱，修改时要避免“局部自洽、全局仍冲突”。
- 本次 worktree 本来就有 `workflow/orientation/`、`workflow/reviews/` 未提交文档，验证时必须确认这些不是实现 diff 的主体。

## 测试策略
- 这不是运行时代码改动，严格 fail-first 测试不适用。
- 替代策略：
  1. 先列出当前不一致点作为“失败基线”；
  2. 修改后用 `rg` + 人工对照验证是否全部消失；
  3. 通过目标文件 diff 确认修改面与计划一致。

## 验证策略
- `rg` 检查 `software-delivery-pipeline` 相关文件中的模板文件名引用是否统一。
- `rg` 检查 `review-workflow-state.md` 是否仍包含 delivery 阶段或错误命名。
- 人工 diff 审阅 `workflow-bootstrap/SKILL.md`，确认只是删重不是改路由逻辑。
- 因为本次来自 review handoff，实施后必须进入 `05-delivery-change-review.md` 再进入验证。

## 退出标准
- [ ] `F-001` 的所有目标文件完成一致性修复，且不再引用缺失模板。
- [ ] `F-002` 的 state 模板与 review workflow 完全对齐。
- [ ] `F-003` 的重复章节被合并，关键输出约束仍在。
- [ ] 已完成 change review 与 verification 记录。

## 澄清与收敛记录
- AI 发现的矛盾 / 缺口 / 风险 / 与代码现状冲突：`software-delivery-pipeline/SKILL.md`、`docs/skills-guide.zh-CN.md` 与 assets 文件集当前明显不闭合。
- 提出的选项或替代方案：继续坚持“以真实模板集为锚点收敛契约”，而不是再人为扩张模板矩阵。
- 用户反馈：已同意 requirements。
- 本轮更新结果：形成可实施的计划，并明确实施后必须经过 change review。
- 未解决阻塞项：无。

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
| 无需独立架构设计 | `workflow/runs/2026-05-26-review-consistency-fixes/01-delivery-requirements.md` | 事实 | 高 | 需求已锁定 |
| `software-delivery-pipeline` 当前声明双路径文件编号 | `plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md:168-180` | 事实 | 高 | 与 assets 不完全一致 |
| `code-review-triage` 需要修正 review state 模板 | `plugins/ai-engineering-skills/skills/code-review-triage/SKILL.md:88-103` | 事实 | 高 |  |
| `workflow-bootstrap` 存在重复输出契约章节 | `plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md:123-139` | 事实 | 高 |  |

## 决策记录
| 决策项 | 选择 | 不选方案 | 原因 | 确认记录 |
| --- | --- | --- | --- | --- |
| `F-001` 修法 | 以现有模板集为锚点收敛文件编号契约 | 补齐第二套复杂路径模板 | 改动面更可控，更符合当前仓库状态 | 已在 requirements 中锁定 |
| 架构门禁 | 不单独创建 `02-delivery-architecture.md` | 进入独立架构阶段 | 任务仅为文档/模板一致性修复 | 已在 requirements 中锁定 |
| 实施后流程 | 进入 `05-delivery-change-review.md` 再验证 | 直接验证 | 本次来自 review handoff，且涉及多文档联动 | 当前计划 |

## 范围锁定
- 允许修改 / 关注的目录或文件：
  - `plugins/ai-engineering-skills/skills/software-delivery-pipeline/**`
  - `plugins/ai-engineering-skills/skills/code-review-triage/**`
  - `plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md`
  - `docs/skills-guide.zh-CN.md`
- 禁止修改 / 不关注的目录或文件：
  - 其他 skill 的主要流程
  - plugin marketplace / plugin.json
  - 历史 `workflow/runs/**`
  - `workflow/orientation/**`、`workflow/reviews/**` 作为并行/上游产物
- 允许改变的行为：
  - 调整文档契约与模板命名一致性
  - 修复 review state 模板恢复语义
  - 删除重复说明
- 不允许改变的行为：
  - 引入新的 workflow 类型或运行时能力
  - 扩展到未选 findings
- 超出范围时的处理：暂停并请求用户确认。

## 影响分析
- 影响模块：`software-delivery-pipeline`、`code-review-triage`、`workflow-bootstrap`
- 影响 API / 接口：无运行时 API 影响；影响的是 workflow 文档接口与恢复契约
- 影响数据表 / 实体 / DTO：无
- 影响配置 / 环境：无
- 影响异步任务 / MQ / 调度：无
- 影响测试：主要增加文档/模板一致性核对与 change review 成本
- 兼容性影响：未来新 run 的解释会更一致；历史 run 不回写
- 回滚影响：若结果不满意，可仅回滚本次文档与模板修改

## 验证矩阵
| 验收项 / Finding | 验证方式 | 命令或步骤 | 结果 | 证据 | 未覆盖原因 |
| --- | --- | --- | --- | --- | --- |
| F-001 | 文件名全集一致性核对 | `rg` 搜索 `delivery` 阶段文件名并人工比对 assets / docs / references / skill | 待执行 | grep 输出 + diff | 实施后执行 |
| F-002 | review state 模板对齐检查 | 比对 `review-workflow-state.md` 与 `code-review-triage/SKILL.md` | 待执行 | 修改后模板内容 | 实施后执行 |
| F-003 | 文档去重检查 | 审阅 `workflow-bootstrap/SKILL.md` diff | 待执行 | diff | 实施后执行 |
| 全局范围控制 | 变更面检查 | `git diff --stat` + 目标文件 diff 审阅 | 待执行 | diff 输出 | 实施后执行 |

## 变更记录
| 轮次 | 用户反馈 | 文档更新 | 当前状态 |
| --- | --- | --- | --- |
| 1 | 同意 requirements | 写入实施计划与验证策略 | 待确认 |

## 用户确认记录
- 待确认；确认前不得进入实现或代码修改阶段。
