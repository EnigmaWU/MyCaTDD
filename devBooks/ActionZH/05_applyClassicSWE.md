# 05 applyClassicSWE

## 软件工程知识手册

软件工程不是时髦框架的集合，而是持久的、历经沧桑的知识体系——那些历经数十年仍被证明是构建复杂系统之真理的原则、实践与模式。软件工程知识手册包括：

| 学科 | 核心问题 | 标志性实践 |
|---|---|---|
| **TDD** — 测试驱动开发 | 如何证明代码能正常工作？ | 先写失败测试，实现使其通过，重构 |
| **BDD** — 行为驱动开发 | 如何将需求与代码连接起来？ | GIVEN/WHEN/THEN 规格说明，可执行规格 |
| **DDD** — 领域驱动设计 | 如何对复杂业务领域建模？ | 统一语言 (Ubiquitous Language)、限界上下文 (Bounded Context)、聚合 (Aggregate)、实体 (Entity) |

这三门学科构成一个三角：TDD 验证行为，BDD 规格化行为，DDD 建模行为。三者共同回答了软件的全生命周期：构建什么（BDD）、如何建模（DDD）、以及如何证明它能正常工作（TDD）。

---

## LLM 时代改变了一切——也什么都没改变

大语言模型已经改变了我们编写代码的方式。但它们并没有改变什么构成好的软件：

- **正确性**依然重要——LLM 能够生成看起来合理但暗藏错误的代码
- **可追溯性**依然重要——谁提出了这个功能需求？我们如何知道它已完成？
- **可维护性**依然重要——只有 LLM 能读懂的代码是不可维护的
- **领域理解**依然重要——除非你告诉 LLM，否则它不知道你的业务规则

LLM 是代码生成的力量倍增器。但如果没有结构，将混乱放大只会产生更多的混乱。经典的 SWE 学科——TDD、BDD、DDD——提供了防止 LLM 驱动开发沦为 LLM 驱动混乱所需的结构。

CaTDD 恰恰诞生于这个交叉点：**它将软件工程知识手册转化为 LLM 可读的、注释鲜活的验证设计。** 它不取代 TDD、BDD 或 DDD，而是为 LLM 时代将它们融合为一体。

---

## LLM 时代的 TDD

### 经典 TDD：基石

测试驱动开发由 Kent Beck 正式提出，有三条定律：

1. 在编写生产代码之前，先写一个失败的测试
2. 只写刚好足够失败的测试
3. 只写刚好足够通过的生产代码

Red→Green→Refactor 循环是 TDD 的心跳：

```
RED:    编写测试 → 测试失败（功能尚不存在）
GREEN:  编写最小化的生产代码 → 测试通过
REFACTOR: 在测试保持绿色的前提下，改进代码和测试结构
```

TDD 不是关于测试的，而是关于**设计**的。测试优先的纪律迫使你在实现之前思考接口、行为和契约。测试是你 API 的第一个客户。

### TDD 在 LLM 之前的结构性局限

经典 TDD 有两个结构性缺口：

1. **没有设计制品**：测试即是设计。但测试展示的是要验证**什么**，而非验证为何重要。业务意图——谁要求这个功能，它提供什么价值——隐含在开发者的脑海中，而不是在测试文件中显式地表达出来。

2. **手动工作量的上限**：逐个编写测试是严谨的，但也是缓慢的。每个测试都必须由人工构思、编写、调试和验证。可能的测试场景总数总是超过可用于编写它们的时间。

### CaTDD：针对 LLM 时代增强的 TDD

CaTDD 通过将**设计意图**和**LLM 可读性**嵌入 TDD 循环来解决这两个缺口：

| 经典 TDD | CaTDD 增强 |
|---|---|
| 测试即是设计 | 注释骨架**即**设计——US/AC/TC 结构使业务意图显式化 |
| 测试什么内容是隐式的 | 优先级框架（P0→P3）使覆盖策略显式化 |
| RED→GREEN→REFACTOR | ⚪TODO→🔴RED→🟢GREEN，各优先级等级之间设有质量关卡 |
| 逐个手动编写测试 | LLM 读取设计骨架，生成测试代码，实现最小化生产代码 |
| 重构是临时进行的 | TC 逐条审查，因审查关卡失败触发重构 |
| 测试是代码制品 | 测试是鲜活的设计文档——注释随代码演进 |

LLM 并不只是更快地编写测试。它编写的是**可追溯到设计意图**的测试，因为设计意图被嵌入在 LLM 读取的同一个文件中。

### CaTDD 的 TDD 循环（配合 LLM）

