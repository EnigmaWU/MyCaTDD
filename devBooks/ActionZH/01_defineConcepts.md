# 01 定义核心概念

## 什么是 CaTDD？

**CaTDD** —— Comment-alive Test-Driven Development（评论即设计测试驱动开发）—— 是由 EnigmaWU 发明、自 2023 年 10 月开始实践的一套方法论。它通过将注释变为 LLM 可解析、可保留、可更新的一等工件，重新定义了软件开发中"设计"的含义。

核心口号道出了其本质：

> Comments is Verification Design. LLM Generates Code. Iterate Forward Together.

在传统开发中，设计存在于独立的文档中，一旦代码发生变化，这些文档就会过时。在 CaTDD 中，设计以结构化注释的形式**存在于测试文件**中，随代码一起演进。注释不是文档——它们就是验证规约。

### "评论即设计"（Comment-alive）的含义

"评论即设计"是 CaTDD 的定义性创新，它有四个维度：

1. **设计细节以结构化注释的形式存在于测试文件和源文件中。** 你不需要维护单独的规约文档、架构文档和测试计划。验证设计就嵌入在代码所在之处。

2. **注释随代码一起演进，而不是在会过时的独立文档中。** 当你重构生产代码时，你同时在同一个文件中更新注释。设计意图和实现通过构造方式保持同步。

3. **注释是 LLM 可以解析和更新的一等工件。** 阅读 CaTDD 测试文件的 LLM 能看到结构化的 `@[US]`、`@[AC]`、`@[TC]` 标记，它可以追踪、验证这些标记并从中生成代码。这就是 CaTDD 被称为"LLM 友好的 TDD"的原因。

4. **US/AC/TC 格式在人类意图和机器可执行测试之间架起了桥梁。** 用户故事（User Story）表达业务价值。验收标准（Acceptance Criteria）使故事可测试。测试用例（Test Case）将验收标准连接到具体的断言。这条链路从人类需求直达机器验证，中间没有缺口。

### "TDD" 部分

CaTDD 继承了传统 TDD 的红→绿→重构循环，但在编码之前增加了结构化设计：

| 传统 TDD | CaTDD |
|---|---|
| 先写一个失败的测试 | 先写结构化注释设计（US/AC/TC），再写失败的测试 |
| 实现代码使其通过 | 实现最小生产代码使其通过 |
| 重构 | 同时重构测试代码和生产代码 |
| 重复 | 标记 TC 状态（⚪→🔴→🟢），推进到下一个 |
| 没有显式的设计工件 | 设计与测试共存于同一文件中 |

CaTDD 不是 TDD 的替代品。它是内置了设计结构、可追溯性和 LLM 可读性的 TDD。

---

## 按类别划分的 Method Prompt

除了主 method prompt 之外，CaTDD 提供了 12 个按类别划分的 prompt——每个测试类别一个。这些深入指导文件（`CaTDD_methodPrompt4Cat-*.md`）在 CodeAgent 针对特定类别工作时给予指引：

| 类别 | Prompt 文件 | 核心指引 |
|---|---|---|
| Typical | `4Cat-Typical.md` | 核心正常路径设计，每个测试一个行为，≤3 个断言 |
| Edge | `4Cat-Edge.md` | 边界值、模式变体，每个边界一个测试以便诊断 |
| Misuse | `4Cat-Misuse.md` | API 合约违规、错误预防、非法调用序列 |
| Fault | `4Cat-Fault.md` | 外部故障、恢复、优雅降级 |
| State | `4Cat-State.md` | 生命周期转换、FSM 验证、非法状态拒绝 |
| Capability | `4Cat-Capability.md` | 系统极限、容量规划、文档化边界 |
| Concurrency | `4Cat-Concurrency.md` | 线程安全、竞态条件、并行访问模式 |
| Performance | `4Cat-Performance.md` | SLO 验证、基准测试、资源使用 |
| Robust | `4Cat-Robust.md` | 压力测试、浸泡测试、长期运行稳定性 |
| Compatibility | `4Cat-Compatibility.md` | 跨平台、版本升级、集成接口 |
| Configuration | `4Cat-Configuration.md` | 构建标志、部署变体、功能开关 |
| Demo/Example | `4Cat-DemoExample.md` | 教程、文档、最佳实践示例 |

