# 06-orientation-open-questions

## 已识别但未深挖的问题

1. **assets 模板完整性未逐个核验**
   - 事实：skill 目录下存在 `assets/` 与 `references/`，但本次主要阅读了 `SKILL.md` 与仓库级 docs。
   - 影响：无法确认每个 skill 的模板是否与 `SKILL.md` / checklist / workflow contracts 完全一致。
   - 建议下一步：如要继续维护仓库，适合进入 `code-review-triage` 做一致性 review。

2. **自动化校验能力未看到明确入口**
   - 事实：当前看到的是文档化规范与 checklist。
   - 待确认：是否存在未被本次范围覆盖的 lint / test / CI 校验逻辑。
   - 风险：如果只靠人工 review，skill 演进时容易再次分叉。

3. **workflow-bootstrap 是否需要更多结构化路由输出**
   - 推断：当前它主要是规则型路由 skill；如果未来仓库继续增长，也许会需要更强的输入分类模板或决策记录格式。
   - 说明：这不是 finding，只是后续 review 线索。

4. **对外使用说明与内部维护说明的边界**
   - 事实：README 与 `docs/skills-guide.zh-CN.md` 已经同时覆盖“怎么用”和“怎么理解”。
   - 待确认：如果后续使用者增多，是否要把“用户指南”和“维护者指南”进一步分层。

## 当前最重要的待确认项
- 主人接下来是想：
  1. 把这个仓库当工具来用；还是
  2. 继续迭代这个仓库本身。

这会直接决定下一步应该走：
- `code-review-triage`（审视仓库质量/一致性）
- `software-delivery-pipeline`（实现新增/改造 skill）
- 或只是继续定向熟悉某个 skill。