```
1. DESIGN: 编写注释骨架 (US/AC/TC)——这就是设计
2. TC SELECTION: LLM 读取骨架，按优先级选择下一个 TC
3. RED: LLM 为 TC 生成测试代码 → 标记 ⚪→🔴 → 测试失败
4. GREEN: LLM 生成最小化生产代码 → 测试通过 → 标记 🔴→🟢
5. REVIEW: LLM 对照设计契约审查实现
6. REPEAT: 推进到下一个 TC
7. GATE: 在 P0/P1/P2 各关卡处停止，验证标准，请求开发者审批
```

步骤 3-5 在紧凑的 LLM 循环中进行。步骤 1、2、6、7 是人类判断发挥作用的节点。LLM 处理机械的 TDD 工作，开发者处理设计判断。

### 为什么 TDD 在 LLM 时代更重要

你可能会想："如果 LLM 能生成代码，为什么还要费心用 TDD？"答案是：

- **LLM 生成看起来合理的代码比生成正确的代码更快。** 没有失败的测试，LLM 就没有反馈。没有通过的测试，你就没有信心。
- **LLM 跨对话丢失上下文。** 测试文件**就是**上下文。CaTDD 注释骨架是代码应该做什么的持久记录，可被下一次 LLM 会话读取。
- **LLM 是乐观的生成器。** 它们假设自己生成的代码是正确的。TDD 强加了验证的纪律。每个 GREEN 测试都是 LLM 无法幻觉越过的检查点。

TDD 在 LLM 时代并非不那么重要，而是**更加**重要。它是防止 LLM 生成代码漂入"看似合理但错误"领域的接地线。

---

## LLM 时代的 BDD

### 经典 BDD：从需求到可执行规格

行为驱动开发由 Dan North 开创，弥合了业务利益相关者与开发者之间的鸿沟：

```
业务语言：      "作为客户，我想要取款，以便购买物品"
BDD 规格说明：   Scenario: 从账户取款
                Given 账户余额为 $100
                When 客户取款 $20
                Then 余额为 $80
自动化测试：    步骤定义将 Given/When/Then 映射到测试代码
```

BDD 的核心洞见是：**规格说明应该是可执行的**。GIVEN/WHEN/THEN 场景既是业务需求，也是自动化测试。当测试通过时，需求即被满足。当测试失败时，需求即被破坏。

### BDD 在 LLM 之前的结构性局限

经典 BDD 需要维护三个由人工编写的制品：

1. **Feature 文件**（Gherkin `.feature` 文件）——由产品负责人或业务分析师编写
2. **步骤定义**（将 Gherkin 步骤映射到测试操作的代码）——由开发者编写
3. **生产代码**（实现）——由开发者编写

跨越两种语言（Gherkin + 代码）的三个制品产生了维护摩擦。Feature 文件逐渐过期，步骤定义变得脆弱。"可执行规格"的愿景常常变成"曾经可执行的规格说明"。

### CaTDD：嵌入测试文件的 BDD

CaTDD 将 BDD 以结构化注释的形式直接嵌入到测试文件中，消除了 Gherkin 与代码之间的间隙：

```
经典 BDD:                              CaTDD BDD:

Feature: CashWithdrawal.feature        UT_Account.cxx:
                                       // US-1: As a customer,
  Scenario: Withdraw from account      //       I want to withdraw cash
    Given the account has $100         //       So that I can buy things.
    When the customer withdraws $20    //
    Then the balance is $80            // AC-1: GIVEN account has $100,
                                       //       WHEN customer withdraws $20,
步骤定义: CashWithdrawal.java           //       THEN balance is $80.
  @Given("account has $100")            //
  public void accountHas100() { ... }  // TC-1: verifyWithdraw_bySufficientBalance
                                       //       _expectReducedBalance
测试运行器: Cucumber/JBehave            TEST(Account, verifyWithdraw_
                                              bySufficientBalance_
                                              expectReducedBalance) { ... }
```

CaTDD 的 US/AC/TC 链**就是**BDD 规格，但它以注释的形式存在于测试文件中，而不是单独的 `.feature` 文件中。步骤定义和测试实现是同一个制品——TEST 函数。规格说明与验证之间的间隙不复存在。

### BDD 作为 CaTDD 的验收标准契约

每个 CaTDD 验收标准都遵循 BDD 格式：

```
AC-n: GIVEN [前置条件与上下文],
      WHEN [特定动作或事件],
      THEN [预期的可观察结果],
       AND [如有额外的结果].
```

这并非巧合——它是 BDD 的 GIVEN/WHEN/THEN 格式作为 CaTDD 中**规范的可测试条件**。创建一个鲜活的文档调和检查清单来验证 BDD 一致性。

