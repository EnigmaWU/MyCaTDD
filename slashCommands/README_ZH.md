# slashCommands

本目录存放可复用的斜杠命令提示词，用于将 CaTDD 方法落地为可触发命令。

## 在四层模型中的角色

`slashCommands` 是方法文档与完整智能体自动化之间的命令化层。

- 将方法片段转为可触发命令单元。
- 降低 GUI 或聊天式工作流的调用成本。
- 提升重复应用方法时的一致性。
- 与具体 code-agent 无关；命令应可被 Copilot、Cline、Continue 或任何能消费提示词文本的助手使用。

## 可移植性契约

斜杠命令不应依赖某一个编辑器、某一个模型提供方或某一种编程语言。

- 方法真理源：`methodPrompts`
- 命令形态：小型、可触发、可参数化的提示词单元
- 预期消费方：人类开发者、GUI/聊天助手，以及 `utCodeAgentCLI`
- 稳定性规则：当命令与 `methodPrompts` 冲突时，先更新 `methodPrompts`，再重新生成或修订命令。

## 模板契约

所有具体斜杠命令都应遵循 [UT_slashCommandTemplate.md](UT_slashCommandTemplate.md)。

该模板使用 5W1H 结构和普通 Markdown，使命令文本可被 Copilot、Cline、Continue、`utCodeAgentCLI` 以及类似助手复用。

## 优先级契约

斜杠命令流程优先级与 `methodPrompts` 中定义的 CaTDD Class 优先级使用同一套 Pn 编号，并从 `P0` 开始。

- **P0 = FuncTestsFlow**：功能测试流程，用于 Typical、Edge、Misuse、Fault 骨架。它就是 CaTDD `P0 Functional`。
- **P1 = DesignTestsFlow**：设计测试流程，用于 State、Capability、Concurrency 骨架。它就是 CaTDD `P1 Design`。
- **P2 = QualityTestsFlow**：质量测试流程，用于 Performance、Robust、Compatibility、Configuration 骨架。它就是 CaTDD `P2 Quality`。

未来的 Addons/Demo 命令应使用 `P3 Addons`，以保持与 `methodPrompts` 一致。

## 开发者入口

当开发者处于以下起点时，可以使用斜杠命令：

- 已有 demo tests，希望转换为 CaTDD 功能测试骨架。
- 已有 interface 或 protocol，希望在实现前设计 Typical 骨架。
- 已有 Typical、Edge、Misuse、Fault 或后续分类骨架，希望选择并实现下一个测试用例。

## 流程地图

| Flow | Purpose | Start here |
| --- | --- | --- |
| P0 FuncTestsFlow | 转换或设计功能测试骨架，然后逐个 TC 实现 | [flows/P0-FuncTestsFlow.md](flows/P0-FuncTestsFlow.md) |
| P1 DesignTestsFlow | 在稳定功能覆盖基础上扩展 State、Capability、Concurrency | [flows/P1-DesignTestsFlow.md](flows/P1-DesignTestsFlow.md) |
| P2 QualityTestsFlow | 在稳定行为基础上扩展 Performance、Robust、Compatibility、Configuration | [flows/P2-QualityTestsFlow.md](flows/P2-QualityTestsFlow.md) |

## 命令地图

| Developer need | Command template |
| --- | --- |
| 创建或修订可移植的 UT 斜杠命令 | [UT_slashCommandTemplate.md](UT_slashCommandTemplate.md) |
| 将 demo tests 转换为 CaTDD Typical 骨架 | [commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md](commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md) |
| 基于 interface/protocol 设计 Typical、Edge、Misuse 或 Fault 骨架 | [commands/P0-FuncTestsFlow/UT_designCatSkeleton.md](commands/P0-FuncTestsFlow/UT_designCatSkeleton.md) |
| 实现前审查功能测试骨架集合 | [commands/P0-FuncTestsFlow/UT_reviewFuncTestsSkeleton.md](commands/P0-FuncTestsFlow/UT_reviewFuncTestsSkeleton.md) |
| 从已有骨架中选择下一个测试用例 | [commands/P0-FuncTestsFlow/UT_tellMeNextImplTest.md](commands/P0-FuncTestsFlow/UT_tellMeNextImplTest.md) |
| 实现已选择的测试用例 | [commands/P0-FuncTestsFlow/UT_implTestCase.md](commands/P0-FuncTestsFlow/UT_implTestCase.md) |
| 审查已实现的测试用例 | [commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md](commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md) |

## 典型内容

- `flows/` 下的流程文档
- 共享命令模板 [UT_slashCommandTemplate.md](UT_slashCommandTemplate.md)
- `commands/` 下的命令提示词模板
- 参数化调用示例
- 防止与 `methodPrompts` 冲突的兼容性说明

## 上游 / 下游

- 上游输入：`methodPrompts`（方法定义）
- 下游消费方：
  - `utCodeAgentCLI`（调用命令的智能体流水线）
  - 使用助手 GUI/聊天模式的开发者
  - 任意兼容的代码助手，例如 Copilot、Cline、Continue 或类似工具

## 维护规则

当某个方法步骤高频且稳定后，将其抽取到本目录形成标准斜杠命令。