每个类别 prompt 定义了：**Position**（在优先级框架中的位置）、**Use When**（适用条件）、**Do Not Use When**（何时应将场景移至其他类别）、**Design Focus**（设计重点）、**Design Skeleton**（合约骨架）、**US/AC/TC Pattern**（标准格式）、**Naming Examples**（具体测试命名）、**Checklist**（质量验证清单）以及 **Common Mistakes**（常见错误）。

这些 prompt 是 LLM 针对每个类别的"风格指南"。当 CodeAgent 设计一个 Typical 设计骨架时，它会读取 `4Cat-Typical.md` 来应用正确的模式、术语和约束。当它将草案分类到类别中时，它会检查"Do Not Use When"规则以避免错误分类。

---

## 四层架构

MyCaTDD 将 CaTDD 方法论组织为四个层级，每个层级职责清晰：

```
┌─────────────────────────────────────────────────────┐
│ [1] methodPrompts       — 方法源头                    │
│     CaTDD 语义、类别含义、US/AC/TC                   │
│     骨架规则、状态纪律、模板                          │
├─────────────────────────────────────────────────────┤
│ [2] slashCommands       — 命令流程                    │
│     可移植的 UT_* 和 SPEC_* 命令、流程顺序            │
│     输入/输出传递、工具中立的执行                      │
├─────────────────────────────────────────────────────┤
│ [3] codeAgents          — 智能执行                    │
│     utCodeAgentCLI（单元测试）、specCodeAgentCLI       │
│     规划、追踪收集、反思循环                           │
├─────────────────────────────────────────────────────┤
│ [4] agentSkills         — 可复用能力包                │
│     Comment-alive TDD 技能、SpecCoding 技能            │
│     打包供 Copilot、Cline 及其他 agent 使用            │
└─────────────────────────────────────────────────────┘
```

### 第 1 层：methodPrompts — 真理之源

`methodPrompts/` 是 CaTDD 的规范性定义。下游的一切都源自这一层。如果方法论有变化，这一层最先变化。

它包含：

- **`CaTDD_methodPrompt.md`** — 主方法规约。CaTDD 的每个方面都在此定义：优先级框架、类别语义、US/AC/TC 合约、TDD 红→绿循环、质量关卡、状态跟踪、风险驱动的优先级排序，以及从理解到最终完成的完整 agent 工作流检查清单。

- **`CaTDD_methodPrompt4Cat-*.md`** — 按类别划分的 method prompt。12 个测试类别（Typical、Edge、Misuse、Fault、State、Capability、Concurrency、Performance、Robust、Compatibility、Configuration、Demo/Example）各自都有专门的深入 prompt，CodeAgent 在该类别下工作时可以参考。

- **`CaTDD_designAndImplTemplate.cxx`** — 一个 C++ 实现模板，展示了完整的 CaTDD 文件结构。尽管使用 C++ 语法，该模板在概念上是语言无关的：任何语言都可以采用 OVERVIEW → DESIGN → IMPLEMENTATION → TODO 结构。

- **独立用户指南** — `README_UserGuide.md` 和 `README_UserGuide_ZH.md` 解释了如何使用 method prompt、谁使用它们、何时应用以及放在哪里。它们的存在使得用户无需阅读整个仓库，仅使用此目录即可上手。

### 第 2 层：slashCommands — 命令化层

`slashCommands/` 将稳定的方法步骤转化为可移植的命令。它是方法语义与 CodeAgent 调用界面（Copilot、Cline、Continue、utCodeAgentCLI）之间的连接器。

核心原则：slashCommands 不重新定义方法语义。它取 methodPrompts 定义的内容，将其包装为可执行的命令单元。当命令与 methodPrompts 冲突时，以 methodPrompts 为准。

该层包含：

- **`flows/` 下的流程文档** — P0-FuncTestsFlow、P1-DesignTestsFlow、P2-QualityTestsFlow 和 Px-SpecFlow。每个流程定义了可重复的命令序列，包含入口点、关卡和循环返回路径。

