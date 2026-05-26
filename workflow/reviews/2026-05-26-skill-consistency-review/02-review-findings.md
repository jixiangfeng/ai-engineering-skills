# 02-review-findings

## 文档元信息
- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- 分支: `main`
- 提交: `25284f0`
- Agent: `codex`
- 来源文档: `01-review-scope.md`
- 状态: completed

## Findings

### F-001｜高｜`software-delivery-pipeline` 的必需产物清单与模板目录不一致，复杂路径会缺模板
- **位置**:
  - `plugins/ai-engineering-skills/skills/software-delivery-pipeline/SKILL.md:168-180`
  - `docs/skills-guide.zh-CN.md:296-316`
  - `plugins/ai-engineering-skills/skills/software-delivery-pipeline/assets/workflow-templates/`
- **证据**:
  - `SKILL.md` 明确声明复杂路径可能使用 `03-delivery-plan.md`、`04-delivery-implementation.md`、`06-delivery-debugging.md`、`07-delivery-verification.md`、`08-delivery-summary.md`。
  - `docs/skills-guide.zh-CN.md` 甚至直接列出了双路径文件全集，包括 `04-delivery-implementation.md`、`05-delivery-debugging.md`、`06-delivery-verification.md`、`07-delivery-summary.md`。
  - 但 `assets/workflow-templates/` 实际只有：
    `01-delivery-requirements.md`、`02-delivery-architecture.md`、`02-delivery-plan.md`、`03-delivery-plan.md`、`03-delivery-implementation.md`、`04-delivery-debugging.md`、`05-delivery-change-review.md`、`05-delivery-verification.md`、`06-delivery-summary.md`、`delivery-workflow-state.md`。
  - 缺失复杂路径声称会使用的后续模板，尤其是 `04-delivery-implementation.md`、`06-delivery-debugging.md`、`07-delivery-verification.md`、`08-delivery-summary.md`；同时 docs 中还声称存在 `05-delivery-debugging.md`、`06-delivery-verification.md`、`07-delivery-summary.md`。
- **影响**:
  - 下游 agent 按 skill 指令“使用 assets 模板”执行复杂任务时，无法找到对应模板，容易临时自造文件内容或错误复用简单路径模板。
  - 这会破坏该仓库最核心的“文档即流程契约”，并直接降低恢复、审查和跨 agent 一致性。
- **修复方向**:
  - 二选一并统一到底：
    1. **补齐模板集**，让 assets 与 `SKILL.md`/docs 声称的双路径完全一致；或
    2. **收敛文件编号策略**，删掉不存在的复杂路径文件名，只保留一套真实模板，并同步更新 `SKILL.md`、`docs/skills-guide.zh-CN.md`、`references/document-contracts.md`、示例文档。
- **置信度**: 高
- **verification_focus**:
  - 逐一核对 `SKILL.md`、`docs/skills-guide.zh-CN.md`、`references/document-contracts.md`、`assets/workflow-templates/` 的文件名全集是否完全一致。
  - 以“有架构门禁 + 有调试阶段 + 有验证 + 有总结”的复杂 run 做一次纸面 walkthrough，确认不会再出现缺模板。

### F-002｜高｜`code-review-triage` 的 `review-workflow-state` 模板误写成 delivery 阶段表，恢复协议会指向错误文档
- **位置**:
  - `plugins/ai-engineering-skills/skills/code-review-triage/SKILL.md:88-103`
  - `plugins/ai-engineering-skills/skills/code-review-triage/assets/review-templates/review-workflow-state.md:16-24`
- **证据**:
  - `SKILL.md` 明确规定 review workflow 的必需产物是：`01-review-scope.md`、`02-review-findings.md`、`03-review-fix-selection.md`、`04-review-fix-plan.md`、`review-to-delivery-handoff.md` 等。
  - 但对应 state 模板的阶段表写成了：
    - `review_scope | 01-review_scope.md`
    - `architecture | 02-delivery-architecture.md`
    - `plan | 02-delivery-plan.md / 03-delivery-plan.md`
    - `implementation | implementation report`
    - `verification | verification report`
    - `delivery | delivery report`
  - 这不仅混入了 delivery workflow 的文档名，还把 review 文件名错误写成 `01-review_scope.md`（下划线），与 `SKILL.md` 中的 `01-review-scope.md` 不一致。
- **影响**:
  - agent 若按模板更新 state，恢复时会读取错误阶段名和错误文档名，导致 review run 无法可靠 resume。
  - 这违反了仓库自己在 `docs/skill-consistency-checklist.md` 中要求的 state 模板需准确承载阶段与恢复点，也会误导维护者把 review/delivery 两类工作混在一起。
- **修复方向**:
  - 将 `review-workflow-state.md` 的阶段表改为 review 专用版本，至少覆盖：`review_scope`、`findings`、`fix_selection`、`fix_plan`、`handoff_or_closure`。
  - 所有文档名改为与 `SKILL.md` 完全一致的 review 命名。
  - 补充“是否允许改代码”与“当前 gate”字段，确保 resume 可直接判断是否仍处于只读阶段。
- **置信度**: 高
- **verification_focus**:
  - 核对 `review-workflow-state.md` 与 `SKILL.md` 的文件名、阶段名一一对应。
  - 模拟“写完 findings 后中断恢复”的路径，确认 resume 不会再跳到 delivery 阶段文件。

### F-003｜中｜`workflow-bootstrap` 存在重复输出章节，虽然不致命，但增加维护分叉风险
- **位置**:
  - `plugins/ai-engineering-skills/skills/workflow-bootstrap/SKILL.md:123-139`
- **证据**:
  - `Routing Output Contract` 与 `Output Behavior` 两个章节都在描述“路由后要说明所用 workflow、继续执行、不要并行重复开 workflow”。
  - 两段内容高度重复，但并非完全逐字相同，后续修改容易只改一处。
- **影响**:
  - 当前不会直接导致执行失败，但会提高文档维护时的分叉概率。
  - 作为路由入口 skill，这种轻微重复会放大为全仓库风格漂移的源头。
- **修复方向**:
  - 合并为单一输出契约章节，把推荐措辞作为附录示例保留。
- **置信度**: 高

## 不建议处理
- 目前没有把“仓库缺少自动化 lint/check 脚本”列为 finding。原因是本次只证实了人工契约体系存在，尚未证实仓库承诺过必须有自动化校验入口。
- 目前没有把各 skill 的 wording 差异当成 finding。除非它已经导致边界冲突、模板缺失或恢复失败，否则这类措辞差异不值得优先处理。

## 剩余风险 / 未覆盖项
- 各 skill `assets/` 模板正文是否与各自 `references/*-document-contracts.md` 逐项完全一致，本轮未逐字段比对。
- plugin 在真实 Claude/Codex/OpenClaw 宿主中的安装/呈现效果，本轮未做集成验证。
