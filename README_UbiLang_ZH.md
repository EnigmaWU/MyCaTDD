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
| VibeCoding | 快速创意/原型模式；结果仍应回收并对齐到 CaTDD 追溯体系。在已开启的故事内，它必须通过 `SPEC_whatsWrong` 显式进入，仅在 `manualMode` 下可用，`ONE-MORE-THING` 始终生效，且探索性修改在某个 `SPEC_*` 步骤重新采纳前始终保持 `unadopted`。 |
| SPEC_whatsWrong | Px-SpecFlow 升级阶梯的第三级，也是从 SpecCoding 进入 VibeCoding 的桥梁。它判定触发原因、校验 `manualMode`、在不移动泳道也不写团队制品的前提下冻结流程、把本次探索以 `adoption_status = unadopted` 记录到 `.catdd/spec/WorkingProcessLog.md`、把每项发现路由到归属命令、报告 `learning_command = /HARNESS_evolveHarness` 且 `evolution_mode=auto`，并用任意 `SPEC_doXYZ`（例如 `SPEC_whatsNextTask`）恢复流程。 |
| agent instruction surface（智能体指令面） | 告诉 code agent 如何在本项目中工作的仓库文件：`AGENTS.md`，以及目录级覆盖用的 `AGENTS.override.md`。`SPEC_initProjectContext` 会记录每个文件的位置、作用域、来源、按区域的归属以及一行摘要；`SPEC_updateProjectContext` 负责对齐它们。来源判定取自文件本身：仅有受管区域 = `catdd-created`，仅有手写内容 = `pre-existing`，两者都有 = `mixed`，空文件 = `present-empty`。归属按区域划分：CaTDD 受管标记之间的区域可重新生成且归 CaTDD 所有，其余归项目所有。其权限上限为"操作约定"，绝不凌驾于方法语义、分类语义、门禁规则、追溯关系或项目事实之上。由安装器生成的适配文件（`.github/instructions/*.md`、`.clinerules/*.md`、`.continue/rules/*.md`、`.antigravityrules/*.md`）与生成目录会被整体重写，不在该模型范围内。 |
| review_verdict（评审结论） | 每个 review 命令每轮报告的唯一门禁结论：`PASS`、`REVISE`、`BLOCKED`、`ASK` 四者之一，并伴随 `severity`（`blocking | advisory`，默认 `blocking`）以及 `rework_route`（结论不是 `PASS` 时必填，写明归属命令）。`cardinality_gate`、`discovery_status`、`ready_for_implementation` 等子门禁用于支撑结论，不构成独立的结论词汇。旧有的各命令结论（`GAPS`、`WARN`、`FAIL`、`RISKY` 及动作型结论）在 Px-SpecFlow 的 Review Gate Contract 映射表中对应到该集合。 |
| PASS（通过） | `review_verdict` 之一：门禁按现状接受该制品，不要求任何阻断性修改，下游步骤可以直接消费它。仍可附带 `severity = advisory` 的发现，它们记录风险但不阻断工作。PASS 不等于"完美"，而是"可以安全推进"；它要求在声明范围内所有子门禁均为 `PASS`。 |
| REVISE（返工） | `review_verdict` 之一：门禁已作出判断，并要求在下游消费该制品之前先做修改。REVISE 必定至少包含一条阻断性发现，指明要改什么以及由哪个命令负责（`rework_route`），并在证据变化后重新评审。与 PASS 的关键区别：PASS = 制品照原样继续；REVISE = 先修改制品，再重新跑门禁。因此 REVISE 是"有方向的行动"，而不只是严重级别。 |
| BLOCKED（受阻） | `review_verdict` 中表示"缺少输入"的结论：必需的来源制品、证据或依赖缺失，门禁根本无法评判该制品。它由能提供该输入的一方解除——通常是 `rework_route` 指明的归属命令；只有当人类是唯一可能的提供者时，才退化为 `ASK`。BLOCKED 报告必须指明缺失的输入。注意与 TC 状态标记 `🚫 BLOCKED` 区分：后者标记无法继续的测试用例，前者描述的是门禁结论。 |
| ASK（提问） | `review_verdict` 中表示"缺少决定"的结论：答案只存在于人类开发者的判断中——意图、取舍、验收或范围。它是"把人类拉入回路"的结论，与 `ONE-MORE-THING` 的产出相同；此时还不存在返工路由，门禁停下。规范的 ASK 会给出选项（A/B、是/否、保留/采纳）让人选择。当流程连问题本身都还无法表述时，应升级为 `SPEC_whatsWrong` 而非 ASK。 |
| Source-First | 源头在先：先审视权威来源工件（契约、架构模型、质量策略）并独立推导预期验证义务，再查阅已有骨架或测试代码，消除作者自身盲区。 |
| TestEvidenceChain | 测试证据链：回答“为什么需要这个测试（WHY）”与“如何正确进行测试（HOW）”的完整无断裂证据链：从来源工件 -> 规则/不变量 -> 测试点（TP） -> 可观测预期（Oracle） -> CaTDD 分类（WHY 层面） -> US/AC/TC -> 测试用例（TC） -> RED/GREEN 实现（HOW 层面）。 |
| SUT | 被测系统 / 被测目标（System Under Test）：在测试中显式声明的被测软件边界（如 `SUT: utCodeAgentCLI`）。它确立了调用方（调用者违反契约属于 `P0 Misuse`）与外部依赖/环境（依赖故障属于 `P0 Fault`）之间的严格分界线。 |
| UT | 单元测试（Unit Testing）：聚焦于单个显式声明的 SUT 的验证活动，遵循项目约定的 `sut_unit_convention`（如模块接口、子模块接口、类、头文件接口、函数或组件）。在编码前通过 CaTDD 验证其公开契约、内部模型与质量属性。 |
| TP | 测试点（Test Point）：从来源规则、模型、边界或故障模式中发掘出的具体验证义务或条件，记录在 `discovery_ledger` 中。从开发者/防御性视角表达“必须验证什么”（目标靶心），通常采用具体的 `GIVEN 技术状态/分区, WHEN 动作/交织时序, THEN 可观测预期` 描述。 |
| TC | 测试用例（Test Case）：具有结构化元数据（`@[Name]`、`@[Expect]`、`SETUP -> BEHAVIOR -> VERIFY -> CLEANUP`）并链接到 `[@AC-n, US-n]` 的可执行规格工件。从执行视角表达“如何具体验证”（射向靶心的箭）。 |
| AC vs TP | AC 出自用户/调用方视角（定义外部业务验收规则：`GIVEN 业务上下文, WHEN 触发操作, THEN 业务结果`）；TP 出自开发者/防御性视角（定义深入边界、异常路径、并发交织的技术探针，用于验证 AC 是否坚挺成立）。一条 AC 通常分解为多个具体 TP（$1:N$ 关系）。将 $TP == AC$ 画等号会导致边界和故障模式遗漏。 |
| TP vs TC | 概念与基数并非绝对 1:1。TP 可以独立存在而尚未编写 TC（`1:0` -> GAP，从而暴露遗漏测试点）；复杂义务可能需要多个用例（`1:N`）；一个用例也可以在断言明确区分时覆盖多个测试点（`N:1`）。过早假设 `TC == TP` 会掩盖测试点遗漏。 |
| Discovery to Categorization | 发现到归类的两阶段桥梁：在 Stage-0（自由草拟）阶段，基于来源和全面扫描广度优先发掘 TP，避免过早陷入分类偏见；在 Stage-1（分类设计）阶段，依据验证视角将各 TP 路由到正确的 CaTDD 类别（契约 -> P0，模型 -> P1，包络 -> P2，认知表面 -> P3），随后形式化为 US/AC/TC 骨架。 |
| manualMode | SpecCoding 的人类驱动形态：由开发者逐条输入 `SPEC_doXYZ`，助手逐步推进，在意图、验收标准或安全性模糊时暂停并提出针对性问题，等待开发者明确确认。它是人类聊天会话的默认值，也是 `autonomousMode` 运行在导向边界处必须暂停时的回退模式。 |
| autonomousMode | SpecCoding 的流程驱动形态：由流程自身调用下一条 `SPEC_doXYZ`。对于驱动 Px-SpecFlow 的 code agent 或 CLI 运行器（如 `specCodeAgentCLI`）它是默认值；对人类会话则需在入口命令上显式传入 `execution_mode: autonomousMode`。**严格仅支持实现导向（implementation-oriented）的用户故事**：需求与架构需要人类意图，运行会在该边界暂停并退回 `manualMode`。模式由驱动方显式声明而非推断，自动推进 Part 2.b 的实现与评审步骤直至最终状态（`closeUserStory`、`abortUserStory` 或 `suspendUserStory`），并且因为缺少人类意图来源而永远无法进入 VibeCoding。 |
| analysis_mode | 分析命令内部（`SPEC_analyzeIssue`、`SPEC_analyzeFeature`）在 `manualMode` 流程下的命令级执行模式。`BRAINSTORM`（头脑风暴，默认）与开发者进行交互式逐步对话探讨；`AUTONOMOUS`（自主分析）单次执行多技能分析流水线草拟 `todoUS` 而不逐步打断，但会显式记录假设与疑问并在存在阻塞性问题时将故事标记为未就绪（NOT ready）。 |
| ONE-MORE-THING | 跨 CaTDD 全局通用安全不变量：无论在 `manualMode` 还是 `autonomousMode` 下，只要遇到不确定、来源缺失、冲突或未明确的事项，智能体都必须暂停并向开发者提问以获取明确答案。自主模式绝非猜测或臆造需求的许可；在 `autonomousMode` 下遇到 ONE-MORE-THING 时立即暂停自主推进并输出结构化 `manual_required` 提问。 |
| commit span（提交区间） | 一次提交所关闭的生命周期区间，也是 Px-SpecFlow 的提交切分单位（按区间而非按文件集合切分）。`pre-story` 区间 = `SPEC_openUserStory` 之前的导入/分析制品；`story` 区间 = `SPEC_openUserStory -> SPEC_closeUserStory`；`step` 区间 = 故事区间内单个已验证的生命周期步骤。 |
| SPEC_commitPreStoryWorks | 故事前区间提交命令：提交 `SPEC_openUserStory` 之前产生的导入/分析制品，包括 `pendingNews/` 到 `analyzedNews/` 的移动、`todoUS/` 故事以及 `README_UserStories.md` 台账。在 `manualMode` 下是可选命令；当导入阶段以 `analysis_mode: AUTONOMOUS` 无值守运行时作为默认的故事前检查点。故事前区间绝不运行于 `autonomousMode`，因为自主执行严格限于实现导向的故事工作。 |
| SPEC_commitStepWorks | 故事区间内的步骤提交命令：仅提交 `SPEC_openUserStory -> SPEC_closeUserStory` 区间里单个已验证的生命周期步骤，且仅在 `SPEC_makePlan` 记录为 `commit_step = yes` 的步骤边界上，并且该步骤门禁达到 `PASS`/`GREEN` 之后才提交。在 `manualMode` 下是可选命令；在 `autonomousMode` 下是每个已规划步骤边界的默认行为。 |
| SPEC_commitStoryWorks | 故事区间提交命令：把整个 `SPEC_openUserStory -> SPEC_closeUserStory` 区间提交为 just-done UserStory 提交，并包含终态生命周期/元文件变更。它承担 `pre_close` 检查点（为 `SPEC_closeUserStory` 提供 `commit_ref`）、`post_close` 检查点（满足 `close_commit_required`），以及部分关闭、中止或挂起之后的 `span_end` 检查点。在 `manualMode` 下是可选命令；在 `autonomousMode` 下是故事完成时的默认提交。 |
| SPEC_commitWorks | 通用、与故事无关的提交命令：先从暂存文件解析范围，其次取最近修改的文件，然后生成符合仓库风格的提交信息。它绝不推进 SpecFlow 生命周期状态，也绝不关闭任何提交区间。 |
| Semantic Falsification Gate | 语义证伪门禁：严格区分合法 `🔴 RED` 与 `⚠️ BROKEN_TEST` 的验证门禁。测试只有在编译/加载正常、完整执行 SETUP 与 BEHAVIOR 并**在 VERIFY 阶段严格触发预期的领域语义断言失败**（如 `AssertionError`、`Expected X but got Y`）时，才被认定为合法的 RED。若因语法错误、缺少依赖/导入、Fixture 崩溃或环境异常而失败，则标记为 `⚠️ BROKEN_TEST`，严禁借此进入生产代码编写，必须先修复测试底座。 |
| Anti-Test-Theater | 反测试演戏机制：杜绝大模型生成空洞、伪装或自我证实的虚假测试工程纪律。严禁“Mock 测试 Mock”（未经 SUT 业务逻辑直接断言 Mock 自身的返回值），严禁空洞的真假/非空断言（如 `assert != null` 或 `assert True`），强制要求断言必须验证 SUT 真实的状态流转、计算产物或领域不变量。 |
| Ambiguity Smell Classifier | 歧义坏味道分类器：在测试设计前系统性扫描自然语言需求中未声明、未详述或主观模糊之处的 Stage-0 诊断工具。基于歧义坏味道分类体系（AST），细分为六大坏味道类别：`SMELL-ACTOR`（无主语被动语态）、`SMELL-BOUND`（无边界形容词）、`SMELL-BRANCH`（缺失异常/负向分支）、`SMELL-STATE`（未声明的生命周期状态）、`SMELL-VAGUE`（含糊动词与漏洞词）以及 `SMELL-RACE`（未声明的并发规则）。一旦探测到任一坏味道，必须在 `discovery_ledger` 中记录为 `QUESTION` 状态，并强制触发全域通用的 `ONE-MORE-THING` 暂停规则，从根源切断 AI 脑补断言与幻觉。 |
| Closed-Loop Regeneration Budget (B) | 闭环再生算力预算（B）：源自 SGRM 算法 1（arXiv:2607.16680）的形式化安全边界，将随机生成的重试循环严格限制在有限预算内（默认 $B \le 3$）。当智能体在 $B$ 次重试内无法通过验证（$V(S, I) = \top$）时，严禁无限循环或暗中降低断言；必须回滚未验证的本地修改、输出结构化失败诊断报告、将 TC 标记为 `🚫 BLOCKED` 并升级上报人类治理层（L4）。 |