### BDD 调和检查清单

建立自动化的调和测试，断言源代码、BDD 规格说明与外部文档之间的一致性：

- 强制每个 CaTDD AC 能映射到一个或多个 TC 实现（无孤立的验收标准，无未记录的测试用例）
- 验证 AC 描述与步骤特定的实现细节相区分——一个 TC 应验证一个 AC，而不是重复其他 AC 的步骤
- 生成清晰的 Markdown 报告，总结哪些 AC 已测试、哪些已规划、哪些已阻塞

### 为什么 BDD 在 LLM 时代更重要

LLM 是模式匹配器，而非业务分析师。它们能令人信服地生成 GIVEN/WHEN/THEN 结构，但无法判断 THEN 子句是否反映了真实的业务规则。配合 CaTDD 的 BDD 提供了护栏：

- **开发者编写 AC**——以 GIVEN/WHEN/THEN 表达的业务规则
- **LLM 生成 TC**——验证 AC 的具体测试
- **开发者审查 TC**——这个测试是否真正验证了 AC 所陈述的内容？
- **LLM 实现测试代码**——4阶段实现
- **测试通过**——AC 被满足

开发者拥有业务规则（AC），LLM 拥有验证机制（TC 与代码）。这种分工是为 LLM 时代优化的 BDD。

---

## LLM 时代的 DDD

### 经典 DDD：对复杂领域建模

领域驱动设计由 Eric Evans 提出，是一种在软件中对复杂业务领域进行建模的方法论。其核心概念包括：

**统一语言 (Ubiquitous Language)**——领域专家与开发者之间的共享语言，在代码、对话和文档中统一使用。如果业务方说"保单"，代码中就有 `Policy` 类，而不是 `InsuranceMathHelper`。

**限界上下文 (Bounded Context)**——模型在其中适用的一个边界。在计费系统中，"Account" 指支付账户，在 CRM 系统中，"Account" 指客户账户。每个限界上下文有其自己的模型。

**战略设计 (Strategic Design)**——限界上下文之间的关系：核心域 (Core Domain)（你的竞争优势）、支撑子域 (Supporting Subdomains)（必要但无差异化）、通用子域 (Generic Subdomains)（购买，不自行构建）。

**战术设计 (Tactical Design)**——限界上下文内的构建块：实体 (Entities)（身份重于属性）、值对象 (Value Objects)（属性重于身份）、聚合 (Aggregates)（一致性边界）、领域事件 (Domain Events)（某事发生了）、仓储 (Repositories)（获取聚合）、服务 (Services)（无状态操作）。

### DDD 在 LLM 之前的结构性局限

DDD 需要深厚的领域知识，这些知识难以传递给新团队成员：

- **统一语言是脆弱的**——一个开发者使用 `Customer`，另一个使用 `Client`，第三个对同一概念使用 `Account`。模型变得支离破碎。
- **限界上下文是隐式的**——它们存在于架构师的脑海和白板绘图上，而不是代码中或 LLM 的训练数据中。
- **模型演进是缓慢的**——重构领域模型需要更新文档、测试、生产代码和团队理解——全部手动进行。

### CaTDD：作为 LLM 可读领域模型的 DDD

CaTDD 通过以下几种机制将 DDD 概念带入 LLM 时代：

#### 1. OVERVIEW 部分作为限界上下文声明

每个 CaTDD 测试文件都以一个声明其限界上下文的 OVERVIEW 开头：

```cpp
/**
 * [WHAT] This file verifies event queue behavior
 * [WHERE] in the IOC Event Subsystem module
 * [WHY] to ensure reliable asynchronous event delivery
 *
 * SCOPE:
 *   - In scope: Event posting, queue capacity, consumer callback
 *   - Out of scope: Event persistence (see UT_EventPersistence.cxx)
 *
 * KEY CONCEPTS:
 *   - Conet vs Conles: Connection-oriented vs connection-less event modes
 *   - EvtDescQueue: Fixed-capacity event descriptor queue
 *   - CbExecCmd_F: Callback function for immediate command processing
 */
```

这个 OVERVIEW 是 DDD 的限界上下文，以 LLM 可读的注释形式呈现。它告诉 LLM："在这个测试文件中，这些是领域概念。不要跨越到其他限界上下文。"

#### 2. US/AC/TC 作为可执行领域规格

CaTDD 中的每个 User Story 映射到 DDD 的战略设计：

