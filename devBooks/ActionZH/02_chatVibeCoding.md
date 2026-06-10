# 02 chatVibeCoding

## 什么是 Vibe Coding？

Vibe coding 是使用与 LLM 的自然语言对话来生成代码的实践。你描述你想要什么，LLM 产生一个实现，你通过优化你的 prompt 来迭代。

在 CaTDD 中，vibe coding 不是无结构的自由发挥。它是 LLM 交互的第一种模式——对话式、探索性的模式，你和 CodeAgent 一起逐步完成设计。但 CaTDD 增加了一个关键区别：有非结构化的 VibeCoding，也有结构化的 SpecCoding。两者各有其位，方法论会告诉你何时使用每一种。

---

## CaTDD 交互的两种模式

用 CaTDD 的术语来说，在 CodeAgent 聊天中直接使用 `methodPrompts` 就是 **VibeCoding**：灵活的、方法引导的对话。使用 `slashCommands` 就是 **SpecCoding**：基于相同方法定义的结构化规约驱动开发流程。

| 方面 | VibeCoding | SpecCoding |
|---|---|---|
| **定义** | 灵活的、方法引导的 LLM 对话 | 带有显式生命周期命令的结构化流程 |
| **方法来源** | 直接使用 methodPrompts | slashCommands（包装 methodPrompts） |
| **控制** | 开发者主导对话 | 流程命令驱动生命周期 |
| **工件** | 注释、测试文件、代码 — 临时性 | SpecFlow 工件：pendingNews、todoUS、doingUS、abortUS、doneUS |
| **可追溯性** | 可选，取决于开发者 | 强制，由流程保证 |
| **使用时机** | 探索、起草、头脑风暴、快速修复 | 结构化交付、团队协作、可复现的工作流 |
| **命令调用** | 开发者输入自由格式的 prompt | 开发者调用 `/UT_*` 或 `/SPEC_*` 命令 |

---

## 何时使用 VibeCoding

VibeCoding 是以下场景的正确模式：

1. **你在探索一个新功能** — 你有一个粗略的想法，但需要 LLM 帮你思考覆盖维度、边界情况和风险。你粘贴 API 头文件，问"我应该考虑哪些测试维度？"，然后在 LLM 的建议上迭代。

2. **你在自由起草测试想法** — CaTDD 的 Stage-0（自由起草）就是纯 VibeCoding。你捕获原始的场景、风险、示例和未解决的问题，而不急于做出类别决策。LLM 帮你头脑风暴。

3. **你在澄清需求** — 你粘贴模块 README，让 LLM 识别模糊的验收标准，并讨论正确的行为应该是什么。这是非正式进行的 `SPEC_clearStoryIntent` 阶段。

4. **你在排查问题** — 一个测试失败了，你粘贴错误信息和测试代码，LLM 帮你诊断是 setup 问题、断言问题还是真正的 bug。

5. **你在做一次性工作** — 一个小的验证脚本、配置变更或文档更新。SpecCoding 的开销不值得。

---

## 何时切换到 SpecCoding

VibeCoding 有一个自然的边界。当你发现自己处于以下情况时：

- 多次向 LLM 重复相同的指令
- 丢失了已做决策的追踪
- 忘记了哪些测试已设计 vs 已实现
- 需要与团队成员分享进展
- 需要在一天或一周后恢复工作

……就是切换到 SpecCoding 的时候了。VibeCoding 用于探索和对话。SpecCoding 用于结构化交付和团队协作。它们不是竞争模式——它们是同一工作流中互补的阶段。

---

## VibeCoding 如何配合 methodPrompts 工作

在 VibeCoding 模式下，你直接使用 methodPrompts 层。你与 LLM 共享 method prompt，然后以对话方式迭代。

### 基本模式