- **命令模板** — `UT_slashCommandTemplate.md` 和 `SPEC_slashCommandTemplate.md` 确保每个命令遵循相同的 WHO/WHAT/WHEN/WHERE/WHY/HOW 结构。

- **`commands/` 下的具体命令文件** — 每个命令文件告诉 CodeAgent 具体做什么：读取什么、产出什么、保留什么，以及接下来执行什么命令。

### 第 3 层：codeAgents — 执行层

`codeAgents/` 包含 CaTDD 原生的 CLI agent 概念。目前这些是设计文档和架构规约——可运行的实现正在进行中。

定义了两个 agent：

- **`utCodeAgentCLI`** — 单元测试代码 agent。它接收开发者目标作为输入，从 CaTDD 方法约束出发进行规划，调用标准化的 slash command 步骤，收集追踪信息，反思结果，并将可复用的模式反馈回方法层和命令层。它保留 CaTDD 的设计骨架合约、US/AC/TC 可追溯性、类别分类以及 RED/GREEN 状态纪律。

- **`specCodeAgentCLI`** — 规约代码 agent。它基于 Px-SpecFlow 编排模块级的 SpecCoding 流程，从输入到输出。它复用 utCodeAgentCLI 的单元测试能力，组织从规约意图到可执行检查的场景级验证。它保持规约流程、验证检查点和实现结果之间的可追溯性。

这两个 agent 共同构成一条流水线：spec → ut → results。

### 第 4 层：agentSkills — 打包层

`agentSkills/` 将 CaTDD 和 SpecCoding 打包为任何 CodeAgent 都可以消费的可复用技能。编写了两个技能：

1. **`comment-alive-test-driven-development`** — CaTDD 测试方法论打包为技能。它包含 WHO/WHAT/WHEN/WHERE/WHY 部分、分阶段执行指令、输入/输出合约、约束和验证规则。当开发者对 CodeAgent 说"使用 CaTDD"时，此技能为 agent 提供所需的一切。

2. **`user-story-centered-spec-coding`** — SpecCoding 生命周期编排打包为技能。它涵盖完整的用户故事生命周期：pendingNews → todoUS → doingUS → doneUS，其中 abortUS 保留不安全的活跃故事以供后续分析，CaTDD 作为默认的单元测试方法。

打包脚本 `makeSkill.sh` 通过从 methodPrompts 和 slashCommands 复制引用，生成自包含的可分发包。编写的源文件是持久资产；生成的包是构建输出。

---

## 反馈循环

这四个层级不是单向流水线。它们形成一个双向改进循环：

```
methodPrompts ──→ slashCommands ──→ codeAgents
      ↑               ↑                │
      └───────────────┴────────────────┘
               反馈循环
```

- **methodPrompts → slashCommands**：稳定的方法步骤被命令化为 slash command。
- **methodPrompts → codeAgents**：Agent 行为受到方法语义的约束。
- **slashCommands → codeAgents**：Agent 调用标准化的命令步骤。
- **slashCommands → methodPrompts**：命令执行揭示方法缺口——方法得到改进。
- **codeAgents → slashCommands**：Agent 反思识别可复用的命令模式——slash command 不断增长。
- **codeAgents → methodPrompts**：执行经验反馈到方法论的改进中。

这个循环确保 CaTDD 从实际使用中演进，而非从理论设计中产生。每个下游层既消费又改进上游层。

---

## 设计骨架合约

在 CaTDD 中，"设计"不是 UML 图或 Word 文档。它是测试文件内部的**可复用注释骨架**。每个骨架按以下方式组织：

- **Class**：优先级族 — `P0 Functional`、`P1 Design`、`P2 Quality`、`P3 Addons`
- **Category**：具体的验证角度 — `Typical`、`Edge`、`Misuse`、`Fault`、`State`、`Capability`、`Concurrency`、`Performance`、`Robust`、`Compatibility`、`Configuration`、`Demo/Example`

每个骨架保留以下最小形态：