```
DDD 战略设计                    CaTDD US/AC/TC

核心域 (Core Domain)          →    P0 Functional（业务关键测试）
  是什么让你独特？                  Typical, Edge, Misuse, Fault

支撑子域 (Supporting Subdomain) →  P1 Design（架构测试）
  必要但非竞争优势                    State, Capability, Concurrency

通用子域 (Generic Subdomain)   →    P2 Quality（基础设施测试）
  购买，不自行构建                    Performance, Robust, Compatibility

文档/示例 (Documentation/Examples) → P3 Addons（教程和演示）
```

优先级框架不止是测试排序——它是一种**领域分类**。P0 测试验证你的核心域。P1 测试验证你的架构。P2 测试检查你的质量属性。该框架告诉 LLM："把精力集中在使该领域独特的部分上，而非优化基础设施。"

#### 3. 设计骨架作为统一语言

CaTDD 设计骨架在测试文件中建立了统一语言：

```cpp
// @[Class]: P0 Functional / ValidFunc
// @[Category]: Typical
// @[Intent]: Prove the core event posting and delivery workflow
// @[UseWhen]: Producer and consumer are valid, queue has capacity
// @[AvoidWhen]: Queue is full, consumer is blocking, or producer is invalid
// @[US]: US-1 (event posting), US-2 (event delivery)
// @[AC]: AC-1 through AC-4
// @[TC]: TC-1 verifyEventPost_byAvailableCapacity_expectEventQueued
//        TC-2 verifyEventDelivery_byCallbackConsumer_expectEventProcessed
```

该骨架一致地使用了领域术语："producer"、"consumer"、"queue"、"capacity"、"blocking"。这些不是通用的测试术语——它们是该领域的统一语言。LLM 读取骨架后，在生成任何代码之前就理解了领域模型。

#### 4. SpecFlow 制品作为领域知识

Px-SpecFlow 的生命周期制品将领域知识保存在版本控制的文件中：

```
.catdd/spec/projectContext.md     → 领域愿景、限界上下文、约定
README_ArchDesign.md              → 战略设计、上下文映射
README_DetailDesign.md            → 战术设计、聚合边界
README_VerifyDesign.md            → 领域验证拓扑
```

这些制品是 DDD 的知识结晶输出，但以 LLM 可读的 Markdown 形式存在，并且能经受代码变更的考验。

### DDD 调和检查清单

使用以下检查点验证 CaTDD 制品中的 DDD 一致性：

- 扫描测试文件中的领域术语一致性——同一概念在所有测试文件中是否以相同方式命名？
- 验证限界上下文边界——`UT_EventQueue.cxx` 是否仅引用 EventQueue 领域概念，还是泄漏到 CommandExecutor 概念中？
- 检查 OVERVIEW 部分是否足够清晰地声明其限界上下文，使 LLM 能够理解
- 对每个聚合根，验证是否存在相应的测试文件，具有 US/AC/TC 覆盖

### 为什么 DDD 在 LLM 时代更重要

LLM 是领域无关的。它们懂得语法但不懂语义。它们能为任何领域生成代码，但对任何领域都不理解。DDD 填补了这一空白：

- **统一语言为 LLM 提供一致的术语**——LLM 读取测试文件时，看到的是 "event producer"、"event consumer"、"EvtDescQueue" 这些一致使用的术语。它从测试注释中学习领域词汇。
- **限界上下文防止 LLM 混合模型**——`Billing.Account` 的测试文件使用计费术语，`CRM.Account` 的测试文件使用 CRM 术语。LLM 不会混淆它们，因为 OVERVIEW 声明了它所处的上下文。
- **战略设计告诉 LLM 要优先关注什么**——优先级框架（P0 核心域，P1 支撑，P2 通用）告诉 LLM 在有限的上下文窗口中把精力集中在哪里。

没有 DDD，LLM 会将每个测试文件视作一个扁平的、可互换的代码制品。通过将 DDD 嵌入 CaTDD 注释，LLM 能理解领域架构。

---

## CaTDD：TDD + BDD + DDD 的融合

CaTDD 不是堆叠在三个学科之上的第四个方法论，而是一种**融合**——TDD、BDD 和 DDD 在一个单一、LLM 可读的制品（测试文件）中共存协作的方式：

