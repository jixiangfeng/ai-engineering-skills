# 04-review-fix-plan

## 文档元信息
- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- 生成时间: `2026-05-26`
- 当前分支 / commit: `main` / `25284f0`
- 执行 agent: `codex`
- 来源文档: `03-review-fix-selection.md`
- 文档状态: 待用户确认

## 文档状态
- 待主人确认后，才允许进入 delivery

## 输入
- `02-review-findings.md`
- `03-review-fix-selection.md`

## 修复映射

### F-001
- **计划修改**: 统一 `software-delivery-pipeline` 的文件编号契约、assets 模板集合、仓库级说明与 references 文档，消除“文档声称存在但 assets 中没有模板”的状态。
- **涉及文件**:
  - `plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md`
  - `plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates/*`
  - `plugins/ai-engineering-skills/skills/software-delivery-pipeline/references/document-contracts.md`
  - `plugins/ai-engineering-skills/skills/software-delivery-pipeline/references/stage-playbook.md`
  - `plugins/ai-engineering-skills/skills/software-delivery-pipeline/references/example-run.md`
  - `docs/skills-guide.zh-CN.md`
- **验证方式**:
  - 列出各处声明的文件名全集并逐项比对
  - 确认 assets 中存在与最终契约一致的模板文件
  - 对“简单路径”和“有架构门禁路径”各做一次纸面 walkthrough，确认文件编号能闭合
- **风险**:
  - 这是契约层调整，改动面跨多个文档；若选错统一方向，可能影响既有历史示例和维护者认知

### F-002
- **计划修改**: 重写 `review-workflow-state.md` 的阶段状态表，使其与 `code-review-triage/SKILL.md` 的真实阶段和文件名严格一致。
- **涉及文件**:
  - `plugins/ai-engineering-skills/skills/code-review-triage/assets/review-templates/review-workflow-state.md`
  - 如有必要，同步更新 `references/review-document-contracts.md` 或 `SKILL.md` 中对 state 字段的表述，但不改 workflow 主流程边界
- **验证方式**:
  - 检查阶段表仅引用 review 产物文件
  - 检查文件名使用 `review-scope` 而非错误的 `review_scope`
  - 模拟“写完 findings 后恢复”场景，确认 resume 语义自然
- **风险**:
  - 若模板字段改动过大，可能和已有 review run 的手工填写习惯略有差异，但影响可接受

### F-003
- **计划修改**: 合并 `workflow-bootstrap/SKILL.md` 中重复的输出契约段落，只保留一套清晰规则与示例。
- **涉及文件**:
  - `plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md`
- **验证方式**:
  - 确认“路由后输出行为”只保留一处主规则
  - 确认删重后仍保留“说明所用 workflow / 是否继续旧 run / 不重复开平行 workflow”的关键约束
- **风险**:
  - 风险很低，主要是避免删除时丢掉细节

## 执行步骤
1. 先确定 `F-001` 的统一方向：**优先收敛到一套真实存在、可闭合的编号/模板体系**，而不是补出一套更复杂的双路径模板集。
2. 基于该方向，统一修改 `software-delivery-pipeline` 的 `SKILL.md`、references、示例与 `docs/skills-guide.zh-CN.md`。
3. 修正 `code-review-triage` 的 `review-workflow-state.md`，让阶段、文件名、恢复语义与 review workflow 一致。
4. 清理 `workflow-bootstrap` 的重复输出契约章节。
5. 做一次仓库内 grep 级核对，验证相关文件名和阶段术语是否仍有残留冲突。
6. 生成 `review-to-delivery-handoff.md`，交给 `software-delivery-pipeline` 实施。

## 验证计划
- 使用 `rg` 搜索所有 `delivery` 相关阶段文件名，核对是否仍存在互相打架的编号说明
- 使用 `rg` 搜索 `01-review_scope.md`、`02-delivery-architecture.md` 等误写残留，确认 review state 模板已修正
- 人工审阅修改后的 `SKILL.md` / docs / templates 是否语义对齐

## 不做事项
- 不新增新的 workflow 类型
- 不重写所有历史 run 产物
- 不顺手统一所有 skill 的措辞风格，除非与本次 findings 直接相关
- 不做宿主侧真实安装/渲染集成测试

