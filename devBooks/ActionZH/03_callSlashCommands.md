# 03 callSlashCommands

## 什么是 Slash 命令？

Slash 命令是 CaTDD 的操作层——它们将 methodPrompts 转化为可执行的命令流程，供任何 CodeAgent 消费使用。Slash 命令不是传统意义上的 CLI 命令。它是一个 **Markdown 提示词文件**，精确定义了 CodeAgent 该做什么：当前执行哪一步、读取什么、生成什么、保留什么，以及下一步应该执行什么命令。

这一层位于 `slashCommands/` 目录中，严格遵循一条架构原则：**slashCommands 不重新定义 CaTDD 的方法语义**。它将 `methodPrompts` 中所定义的内容转换为可移植、可重复的命令单元。当 slash 命令与 methodPrompts 发生冲突时，以 methodPrompts 为准。

---

## 两大命令族系

Slash 命令按不同用途分为两个族系：

### UT 命令 —— 单元测试设计与实现

```text
UT_<verb><Object>
```

UT 命令执行 CaTDD 的测试开发步骤。它们操作的对象是测试文件、设计骨架和实现工作制品。它们属于特定类别的流程（P0、P1、P2）。

**示例**：
- `UT_designTypicalSkeleton` —— 设计 Typical 类别设计骨架
- `UT_implTestCase` —— 按 RED→GREEN 循环实现单个测试用例
- `UT_reviewFuncTestsSkeleton` —— 在实现前审查完整的 P0 功能骨架集
- `UT_tellMeNextImplTest` —— 从 TODO 跟踪区选择下一个要实现的测试用例

### SPEC 命令 —— SpecCoding 生命周期编排

```text
SPEC_<verb><Object>
```

SPEC 命令驱动工作沿着可追溯的 SpecCoding 生命周期前进。它们操作的是生命周期工作制品——项目上下文、待处理消息、用户故事、设计文档、测试、产品代码和提交/CI 状态——而非直接操作测试类别或类别骨架。

**示例**：
- `SPEC_initProjectContext` —— 创建首个项目上下文文件
- `SPEC_analyzeIssue` —— 将 Issue 转化为可追溯的用户故事
- `SPEC_takeArchDesign` —— 产出高层架构设计
- `SPEC_designUnitTests` —— 进入 CaTDD 测试设计，通常经 P0/P1/P2 流程
- `SPEC_commitWorks` —— 准备并提交已完成的工作
- `SPEC_closeUserStory` —— 将审核通过的已完成工作移至 done 归档

---

## 通用命令模板

每个 slash 命令都遵循 `UT_slashCommandTemplate.md` 和 `SPEC_slashCommandTemplate.md` 中定义的同一 Markdown 结构：

| 区域 | 内容 |
|---|---|
| **Command Header** | 命令名、流程、CaTDD 类、类别、方法来源、适配器目标 |
| **WHO** | 谁调用此命令、谁应执行此命令 |
| **WHAT** | 此命令具体做什么——它执行的单个工作流步骤 |
| **WHEN** | 有效的启动条件、何时不应使用、前序/后续命令 |
| **WHERE** | 输入文件、输出文件、方法引用、相关流程文档 |
| **WHY** | 开发者价值、CaTDD 方法理由、如何减少歧义 |
| **HOW** | 执行流程——读取什么、保留什么、执行什么、报告什么 |
| **Input Contract** | 使用可移植占位符的命令参数 |
| **Output Contract** | 期望的响应格式——摘要、涉及的文件、下一步命令 |
| **CodeAgent Compatibility** | 纯 Markdown，无工具特定假设 |

这种一致性意味着每个 CodeAgent（Copilot、Cline、Continue、utCodeAgentCLI）都能使用相同的结构来解析和执行任何 slash 命令。

---

## 四种命令流程

命令按四种流程组织，每种流程都有文档化的命令序列：

```
slashCommands/flows/
├── P0-FuncTestsFlow.md    ← UT 命令：功能测试设计
├── P1-DesignTestsFlow.md   ← UT 命令：设计导向测试
├── P2-QualityTestsFlow.md  ← UT 命令：质量导向测试
└── Px-SpecFlow.md          ← SPEC 命令：完整生命周期编排
```

SpecFlow 中的 `Px` 意为"跨优先级"——它并非像 P0/P1/P2 那样的测试类别优先级，而是一个编排各测试层的流程。

---

## P0 FuncTestsFlow —— 第一个需要学习的流程

P0 是最常见的入口点，因为它涵盖了功能测试设计——每个开发者首先需要的内容。流程图中的命令序列如下：

```
              现有 Demo 测试
                       │
                       ▼
          ┌─────────────────────────┐
          │ UT_convertDemoToTypical │
          └───────────┬─────────────┘
                      │
                      ▼
     接口/协议 ──→ UT_designTypicalSkeleton
                                       │
                                       ▼
                               Typical 骨架
                                       │
               ┌───────────────────────┼───────────────────────┐
               ▼                       ▼                       ▼
     UT_designEdgeSkeleton    UT_designMisuseSkeleton   UT_designFaultSkeleton
               │                       │                       │
               └───────────────────────┼───────────────────────┘
                                       ▼
                           P0 功能骨架集
                                       │
                                       ▼
                        UT_reviewFuncTestsSkeleton
                                       │
                                       ▼
                        UT_tellMeNextImplTest
                                       │
               ┌───────────────────────┘
               ▼
       UT_implTestCase ──→ UT_reviewImplTestCase
               │                       │
               └───────────────────────┘
                       (循环)
```