```text
//=================================================================================================
// [Class] / [Category] Design Skeleton
//=================================================================================================
// @[Class]: P0 Functional / ValidFunc
// @[Category]: Typical
// @[Intent]: 此类别对该组件要验证什么
// @[UseWhen]: 何时使用此类别
// @[AvoidWhen]: 何时将场景移至其他类别
// @[US]: 此类别覆盖的 User Story ID
// @[AC]: 此类别覆盖的 Acceptance Criteria ID
// @[TC]: Test Cases、状态及预期的 TDD 下一步动作
//=================================================================================================
```

这个骨架是开发者和 CodeAgent 共同遵守的"合约"。开发者用验证意图填充骨架。CodeAgent 读取骨架并生成满足该意图的测试代码。双方在代码演进中共同更新骨架。

---

## 优先级框架

CaTDD 将测试组织为四个优先级级别，并遵循严格的执行顺序。这就是验证的架构。

### P0：功能测试（Functional Testing）

**公式**：`P0 = ValidFunc(Typical + Edge) + InvalidFunc(Misuse + Fault)`

P0 是其他一切之前的默认关卡。按照标准顺序，在推进到 P1 之前至少完成 P0 级别的测试——这确保 API 合约的成功路径和失败路径都得到验证。然而，下文所述的针对特定上下文的调整可能会将某些 P1 类别提前，与 P0 的完成交叉进行。

#### ValidFunc — 证明系统正确工作

| 类别 | 目的 | 示例 |
|---|---|---|
| **Typical** ⭐ | 核心正常路径工作流 | 服务注册、事件发布、命令执行 |
| **Edge** 🔲 | 边界值、极限、模式 | 最小/最大值、空输入、Block/NonBlock/Timeout 模式 |

#### InvalidFunc — 证明系统优雅地失败

| 类别 | 目的 | 示例 |
|---|---|---|
| **Misuse** 🚫 | 不正确的 API 使用模式 | 错误的调用顺序、重复初始化、无效参数 |
| **Fault** ⚠️ | 外部故障与恢复 | 网络故障、磁盘满、进程崩溃恢复 |

### P1：面向设计的测试（Design-Oriented Testing）

验证架构决策的测试：状态管理、容量规划和并发模型。

| 类别 | 目的 | 示例 |
|---|---|---|
| **State** 🔄 | 状态机转换与生命周期 | Init→Ready→Running→Stopped |
| **Capability** 🏆 | 最大容量与系统极限 | 最大连接数、队列极限、资源池耗尽 |
| **Concurrency** 🚀 | 线程安全与竞态条件 | 并行访问、死锁场景、无锁验证 |

### P2：面向质量的测试（Quality-Oriented Testing）

非功能需求：性能、稳定性和兼容性。

| 类别 | 目的 | 示例 |
|---|---|---|
| **Performance** ⚡ | 速度、吞吐量、资源使用 | 延迟基准测试、内存泄漏检测 |
| **Robust** 🛡️ | 压力、重复、长期运行稳定性 | 1000 次重复、24 小时浸泡测试 |
| **Compatibility** 🔄 | 跨平台、版本测试 | Windows/Linux/macOS、API 版本兼容 |
| **Configuration** 🎛️ | 设置与部署变体 | Debug vs Release、功能开关、环境变量 |

### P3：附加项测试（Addons Testing）

| 类别 | 目的 |
|---|---|
| **Demo/Example** 🎨 | 端到端演示、教程、最佳实践示例 |

### 默认测试顺序

```
P0: Typical → Edge → Misuse → Fault
P1: State → Capability → Concurrency
P2: Performance → Robust → Compatibility → Configuration
P3: Demo/Example
```

此顺序并非僵化不变——它会根据上下文进行调整。

---

## 针对特定上下文的优先级调整

不同的项目类型需要不同的测试优先级。CaTDD 为常见上下文提供了调整规则：

### 新的公共 API

```
P0: Typical → Edge → Misuse → Fault（彻底完成 P0）
P1: State → Capability → Concurrency
P2: Performance
```

*理由*：在做高级测试之前，先确保 API 合约的正确性。

### 有状态/重度 FSM 组件