### Category Vocabulary

| 层级 | 分类 |
| --- | --- |
| P0 Functional | Typical, Edge, Misuse, Fault |
| P1 Design | State, Capability, Interaction, Concurrency |
| P2 Quality | Performance, Robust, Compatibility, Configuration, Diagnosis, Security |
| P3 Addons | Demo/Example |

### Ownership Vocabulary

| 层 | 职责 |
| --- | --- |
| `methodPrompts/` | 分类语义与 CaTDD 方法约束的真理源。 |
| `slashCommands/` | 对方法语义的可移植命令/流程封装。 |
| `codeAgents/` | 目标驱动编排与执行策略。 |
| `agentSkills/` | 面向非原生代码智能体的技能打包。 |

### 概念图解与实例（Diagrams and Examples）

#### 1. SUT 边界不变量（Misuse 与 Fault 的分界）

显式声明的 **SUT** 确立了契约分界线：

```mermaid
flowchart LR
    Caller["调用方 / 客户端"] -->|调用 SUT 公开 API| SUT["显式声明的 SUT 边界"]
    SUT -->|交互| Dep["外部依赖 / 环境 / 操作系统 / 硬件"]

    subgraph ErrorTaxonomy["CaTDD 错误分类体系"]
        CallerBreak["调用方违反契约<br/>(参数错误、前置条件不满足、时序错误)"] -.->|归类为| Misuse["P0 Misuse (调用误用)"]
        NormalExec["合法调用方走普通成功路径"] -.->|归类为| Typical["P0 Typical (典型成功)"]
        ValidEdge["合法调用方走边界或特殊模式"] -.->|归类为| Edge["P0 Edge (合法边界)"]
        DepFail["外部环境或依赖故障<br/>(网络中断、磁盘满、EIO、503)"] -.->|归类为| Fault["P0 Fault (外部故障)"]
    end
```