### 入口点

你可以从两个位置启动 P0 流程：

1. **现有 Demo 测试**：如果你有用以演练组件的 Demo/Example 代码，使用 `UT_convertDemoToTypical` 将核心行为提炼为 CaTDD Typical 骨架。这能保留已有的工作成果，而非从零开始。

2. **接口或协议**：如果你有 API 头文件或规格文档，使用 `UT_designTypicalSkeleton` 从接口契约出发设计 Typical 骨架。

### 逐命令详解

#### 选项 A：UT_convertDemoToTypical

**何时使用**：当你已有演示组件用法的 Demo 测试时。这些并非 CaTDD P3 Demo/Example 测试——它们是捕获核心工作流的原始输入素材。

**做什么**：读取 Demo 测试，提取核心行为模式，将其映射为 CaTDD Typical 类别格式，并写出带有 US/AC/TC 结构的 Typical 设计骨架。

**输出**：目标测试文件中的 CaTDD Typical 骨架，其中填充了 `@[US]`、`@[AC]`、`@[TC]` 标记和 OVERVIEW 区域。

**下一步命令**：`UT_designEdgeSkeleton`

#### 选项 B：UT_designTypicalSkeleton

**何时使用**：从接口或协议出发——没有现成的 Demo 代码时。

**做什么**：读取接口规格，分析 API 契约，识别核心正向路径场景，并以用户故事、验收标准和测试用例设计 Typical 骨架。

**输出**：具有完整 US/AC/TC 链的 Typical 设计骨架。

**下一步命令**：`UT_designEdgeSkeleton`

#### 步骤 3-5：UT_designEdgeSkeleton、UT_designMisuseSkeleton、UT_designFaultSkeleton

每个命令通过读取现有骨架（以保持一致性）、API 接口和对应类别的 method prompt，设计一个类别骨架。它们遵循 P0 顺序：Edge 在 Typical 之后，Misuse 在 Edge 之后，Fault 在 Misuse 之后。

**替代方案**：当你想一次性设计完整的功能测试集时，可使用 `UT_designFuncTestsSkeleton` 将全部四个 P0 骨架（Typical + Edge + Misuse + Fault）作为单一行为来设计。

**重要**：每个骨架在不同类别中引用相同的 US ID。例如，US-1 覆盖 Typical 场景，而同一个 US-1 也可能有 Misuse 场景（该能力在同一个用户故事中被错误使用时会怎样）。

#### 步骤 6：UT_reviewFuncTestsSkeleton

**何时使用**：所有 P0 骨架已设计但尚未实现时。

**做什么**：审查完整的 P0 功能骨架集，检查以下方面：
- 完备性：四种类别是否全部具备？
- 可追溯性：每个 TC 是否引用了 AC，每个 AC 是否引用了 US？
- 类别正确性：Misuse 场景是否被正确归类（没有误入 Edge）？
- 一致性：骨架命名、状态标记和格式是否遵循约定？
- 关卡就绪度：设计是否可进入 P0 实现阶段？

**输出**：包含每个质量维度 PASS/FAIL 以及具体待修复问题的审查报告。

**下一步命令**：若 PASS → `UT_tellMeNextImplTest`。若 FAIL → 回到对应的设计命令。

**重要**：永远不要跳过这个审查关卡。设计阶段发现的缺陷，其修复成本仅为后期实现阶段发现缺陷的十分之一。

#### 步骤 7：UT_tellMeNextImplTest

**何时使用**：准备开始实现——所有骨架已审查通过。

**做什么**：读取所有测试文件中的 TODO 跟踪区，评估 P0 默认顺序（Typical → Edge → Misuse → Fault），检查依赖关系（例如 TC-3 是否因能力 API 尚不存在而被阻塞？），并推荐下一个要实现的测试用例。

**输出**：下一个 TC 的名称、所在文件、类别、预估复杂度和所有依赖关系或阻塞因素。

#### 步骤 8：UT_implTestCase

**何时使用**：已选定一个具体的 TC 准备实现时。

**做什么**：遵循严格的 TDD 循环实现一个测试用例：
1. 编写测试实现（四阶段：SETUP/BEHAVIOR/VERIFY/CLEANUP）
2. 在 TODO 区域将其标记为 🔴 RED
3. 运行测试——确认 RED（因缺少产品代码而失败）
4. 实现最小量产品代码
5. 运行测试——确认 GREEN（通过）
6. 在 TODO 区域将其标记为 🟢 GREEN
7. 使用实现说明更新 TC 规格

**输出**：一个已实现的测试用例，包含 RED→GREEN 历史记录和更新后的状态标记。

**下一步命令**：`UT_reviewImplTestCase`

#### 步骤 9：UT_reviewImplTestCase