## 澄清与收敛记录
- AI 发现的矛盾 / 缺口 / 风险 / 与代码现状冲突：`F-001` 存在“补模板”与“收敛编号”两种修法；前者保留弹性，但会增加模板数量与维护成本；后者更轻、更稳，但需要同步改 docs 和 references
- 提出的选项或替代方案：推荐采用“收敛编号/模板契约”为主线，把不存在的复杂后续模板路径收拢到现有模板体系
- 用户反馈：主人已在 `03-review-fix-selection.md` 中确认全修，但尚未确认本计划中的具体修法
- 本轮更新结果：形成了以“收敛契约”为主的修复计划
- 未解决阻塞项：等待主人确认是否按此计划推进

## 证据引用
| 结论 | 证据位置 | 类型 | 置信度 | 备注 |
| --- | --- | --- | --- | --- |
| `software-delivery-pipeline` 存在文件名全集不一致 | `workflow/reviews/2026-05-26-skill-consistency-review/02-review-findings.md` | 事实 | 高 | 对应 F-001 |
| `review-workflow-state` 模板混入 delivery 阶段 | `workflow/reviews/2026-05-26-skill-consistency-review/02-review-findings.md` | 事实 | 高 | 对应 F-002 |
| `workflow-bootstrap` 输出契约重复 | `workflow/reviews/2026-05-26-skill-consistency-review/02-review-findings.md` | 事实 | 高 | 对应 F-003 |
| 当前计划选择“收敛现有契约”而非“扩张模板集” | 本文“执行步骤”与“澄清与收敛记录” | 推断 | 中 | 需主人确认 |

## 决策记录
| 决策项 | 选择 | 不选方案 | 原因 | 确认记录 |
| --- | --- | --- | --- | --- |
| F-001 修法 | 收敛到一套真实存在的编号/模板体系 | 补齐一整套复杂路径模板 | 改动更聚焦、维护成本更低、与当前 assets 更一致 | 待主人确认 |

## 范围锁定
- 允许修改 / 关注的目录或文件：
  - `plugins/ai-engineering-skills/skills/software-delivery-pipeline/**`
  - `plugins/ai-engineering-skills/skills/code-review-triage/**`
  - `plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md`
  - `docs/skills-guide.zh-CN.md`
- 禁止修改 / 不关注的目录或文件：
  - 其他 skill 的主要流程
  - plugin marketplace / plugin.json
  - 已存在的历史 `workflow/runs/**`
- 允许改变的行为：
  - 调整文档契约与模板命名一致性
  - 修复 review state 模板的恢复语义
  - 删除重复说明
- 不允许改变的行为：
  - 引入新的产品级能力或运行时逻辑
  - 借机修改本轮未审出的其他设计边界
- 超出范围时的处理：暂停并请求用户确认。

## 影响分析
- 影响模块：`software-delivery-pipeline`、`code-review-triage`、`workflow-bootstrap`
- 影响 API / 接口：无运行时 API 影响；主要是文档/流程接口影响
- 影响数据表 / 实体 / DTO：无
- 影响配置 / 环境：无
- 影响异步任务 / MQ / 调度：无
- 影响测试：主要是需要补做仓库内一致性核对
- 兼容性影响：历史 run 文档不改，但未来 run 的命名/模板解释会更一致
- 回滚影响：若修改方向不满意，主要回滚文档与模板文件即可

## 验证矩阵
| 验收项 / Finding | 验证方式 | 命令或步骤 | 结果 | 证据 | 未覆盖原因 |
| --- | --- | --- | --- | --- | --- |
| F-001 | 文件名全集一致性核对 | `rg` 检索 `delivery` 阶段文件名；人工比对 assets 与 docs | 待执行 | 修改后的 grep 输出 | 需进入 delivery 后执行 |
| F-002 | review state 模板对齐检查 | 检查阶段表与 `SKILL.md` 文件名/阶段名是否一一对应 | 待执行 | 修改后的模板内容 | 需进入 delivery 后执行 |
| F-003 | 文档去重检查 | 检查 `workflow-bootstrap/SKILL.md` 仅保留一处输出契约 | 待执行 | 修改后的 SKILL diff | 需进入 delivery 后执行 |

## 变更记录
| 轮次 | 用户反馈 | 文档更新 | 当前状态 |
| --- | --- | --- | --- |
| 1 | 全修 | 形成覆盖 `F-001`/`F-002`/`F-003` 的实施计划 | 待确认 |

## 用户确认记录
- 待确认；确认前不得进入实现或代码修改。
