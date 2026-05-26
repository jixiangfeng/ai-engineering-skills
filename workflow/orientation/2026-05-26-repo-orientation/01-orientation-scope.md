# 01-orientation-scope

## 文档元信息
- 项目根目录: `/Users/fengjixiang/.openclaw/workspace/ai-engineering-skills`
- 生成时间: 2026-05-26
- 分支: `main`
- 提交: `25284f0`
- Agent: `codex`
- 状态: completed

## 本次目标
熟悉 `ai-engineering-skills` 仓库，明确它的定位、核心 skill 组成、目录结构、插件安装方式、workflow 产物约定，以及后续继续 review / 开发时的推荐切入点。

## 范围内
- 仓库根目录与 plugin 目录结构
- README 与 docs 核心说明
- 各 skill 的 `SKILL.md` 顶层规则与职责边界
- Claude/Codex marketplace 元数据
- 已有 `workflow/runs/` 产物分布

## 范围外
- 不逐条深入核验每个 skill 的全部模板文件内容
- 不执行插件安装、发布、打包、远程验证
- 不对 skill 质量做正式 review finding 输出
- 不修改 skill 内容或仓库配置

## 关注点
1. 这个仓库到底是不是“业务项目”，还是“研发流程 skill 仓库”
2. 七个 skill 如何分工、如何衔接
3. 仓库的单一事实来源在哪里
4. 产物写到哪里，恢复/交接靠什么文件约束
5. 后续如果要继续增强这个仓库，最合理的进入 workflow 是什么

## 事实
- 仓库名为 `ai-engineering-skills`，不是业务应用服务仓库。
- 根 README 明确其定位为“面向软件研发流程的七套 agent skill，Codex 和 Claude 都可以使用”。
- `plugins/ai-engineering-skills/skills/` 是唯一 skill 源码目录。

## 待确认
- 主人后续更关心的是“作为用户怎么用这套 skill”，还是“继续迭代维护这套 skill 仓库本身”。