```
P0: Typical → Edge（基本功能）
P1: State（提前提升）→ Capability → Concurrency
P0: Misuse → Fault（完成功能测试）
P2: Performance → Robust
```

*理由*：状态转换是架构核心——在基本功能之后测试它们。

### 可靠性关键服务

```
P0: Typical → Edge → Fault（提升）→ Misuse
P1: State → Capability → Concurrency
P2: Robust（提升）→ Performance → Compatibility
```

*理由*：错误处理和稳定性至关重要。

### 高性能系统（有 SLO）

```
P0: Typical → Edge → Misuse
P2: Performance（在 P2 内提升）→ Robust
P1: State → Capability → Concurrency
P0: Fault（完成 P0）
```

*理由*：性能特征是设计约束，而非事后考虑。

### 高并发设计

```
P0: Typical → Edge → Misuse
P1: Concurrency（提升为 P1 第一个）→ State → Capability
P0: Fault（完成 P0）
P2: Performance → Robust
```

*理由*：线程安全是架构基础。

### 数据处理管道

```
P0: Typical → Edge → Fault → Misuse
P2: Performance（提升）→ Robust（提升）
P1: State → Capability → Concurrency
```

*理由*：数据完整性和吞吐量是关键质量属性。

---

## 风险驱动的优先级调整

当针对特定上下文的调整不够时，使用风险评分公式：

```
Risk Score = Impact × Likelihood × Uncertainty

Impact:      1（低） → 3（关键）
Likelihood:  1（罕见）→ 3（频繁）
Uncertainty: 1（已知）→ 3（未知）

最高分：27
```

**优先级规则**：

- 得分 ≥ 18：将该类别立即移到 Edge 之后
- 得分 12–17：比默认位置提前 2 位
- 得分 9–11：比默认位置提前 1 位
- 得分 ≤ 8：保持默认位置

**评估示例**：

```
多线程队列中的 Concurrency：
  Impact: 3（数据损坏）
  Likelihood: 3（多线程）
  Uncertainty: 3（复杂交互）
  得分：27 → 在 Edge 之后立即测试

批处理器中的 Performance：
  Impact: 2（较慢但仍可用）
  Likelihood: 2（取决于负载）
  Uncertainty: 2（已有部分基准测试）
  得分：8 → 保持默认位置
```

---

## US/AC/TC 合约

CaTDD 的核心是从人类需求到机器可执行测试的可追溯链路：

```
User Story (US) → Acceptance Criteria (AC) → Test Case (TC)
      ↓                    ↓                      ↓
   业务价值            可测试条件              具体断言
```

### 用户故事（User Story）模板

```
US-n: 作为 [特定角色/人物画像]，
      我想要 [特定的能力或功能]，
      以便 [具体的业务价值或收益]。
```

每个 US 代表一个独特的用户价值。一个模块通常有 2–5 个 User Story。

**来自 IOC 事件系统的真实示例**：

```
US-1: 作为高负载场景下的事件生产者，
      我希望在队列满时能够不阻塞地发布事件，
      以便我的应用在负载下保持响应。
```

### 验收标准（Acceptance Criteria）模板

```
AC-n: GIVEN [初始上下文和前置条件]，
      WHEN [特定的触发器、动作或事件]，
      THEN [预期的可观察结果或行为]，
       AND [如有额外的预期结果]。
```

每个 US 定义 1–4 个 AC。每个 AC 必须可独立验证。

**真实示例**：

```
AC-1: GIVEN 一个事件生产者调用 IOC_postEVT_inConlesMode，
      WHEN IOC 的 EvtDescQueue 在 ASyncMode 下因阻塞消费者而满，
      THEN 生产者立即返回而不等待，
       AND 返回 IOC_RESULT_TOO_MANY_QUEUING_EVTDESC，
       AND 该事件未被加入处理队列。
```

### 测试用例（Test Case）模板

```
[@AC-n,US-n]
 TC-n:
   @[Name]: verifyBehavior_byCondition_expectResult
   @[Purpose]: 为什么这个测试重要以及它验证什么
   @[Brief]: 用简单的话描述测试做什么
   @[Steps]: 详细执行步骤（复杂测试可选）
   @[Expect]: 如何验证成功
   @[Notes]: 额外上下文、注意事项或依赖
```