```
┌─────────────────────────────────────────────────────────────────┐
│                      THE CaTDD TEST FILE                         │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │ OVERVIEW: Domain Context Declaration (DDD)                 │ │
│  │ WHAT, WHERE, WHY, SCOPE, KEY CONCEPTS                     │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │ US: User Stories — Business Intent (BDD)                  │ │
│  │ As a [role], I want [capability], So that [value]         │ │
│  └──────────────────────────┬────────────────────────────────┘ │
│                             │ traces to                          │
│  ┌──────────────────────────▼────────────────────────────────┐ │
│  │ AC: Acceptance Criteria — Executable Specs (BDD)          │ │
│  │ GIVEN [context], WHEN [action], THEN [outcome]            │ │
│  └──────────────────────────┬────────────────────────────────┘ │
│                             │ traces to                          │
│  ┌──────────────────────────▼────────────────────────────────┐ │
│  │ TC: Test Cases — Verification Design (TDD + BDD)          │ │
│  │ @[Name]: verifyBehavior_byCondition_expectResult          │ │
│  │ @[Purpose], @[Brief], @[Steps], @[Expect], @[Notes]       │ │
│  └──────────────────────────┬────────────────────────────────┘ │
│                             │ implements                         │
│  ┌──────────────────────────▼────────────────────────────────┐ │
│  │ TEST CODE: Implementation (TDD)                            │ │
│  │ SETUP → BEHAVIOR → VERIFY → CLEANUP                       │ │
│  │ Status: ⚪ TODO → 🔴 RED → 🟢 GREEN                        │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │ TODO TRACKING: Progress Dashboard (TDD)                    │ │
│  │ P0→P1→P2→P3 priority, status markers, quality gates       │ │
│  └───────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

一个单一的测试文件包含：
- **DDD 的限界上下文**（OVERVIEW 部分）
- **BDD 的可执行规格**（US/AC 链，使用 GIVEN/WHEN/THEN）
- **TDD 的验证循环**（TC 实现，使用 RED→GREEN 标记）
- **DDD 的战略优先级排序**（P0→P3 框架映射到核心/支撑/通用）

这就是融合。一个文件。三门经典学科。全程 LLM 可读。

---

## LLM 作为知识手册阅读器

软件工程知识手册教导我们：

| 原则 | 含义 | CaTDD 如何应用 |
|---|---|---|
| **先设计后编码** | 在构建之前理解要构建什么 | 注释骨架即设计 |
| **先验证后发布** | 交付前证明正确性 | RED→GREEN 循环 + 质量关卡 |
| **说领域语言** | 在代码中使用业务术语 | OVERVIEW + US/AC 使用领域词汇 |
| **限定模型边界** | 每个上下文一个模型，不要混用 | 每个聚合/限界上下文一个测试文件 |
| **从外向内测试** | 验证行为，而非实现 | GIVEN/WHEN/THEN 关注可观察结果 |
| **小的、可逆的变更** | 小步提交，轻松回滚 | 每次一个 TC，RED→GREEN 提交 |
| **知识在代码中** | 不要让知识只存在于脑海 | 注释鲜活的设计保留决策 |

LLM 时代并没有否定这些原则，反而更加迫切地需要它们——因为没有这些原则，LLM 生成的代码就没有护栏。

### LLM 通过 CaTDD 阅读知识手册

当你将一个 CaTDD 测试文件分享给 LLM 时，你分享的是以注释编码的知识手册：

```
LLM reads:   OVERVIEW section        → 学习限界上下文和领域概念
LLM reads:   US section              → 学习业务价值和参与者角色
LLM reads:   AC section              → 学习可执行规格说明 (BDD)
LLM reads:   TC section              → 学习要验证什么以及如何验证
LLM reads:   TODO tracking section   → 学习当前进度和下一步行动
LLM reads:   TEST CODE section       → 学习实现模式
LLM reads:   @[Category] tags        → 学习测试优先级和风险等级
```

LLM 无需了解 DDD 术语即可从 DDD 中获益。它读取的测试文件以通俗易懂的方式声明了其限界上下文（OVERVIEW），使用一致的领域术语（US/AC 中的统一语言），并遵循优先级规则（P0→P3 中的战略设计）。方法论被嵌入在制品中。

---

## BDD → CaTDD：从 Feature 文件到注释链

经典 BDD 使用独立于测试代码的 Gherkin `.feature` 文件：

```gherkin
Feature: Cash Withdrawal
  As a customer
  I want to withdraw cash from my account
  So that I can make purchases

  Scenario: Successful withdrawal
    Given my account has a balance of $100
    When I withdraw $20
    Then my balance should be $80
    And the ATM should dispense $20

  Scenario: Insufficient funds
    Given my account has a balance of $50
    When I withdraw $100
    Then the withdrawal should be rejected
    And my balance should remain $50