```
1. 共享上下文：   粘贴 methodPrompts/CaTDD_methodPrompt.md（或相关类别 prompt）
2. 描述意图：     "使用 CaTDD，帮我为 [组件] 设计测试。"
3. 提供输入：     粘贴 API 头文件、已有测试文件、文档
4. 迭代：         审查、优化、请求澄清、请求替代方案
5. 产出：         LLM 生成 US/AC/TC 设计、测试代码或生产代码
6. 保存：         将 LLM 的输出复制到你的测试文件中
```

### 示例：VibeCoding 一个 Typical 设计骨架

**开发者**：
```
使用 CaTDD 方法论（来自 methodPrompts/CaTDD_methodPrompt.md），
帮我为事件队列组件设计 Typical 设计骨架。

关键关注点：
- 生产者异步发布事件
- 消费者拉取事件，支持可选的阻塞模式
- 队列具有固定容量

覆盖维度：Producer × Consumer × Mode
优先级：默认 P0 顺序（Typical → Edge → Misuse → Fault）
```

**CodeAgent**（在阅读 method prompt 之后）：
```
我将为事件队列设计 P0 Functional / Typical 设计骨架。

覆盖矩阵：
┌──────────────┬──────────────┬───────────┬────────────────────────┐
│ Producer     │ Consumer     │ Mode      │ Scenario               │
├──────────────┼──────────────┼───────────┼────────────────────────┤
│ Single       │ Single       │ Callback  │ US-1: 基本事件流        │
│ Single       │ Single       │ Pull      │ US-2: 轮询流            │
│ Multiple     │ Single       │ Callback  │ US-3: 多对一汇聚        │
└──────────────┴──────────────┴───────────┴────────────────────────┘

用户故事（User Stories）：

US-1: 作为事件生产者，
      我希望将事件发布到队列以进行异步处理，
      以便我的生产者线程不被消费者工作阻塞。

US-2: 作为事件消费者，
      我希望从队列中拉取事件，支持可选的阻塞模式，
      以便我可以在准备就绪时处理事件，无需忙等待。

US-3: 作为系统操作员，
      我希望多个生产者安全地向同一队列发布事件，
      以便来自不同来源的事件被正确处置。

...
```

对话继续：开发者审查，请求边界情况覆盖，要求 CodeAgent 生成实现，并迭代优化。这就是 VibeCoding——LLM 是应用 CaTDD 方法的对话伙伴。

---

## VibeCoding 工作流

CaTDD 的 VibeCoding 遵循方法各阶段的自然推进：

### 阶段 1：理解（方法引导的探索）

**你对 LLM 说的话**：
```
"我在构建一个 [组件]。这是 API 头文件。
使用 CaTDD，我应该测试什么以及如何排优先级？"
```

**LLM 做什么**：
- 读取你的接口
- 检查已有的相关测试
- 识别依赖和约束
- 呈现理解摘要
- 在继续之前提出澄清问题

**CaTDD 合约**：LLM 应遵循 methodPrompt 中的 Agent Workflow Checklist（阶段 1：理解）。它在设计任何东西之前，应读取文件、识别 API、找到类似测试并澄清模糊之处。

### 阶段 2：设计（注释优先，尚未编码）

**你说的话**：
```
"好的。现在设计覆盖矩阵和 User Stories。"
```

**LLM 做什么**：
- 填充 OVERVIEW 部分（WHAT/WHERE/WHY/SCOPE）
- 定义覆盖矩阵维度
- 编写 User Stories（2–5 个，As a/I want/So that 格式）
- 编写 Acceptance Criteria（GIVEN/WHEN/THEN）
- 使用结构化元数据详细说明 Test Cases
- 填充 TODO 跟踪部分

**CaTDD 合约**：先设计后编码。LLM 在生成任何测试实现之前，应首先编写注释——US/AC/TC 链路。这就是"评论即设计"的部分：设计以注释形式存在，并与代码共存。

### 阶段 3：实现（TDD 红→绿）

**你说的话**：
```
"实现第一个 Typical 测试用例。遵循 RED→GREEN。"
```