#### 2. 测试证据链（TestEvidenceChain：回答 WHY 与 HOW）

每个测试都必须建立一条从设计意图贯穿到代码实现的完整证据链：

```mermaid
flowchart TD
    subgraph WHY["第一层：WHY（为什么需要该测试：设计理由与验证义务）"]
        Source["来源工件 (契约 / 规格 / 架构模型 / 质量策略)"] --> Rule["规则 / 不变量 / 质量阈值"]
        Rule --> TP["测试点 (TP) — 验证什么 (目标靶心)"]
        TP --> Oracle["可观测预期 (Oracle：数值预算或精确谓词)"]
        Oracle --> Cat["CaTDD 分类视角 (P0 契约 / P1 模型 / P2 包络 / P3 认知)"]
    end

    subgraph HOW["第二层：HOW（如何正确进行测试：规格定义与执行验证）"]
        Cat --> Spec["US / AC / TC 活注释骨架设计"]
        Spec --> TC["测试用例 (TC) — 如何验证 (射向靶心的箭)"]
        TC --> RedGreen["四阶段测试代码 (SETUP -> BEHAVIOR -> VERIFY -> CLEANUP) -> RED -> GREEN"]
    end

    WHY --> HOW
```

#### 3. AC vs. TP vs. TC（$1 \text{ AC} : N \text{ TPs} : M \text{ TCs}$ 视角与基数）