**做什么**：审查以下实现方面：
- 正确性：测试是否确实验证了它声称要验证的 AC？
- 结构：是否遵循四阶段模式？
- 断言：是否有 ≤3 个关键断言且具有实质意义？
- 可追溯性：US/AC/TC 链是否得到保留？
- 隔离性：清理是否执行并防止状态泄漏？
- 状态：标记是否正确设置？

**输出**：包含 PASS/FAIL 的审查报告。若 PASS，循环回到 `UT_tellMeNextImplTest` 获取下一个 TC。若 FAIL，返回修复。

---

## Slash 命令中的 RED→GREEN 纪律

`UT_implTestCase` 命令强制执行严格的 TDD 纪律。详细过程如下：

### RED 阶段

```
1. 读取 TC 规格（评论即设计）
2. 按四阶段模式编写测试函数
3. 在测试函数上方添加 @[Name] 和 @[Steps] 注释
4. 更新 TODO 跟踪区：⚪ → 🔴 RED/FAILING
5. 编译并运行——验证测试失败
6. 如果测试通过：进行调查，可能是以下原因之一：
   a) 测试编写不当（未测试正确的内容）
   b) 功能已存在（先写了产品代码——违反 TDD！）
   c) 测试框架配置有误
7. 报告："RED 确认。测试按预期失败，因为 [原因]。
   准备实现产品代码。"
```

### GREEN 阶段

```
1. 阅读测试代码，理解需要哪些产品代码
2. 编写最小量产品代码——仅足以让此测试通过
3. 不要实现未经测试的功能，也不要过度设计
4. 编译并运行——验证测试通过
5. 更新 TODO 跟踪区：🔴 → 🟢 GREEN/PASSED
6. 运行整个测试文件——验证无回归
7. 提交变更
8. 报告："GREEN 确认。测试通过。P0 中剩余 [N] 个测试。"
```

### "最小量产品代码"规则

这是关键原则。当 `UT_implTestCase` 处于 GREEN 阶段时，它必须实现**仅足以让当前测试通过的产品代码**。一行都不多。这防止了：

- 死代码：编写了但从未被测试的代码
- 过度设计：实现了没有任何测试要求的功能
- 虚假信心：测试因额外代码意外满足而通过
- 可追溯性丢失：产品代码缺少对应的 TC

---

## P1-DesignTestsFlow 和 P2-QualityTestsFlow

P1 和 P2 流程遵循与 P0 相同的结构，但针对各自的类别。然而，它们有一个 P0 不具备的关键约束：**设计源关卡（Design Source Gate）**。

### 设计源关卡

P1 和 P2 命令在开始起草任何骨架之前，需要有已确认的设计源。这防止了在架构决策缺失的情况下设计测试：

| 优先级 | 类别 | 必需的设计源 |
|---|---|---|
| P1 | State | `README_StateDesign.md` 或 `README_ArchDesign.md` 中的 `State Design` 章节 |
| P1 | Capability | `README_DetailDesign.md` |
| P1 | Concurrency | `README_ResourceDesign.md` |
| P2 | Performance | `README_PerfDesign.md` |
| P2 | Robust | `README_ErrorDesign.md` |
| P2 | Compatibility | `README_CompatDesign.md` |
| P2 | Configuration | `README_DetailDesign.md` |

如果缺少必需的设计源，命令会在起草骨架前**发出警告并停止**。它会询问开发者："状态架构设计在哪里？我在设计状态测试之前需要它。"这个关卡贯彻了一个原则：P1 和 P2 测试验证的是**架构决策**，而不仅是 API 行为。

### P1-DesignTestsFlow

处理架构验证：State、Capability 和 Concurrency。

```
P0 功能骨架（已完成）
         │
    ┌────┼────┐
    ▼    ▼    ▼
UT_designStateSkeleton  UT_designCapabilitySkeleton  UT_designConcurrencySkeleton
    │         │                    │
    └────┬────┘                    │
         ▼                         │
 UT_reviewDesignTestsSkeleton ←────┘
         │
         ▼
 UT_tellMeNextImplTest → UT_implTestCase → UT_reviewImplTestCase
```

**入口条件**：P0 功能骨架必须存在（尤其是 Typical 和 Edge）。每个 P1 类别都需要已确认的设计源。P1 在骨架起草开始之前必须有 DESIGN。

**关卡 P1**：进入 P1 前，所有 P0 测试必须为 GREEN。离开 P1 前，架构必须经过验证（无死锁、无竞态条件、ThreadSanitizer 干净）。

### P2-QualityTestsFlow

处理非功能质量属性：Performance、Robust、Compatibility、Configuration。

```
P0/P1 稳定覆盖（已完成）
         │
    ┌────┼────┬────┐
    ▼    ▼    ▼    ▼
UT_designPerformanceSkeleton  UT_designRobustSkeleton  UT_designCompatibilitySkeleton  UT_designConfigurationSkeleton
    │         │                    │                              │
    └────┬────┘                    │                              │
         ▼                         │                              │
 UT_reviewQualityTestsSkeleton ←───┘──────────────────────────────┘
         │
         ▼
 UT_tellMeNextImplTest → UT_implTestCase → UT_reviewImplTestCase
```