**命名规范**：`verifyBehavior_byCondition_expectResult`

```
verifyServiceRegistration_byValidName_expectSuccess
verifyEventPost_byFullQueue_expectNonBlockReturn
verifyCommandExec_byMultipleClients_expectIsolatedExecution
verifyStateTransition_byInvalidSequence_expectError
```

这条链路必须是可追溯的：每个 TC 引用其 AC，每个 AC 引用其 US。CaTDD CodeAgent 读取这条可追溯链路，以理解要生成什么以及为什么。

---

## TDD 红→绿循环（CaTDD 风格）

CaTDD 通过显式的状态跟踪来规范 TDD 循环：

```
⚪ TODO/PLANNED  →  🔴 RED/FAILING  →  🟢 GREEN/PASSED
   （已设计）          （测试已编写，           （测试通过）
                        代码缺失）
```

每个测试用例以 ⚪ TODO 开始（在注释中设计好）。你实现测试，将其标记为 🔴 RED（应该失败，因为生产代码尚未编写）。你实现最小生产代码，运行测试，将其标记为 🟢 GREEN。然后你推进到下一个测试用例。

### 4 阶段测试结构

每个测试遵循一致的模式：

```cpp
TEST(CategoryName, verifyBehavior_byCondition_expectResult) {
    //===SETUP===
    // 初始化环境、创建资源、配置前置条件

    //===BEHAVIOR===
    printf("🎯 BEHAVIOR: verifyBehavior_byCondition_expectResult\n");
    // 执行被测试的动作

    //===VERIFY===
    // 验证结果（保持 ≤3 个关键断言）

    //===CLEANUP===
    // 释放资源、重置状态
}
```

**为什么每个测试 ≤3 个断言？**

- 更容易识别哪个失败了
- 更好的测试隔离性
- 更清晰的测试目的
- 如果需要更多断言，创建额外的测试用例

---

## 质量关卡（Quality Gates）

CaTDD 在各优先级级别之间定义了显式的关卡。在满足所有条件之前，你不能通过关卡。

### 关卡 P0：离开功能测试之前

必须完成：ValidFunc(Typical + Edge) + InvalidFunc(Misuse + Fault)

- 所有 Typical 测试 GREEN（80–90% 核心工作流覆盖）
- 所有 Edge 测试 GREEN（边界情况、边界值、极限已验证）
- 所有 Misuse 测试 GREEN 或已记录（错误用法已处理）
- 所有 Fault 测试 GREEN 或已记录（错误恢复已验证）
- 没有关键的正确性 bug
- **Fast-Fail Six** 测试全部通过
- 基本的内存/资源泄漏检查通过

**退出条件**：完整的 API 合约经过测试——成功和失败路径均覆盖。

### 关卡 P1：进入面向质量的测试之前

- State 测试 GREEN（如果有状态组件）
- Capability 测试 GREEN（极限已表征）
- Concurrency 测试 GREEN（如果多线程）
- 没有已知的死锁或竞态条件
- ThreadSanitizer/AddressSanitizer 通过
- 架构已验证符合设计要求

### 关卡 P2：发布之前

- Performance 测试 GREEN（如有 SLO 定义则满足）
- Robust 测试 GREEN（压力/浸泡测试通过）
- Compatibility 测试 GREEN（如果跨平台）
- Configuration 测试 GREEN（如果可配置）
- 满足生产就绪标准

### 可选关卡 P3：文档完成

- Demo/Example 测试 GREEN
- 教程代码已验证
- 最佳实践已记录

---

## Fast-Fail Six

尽早并经常运行这六个测试，以在详细测试浪费时间之前捕获常见问题：

1. **空/空值输入处理** — 每个 API 是否用正确的错误码拒绝 `NULL` 和空字符串？

2. **零/负数超时** — 超时为 0、-1 或 UINT_MAX 时会发生什么？

3. **重复注册/订阅** — 重复注册是否返回 ALREADY_EXISTS？

4. **非法调用序列** — 在初始化之前或清理之后调用 API 会发生什么？