- **验收准则 (AC)**：用户视角 —— “外部业务期望达成什么规则？”
- **测试点 (TP)**：开发者视角 —— “内部需要探测哪些边界、异常与并发条件？”（目标靶心）
- **测试用例 (TC)**：执行视角 —— “在代码中如何编写确定性的步骤与断言？”（射向靶心的箭）

实例拆解（以批量导出器为例）：

```text
AC-01 (用户业务规则):
  "GIVEN 1 到 100 条有效记录, WHEN 调用 write 时, THEN 持久化所有记录并返回 OK。"

分解为开发者技术探针测试点 (TPs):
  ├── TP-01 (Typical): 写入 2 条记录 (正常代表分区) -> 返回 OK 且数据持久化 (P0 Typical)
  ├── TP-02 (Edge):    写入 1 条记录 (最小合法边界) -> 返回 OK 且数据持久化 (P0 Edge)
  ├── TP-03 (Edge):    写入 100 条记录 (最大合法边界) -> 返回 OK 且数据持久化 (P0 Edge)
  ├── TP-04 (Misuse):  写入 0 条记录 (低于合法范围) -> 返回 INVALID_COUNT 且文件未修改 (P0 Misuse)
  └── TP-05 (Misuse):  写入 101 条记录 (高于合法范围) -> 返回 INVALID_COUNT 且文件未修改 (P0 Misuse)

映射并实现为可执行测试用例 (TCs):
  ├── TC-01: verifyWrite_byNominalBatch_expectSuccess      (覆盖 TP-01)
  ├── TC-02: verifyWrite_byBoundaryBatch_expectSuccess     (覆盖 TP-02 与 TP-03)
  ├── TC-03: verifyWrite_byZeroBatch_expectInvalidCount    (覆盖 TP-04)
  └── TC-04: verifyWrite_byOversizedBatch_expectInvalidCount(覆盖 TP-05)
```