```

CaTDD 将其转换为测试文件中的注释链：

```cpp
// US-1: As a customer,
//       I want to withdraw cash
//       So that I can make purchases.
//
// AC-1: GIVEN account has balance $100,
//       WHEN customer withdraws $20,
//       THEN balance is $80,
//        AND ATM dispenses $20.
//
// AC-2: GIVEN account has balance $50,
//       WHEN customer withdraws $100,
//       THEN withdrawal is rejected,
//        AND balance remains $50.

// [@AC-1,US-1] P0 Functional / Typical
//  TC-1:
//    @[Name]: verifyWithdraw_bySufficientBalance_expectReducedBalance
//    @[Purpose]: Ensure valid withdrawals are processed correctly
//    @[Brief]: Set up account with $100, withdraw $20, verify balance $80
//    @[Expect]: Balance is $80, dispense event is triggered

TEST(AccountWithdraw, verifyWithdraw_bySufficientBalance_expectReducedBalance) {
    //===SETUP===
    Account acc(100);
    
    //===BEHAVIOR===
    auto result = acc.withdraw(20);
    
    //===VERIFY===
    ASSERT_TRUE(result.success);
    ASSERT_EQ(80, acc.balance());
    ASSERT_TRUE(result.dispensed);
}
```

这种转换保留了 BDD 的结构，但消除了规格说明与测试之间的分离。GIVEN/WHEN/THEN 存在于 AC 注释中。场景实现存在于其正下方的 TEST 函数中。LLM 在读取此文件时，在一个连续的上下文中看到了从业务需求到可执行验证的完整链条。

---

## DDD → CaTDD：从领域模型到注释骨架

经典 DDD 产出一个以类图、上下文映射和设计文档形式表达的领域模型：

```
DDD 制品：
  - Bounded Context: Account Management
  - Aggregate Root: Account
  - Entity: Transaction
  - Value Object: Money
  - Domain Service: TransferService
  - Ubiquitous Language: balance, withdraw, deposit, transfer, overdraft
```

CaTDD 将此领域模型嵌入到测试文件的 OVERVIEW 和设计骨架中：

```cpp
//=========================================================================================
//======>BEGIN OF OVERVIEW===============================================================
/**
 * [WHAT] This file verifies Account aggregate behavior
 * [WHERE] in the Account Management bounded context
 * [WHY] to ensure correct balance operations and transfer integrity
 *
 * SCOPE:
 *   - In scope: Account withdrawal, deposit, transfer logic
 *   - Out of scope: User authentication (see UT_Authentication.cxx)
 *   - Out of scope: Notification delivery (see UT_Notification.cxx)
 *
 * KEY CONCEPTS:
 *   - Account (Aggregate Root): Manages balance and transaction history
 *   - Money (Value Object): Immutable amount + currency pair
 *   - Transaction (Entity): Recorded entry in account history
 *   - TransferService (Domain Service): Coordinates two-account transfer
 */
//======>END OF OVERVIEW==================================================================
```

LLM 读取此 OVERVIEW 并理解到：
- 该测试文件覆盖一个限界上下文（Account Management）
- 聚合根是 Account——测试应针对 Account 行为
- Money 是值对象——测试应验证值相等性，而非标识符
- Transaction 是实体——测试应验证它被正确记录
- 该文件**不**测试身份认证或通知（超出范围）

这是通过结构化注释传递给 LLM 的 DDD 知识。

---

## P0→P3 框架作为战略 DDD

CaTDD 的优先级框架直接映射到 DDD 的战略设计：

```
DDD 战略分类                            CaTDD 优先级映射

核心域 (Core Domain)                   P0 Functional
（你的竞争优势）                         (Typical, Edge, Misuse, Fault)
│                                      │
├── 创造利润的内容                      ├── 业务关键工作流
├── 对你业务独有的内容                   ├── 领域特定的行为
└── 在这里投入最多精力                   └── 在任何其他测试之前完成

支撑子域 (Supporting Subdomain)         P1 Design
（必要但非独有）                         (State, Capability, Concurrency)
│                                      │
├── 支撑核心域的内容                     ├── 架构验证
├── 可以外包的内容                       ├── 生命周期与 FSM
└── 投入足够保持它运行的精力              └── 在 P0 之后完成

通用子域 (Generic Subdomain)            P2 Quality
（购买，不自行构建）                     (Performance, Robust, Compatibility)
│                                      │
├── 所有业务都通用的内容                  ├── 非功能性质量
├── 使用现有解决方案                     ├── 平台兼容性
└── 最小化定制投入                       └── 在 P1 之后完成