**LLM 做什么**：
- 编写测试实现（4 阶段结构）
- 在 TODO 部分将其标记为 🔴 RED
- 确认它失败（应该失败，因为代码缺失）
- 实现最小生产代码
- 确认它通过
- 将其标记为 🟢 GREEN

**CaTDD 合约**：LLM 应遵循严格的 TDD 纪律。绝不应在编写失败测试之前实现生产代码。每次动作后应立即更新状态标记。

### 阶段 4：迭代与优化

**你说的话**：
```
"现在做 Edge 测试。并添加队列满行为的测试。"
```

**LLM 做什么**：
- 按照优先级框架继续推进
- 逐个 TC 推进 RED→GREEN 循环
- 在每个质量关卡处停下来进行审查
- 报告覆盖缺口并推荐下一步

---

## VibeCoding vs SpecCoding：开发者的决策

VibeCoding 和 SpecCoding 之间的选择是一个光谱，而非二元开关。你可以从 VibeCoding 开始，到达自然的转折点，然后切换到 SpecCoding。

### 从 VibeCoding 开始的情况

- 组件是新的，需求正在浮现
- 你是唯一的开发者
- 你需要在承诺结构化之前探索
- 范围较小（<5 个 User Stories，<20 个测试用例）
- 你想要快速迭代，不需要生命周期开销

### 切换到 SpecCoding 的情况

- 需求已经稳定，需要可追溯性
- 你正在与团队成员协作
- 你需要跨天暂停和恢复工作
- 范围较大（5+ 个 User Stories，20+ 个测试用例）
- 你想要可复现的 `/UT_*` 和 `/SPEC_*` 命令序列
- 利益相关者需要了解进展（pendingNews → todoUS → doingUS → doneUS，或当活跃故事不宜继续时使用 abortUS）

### 自然过渡点

最常见的过渡点是在 Stage-0 自由起草之后。你在 VibeCoding 模式中探索、头脑风暴、讨论风险、草绘测试场景。当你对草案有足够清晰的认识，可以将其分类到 CaTDD 类别中时（Stage-1），你切换到 SpecCoding 并开始调用结构化命令。

```
VibeCoding:   探索 → 头脑风暴 → 起草 → 讨论
                        ↓（转折点）
SpecCoding:   分类 → 设计骨架 → 审查 → 实现 → 提交 → 关闭
```

---

## Method Prompt 作为聊天上下文

在 VibeCoding 中，method prompt 是你与 LLM 的共享上下文。你不需要每次都重新解释 CaTDD——你共享一次 method prompt，LLM 在整个对话中都会应用它。

### 需要共享什么

有效 VibeCoding 的最小上下文：

1. **主 method prompt**（`CaTDD_methodPrompt.md`）—— 建立方法论合约：优先级框架、类别定义、US/AC/TC 格式、状态跟踪、质量关卡。

2. **相关类别 prompt**（`CaTDD_methodPrompt4Cat-Typical.md` 等）—— 在特定类别下工作时，共享该类别的专门指导。

3. **API 接口**—— 被测组件的头文件、规约文档或协议定义。

4. **已有测试文件**—— 以便 LLM 遵循已有模式并避免重复。

### 多少上下文足够？

CaTDD method prompt 是全面的（1500+ 行规约说明）。你不需要将它全部粘贴到每次对话中。而是：

- **首次对话**：共享完整的 method prompt。LLM 现在理解 CaTDD 了。
- **后续对话**：引用它："继续像之前一样使用 CaTDD 方法。"
- **聚焦的对话**：仅共享特定工作相关的类别 prompt。

LLM 的上下文窗口是你的约束。优先级如下：
1. 组件接口和规约文档（必须——LLM 需要知道测试**什么**）
2. 相关类别 prompt（重要——LLM 需要知道**如何**测试）
3. 已有测试代码（有帮助——LLM 遵循惯例）