#### 4. 发现到分类（Stage-0 到 Stage-1 的两阶段桥梁）

```mermaid
flowchart LR
    Sources["权威来源工件"] --> Sweep["全类全面扫描<br/>(分区、边界、故障、架构模型、质量预算)"]
    Sweep --> Stage0["Stage-0: 自由草拟 (Freely Drafting)<br/>(在 discovery_ledger 中广度发掘裸 TP，无目录偏见)"]
    Stage0 --> Route["按验证视角路由分类"]
    Route --> P0["P0 契约视角<br/>(Typical, Edge, Misuse, Fault)"]
    Route --> P1["P1 模型视角<br/>(State, Capability, Interaction, Concurrency)"]
    Route --> P2["P2 包络视角<br/>(Perf, Robust, Compat, Config, Diag, Sec)"]
    Route --> P3["P3 认知视角<br/>(Demo/Example)"]
    P0 --> Stage1["Stage-1: 分类设计 (Classifying Design)<br/>(固化为结构化 US/AC/TC 活注释骨架)"]
    P1 --> Stage1
    P2 --> Stage1
    P3 --> Stage1
```

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
rg -n "Typical|Edge|Misuse|Fault|State|Capability|Interaction|Concurrency|Performance|Robust|Compatibility|Configuration|Diagnosis|Security|Demo/Example|US/AC/TC|SpecCoding|VibeCoding|Source-First|TestEvidenceChain|SUT|UT|TP|TC|manualMode|autonomousMode|analysis_mode|ONE-MORE-THING" README*.md methodPrompts slashCommands codeAgents agentSkills
```

预期结果：这些术语的含义与本文件定义保持一致。