**入口条件**：P0 功能覆盖存在，相关的 P1 设计覆盖存在，且每个 P2 类别都有已确认的项目根设计源。

**关卡 P2**：进入 P2 前，P1 必须完成。离开 P2 前，质量 SLO 必须满足，生产就绪标准必须达标。

---

## Px-SpecFlow —— 主编排流程

Px-SpecFlow 是最大、最重要的流程，因为它编排完整的 SpecCoding 生命周期。UT 流程执行测试相关的具体步骤，而 SPEC 命令则管理从导入到关闭整个故事生命周期。

### SpecFlow 生命周期

```
pendingNews → todoUS → doingUS → doneUS
                         ↘ abortUS（针对不应继续的活跃故事）
```

每个工作项通常经历四个阶段，其中 `abortUS` 用于保留不应继续进行的活跃故事：

| 阶段 | 目录 | 含义 |
|---|---|---|
| **pendingNews** | `.catdd/spec/pendingNews/` | 等待分析的工作。原始 Issue、功能请求、导入的用户故事。 |
| **todoUS** | `.catdd/spec/todoUS/` | 已分析、可领取的工作。结构化用户故事及候选验收标准。 |
| **doingUS** | `.catdd/spec/doingUS/` | 正在进行中的活跃工作。处于设计、测试或实现阶段的已开启用户故事。 |
| **abortUS** | `.catdd/spec/abortUS/` | 已中止的活跃工作，保留以供后续分析或作为下一轮改进的输入。 |
| **doneUS** | `.catdd/spec/doneUS/` | 已完成的工作。经审查、已提交、CI 通过的故事。 |

### 完整命令序列

完整的 SpecFlow 生命周期包含 21+ 个命令，分为三个阶段：

#### 阶段 A：故事前（输入和分析）

```
1. SPEC_initProjectContext
   创建 .catdd/spec/projectContext.md —— 共享的项目宪章

2. SPEC_importIssue / SPEC_importFeature
   将工作输入导入 pendingNews/

3. SPEC_importUserStory
   将已结构化的用户故事直接排入 todoUS/（跳过分析）

4. SPEC_analyzeIssue / SPEC_analyzeFeature
   将待处理输入转化为 todoUS/ 中的可追溯用户故事
   将原始输入从 pendingNews/ 移至 analyzedNews/ 以便追溯

5. SPEC_openUserStory
   将选定的故事从 todoUS/ 移至 doingUS/（工作开始）
```

#### 阶段 B：设计与规划

```
6. SPEC_clearStoryIntent（可选但推荐）
   在设计前对齐开发者意图与 CodeAgent 意图
   记录双向意图契约（Mutual Intent Contract）：范围、非目标、成功信号、假设

7. SPEC_makePlan
   在 doingUS/ 中创建配对任务工作制品（*-TASKs.md）
   将工作分类为：意图澄清类、需求导向类、设计导向类或实现导向类
   决定下一步执行哪个 SPEC_* 步骤

   ┌─ 若为需求导向 ────────────────────────────────┐
   │ 8.  SPEC_updateUserStory                            │
   │     更新模块 README_UserStory.md 和 README_UserGuide.md
   │ 9.  SPEC_reviewUserStory                            │
   │     审查需求质量                                      │
   │     若 PASS：SPEC_commitWorks → SPEC_closeUserStory  │
   │     或转入设计导向的下一步骤                          │
   └─────────────────────────────────────────────────────┘

   ┌─ 若为设计导向（初始架构） ─────────────────────┐
   │ 10. SPEC_takeArchDesign                              │
   │     产出 README_ArchDesign.md                         │
   │ 11. SPEC_reviewArchDesign                            │
   │     在进入详细设计前把关架构质量                       │
   │ 12. SPEC_updateArchDesign（若审查未通过）             │
   └─────────────────────────────────────────────────────┘

   ┌─ 若为设计导向（初始详细设计） ─────────────────┐
   │ 13. SPEC_takeDetailDesign                            │
   │     产出 README_DetailDesign.md 和 AC                │
   │ 14. SPEC_reviewDetailDesign                          │
   │     把关详细设计质量                                   │
   │ 15. SPEC_updateDetailDesign（若审查未通过）           │
   └─────────────────────────────────────────────────────┘
```

#### 阶段 C：实现与关闭

```
   ┌─ 若为实现导向 ──────────────────────────────────┐
   │ 16. SPEC_designUnitTests                             │
   │     经 P0/P1/P2 流程进入 CaTDD 测试设计              │
   │ 17. SPEC_implUnitTests                               │
   │     实现选定的 TC（RED→GREEN）                       │
   │ 18. SPEC_implProductCodes                            │
   │     实现产品代码以使测试通过                           │
   │ 19. SPEC_reviewProductCodes                          │
   │     审查实现质量                                      │
   │                                                       │
   │     若审查 FAIL：                                     │
   │ 20. SPEC_abortUserStory（当继续推进不安全时）         │
   │     将活跃故事移至 abortUS 以供后续分析               │
   └─────────────────────────────────────────────────────┘

21. SPEC_commitWorks
    准备并提交已完成的工作

22. SPEC_closeUserStory
    将已审查、已提交的故事从 doingUS/ 移至 doneUS/
    将配对的 TASKs 工作制品从 doingUS/ 移至 doneUS/
```