---

## VibeCoding 的模型层级策略

VibeCoding 让你与 LLM 直接对话。你选择的模型会影响决策质量。CaTDD 建议使用能保持决策质量的最小模型层级：

| 层级 | 在 VibeCoding 中何时使用 |
|---|---|
| **SOTA 推理**（GPT-5.5-xHigh） | 架构决策、系统边界、质量权衡、跨模块约束。当对话涉及不可逆的设计选择时使用。 |
| **高性能** | 需求分析、US/AC/TC 设计、测试设计、代码审查。当推理需要跨越多个工件（规约、测试、生产代码）时使用。 |
| **闪速** | 确定性任务：编写单个测试实现、更新 TODO 状态、简单重构。当输入清晰且动作范围狭窄时使用。 |

**升级规则**：如果闪速模型产出的设计看起来肤浅，升级到高性能。如果高性能模型做出的架构决策感觉有风险，升级到 SOTA。

---

## 常见的 VibeCoding 模式

### 模式 1：设计审查循环

```
开发者："为这个 API 设计 Typical 设计骨架。"
CodeAgent：[产出 US/AC/TC 设计]
开发者："US-2 没有体现非阻塞需求。修改一下。"
CodeAgent：[修改 US-2 并更新受影响的 AC 和 TC]
开发者："好。现在添加超时模式的覆盖。"
CodeAgent：[为超时行为添加 AC-4 和 TC]
开发者："看起来完整了。切换到 SpecCoding 开始实现。"
```

这是最自然的模式：开发者审查 LLM 的设计输出并指导优化。LLM 保持可追溯性（更新一个 US 会级联影响关联的 AC 和 TC）。

### 模式 2：覆盖缺口分析

```
开发者："这是我当前的测试文件。你看到哪些覆盖缺口？"
CodeAgent：[对照优先级框架分析已有的 US/AC/TC 链路]
CodeAgent："缺失：P0 Edge（队列满行为）、P0 Misuse（重复关闭）、
           P1 State（清理后的生命周期转换）。"
开发者："先设计 Edge 设计骨架。然后我们做 Misuse。"
```

LLM 使用 CaTDD 优先级框架作为对照已有测试的检查清单。它识别应该存在但缺失的内容。

### 模式 3：排查会话

```
开发者："TC-3 失败了。期望 IOC_RESULT_INVALID_PARAM，实际得到 success。"
CodeAgent：[读取测试代码、读取生产代码]
CodeAgent："测试调用了 IOC_post(NULL, ...)，但生产代码有一个
            guard clause 为 NULL 句柄返回 SUCCESS。这可能是：
            A) 生产代码 bug（应该返回 INVALID_PARAM），或
            B) 测试误解（此 API 允许 NULL）。
            哪个是该 API 合约的正确行为？"
```

LLM 充当诊断伙伴，将测试期望与生产行为进行比较，并揭示合约模糊性。

### 模式 4："下一步做什么"查询

```
开发者："我已经完成了所有 P0 Typical 测试。下一步应该做什么？"
CodeAgent：[读取 TODO 跟踪部分]
CodeAgent："你有 4 个 Edge 测试用例在 ⚪ TODO、2 个 Misuse 用例在 ⚪ TODO、
           1 个 Fault 用例在 ⚪ TODO。按照 P0 默认顺序，
           接下来实现 Edge 用例。TC-Edge-1 依赖于你尚未实现的 capacity API——
           考虑将其标记为 BLOCKED，改为推进 TC-Edge-2。"
```

LLM 读取 CaTDD 跟踪部分，根据优先级规则和依赖分析推荐下一步行动。

---

## VibeCoding 中的两个设计阶段

CaTDD method prompt 支持两个设计阶段，它们自然地映射到 VibeCoding：

### Stage-0：自由起草

这是纯 VibeCoding。你捕获原始场景、风险、示例和未解决的问题，而不强制做出类别决策。目标是覆盖广度，而非结构。

