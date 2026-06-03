# utCodeAgentCLI

`utCodeAgentCLI` 代表 CaTDD-native CLI 代码智能体执行层。

本 README 是 CLI agent 层的 WHAT / WHY 入口。关于 user intent 和 acceptance criteria，请阅读 [README_UserStory_ZH.md](README_UserStory_ZH.md)。关于 HOW、WHO、WHEN、WHERE 如何设计或使用这一层，请阅读 [README_UserGuide.md](README_UserGuide.md) 或 [README_UserGuide_ZH.md](README_UserGuide_ZH.md)。

## What

`utCodeAgentCLI` 是 CaTDD 四层模型中的智能执行层。

它是本仓库的 CaTDD-native agent 概念：

- 开发者定义目标。
- 智能体基于 CaTDD 方法约束进行规划。
- 智能体可调用 `slashCommands` 的标准化步骤。
- 智能体收集轨迹、反思结果，并将可复用模式反馈回方法层和命令层。
- 智能体保持 CaTDD 注释骨架、US/AC/TC 可追踪关系、分类归属和 RED/GREEN 状态纪律。

在当前仓库阶段，本目录记录预期的 CLI 层契约。它尚未包含可运行的 CLI 实现。

## Why

`utCodeAgentCLI` 存在的原因，是把可复用 CaTDD 知识闭环到有明确取向的 CaTDD-native 执行。

它保持清晰的执行边界：

- `methodPrompts` 负责方法语义。
- `slashCommands` 负责可移植命令步骤和流程。
- `agentSkills` 负责把 CaTDD 打包给 GitHub Copilot 等通用 CodeAgent 使用；它不是本 CLI 层的上游依赖。
- `utCodeAgentCLI` 在 CLI 实现加入后，负责目标驱动规划、执行、轨迹收集和反思。

这样可以避免让通用 CodeAgent 适配器承载 CaTDD 专用编排逻辑，同时保留未来一等 CaTDD 自动化路径。

## CaTDD-native contract

未来的 CLI 实现应建立在上游层之上：

- `methodPrompts` 提供与语言无关的 CaTDD 方法契约。
- `slashCommands` 提供与 code-agent 无关的可复用提示词命令。
- `utCodeAgentCLI` 增加规划、执行策略、轨迹处理和反思回路。

它可以面向多种编程语言，但必须保持 CaTDD 的 comment-alive verification design。

## Typical contents

- 独立 User Story 文档（`README_UserStory.md`、`README_UserStory_ZH.md`）
- 独立用户指南（`README_UserGuide.md`、`README_UserGuide_ZH.md`）
- 架构与详细设计文档（`README_ArchDesign.md`、`README_DetailDesign.md` 及 ZH mirrors）
- 未来的 CLI 任务入口提示词
- 未来的目标模板与执行检查清单
- 未来的轨迹收集与反思回路设计记录
- CLI 变为可执行时的未来实现文件

## Upstream / Downstream

- 上游输入：
  - `methodPrompts` 提供方法约束。
  - `slashCommands` 提供可复用执行单元。
- 独立的通用 CodeAgent 打包路径：
  - `agentSkills` 帮助通用 CodeAgent 使用 CaTDD，但 `utCodeAgentCLI` 不应依赖它。
- 下游输出：
  - 已执行任务。
  - 执行轨迹。
  - 反思记录。
  - 用于改进 `slashCommands` 和 `methodPrompts` 的反馈。

## Documentation boundary

保持文档分工清晰：

| 文件 | 负责内容 |
| --- | --- |
| `README.md` / `README_ZH.md` | WHAT：这一层是什么；WHY：这一层为什么存在。 |
| `README_UserStory.md` / `README_UserStory_ZH.md` | WHO：谁需要这一层；WHAT：它应提供什么用户价值；以及 detail design 前的 BDD acceptance criteria。 |
| `README_ArchDesign.md` / `README_ArchDesign_ZH.md` | 高层模块架构、runtime adapter 边界、AgentSDK 分离、trace/audit/control 设计，以及关键 trade-offs。 |
| `README_DetailDesign.md` / `README_DetailDesign_ZH.md` | 面向 TypeScript 的 contracts、data schemas、state transitions、error handling、implementation plan 与 verification strategy。 |
| `README_UserGuide.md` / `README_UserGuide_ZH.md` | HOW：现在如何设计或使用这一层；WHO：谁使用；WHEN：何时在这一层工作；WHERE：未来资产位于哪里；以及可复制执行的 `Usage Example`。 |

当可运行 CLI 存在后，具体 CLI 命令应记录在独立用户指南中。

## Maintenance rule

当规划、执行、轨迹或反思模式出现稳定复用时，将其固化到这里。

当这些模式稳定为可复用提示词步骤时，将改进反馈回 `slashCommands` 与 `methodPrompts`。