### 流程图：完整生命周期

```
                    SPEC_initProjectContext
                    SPEC_updateProjectContext
                            │
                            ▼
                  .catdd/spec/projectContext.md
                            │
              ┌─────────────┼─────────────┐
              ▼             ▼             ▼
     SPEC_importIssue  SPEC_importFeature  SPEC_importUserStory
              │             │                     │
              ▼             ▼                     │
      pendingNews/*.md  pendingNews/*.md           │
              │             │                     │
              ▼             ▼                     │
     SPEC_analyzeIssue  SPEC_analyzeFeature        │
              │             │                     │
              └──────┬──────┘                     │
                     ▼                            ▼
              todoUS/*-UserStory.md
                     │
                     ▼
              SPEC_openUserStory
                     │
                     ▼
              doingUS/*-UserStory.md
                     │
                     ▼
              SPEC_clearStoryIntent（对齐意图）
                     │
                     ▼
              SPEC_makePlan（创建任务工作制品）
                     │
         ┌───────────┼───────────┐
         ▼           ▼           ▼
    需求导向     设计导向     实现导向
         │           │           │
         ▼           ▼           ▼
    updateStory  takeDesign  designTests
    reviewStory  reviewDesign implTests
         │           │       implCode
         ▼           ▼       reviewCode
    commitWorks  commitWorks commitWorks
    closeStory   closeStory  closeStory
         │           │           │
         └───────────┼───────────┘
                     ▼
              doneUS/*-UserStory.md
```

### 关键 SpecFlow 命令详解

#### SPEC_initProjectContext

**目的**：创建项目的共享宪章——每个后续 SPEC 命令都会引用的事实、约束、约定和决策。

**记录内容**：
- 项目事实：仓库、所有者、主要目的
- 层次模型：methodPrompts → slashCommands → codeAgents → agentSkills
- 已安装的项目表面：`.catdd/` 目录结构
- 稳定约定：文档拆分规则、中英文镜像规则、方法语义边界
- 当前设计决策：P0/P1/P2 类别列表、设计骨架命名规则
- 验证命令：用于验证文档和打包完整性的脚本

**输出**：`.catdd/spec/projectContext.md`

**为什么重要**：没有项目上下文，每次 CodeAgent 会话都从零开始。有了项目上下文，agent 只需读取一个文件就能了解项目的规则、约定和当前状态。

#### SPEC_analyzeIssue

**目的**：将原始 Issue 或功能请求转化为可追溯的用户故事。

**做什么**：
1. 从 `pendingNews/` 读取待处理的 Issue/Feature 文件
2. 结合项目上下文和已有故事对输入进行分析
3. 在 `todoUS/` 中生成结构化用户故事，包含：
   - 角色、能力、价值（US 格式）
   - 候选验收标准
   - 风险评估
   - 给开发者的待定问题
4. 将原始输入移至 `analyzedNews/` 以便追溯
5. 不凭空捏造产品意图——将不明确的方面作为待定问题保留

**输出**：`todoUS/` 中的用户故事文件和 `analyzedNews/` 中的归档原始输入。

**CoT 模式**：ReACT（推理 + 行动）——命令必须检查当前状态、决定提取什么、通过编写故事采取行动，并迭代地观察结果。

#### SPEC_makePlan

**目的**：为已开启的用户故事创建执行计划。

**做什么**：
1. 读取 `doingUS/` 中的活跃故事
2. 将工作分类为以下之一：
   - **意图澄清类**：开发者与 CodeAgent 的意图尚未对齐
   - **需求导向类**：需要更新需求文档
   - **设计导向类**：需要架构或详细设计（初始或跟进）
   - **实现导向类**：可进入测试设计和代码实现
3. 创建包含 Markdown 复选框任务的 `*-TASKs.md` 文件
4. 根据分类决定下一个 SPEC 命令

**输出**：`doingUS/YYYYMMDD-TASKs.md` 中的任务工作制品。

**为什么重要**：这是防止过早设计和实现的规划步骤。没有它，团队往往直接跳到编码，而他们本应对齐意图或先设计架构。

#### SPEC_clearStoryIntent

**目的**：在开始设计之前，对齐开发者对故事的理解与 CodeAgent 的理解。

**记录内容**（"双向意图契约"）：
- 开发者意图：开发者认为此故事是关于什么的
- CodeAgent 意图：agent 从阅读故事中推断出的内容
- 范围内工作：包含什么
- 范围外工作：明确排除什么
- 成功信号：我们如何知道故事已完成
- 假设条件：我们当前假设但尚未确认的内容
- 待定问题：需要开发者回答的问题

**为什么重要**：如果意图不清，agent 可能会针对错误的范围或成功信号进行优化。一个解决了错误问题的昂贵架构设计，比完全没有设计更糟糕。

#### SPEC_takeArchDesign 和 SPEC_takeDetailDesign

**目的**：在两个抽象层次上产出设计工作制品。

