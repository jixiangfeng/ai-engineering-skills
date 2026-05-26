# Skill Consistency Checklist

这份清单用于判断一个 skill 在本仓库中是否达到“结构一致、可恢复、可交接、可维护”的最低合格线。

适用场景：
- 新增 skill 前的设计检查
- 修改现有 `SKILL.md` 后的自检
- review 仓库中 skill 成熟度时的统一标准

## 1. 基础定位

- [ ] skill 名称、用途、适用场景清晰
- [ ] 明确说明何时使用、何时不使用
- [ ] 若存在相邻 skill，边界清晰，不与其它 skill 严重重叠
- [ ] 若只是入口/路由 skill，明确其只负责分流，不承担完整执行职责

## 2. 权限与行为边界

- [ ] 明确是只读 skill、设计 skill，还是默认允许改代码的交付 skill
- [ ] 明确哪些情况下禁止直接改代码
- [ ] 明确范围扩大、破坏性操作、高风险操作时必须暂停确认
- [ ] 明确是否允许绕过默认 workflow 边界，以及绕过条件

## 3. Preflight / Resume / State

- [ ] 有 preflight checklist
- [ ] 有 resume protocol
- [ ] 如 workflow 会跨回合继续，存在 workflow-state 文件约定
- [ ] 若 `SKILL.md` 要求使用 state 文件，则 assets 中存在对应模板
- [ ] state 文件至少能记录：当前阶段、当前状态、下一步、阻塞项、是否允许改代码

## 4. 阶段化执行

- [ ] 若 skill 不是纯路由器，则有清晰阶段定义
- [ ] 每个阶段都说明目标、动作和产物
- [ ] 需要用户确认的阶段有明确 gate
- [ ] 继续执行前知道应读取哪些上游文档
- [ ] 不会把 review / design / debug / delivery 等不同类型工作偷偷混成一类

## 5. 文档产物

- [ ] 明确产物目录位置（项目根目录下的 `workflow/` 子目录）
- [ ] 明确必需文档和可选文档
- [ ] 新文件命名遵循仓库统一前缀规则
- [ ] 对旧命名文件是否兼容有说明
- [ ] 文档默认语言要求明确（当前仓库默认中文）

## 6. 质量约束

- [ ] 明确要求文档元信息
- [ ] 明确要求证据引用或事实/推断/待确认区分
- [ ] 明确要求范围锁定
- [ ] 明确要求决策记录或确认记录
- [ ] 重要结论不能只停留在聊天里，而要写回文档

## 7. Handoff / Downstream Compatibility

- [ ] 若 skill 会把结果交给下游 skill，handoff 文件存在且用途清晰
- [ ] handoff 不依赖聊天上下文猜范围
- [ ] handoff 明确包含范围、约束、证据和未解决问题
- [ ] 若有 machine-readable 约束（如 YAML），格式要求明确
- [ ] 若不需要 handoff，也应清楚说明结束条件

## 8. References / Contracts

- [ ] skill 至少有一个稳定的 reference/guideline/contract 承载点
- [ ] contract 类规则不要只散落在 `SKILL.md` 的长段文本里
- [ ] 新增规则优先集中到可复用文档，避免复制到多个 skill 形成分叉
- [ ] reference 文档名称与用途清晰，便于后续维护者快速发现

## 9. 仓库一致性检查

- [ ] 与 README、`docs/skills-guide.zh-CN.md` 的说明不冲突
- [ ] 与现有成熟 skill（尤其 `software-delivery-pipeline`、`code-review-triage`、`codebase-orientation`、`debug-root-cause`）的结构风格相容
- [ ] 新增内容没有无意义发明新的术语体系
- [ ] 新增模板、reference、state 文件在目录结构中可被自然发现

## 10. 何时算“可以接受”

一个新 skill 或被修改后的 skill，至少应满足：
- 基础定位清楚
- 行为边界清楚
- 有 preflight / resume / state（如需要）
- 有阶段或清晰路由规则
- 有稳定产物或明确说明不产生产物
- 有 reference / guideline / contract 承载点
- 与仓库整体 naming / workflow / docs 体系一致

如果不能同时满足这些点，至少要在文档中明确说明为什么例外，而不是静默缺失。

## 11. 自动化自检

修改 skill、模板、reference、README、workflow contract 或 plugin metadata 后，运行：

```bash
bash scripts/check-consistency.sh
```

该检查不能替代人工 review，但可以提前发现：

- README / 使用说明中列出的 skill 与实际目录不一致
- `SKILL.md` 声明的 required files 缺少模板
- plugin manifest 指向的 skills 路径不存在
- workflow contract 的关键章节丢失