文档/教育 (Documentation / Education)    P3 Addons
（演示、示例、教程）                     (Demo/Example)
```

CaTDD CodeAgent 读取此映射后理解到：
- "P0 测试 = 这是使该领域有价值的内容——大力投入"
- "P1 测试 = 这是支撑核心的内容——充分测试架构"
- "P2 测试 = 这是基础设施——验证质量，不要过度测试"

这防止了 LLM 常见的一种反模式：将所有测试同等对待。LLM 学会基于领域重要性来排优先级，而不仅基于代码覆盖率指标。

---

## LLM 时代的鲜活文档

知识手册教导我们，文档必须随代码演进而演进。CaTDD 通过**注释鲜活的设计**将这一原则具体化：

### 鲜活词汇表

CaTDD 测试文件通过注释中一致的领域术语建立起统一语言：

- 仅扫描目标限界上下文中的文件
- 过滤掉测试工具、框架配置和样板代码
- 测试文件名中的类名映射到领域术语（例如 `UT_Account.cxx` → Account 聚合）
- AC 注释定义了术语行为："GIVEN account has balance $100"——术语 "balance" 由此条件所定义

LLM 通过阅读 OVERVIEW 部分和 AC 注释来构建其领域词汇表。无需单独的词汇表文件。

### 鲜活图表

SpecFlow 面向架构的 SPEC 文档充当鲜活图表：

- `README_ArchDesign.md` → 限界上下文映射，以 LLM 可读的文本形式表达
- `README_DetailDesign.md` → 聚合边界和类关系
- `README_VerifyDesign.md` → 测试拓扑和验证覆盖

这些是文本文档，而非图片。LLM 能够解析它们。但它们在人类需要可视化时也可以使用 Mermaid 或 PlantUML 渲染为图表。文本是真理之源——图表是一种展示视图。

### CaTDD 中的 BDD 调和

经典 BDD 中的调和意味着验证 Feature 文件、步骤定义和生产代码之间的一致性。在 CaTDD 中，调和更简单，因为不存在间隙：

- Feature 文件 = 测试文件中的 AC 注释
- 步骤定义 = 同一文件中的 TC 注释 + TEST 函数
- 生产代码 = 在针对该 TC 的 GREEN 阶段中实现

调和检查变为：
- 每个 AC 至少有一个追溯到它的 TC
- 每个 TC 的断言实际验证了它声称要验证的 AC
- 每个生产代码的变更都是由一个 RED TC 所驱动的

这些检查可以通过解析注释标记来自动化——无需外部 BDD 工具。

---

## 应用知识手册：一个完整示例

让我们追踪一个特性经过 TDD、BDD 和 DDD，看看 CaTDD 如何应用它们：

### 1. BDD：表达需求

```
US-1: As a customer,
      I want to transfer money between my accounts
      So that I can manage my funds across accounts.

AC-1: GIVEN checking account has $500 and savings account has $200,
      WHEN customer transfers $100 from checking to savings,
      THEN checking balance is $400,
       AND savings balance is $300.

AC-2: GIVEN checking account has $100,
      WHEN customer transfers $200 from checking to savings,
      THEN transfer is rejected,
       AND checking balance remains $100,
       AND savings balance is unchanged.
```

### 2. DDD：在 OVERVIEW 中对领域建模

```cpp
/**
 * [WHAT] This file verifies cross-account money transfer
 * [WHERE] in the Account Management bounded context
 *
 * KEY CONCEPTS:
 *   - Transfer (Domain Operation): Moves Money between two Accounts
 *   - Money (Value Object): amount + currency, immutable
 *   - Account (Aggregate Root): owns balance and transaction history
 *   - TransferLimit (Policy): maximum per-transfer amount
 */
```

### 3. TDD：设计测试用例

```cpp
// P0 Functional / Typical — Core Domain
//  TC-1: verifyTransfer_byBasicTransfer_expectUpdatedBalances
//    @[Purpose]: Verify the fundamental transfer operation
//    @[Brief]: Set up two accounts, transfer $100, verify both balances

// P0 Functional / Edge — Domain boundaries
//  TC-2: verifyTransfer_byExceedingBalance_expectRejected
//    @[Purpose]: Verify overdraw protection
//    @[Brief]: Attempt to transfer more than available balance

// P0 Functional / Edge — Domain precision
//  TC-3: verifyTransfer_byZeroAmount_expectNoOperation
//    @[Purpose]: Verify zero-amount transfer is a no-op
//    @[Brief]: Transfer $0, verify no balance change