**你说的话**：
```
"我在构建一个事件队列。什么可能出问题？我应该测试什么？"
```

**LLM 产出的内容**：
```
FreelyDrafts:
- 如果队列满了，生产者尝试发布会怎样？
- 如果消费者尝试从空队列拉取会怎样？
- 如果多个生产者同时发布会怎样？
- 如果消费者阻塞等待永远不会到达的事件会怎样？
- 如果队列容量为 0——应该允许吗？
- 如果我们在队列被销毁后发布会怎样？
- 如果事件大小差异巨大会怎样？
- 如果回调消费者抛出异常会怎样？
- 风险：如果回调尝试向同一队列回发事件，消费者死锁
- 风险：如果事件发布后从未被消费，内存泄漏
- 问题：零容量队列应该是有效配置吗？
- 问题：我们应该支持基于优先级的事件排序吗？
```

Stage-0 的输出故意是非结构化的。目标是捕获想法。结构在 Stage-1 中到来。

### Stage-1：分类设计

在起草之后，你在编写最终的 US/AC/TC 之前将草案分类到 CaTDD 类别中。这是 VibeCoding 和 SpecCoding 之间的桥梁。

**你说的话**：
```
"将这些草案分类到 CaTDD 类别中，并设计骨架。"
```

**LLM 产出的内容**（按类别结构化）：

```
P0 Functional / Typical：
  US-1: 作为生产者，我希望发布事件以便它们排队等待处理。
  AC-1: GIVEN 有可用容量的队列，WHEN 生产者发布，THEN 事件被加入队列。
  TC-1: verifyEventPost_byAvailableCapacity_expectEventQueued

P0 Functional / Edge：
  US-2: 作为生产者，我希望队列满时具有非阻塞行为。
  AC-2: GIVEN 队列满，WHEN 生产者以 NonBlock 模式发布，THEN 立即返回并带有错误。
  TC-2: verifyNonBlockPost_byFullQueue_expectImmediateReturn

P0 Functional / Misuse：
  US-3: 作为开发者，我希望对于不正确的队列使用有正确的错误码。
  AC-3: GIVEN 已销毁的队列，WHEN 生产者发布，THEN 返回 INVALID_STATE。
  TC-3: verifyPost_byDestroyedQueue_expectInvalidState

P0 Functional / Fault：
  US-4: 作为系统操作员，我希望消费者故障后能优雅恢复。
  AC-4: GIVEN 消费者回调崩溃，WHEN 已发布的事件保留，THEN 队列保持可操作。
  TC-4: verifyQueue_byConsumerCrash_expectQueueRemainsOperational
```

Stage-1 弥合了自由探索和结构化执行之间的鸿沟。一旦分类完成，你就可以切换到 SpecCoding 并调用 slash command 来实现每个骨架。

---

## 带有实时反馈的 VibeCoding

VibeCoding 的优势之一是即时反馈。你立即看到 LLM 的输出并进行迭代。这创建了一个紧密的反馈循环：

```
你的 prompt → LLM 响应 → 你的审查 → 优化后的 prompt → 更好的响应
     ↑                                                              ↓
     └────────────────────── 持续优化 ─────────────────────────────┘
```

这个循环很快但很脆弱。如果你不保存输出（将它们复制到测试文件中、更新 TODO 状态），对话就成了决策的唯一记录。当聊天过期时，设计就丢失了。

**VibeCoding 保存规则**：在每次重要的设计输出后，将其复制到文件中。在每次测试实现后，运行它并更新 TODO 部分。不要让聊天成为你唯一的真实来源。

---

## CodeAgent 在 VibeCoding 中的角色

在 VibeCoding 中，CodeAgent 是一个**理解方法的对话伙伴**。它：