**架构设计** (`SPEC_takeArchDesign`)：
- 高层模块分解
- 依赖方向和数据流
- 运行时部署与关键权衡
- 创建 `README_ArchDesign.md` 和其他架构导向的 SPEC 文档

**详细设计** (`SPEC_takeDetailDesign`)：
- 类级 API 签名和数据结构
- 状态机和生命周期转换
- 活跃故事的验收标准
- 创建 `README_DetailDesign.md` 和其他详细设计导向的 SPEC 文档

**模型层级**：这两类命令的初始设计需要 SOTA 推理能力（决定边界、权衡、约束）。跟进修订（`SPEC_updateArchDesign`、`SPEC_updateDetailDesign`）可使用 High Performance 模型。

**重要**：`SPEC_take*Design` 用于**初始**设计工作。`SPEC_update*Design` 针对现有设计证据、审查反馈或故事级设计差距的**跟进**修订。不要混用。

#### SPEC_reviewArchDesign 和 SPEC_reviewDetailDesign

**目的**：在下游生命周期步骤之前把关设计质量。

**检查内容**：
- 完备性：所有必要的设计方面是否都已覆盖？
- 可追溯性：设计是否与需求关联？
- 一致性：是否存在内部矛盾？
- 可行性：在给定约束下设计是否可实现？
- 清晰性：开发者阅读后能否正确实现？

**关键规则**：每个产生设计的步骤（`SPEC_take*Design`、`SPEC_update*Design`）必须在下游生命周期步骤之前经过其审查关卡的把关。永远不要跳过审查。

#### SPEC_designUnitTests

**目的**：进入 CaTDD 测试设计模式，通常经 P0/P1/P2 流程进行。

**做什么**：
1. 确定测试方法（默认：CaTDD）
2. 根据故事和设计确定需要哪些测试类别
3. 路由到对应的 UT 流程命令
4. 可能会调用 `UT_designTypicalSkeleton`、`UT_designEdgeSkeleton` 等

**测试方法默认值**：CaTDD 是 SpecFlow 中默认的单元测试方法。当项目明确要求时，也可以使用典型 TDD 或其他项目特定的方法。

#### SPEC_commitWorks

**目的**：准备并提交已完成的工作，附带可追溯的提交信息。

**做什么**：
1. 审查变更内容：测试文件、产品代码、设计文档、Spec 工作制品
2. 按故事/关注点对变更进行分组
3. 起草引用 US ID 的提交信息
4. 以适当范围提交
5. 不执行 push——推送是开发者独立的操作

#### SPEC_closeUserStory

**目的**：将已完成的工作移至 done 归档。

**做什么**：
1. 验证故事确实已完成（审查、测试、提交均已完成）
2. 将故事从 `doingUS/` 移至 `doneUS/`
3. 将配对的 TASKs 工作制品一并移入
4. 记录关闭日期和所有经验教训
5. 不关闭未经审查和提交的故事

---

## 命令的模型层级指引

Px-SpecFlow 提供了明确的模型层级指引——使用能够保持决策质量的最小模型：

| 层级 | 用途 | SPEC 命令 |
|---|---|---|
| **SOTA reasoning** | 架构决策、系统边界、质量权衡、不可逆选择 | `SPEC_takeArchDesign`、`SPEC_reviewArchDesign` |
| **High Performance** | 多工作制品推理、设计、审查、规划 | `SPEC_initProjectContext`、`SPEC_analyzeIssue`、`SPEC_analyzeUserStory`、`SPEC_makePlan`、`SPEC_takeDetailDesign`、`SPEC_reviewDetailDesign`、`SPEC_designUnitTests`、`SPEC_reviewProductCodes` |
| **Flash Speed** | 确定性工作制品移动、导入、提交、关闭 | `SPEC_importIssue`、`SPEC_openUserStory`、`SPEC_abortUserStory`、`SPEC_implUnitTests`、`SPEC_implProductCodes`、`SPEC_commitWorks`、`SPEC_closeUserStory` |

**升级规则**：当命令暴露出架构层面显著的不确定性时，从较低层级升级到较高层级：竞争性非功能需求、安全/保密风险、实时约束、并发边界或不可逆的 API 决策。

---

## 命令中的思维链模式

SPEC 命令使用三种 CoT 推理模式，根据命令的决策复杂度进行选择：

### ReACT（推理 + 行动）

用于必须检查当前生命周期状态、决定做什么、采取行动并迭代地观察结果的命令。适用于分析、设计和审查命令。

**执行循环**：
1. **思考（Thought）**：检查输入工作制品。识别当前状态、缺口和冲突。
2. **行动（Action）**：创建、更新、审查或移动命名的工作制品。
3. **观察（Observation）**：验证输出是否满足契约。检查遗漏的可追溯性、未解决的问题、质量失败。
4. 如果观察发现质量问题，将其作为问题或假设提出并停止。

**适用命令**：`SPEC_analyzeIssue`、`SPEC_makePlan`、`SPEC_reviewArchDesign`、`SPEC_reviewDetailDesign`、`SPEC_reviewProductCodes`

### ToT（思维树）