// P0 Functional / Misuse — Domain misuse
//  TC-4: verifyTransfer_bySameAccount_expectRejected
//    @[Purpose]: Prevent transfer to the same account
//    @[Brief]: Set source and destination to same account
```

### 4. LLM：实现 TDD 循环

LLM 读取 US/AC/TC 设计（BDD 规格说明 + DDD 领域模型）并实现：

```
TC-1: RED → 实现 TransferService.transfer($100) → GREEN
TC-2: RED → 实现 InsufficientFunds 检查           → GREEN
TC-3: RED → 实现零金额防护子句                    → GREEN
TC-4: RED → 实现同账户检查                        → GREEN
```

每个实现都被领域所限定：LLM 从 OVERVIEW 中知道 Transfer 是一个领域操作，Money 是一个值对象，Account 是一个聚合根。生成的代码使用了这些术语。

### 5. 审查：对照知识手册进行验证

```
✅ BDD: 每个 AC 有一个或多个 TC——可执行规格存在
✅ DDD: OVERVIEW 声明了限界上下文——领域模型显式化
✅ TDD: 所有 TC 遵循 RED→GREEN 循环——验证完整
✅ 融合:  变更可追溯：US → AC → TC → Code → Git commit
```

---

## 知识手册应用于实践

软件工程知识手册教导的是持久的、历久弥新的原则。CaTDD 是在 LLM 时代对它们的应用：

| 知识手册原则 | CaTDD 实践 |
|---|---|
| TDD: 测试优先，代码其次 | 注释骨架优先，LLM 生成 TC → RED → GREEN |
| BDD: 规格化行为，而非实现 | US/AC/TC 链即是可执行规格 |
| DDD: 说领域语言 | OVERVIEW + US/AC 使用一致的领域术语 |
| DDD: 限定模型边界 | 每个限界上下文/聚合根一个测试文件 |
| TDD: 小的、已验证的步骤 | 每次一个 TC，⚪→🔴→🟢 标记 |
| BDD: 将规格与测试放在一起 | AC 注释与 TEST 函数在同一文件中 |
| DDD: 战略优先级排序 | P0(核心)→P1(支撑)→P2(通用)→P3(文档) |
| SWE: 知识在代码中 | 注释鲜活的设计将决策保留在制品中 |

LLM 时代并没有使 TDD、BDD 或 DDD 过时，而是使它们**可操作化**。CaTDD 就是在 LLM 硬件上运行 TDD、BDD 和 DDD 的操作系统。

### 将知识手册打包为 Agent Skills

知识手册不仅仅存在于人类编写的书籍中。CaTDD 通过两个可复用的 agent skills 将其操作化，任何 CodeAgent 都可以加载：

**`comment-alive-test-driven-development`** —— 将 CaTDD 打包为可复用的能力。当 Copilot 用户加载此 skill 并说 "use CaTDD" 时，agent 即拥有完整的知识手册：完整的 `CaTDD_methodPrompt.md`、`CaTDD_designAndImplTemplate.cxx` 模板以及 `slashCommands` 流程素材。该 skill 告诉 agent 谁使用它、创建什么（测试文件作为鲜活的设计文档）、何时应用它、输出放在何处、为什么重要（结构化注释为 LLM 提供生成正确代码所需的上下文）以及如何执行（4 个阶段：Scope → Design → Implement → Validate）。

**`user-story-centered-spec-coding`** —— 将 SpecCoding 生命周期打包为可复用的工作流。它告诉 agent 如何将工作从 pendingNews → todoUS → doingUS → doneUS 推进，其中 abortUS 保留不安全的活跃故事以供后续分析，CaTDD 作为默认测试方法，typical TDD 作为备选方案。该 skill 捆绑了完整的 Px-SpecFlow 生命周期：流程文档、所有 27 个 `SPEC_*` 命令文件、项目根 README SPEC 模板以及作为默认测试引擎的 CaTDD 方法引用。

两个 skills 均由 `agentSkills/makeSkill.sh` 从原创源文件生成。原创源文件是持久的资产；生成的包是构建输出。这种分离保护了知识手册的完整性——方法在单一位置（methodPrompts）进行变更，并通过构建脚本传播到所有 skill 包。

---

## 结语：经典 SWE 的三角

```
                         TDD
                        /   \
                       /     \
                      / CaTDD \
                     /         \
                    /           \
                 BDD-------------DDD

   TDD proves behavior.
   BDD specifies behavior.
   DDD models behavior.
   CaTDD synthesizes all three into
   one LLM-readable test file.
```

软件工程知识手册不是过往实践的博物馆，而是构建正确的、可维护的、领域一致的软件的运维手册——无论有没有 LLM。CaTDD 即是一种方法论，它阅读该手册并将其转化为注释鲜活的验证设计，LLM、开发者和 code agents 都能理解、执行和改进。

**Comments is Verification Design. LLM Generates Code. Iterate Forward Together.**