5. **缓冲区满/空的边界情况** — 填充到容量上限，再尝试一个。完全清空，再尝试一个。

6. **重复关闭/重新初始化的幂等性** — 系统是幂等的还是返回正确错误？

这六个测试是防范 API 滥用的最低防线。它们在更深入的测试设计开始之前建立合约边界。

---

## 测试组织策略

CaTDD 根据项目规模支持两种组织策略：

### 单文件策略（较简单项目，<50 个测试）

将一个组件的所有测试放在一个文件中。使用 TEST suite 按类别组织。适用于小型到中型模块。

### 多文件策略（较大项目）

所有测试文件放在 `Test/` 目录中：

- `UT_Component_FreelyDrafts.cxx` — 探索与想法捕获
- `UT_Component_Typical.cxx` — 核心工作流
- `UT_Component_Edge.cxx` — 边界情况、边界值、极限
- `UT_Component_Misuse.cxx` — API 滥用模式
- `UT_Component_Fault.cxx` — 错误处理与恢复
- `UT_Component_State.cxx` — 状态转换
- `UT_Component_Concurrency.cxx` — 线程安全
- 公共工具放在 `_UT_Common.h`

成熟、稳定的测试从探索文件迁移到按类别划分的文件。

---

## 实现跟踪模板

每个 CaTDD 测试文件包含一个 TODO/实现跟踪部分，记录所有测试用例及其状态：

```
//===========================================================================================
// 🥇 高优先级 – 核心功能
//===========================================================================================
//   ⚪ [@AC-1,US-1] TC-1: verifyCore_byBasicOperation_expectSuccess
//   🔴 [@AC-2,US-1] TC-1: verifyCore_byMaxCapacity_expectProperHandling
//
//===========================================================================================
// 🥈 中优先级 – 边界与错误处理
//===========================================================================================
//   ⚪ [@AC-3,US-1] TC-1: verifyEdge_byEmptyQueue_expectEmptyResult
//   ⚪ [@AC-4,US-2] TC-1: verifyMisuse_byDoubleInit_expectError
//
//===========================================================================================
// 🥉 低优先级 – 高级场景
//===========================================================================================
//   ⚪ [@AC-5,US-2] TC-1: verifyPerformance_byHighLoad_expectAcceptableLatency
//
// 🚪 GATE P0：所有 P0 测试必须 GREEN 后才能进入 P1。
```

这个跟踪部分是整个测试工作的仪表盘。开发者和 CodeAgent 都通过它了解哪些已完成、哪些进行中、哪些已规划。

---

## 设计即活合约

CaTDD 从根本上重新定义了设计。设计不是编码开始之前就完成的、在上游的活动。设计是一份活合约，它存在于测试文件中，随代码一起演进，并且对人类和 LLM 都是可读的。

这份合约声明了：

1. **什么重要** — 以附带业务价值的 User Story 表达
2. **要验证什么** — 以 GIVEN/WHEN/THEN 格式的 Acceptance Criteria 表达
3. **如何验证** — 以带有具体断言的 Test Case 表达
4. **什么优先级** — 以 P0→P1→P2→P3 框架表达
5. **什么状态** — 以 ⚪→🔴→🟢 标记表达

这是 CaTDD 一切的基础。它是 methodPrompts 定义的、slashCommands 操作化的、codeAgents 执行的、agentSkills 打包的。所有其他层都依赖这些概念。

---

## 从概念到行动

后续章节从"是什么"转向"怎么做"：

- **第 2 章：chatVibeCoding** — 如何在基于聊天的开发中结合 LLM 使用 CaTDD，VibeCoding 与 SpecCoding 的区别
- **第 3 章：callSlashCommands** — 如何调用 slash command 系统，进行结构化、可重复的 CaTDD 执行
- **第 4 章：asyncCodeAgent** — 代码 agent 如何自动化测试设计、测试实现以及完整的 SpecCoding 生命周期
- **第 5 章：applyClassicSWE** — 软件工程知识之书（TDD、BDD、DDD）在 LLM 时代的应用，通过 CaTDD 将三者融为一体
