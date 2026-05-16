# utCodeAgentCLI

本目录代表 CLI 代码智能体执行层。

## 在四层模型中的角色

`utCodeAgentCLI` 是智能执行层。

- 开发者定义目标，智能体完成任务规划与执行。
- 继承 `methodPrompts` 的方法约束。
- 可调用 `slashCommands` 的标准化步骤。
- 它是本仓库自己的 CaTDD-native 代码智能体概念，设计时深度内化 CaTDD。

## CaTDD-native 契约

`utCodeAgentCLI` 应建立在两个上游层之上：

- `methodPrompts` 提供与语言无关的 CaTDD 方法契约。
- `slashCommands` 提供与 code-agent 无关的可复用提示词命令。
- `utCodeAgentCLI` 增加规划、执行、轨迹收集和反思，形成有明确取向的 CaTDD-native 智能体工作流。

它可以面向多种编程语言，但应保持 CaTDD 的注释骨架、US/AC/TC 可追踪关系、分类归属和 RED/GREEN 状态纪律。

## 典型内容

- CLI 任务入口提示词
- 目标模板与执行检查清单
- 反思回路与迭代记录

## 上游 / 下游

- 上游输入：
  - `methodPrompts`：方法约束来源
  - `slashCommands`：可复用执行单元
  - `agentSkill`：领域技能封装
- 下游输出：
  - 已执行任务、过程轨迹与反馈，用于方法改进

## 维护规则

当规划/执行/反思模式出现稳定复用时，将其固化，并把改进回写到 `slashCommands` 与 `methodPrompts`。