用于命令必须生成多个候选方案、根据质量标准评估每个方案并选择最佳方案的场景。

**执行循环**：
1. **生成（Generate）**：生成 2 个以上候选方案或工作制品大纲。
2. **评估（Evaluate）**：根据质量标准评估每个方案。
3. **选择（Select）**：选择最佳方案。如果没有明显最优的方案，向开发者呈现选项。
4. **执行（Execute）**：应用选定的方案产出工作制品。
5. **验证（Verify）**：确认输出满足契约。

**适用命令**：`SPEC_takeArchDesign`（比较架构替代方案）、`SPEC_clearStoryIntent`（评估不同范围）

### Linear（直接执行）

用于当给定完整且有效的输入时，命令的动作是确定性的。

**执行循环**：
1. 读取输入和方法引用。
2. 保留现有的可追溯性、状态标记和约定。
3. 仅执行此命令所请求的步骤。
4. 报告产出的工作制品和下一个推荐命令。

**适用命令**：`SPEC_importIssue`、`SPEC_openUserStory`、`SPEC_commitWorks`、`SPEC_closeUserStory`

---

## SpecFlow 工作制品

SpecFlow 创建并维护一组可追溯的工作制品：

### 生命周期工作制品（位于 `.catdd/spec/` 下）

| 工作制品 | 用途 | Git 策略 |
|---|---|---|
| `projectContext.md` | 共享项目宪章 | 提交——团队成员和 agent 需要相同事实 |
| `pendingNews/*.md` | 已导入、等待分析的工作 | 提交——团队可见性 |
| `analyzedNews/*.md` | 分析后归档的原始输入 | 提交——保留可追溯性 |
| `todoUS/*-UserStory.md` | 已分析、可领取的故事 | 提交——团队待办列表 |
| `doingUS/*-UserStory.md` | 正在进行中的活跃故事 | 提交——跨机器可见性 |
| `doingUS/*-TASKs.md` | 活跃任务计划，含复选框任务 | 提交——显式、可检查的步骤 |
| `doneUS/*-UserStory.md` | 已完成、已审查、已提交的故事 | 提交——项目历史 |
| `doneUS/*-TASKs.md` | 已完成的任务工作制品 | 提交——后续诊断 |
| `WorkingProcessLog.md` | 本地工作状态跟踪 | Gitignore——个人的，非团队共享 |

### 项目根 SPEC 文档

| 文件 | 用途 | 管理者 |
|---|---|---|
| `README.md` | 项目概览、所有权、主目录 | 其他 SPEC 步骤 |
| `README_ArchDesign.md` | 高层架构、模块、依赖关系 | `SPEC_takeArchDesign` |
| `README_DetailDesign.md` | 类设计、API 签名、数据结构 | `SPEC_takeDetailDesign` |
| `README_UserStories.md` | 项目范围用户故事、追溯链接 | 其他 SPEC 步骤 |
| `README_UserGuide.md` | 面向用户的运行时使用指南 | 其他 SPEC 步骤 |
| `README_VerifyDesign.md` | 验证拓扑、测试策略、US/AC/TC 可追溯性 | SpecFlow + UT 流程 |
| `README_ErrorDesign.md` | 容错架构、故障安全状态 | `SPEC_takeArchDesign` |
| `README_ResourceDesign.md` | 资源分配、内存/CPU 预算 | `SPEC_takeArchDesign` |
| `README_StateDesign.md` | 状态机、生命周期转换 | `SPEC_takeDetailDesign` |
| `README_PerfDesign.md` | 性能预算、延迟限制 | `SPEC_takeArchDesign` |
| `README_CompatDesign.md` | 兼容性矩阵、平台/工具链版本 | `SPEC_takeArchDesign` |
| `README_DiagnosisDesign.md` | 可观测性、日志、遥测、诊断 | `SPEC_takeArchDesign` |
| `README_UsageDesign.md` | 公共边界、CLI/API 契约 | `SPEC_takeArchDesign` |

仅当项目需要该表面时才创建项目根 SPEC 文档。首次创建时，使用 `slashCommands/templates/` 中的模板。

---

## 命令模板即契约

每个 slash 命令都是开发者与 CodeAgent 之间的**契约**。开发者调用命令（表明意图）。CodeAgent 执行契约（忠实地应用方法规则）。该契约包含：

1. **前置条件**：调用前必须存在的输入（例如 API 头文件、已有骨架、项目上下文）
2. **动作**：命令执行的单一步骤（不是"设计、实现和审查"——只选其一）
3. **后置条件**：执行后必须存在的输出（例如设计好的骨架、已实现的测试、审查报告）
4. **不变量**：必须保留的内容（CaTDD 评论骨架、US/AC/TC 可追溯性、类别标签、状态标记）
5. **下一步**：接下来应该执行什么命令（永远不要让 CodeAgent 猜测）

这种契约结构正是 slash 命令可重复的原因。每次调用 `UT_designTypicalSkeleton` 都会产出一个 CaTDD Typical 骨架，无论由哪个 CodeAgent 执行，因为契约精确定义了输出。

---

## 冲突保护规则

Px-SpecFlow 定义了严格的冲突保护规则，防止各层违反彼此的边界：

