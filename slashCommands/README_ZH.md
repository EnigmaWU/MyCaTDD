# slashCommands

本目录存放可复用的斜杠命令提示词与流程，用于将 CaTDD 方法落地为可触发命令。

本 README 是命令连接层的 WHAT / WHY 入口。关于 HOW、WHO、WHEN、WHERE 如何使用 `slashCommands/`，请阅读 [README_UserGuide.md](README_UserGuide.md) 或 [README_UserGuide_ZH.md](README_UserGuide_ZH.md)。

## What

`slashCommands` 是 `methodPrompts` 与现有 CodeAgent 之间偏流程的连接与命令化层。

它为自动化或半自动化 CaTDD 执行定义可移植的命令意图与流程顺序：

- 将可重复命令阶段组织起来的流程文档。
- 每次只描述一个动作的小型命令提示词模板。
- 保持可移植提示词一致的共享命令模板。
- 从项目上下文推进到故事完成的 SpecCoding 流程契约。
- 与 CaTDD 优先级类对齐的功能、设计和质量测试流程。

`slashCommands` 与具体 code-agent 无关。同一套可移植命令文件可以被包装给 Copilot、Cline、Continue、`utCodeAgentCLI`，或任何能消费提示词文本的助手。

## Why

`slashCommands` 存在的原因，是让稳定的 CaTDD 方法步骤可以被重复调用，同时不在每个 CodeAgent 适配器中重复定义方法语义。

它保持清晰分工：

- `methodPrompts` 负责 CaTDD 方法含义、分类语义、优先级顺序和设计骨架规则。
- `slashCommands` 负责可移植流程意图、命令顺序，以及步骤之间的执行交接。
- 原生适配层只负责工具特定的暴露方式，例如 Copilot prompt files、Continue prompt files、Cline rules 或 CLI 集成。

这样可以避免每个工具集成都发明自己的 CaTDD 工作流，同时仍允许每个工具用自己的原生形态暴露命令。

## SpecCoding contract

`slashCommands` 是 CaTDD 的 Spec-Driven Development 风格工作流层。它不是一组松散的提示词快捷方式。

- 治理 spec 是来自 `methodPrompts` 的 comment-alive verification design。
- 流程命令推动开发者和 CodeAgent 经过可重复阶段：转换或设计骨架、审查骨架、选择下一个 TC、实现一个 TC、审查实现。
- 活的产物是 US/AC/TC 注释、分类标签、优先级关卡、TC 状态标记、测试文件，以及 `.catdd/spec/` 下的 SpecFlow 状态。
- 命令文件描述现在做什么、读什么、产出什么、保留什么，以及下一条命令是什么。

在 CaTDD 术语中，直接在 CodeAgent 对话中使用 `methodPrompts` 是 **VibeCoding**：灵活、由方法引导的对话。使用 `slashCommands` 是 **SpecCoding**：基于同一套方法定义的结构化 Spec-Driven Development 流程。

## Layer boundary

`slashCommands` 应作为适配层，而不是第二套方法论层。

- 不重新定义 CaTDD 分类含义。
- 不替代 `methodPrompts`。
- 不依赖某一个编辑器、某一个模型提供方或某一种编程语言。
- 不把原生生成的包装文件作为真理源。

当命令与 `methodPrompts` 冲突时，先更新 `methodPrompts`，再修订或重新生成命令层。

## Priority contract

斜杠命令流程优先级与 `methodPrompts` 中定义的 CaTDD Class 优先级使用同一套 Pn 编号，并从 `P0` 开始。

- **P0 = FuncTestsFlow**：功能测试流程，用于 Typical、Edge、Misuse、Fault 骨架。它就是 CaTDD `P0 Functional`。
- **P1 = DesignTestsFlow**：设计测试流程，用于 State、Capability、Concurrency 骨架。它就是 CaTDD `P1 Design`。
- **P2 = QualityTestsFlow**：质量测试流程，用于 Performance、Robust、Compatibility、Configuration 骨架。它就是 CaTDD `P2 Quality`。

未来的 Addons/Demo 命令应使用 `P3 Addons`，以保持与 `methodPrompts` 一致。

## 追溯与 SUT 约束

- `SPEC_designUnitTests` 与相关 `UT_design*Skeleton` 命令应强制满足最小追溯基数：每个 US 至少有 1 个 AC，每个 AC 至少有 1 个 TC。
- 测试设计产出必须在测试文件 Overview 中显式声明 SUT（例如：`SUT: utCodeAgentCLI`）。
- 若存在未闭合追溯（US 无 AC 或 AC 无 TC），命令应阻止该设计结果作为完成态。

## Typical contents

- 独立用户指南（`README_UserGuide.md`、`README_UserGuide_ZH.md`）
- `flows/` 下的流程文档
- 共享命令模板 [UT_slashCommandTemplate.md](UT_slashCommandTemplate.md)
- `commands/` 下的命令提示词模板
- 防止与 `methodPrompts` 冲突的兼容性说明

## Upstream / Downstream

- 上游输入：`methodPrompts` 方法定义。
- 下游消费方：
  - 面向 Copilot 和 Continue 的原生适配生成器。
  - 面向 Copilot、Continue 和 Cline 目标项目的安装器。
  - 调用命令单元的 `utCodeAgentCLI` 智能体流水线。
  - 使用助手 GUI/聊天模式的开发者。
  - 任意能消费提示词文本的兼容 code assistant。

## Documentation boundary

保持文档分工清晰：

| 文件 | 负责内容 |
| --- | --- |
| `README.md` / `README_ZH.md` | WHAT：这一层包含什么；WHY：这一层为什么存在。 |
| `README_UserGuide.md` / `README_UserGuide_ZH.md` | HOW：如何使用；WHO：谁使用；WHEN：何时使用；WHERE：安装后的资产在哪里；以及可复制执行的 `Usage Example`。 |

具体的生成器命令、安装器命令、流程地图和命令地图属于独立用户指南，不放在本 README 中。

## Maintenance rule

当某个方法步骤高频且稳定后，将其抽取到本目录形成标准斜杠命令。

当命令行为发生变化时，保持可移植命令文件为源头，然后为目标工具重新生成原生适配。