- **读取 method prompt** 以理解 CaTDD 语义，而非仅仅是泛化的 TDD
- **保留注释骨架合约** —— 它知道 `@[US]`、`@[AC]`、`@[TC]` 标记是结构性的，而非装饰性的
- **遵循优先级纪律** —— 它在 P1 之前设计 P0，在 Edge 之前设计 Typical
- **跟踪状态** —— 随着对话的推进更新 ⚪→🔴→🟢 标记
- **提问而非假设** —— 当产品意图不明确时，它提问而不是猜测
- **报告它不知道的内容** —— 它呈现缺失的信息，而非用听起来自信的输出来掩盖缺口

CodeAgent 不取代开发者的判断。它通过应用方法一致性和生成结构化输出的速度——比人类打字更快——来放大开发者的判断力。

---

## VibeCoding 反模式

### 反模式 1：永远 VibeCoding

有些开发者无限期地停留在 VibeCoding 模式中，把每次 LLM 对话都当作临时性的。没有结构，你会积累：

- 孤立的测试用例，没有到需求的可追溯性
- 通过但不验证任何有意义内容的测试（"绿但空洞"问题）
- 跨文件不一致的命名、结构和优先级顺序
- 仅存在于过期聊天会话中的、丢失的设计决策

**解决办法**：当设计稳定时切换到 SpecCoding。从对话迁移到结构化工件。

### 反模式 2：在 VibeCoding 中跳过设计

VibeCoding 的速度可能诱使你直接跳到实现："帮我为事件队列写一个测试。"LLM 生成测试代码，你运行它，它通过。感觉很高效。但是：

- 没有 US/AC/TC 可追溯性：这个测试验证了什么业务价值？
- 没有优先级分类：这是 Typical、Edge 还是一个随机测试？
- 没有覆盖推理：什么应该被测试但尚未被测试？

**解决办法**：即使在 VibeCoding 模式下，也要遵循"先设计后编码"的原则。要求 LLM 先设计骨架，审查它，然后再实现。

### 反模式 3：上下文饥饿

你没有提供 API 头文件、已有测试模式或项目惯例，就要求 LLM 设计测试。LLM 用看似合理但错误的假设填补缺口。

**解决办法**：在要求设计之前，提供：
- Method prompt（以便 LLM 遵循 CaTDD）
- 组件接口（以便 LLM 知道测试**什么**）
- 已有测试示例（以便 LLM 遵循惯例）
- 你的具体关注点或风险领域（以便 LLM 正确排优先级）

### 反模式 4：静默批准

LLM 产出了一个设计。你读了，它看起来合理，你说"实现"。但"看起来合理"不等于"正确"。

**解决办法**：对照 CaTDD 合约明确审查每个输出：
- User Stories 是否表达了真正的用户价值？
- Acceptance Criteria 是否精确地使用了 GIVEN/WHEN/THEN？
- Test Cases 是否追溯回 AC 和 US？
- 类别是否正确（这真的是 Edge 而不是 Misuse？）？
- 断言测试的内容是否正确？

---

## 从 VibeCoding 到 SpecCoding：桥梁

VibeCoding（第 2 章）和 SpecCoding（第 3 章）之间的桥梁就是 slash command 系统。当你准备好从对话迁移到结构化执行时：

1. **保存 VibeCoding 输出**：将 US/AC/TC 设计作为注释骨架复制到测试文件中。
2. **初始化 SpecFlow**：运行 `/SPEC_initProjectContext` 建立共享项目上下文。
3. **导入工作**：使用 `/SPEC_importFeature` 或 `/SPEC_importIssue` 创建可追溯的故事工件。
4. **打开故事**：使用 `/SPEC_openUserStory` 将工作移入活跃状态。
5. **开始结构化执行**：使用 `/UT_designTypicalSkeleton`、`/UT_implTestCase` 及其他 slash command，用可复现、可追溯的步骤按优先级框架推进工作。

VibeCoding 发现了设计。SpecCoding 交付它。两者共同构成了完整的 CaTDD 工作流。
