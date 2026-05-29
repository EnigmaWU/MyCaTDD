# agentSkills

`agentSkills` 存放技能源码与生成后的技能包，用于在智能体工作流中复用 CaTDD 与 SpecCoding 能力。

本 README 是能力封装层的 WHAT / WHY 入口。关于 HOW、WHO、WHEN、WHERE 如何打包或消费 CaTDD 与 SpecCoding skills，请阅读 [README_UserGuide.md](README_UserGuide.md) 或 [README_UserGuide_ZH.md](README_UserGuide_ZH.md)。

## What

`agentSkills` 是 CaTDD 四层模型中的可复用能力封装层。

它定义如何把 CaTDD 方法知识与 SpecCoding 工作流知识封装为 CodeAgent 友好的技能：

- 技能源码目录。
- 机器可读的 `SKILL.md` 定义。
- 人类可读的技能本地 README 文件。
- 从 `methodPrompts` 复制的打包参考资料。
- 用于执行支持与 SpecCoding 生命周期支持的打包版 `slashCommands` 命令流程。
- 被忽略的 `dist/` 输出目录下的生成式分发包。

技能源码是持久资产。生成包是构建输出。

## Why

`agentSkills` 存在的原因，是让 CaTDD 与 SpecCoding 可以被智能体复用，而不需要每个智能体都从零发现方法、命令流程、生命周期规则、约束和参考资料。

它保持清晰的打包边界：

- `methodPrompts` 负责权威 CaTDD 方法定义。
- `slashCommands` 负责可移植命令流程执行。
- `agentSkills` 将这些资产封装为包含范围、约束、输入、输出和验证预期的可复用能力。
- 生成的 `dist/` 包是自包含的，因此可以复制或发布，而不会暴露源码树中的符号链接或重复 authored paths。

## Supported skills

| Skill | Owns |
| --- | --- |
| `comment-alive-test-driven-development` | CaTDD，作为可复用验证与测试方法论。 |
| `user-story-centered-spec-coding` | 以 user story 为中心的 SpecCoding 生命周期编排，并默认使用 CaTDD 作为 UnitTesting 方法。 |

## Packaging contract

技能包应从源码生成，不应手工编辑 `dist/`。

- 编辑对应 `agentSkills/<skill-name>/` 目录下的技能源码。
- 保持参考资料与 `methodPrompts`、`slashCommands` 对齐。
- 使用 `agentSkills/makeSkill.sh` 生成自包含包。
- 在本源仓库中保持生成的 `agentSkills/dist/` 输出被忽略。

## Typical contents

- 独立用户指南（`README_UserGuide.md`、`README_UserGuide_ZH.md`）
- 打包脚本（`makeSkill.sh`）
- 技能源码目录，例如 `comment-alive-test-driven-development/` 和 `user-story-centered-spec-coding/`
- 机器可读技能行为的 `SKILL.md` 文件
- 人类可读技能用法的技能本地 `README.md` 文件
- `dist/` 下生成的技能包，其中包含复制后的 `references/` 资产与复制后的 `slashCommands/`

## Upstream / Downstream

- 上游输入：
  - `methodPrompts` 提供权威方法定义。
  - `slashCommands` 提供可移植执行流程。
- 下游消费方：
  - 加载打包技能的 CodeAgent skill systems。
  - 需要可复用技能行为时的 `utCodeAgentCLI`。
  - 将 CaTDD 作为 agent capability 分发的开发者或维护者。

## Documentation boundary

保持文档分工清晰：

| 文件 | 负责内容 |
| --- | --- |
| `README.md` / `README_ZH.md` | WHAT：这一层包含什么；WHY：这一层为什么存在。 |
| `README_UserGuide.md` / `README_UserGuide_ZH.md` | HOW：如何生成包；WHO：谁使用；WHEN：何时打包；WHERE：输出在哪里；以及可复制执行的 `Usage Example`。 |

具体的打包命令与验证命令属于独立用户指南，不放在本 README 中。

## Maintenance rule

更新技能行为时，应编辑技能源码，并与 `methodPrompts` 和 `slashCommands` 保持一致。

当打包规则发生变化时，更新用户指南和测试，确保生成包保持自包含且可复现。
