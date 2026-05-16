# MyCaTDD

MyCaTDD 是一个把 CaTDD 方法论逐步产品化的仓库，目标是把“方法”从手工使用，演进到可自动化、可智能化执行。

CaTDD 是 EnigmaWU 发明的方法论。IOC 是一个 PlayKata 模块和验证场，帮助 CaTDD 从想法演进为真实可复用的方法论。

核心口号：

> Comments is Verification Design. LLM Generates Code. Iterate Forward Together.

## 你图里的意思（本仓库对应）

你的图表达的是一条四层演进链路：

1. [methodPrompts](methodPrompts/README.md)（方法提示词）
2. [slashCommands](slashCommands/README.md)（提示词命令）
3. [utCodeAgentCLI](utCodeAgentCLI/README.md)（代码智能体）
4. [agentSkill](agentSkill/README.md)（技能包）

并且存在双向改进闭环：

- [1] 应用到 [2]、[3]
- [4] 把 [1] 封装为可复用的智能体能力
- [2] 和 [3] 的实践再反哺改进 [1]
- [3] 的任务规划与反思进一步反哺 [2]

这个 README 按这条主线组织。

## 四层资产与职责

### [1] [methodPrompts](methodPrompts/README.md)（方法提示词）

简介：CaTDD 的语言无关方法源头层。它定义 comment-alive 设计骨架、分类方法提示词、用户指南材料和实现模板。

更多说明：[methodPrompts/README.md](methodPrompts/README.md)。

当前仓库内容：

- `methodPrompts/CaTDD_methodPrompt.md`
- `README_UserGuide.md`
- `methodPrompts/CaTDD-UserGuide-PPT.md`
- `methodPrompts/CaTDD-UserGuide-PPT-ZH_CN.md`
- `methodPrompts/CaTDD_ImplTemplate.cxx`

来源说明：以上材料初始导入自
`https://github.com/EnigmaWU/MyIOC_inTDD_withGHC/tree/main/LLM`
（部分示例中的相对路径仍指向原仓库结构）。

### [2] [slashCommands](slashCommands/README.md)（提示词命令）

简介：与具体 code-agent 无关的命令化层。它把稳定的 CaTDD 方法步骤整理为小型、可触发的提示词命令，可被 Copilot、Cline、Continue 或类似助手使用。

更多说明：[slashCommands/README.md](slashCommands/README.md)。

### [3] [utCodeAgentCLI](utCodeAgentCLI/README.md)（代码智能体）

简介：本仓库自己的 CaTDD-native CLI 智能体层。开发人员定义目标后，智能体基于 [1] 和 [2] 完成规划、执行、追踪与反思。

更多说明：[utCodeAgentCLI/README.md](utCodeAgentCLI/README.md)。

### [4] [agentSkill](agentSkill/README.md)（技能包）

简介：可复用能力封装层。它把 CaTDD 方法知识封装为可触发技能，并保持技能引用与 canonical method files 对齐。

更多说明：[agentSkill/README.md](agentSkill/README.md)。

`agentSkill/comment-alive-test-driven-development` 负责把 CaTDD 封装为可触发技能：

- `agentSkill/comment-alive-test-driven-development/SKILL.md`
  - 技能定义：触发条件、输入输出、约束、分阶段流程
- `agentSkill/comment-alive-test-driven-development/README.md`
  - 人类可读说明：US/AC/TC 分层、优先级框架、使用示例
- `agentSkill/comment-alive-test-driven-development/references/`
  - 参考资料打包：User Guide / method prompt / Template / PPT

这层资产可以视作从 [1] 向 [2]/[3] 过渡的关键桥梁。

## 三种协作模式（与图一致）

### 模式 A：开发人员手动模式

- 输入：`methodPrompts`
- 方式：手工阅读并执行方法步骤
- 产出：可验证的测试设计与实现

### 模式 B：开发人员 + 代码助手（GUI）

- 输入：`methodPrompts` +（未来）`slashCommands`
- 方式：按需调用方法或命令片段
- 关注点：方法分解、流程自动化应用

### 模式 C：开发人员 + 代码智能体（CLI）

- 输入：`methodPrompts` + `slashCommands` + 目标定义
- 方式：智能体完成任务规划、执行与反思
- 关注点：智能化应用方法、闭环优化

## 迭代闭环（建议执行方式）

1. 先在 [1] 把方法写清楚、写稳定。
2. 在 [2] 把高频步骤命令化，降低调用成本。
3. 在 [3] 把完整任务交给智能体执行。
4. 把 [3] 暴露的问题回写到 [2] 与 [1]，持续改进。

## 快速开始

1. 先阅读 `README_UserGuide.md` 了解全貌。
2. 用 `methodPrompts/CaTDD_ImplTemplate.cxx` 新建测试文件骨架。
3. 参考 `agentSkill/comment-alive-test-driven-development/SKILL.md` 以技能化流程执行。
4. 运行 `bash agentSkill/makeSkill.sh` 打包技能引用与链接。
5. 在你的工具链中逐步补齐 `slashCommands` 与 CLI 智能体接入。
