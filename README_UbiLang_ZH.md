# CaTDD 通用语言（Ubiquitous Language）

本文件定义了 CaTDD 安装器会分发到目标项目根目录的词汇体系。
它是统一语义契约，用于保证方法提示词、slash 命令、代码智能体和生成适配器中的关键术语保持一致。

## Who

- 维护 `methodPrompts/` 的方法维护者。
- 维护 `slashCommands/` 的流程维护者。
- 维护 `codeAgents/` 与 `agentSkills/` 的代码智能体维护者。
- 将 CaTDD 安装到自身仓库的项目团队。

## What

这是 CaTDD 执行环境的共享术语表。

### Core Concepts

| 术语 | 含义 |
| --- | --- |
| CaTDD | Comment-alive Test-Driven Development（注释存活测试驱动开发）。 |
| Comment-alive | 在代码生成前，以结构化注释显式表达验证意图。 |
| US / AC / TC | User Story / Acceptance Criteria / Test Case 的可追溯链路。 |
| Skeleton | 仅注释的测试设计骨架，包含追溯标记和计划测试意图。 |
| RED | 产品代码修改前，处于可执行且预期失败的测试状态。 |
| GREEN | 产品代码修改后，测试通过状态。 |
| SpecCoding | 将验证设计工件作为可执行规格生命周期的 CaTDD 工作流。 |
| VibeCoding | 快速创意/原型模式；结果仍应回收并对齐到 CaTDD 追溯体系。 |

### Category Vocabulary

| 层级 | 分类 |
| --- | --- |
| P0 Functional | Typical, Edge, Misuse, Fault |
| P1 Design | State, Capability, Concurrency |
| P2 Quality | Performance, Robust, Compatibility, Configuration |

### Ownership Vocabulary

| 层 | 职责 |
| --- | --- |
| `methodPrompts/` | 分类语义与 CaTDD 方法约束的真理源。 |
| `slashCommands/` | 对方法语义的可移植命令/流程封装。 |
| `codeAgents/` | 目标驱动编排与执行策略。 |
| `agentSkills/` | 面向非原生代码智能体的技能打包。 |

## When

在以下场景使用本术语表：

- 在 README、prompt、rule、架构文档中定义新术语时；
- 命名新的 UT_*/SPEC_* 命令时；
- 审查 EN/ZH 或不同适配器之间术语漂移时；
- 将 CaTDD 安装到新项目时。

## Where

- 本仓库真理源：`README_UbiLang.md`（项目根目录）。
- 目标项目安装位置：`<target>/README_UbiLang.md` 与 `<target>/README_UbiLang_ZH.md`。
- 被已安装规则/说明引用：`.github/instructions`、`.continue/rules`、`.clinerules`、`.antigravityrules` 以及自定义适配器规则。

## Why

CaTDD 是方法驱动的体系。关键词漂移会直接导致行为漂移。

统一通用语言可确保不同代码智能体运行时下，生成 prompt、命令流程、评审输出与实现决策保持一致。

## How

1. 新增领域术语时，先在这里定义，再扩散到其他文档。
2. 对工具依赖的状态名/分类名保持稳定措辞。
3. 拒绝会改变语义的随意同义词替换（例如不要随意重命名分类）。
4. 更新安装器时，确保两个术语文件都复制到目标项目根目录。

## Usage Example

发布前进行术语一致性检查：

```bash
rg -n "Typical|Edge|Misuse|Fault|State|Capability|Concurrency|Performance|Robust|Compatibility|Configuration|US/AC/TC|SpecCoding|VibeCoding" README*.md methodPrompts slashCommands codeAgents agentSkills
```

预期结果：这些术语的含义与本文件定义保持一致。