1. **Px-SpecFlow 仅定义生命周期编排；CaTDD 方法语义保留在 methodPrompts 中。**
2. **SPEC 命令可以调用 UT 命令，但不得替换 P0/P1/P2 类别规则。**
3. **在需求导向工作中，SPEC_updateUserStory 之后不得跳过 SPEC_reviewUserStory。**
4. **当活跃故事的开发者意图和 CodeAgent 意图尚未对齐时，不得开始设计。**
5. **在 SPEC_makePlan 之后，SPEC_take*Design 仅用于初始设计工作，SPEC_update*Design 仅用于跟进设计修订。**
6. **每个产生设计的步骤必须在下游生命周期步骤之前经过其审查关卡的把关。**
7. **如果产品意图不明确，保持用户故事开放并询问开发者，而不是凭空捏造需求。**

---

## 实践中的命令调用

Slash 命令根据不同的 CodeAgent 以不同方式调用：

### 在 Copilot Chat 中

```
/UT_designTypicalSkeleton
```

Copilot 提示词包装器（由 `scripts/makeSlashCmd4Copilot.sh` 生成）将可移植的 Markdown 命令适配为 Copilot 的提示词格式。开发者输入 slash 命令，Copilot 读取适配后的提示词，并执行契约。

### 在 Cline/Continue 中

直接读取命令提示词文件。开发者输入命令名称或从助手的命令面板中选择。

### 在 utCodeAgentCLI 中（未来）

```bash
utCodeAgentCLI --target myTestFile.ts --input spec/IOC.h --behave designTypicalSkeleton
```

CLI 将 `--behave` 的值映射到 slash 命令行为。别名如 `reviewFuncTestsSkeleton` 和 `tellMeNextImplTest` 会解析为其完整的 UT 命令名称。

### 可移植占位符

命令文件使用适配器填充的可移植占位符：

- `{{feature_name}}` —— 被测试功能/模块的名称
- `{{category}}` —— CaTDD 类别（Typical、Edge 等）
- `{{source_files}}` —— API 头文件或规格文档
- `{{test_files}}` —— 要读取和扩展的已有测试文件
- `{{language}}` —— 目标编程语言
- `{{test_framework}}` —— 使用的测试框架
- `{{developer_goal}}` —— 未在工作制品中体现的开发者意图

---

## 何时使用哪个流程

| 起点 | 使用流程 |
|---|---|
| 新组件，无现有测试 | P0-FuncTestsFlow → `UT_designTypicalSkeleton` |
| 现成的 Demo 代码 | P0-FuncTestsFlow → `UT_convertDemoToTypical` |
| 完整功能测试设计 | P0-FuncTestsFlow → `UT_designFuncTestsSkeleton` |
| 需要架构验证 | P1-DesignTestsFlow（在 P0 完成后） |
| 需要性能/容量数据 | P2-QualityTestsFlow（在 P0/P1 完成后） |
| 来自产品团队的新功能请求 | Px-SpecFlow → `SPEC_importFeature` → `SPEC_analyzeFeature` |
| 来自 QA 的 Bug 报告 | Px-SpecFlow → `SPEC_importIssue` → `SPEC_analyzeIssue` |
| 已有用户故事 | Px-SpecFlow → `SPEC_importUserStory` → `SPEC_openUserStory` |
| 恢复暂停的工作 | Px-SpecFlow → `SPEC_whatsNextTask`（读取当前状态并推荐下一步） |
| 需要架构决策 | Px-SpecFlow → `SPEC_takeArchDesign` |
| 设计完成后准备编码 | Px-SpecFlow → `SPEC_designUnitTests` → P0/P1/P2 流程 |

---

## 子 Agent 模式

某些 SPEC 命令支持通过子 agent 进行后台委托。当某个命令适合在对话过程中委托执行时：

- **何时委托**：当其他工作正在进行时出现新 Issue
- **捕获内容**：源文本或 URL 及相关的项目上下文
- **期望返回**：输出文件名（例如 `todoUS/` 中的新故事）
- **调用方行为**：主对话继续，无需等待

适合子 agent 委托的命令：`SPEC_importIssue`、`SPEC_importFeature`、`SPEC_analyzeIssue`、`SPEC_analyzeFeature`。

必须同步执行的命令：`SPEC_takeArchDesign`（输出需要立即用于审查）、`SPEC_makePlan`（决定下一步）、`SPEC_commitWorks`（必须与开发者的工作空间同步）。

---

## 从命令到自动化

Slash 命令是 VibeCoding 对话式灵活性与 CodeAgent 自动化之间的桥梁。当开发者调用 `/UT_implTestCase` 时，CodeAgent 读取命令契约，应用 CaTDD 方法，并产生结构化输出。当开发者调用 `/SPEC_analyzeIssue` 时，CodeAgent 读取原始 Issue，将其转化为用户故事，并使其在生命周期中流转。

下一章 **asyncCodeAgent** 将更进一步：CaTDD 原生代码 agent 不再等待开发者逐个调用命令，而是自主规划、执行、收集追踪并反思——将整个循环从目标到经过验证的实现完全自动化。
