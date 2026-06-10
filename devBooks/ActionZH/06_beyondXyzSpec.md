# 06 beyondXyzSpec

## 规格驱动开发现状

LLM 时代已催生出三个主要的规格驱动开发开源方案。它们共享一个信念——**规格先于代码 (spec before code)**——但在核心理念和适用范围上存在根本差异。

| | GitHub Spec Kit | OpenSpec | CaTDD Px-SpecFlow |
|---|---|---|---|
| **核心理念** | 文档 (`spec.md`, `plan.md`) | 变更 (`openspec/changes/`) | **用户故事 (User Stories)**（US 生命周期）|
| **Star 数** | 111k | 54k | — |
| **CLI** | Python (`specify`) | TypeScript/Node.js (`openspec`) | Markdown prompt 命令（agent 无关）|
| **Agent 集成** | 30+ | 25+ | Copilot, Cline, Continue, utCodeAgentCLI |
| **测试方法论** | 未嵌入 | 未嵌入 | **嵌入** — UT P0/P1/P2 配合 TDD |

本章审视三者，并阐释 CaTDD 的双流架构——SPEC 生命周期 + UT 验证——为何超越了独立规格驱动工具所能提供的范畴。

---

## GitHub Spec Kit — 以文档为中心的规格驱动开发

GitHub Spec Kit（111k stars, `github/spec-kit`）是一个基于 Python 的工具包，围绕四个核心文档组织开发：

```
constitution.md  →  spec.md  →  plan.md  →  tasks.md  →  implement
```

### 架构

| 制品 | 位置 | 承载内容 |
|---|---|---|
| **Constitution** | `.specify/memory/constitution.md` | 项目原则、质量标准、治理规则 |
| **Spec** | `specs/001-feature/spec.md` | WHAT & WHY — 用户故事、功能需求 |
| **Plan** | `specs/001-feature/plan.md` | HOW — 技术栈、架构、实现决策 |
| **Tasks** | `specs/001-feature/tasks.md` | 可执行的任务清单，含依赖与 `[P]` 并行标记 |

### 命令流程

```
/speckit.constitution   — 创建项目治理原则
/speckit.specify        — 定义构建什么（需求、用户故事）
/speckit.clarify        — 澄清规格不足的地方（制定计划前必须执行）
/speckit.plan           — 定义如何构建（技术栈、架构）
/speckit.tasks          — 将计划分解为可操作任务及依赖
/speckit.analyze        — 跨制品一致性与覆盖分析
/speckit.checklist      — 生成质量检查清单（"英语的单元测试"）
/speckit.implement      — 执行所有任务以构建特性
```

### 核心能力

- **扩展与预设 (Extensions & Presets)**：定制或扩展工作流。Extension 添加新命令（如 Jira 集成），Preset 覆盖模板（如合规格式、领域术语）。`.specify/templates/overrides/` 中的项目本地覆盖具有最高优先级。
- **安装方式**：`uv tool install specify-cli`，然后 `specify init <project> --integration copilot`
- **并行任务执行**：标记 `[P]` 的任务并发运行，未标记 `[P]` 的任务遵守依赖顺序。

### Spec Kit 止步于何处

Spec Kit 是一个**从规格到任务的流水线**。它告诉你构建什么以及按什么顺序，但除了通用检查清单之外，它不告诉你如何验证正确性。`/speckit.checklist` 命令生成质量验证条目，但没有嵌入的测试方法论，没有 US/AC/TC 可追溯链，没有 TDD 纪律，也没有验证状态跟踪。一旦运行 `/speckit.implement`，规格的任务即告完成——规格不会作为可验证的鲜活制品继续存在。

---

## CaTDD 从 Spec Kit 采纳的内容

CaTDD 的 Px-SpecFlow 明确记录了从 Spec Kit 采纳的六项改进，每项都适配了 CaTDD 方法论：

| Spec Kit 概念 | CaTDD 采纳 |
|---|---|
| Constitution 治理所有决策 | `.catdd/spec/projectContext.md` 作为共享护栏——`SPEC_initProjectContext` 在故事工作开始前记录稳定的原则、约束和团队约定 |
| 按优先级排序的、可独立测试的用户故事 | `SPEC_analyzeIssue` 产出的故事包含参与者、价值、优先级、独立测试意图、验收场景、边缘情况、风险和开放问题——从分析阶段即为可测试性构建 |
| 设计前明确意图 | `SPEC_clearStoryIntent` 在 `SPEC_openUserStory` 之后记录**相互意图契约 (Mutual Intent Contract)**：开发者意图、CodeAgent 意图、范围、非目标、成功信号、假设、开放问题 |
| 将 WHAT 与 HOW 分离 | `SPEC_makePlan` 创建配对的 `*-TASKs.md` 制品，将工作分类为意图澄清、需求导向、设计导向或实现导向——技术选择落在项目根 `README*` SPEC 文档中 |
| 编码前澄清/分析 | `SPEC_reviewArchDesign` 和 `SPEC_reviewDetailDesign` 作为设计质量关卡；失败的审查路由至 `SPEC_update*Design`，然后再进行下游工作 |
| 显式的、支持并行的执行切片 | US/AC/TC 切片，P0 优先排序，独立工作标记为可并行执行 |

CaTDD 采纳了 Spec Kit 的结构智慧，但将其嵌入到一个以用户故事为中心、配有集成验证引擎的生命周期中。

---

## OpenSpec — 以变更为中心的规格驱动开发

OpenSpec（54k stars, `Fission-AI/OpenSpec`）是一个基于 TypeScript 的工具，构建于不同的理念之上：**流动而非僵化，迭代而非瀑布，简易而非复杂，为既有代码库 (brownfield) 而设计，非仅全新项目 (greenfield)**。

### 架构

OpenSpec 围绕**变更 (changes)** 组织工作——`openspec/changes/` 中自包含的文件夹。每个变更都是一个关于构建或修改的提案：

```
openspec/changes/add-dark-mode/
├── proposal.md   — 为什么做这个、变更的内容是什么
├── specs/        — 需求和场景
├── design.md     — 技术方案
└── tasks.md      — 实现检查清单
```

### 命令流程

**核心工作流**（3 个命令）：
```
/opsx:propose "add-dark-mode"    — 一步创建 proposal + specs + design + tasks
/opsx:apply                       — 实现所有任务
/opsx:archive                     — 移至归档，更新 specs
```

**扩展工作流**（额外 6 个命令）：
```
/opsx:new          — 以引导上下文创建新变更
/opsx:continue     — 恢复活跃变更上的工作
/opsx:ff           — 快速完成简单任务
/opsx:verify       — 对照 specs 验证实现
/opsx:bulk-archive — 一次归档多个已完成的变更
/opsx:onboard      — 通过引导探索走查系统
```

### 核心能力

- **变更文件夹隔离**：每个变更位于自己的文件夹中，特性之间无交叉污染。变更是自包含的且可独立归档。
- **仪表板 (Dashboard)**：所有变更的可视化全景，显示状态和关系。
- **优先适配既有代码库 (Brownfield-first)**：专为现有代码库设计，而不仅是全新项目。你为已存在的内容提出变更提案。
- **安装方式**：`npm install -g @fission-ai/openspec`，然后 `openspec init`
- **自我对比**："vs Spec Kit — 全面但重量级，僵化的阶段关卡。OpenSpec 更轻量，让你自由迭代。"

### OpenSpec 止步于何处

OpenSpec 是一个**变更管理系统**，配有轻量级规格脚手架。每个变更都有 proposal、specs、design 和 tasks。但和 Spec Kit 一样，它在实现阶段止步——没有嵌入的测试方法论，没有 US/AC/TC 可追溯性，也没有验证生命周期。规格描述要变更什么，但不定义如何证明变更正确。变更被归档时即视为"完成"——没有推动闭环的 RED→GREEN 测试状态。

---

## CaTDD Px-SpecFlow — 以用户故事为中心的规格编码

CaTDD Px-SpecFlow 既不是以文档为中心，也不是以变更为中心，而是**以用户故事为中心的**。用户故事是核心生命周期制品。每个 SPEC 命令都服务于故事从接收到已验证、已审查、已提交闭环的旅程。

### 故事生命周期

```
pendingNews/  →  todoUS/  →  doingUS/  →  abortUS/ 或 doneUS/
  (原始输入)      (已分析)      (活跃中)       (已保留)       (已完成)
```

六种生命周期状态，每种都在 `.catdd/spec/` 下的版本控制目录中：

| 状态 | 目录 | 含义 |
|---|---|---|
| **pendingNews** | `pendingNews/` | 等待分析的原始 issue、feature 或导入的用户故事 |
| **analyzedNews** | `analyzedNews/` | 分析后的原始输入，作为源追溯保留 |
| **todoUS** | `todoUS/` | 已分析的用户故事，准备好被开启工作 |
| **doingUS** | `doingUS/` | 活跃的用户故事，处于设计、测试或实现阶段 |
| **abortUS** | `abortUS/` | 已中止的故事，保留以供后续重新分析或改进 |
| **doneUS** | `doneUS/` | 已完成的故事，通过审查、提交和 CI 之后 |

### SPEC 命令家族

Px-SpecFlow 提供 21 个 SPEC 命令，组织为三个生命周期阶段：

**阶段 A — 故事前：输入与分析**
```
SPEC_initProjectContext     → .catdd/spec/projectContext.md（共享章程）
SPEC_updateProjectContext   → 更新项目上下文
SPEC_importIssue            → 原始 issue → pendingNews/
SPEC_importFeature          → 原始 feature → pendingNews/
SPEC_importUserStory        → 结构化的 US → todoUS/（跳过分析）
SPEC_analyzeIssue           → pending 输入 → todoUS/ 中的用户故事 + 存档于 analyzedNews/
SPEC_analyzeFeature         → pending 输入 → todoUS/ 中的用户故事 + 存档于 analyzedNews/
SPEC_openUserStory          → 将选定故事从 todoUS/ 移至 doingUS/（工作开始）
```

**阶段 B — 设计与规划**
```
SPEC_clearStoryIntent       → 对齐开发者与 CodeAgent 的意图（相互意图契约）
SPEC_makePlan               → 分类工作导向，创建 *-TASKs.md，选择下一步命令
SPEC_updateUserStory        → 更新模块 README_UserStory.md + README_UserGuide.md
SPEC_reviewUserStory        → 在下游工作前把关需求质量
SPEC_takeArchDesign         → 初始架构设计（README_ArchDesign.md + 7 个其他文件）
SPEC_reviewArchDesign       → 把关架构质量
SPEC_updateArchDesign       → 后续架构修订
SPEC_takeDetailDesign       → 初始详细设计（README_DetailDesign.md + README_StateDesign.md）
SPEC_reviewDetailDesign     → 把关详细设计质量
SPEC_updateDetailDesign     → 后续详细设计修订
```

**阶段 C — 实现与闭环**
```
SPEC_designUnitTests        → 进入 CaTDD 测试设计（路由至 P0/P1/P2 UT 流程）
SPEC_implUnitTests          → 实现测试用例（通过 UT 命令进行 RED→GREEN）
SPEC_implProductCodes       → 实现生产代码以通过测试
SPEC_reviewProductCodes     → 审查实现质量
SPEC_refactorIssue          → 将质量问题路由回设计/测试/代码
SPEC_abortUserStory         → 中止活跃故事 → abortUS/（保留以供重新分析）
SPEC_commitWorks            → 准备并提交已完成的工作
SPEC_closeUserStory         → 将已审查、已提交的故事移至 doneUS/
```

### CaTDD 的独特之处

Px-SpecFlow 的创新超越了 Spec Kit 和 OpenSpec 所提供的范畴：

**1. 以用户故事为中心，而非以文档为中心或以变更为中心。** Spec Kit 围绕 `spec.md`/`plan.md`/`tasks.md` 这些文档展开。OpenSpec 围绕 `changes/` 这些提案文件夹展开。CaTDD 围绕**用户故事本身**作为鲜活制品展开，经历六种生命周期状态。每个 SPEC 命令都服务于故事的旅程。故事从原始导入、经分析待办、活跃进行中、可能中止、到最终闭环，拥有显式的存在状态。

**2. 相互意图契约。** Spec Kit 和 OpenSpec 都没有在开始设计前对齐人类与 LLM 意图的机制。CaTDD 的 `SPEC_clearStoryIntent` 记录一个契约：开发者认为故事是什么，CodeAgent 推断出什么，范围内工作，范围外工作，成功信号，假设和开放问题。意图未对齐，设计不开始。

**3. `SPEC_abortUserStory` — 显式的失败保留。** 当活跃故事存在阻塞性的范围问题、无效假设或不应就地修补的质量问题时，CaTDD 将故事中止到 `abortUS/` 中作为保留历史。中止生命周期反馈到 `SPEC_analyzeUserStory` 或 `SPEC_importIssue`，以便进行深思熟虑的重新分析。Spec Kit 和 OpenSpec 都没有显式的中止并保留路径。

**4. `SPEC_makePlan` — 工作导向分类。** 在任何下游工作之前，`SPEC_makePlan` 将故事分类为四种导向之一：意图澄清、需求导向、设计导向或实现导向。它区分初始设计（`SPEC_take*Design`）与后续修订（`SPEC_update*Design`）。它创建配对的 `*-TASKs.md` 制品，以 Markdown 复选框任务的形式展示所需的下一步步骤。

**5. 项目根 README SPEC 文档。** CaTDD 管理 11 种项目根架构/详细文档类型，每种有明确的用途和负责人：

| 面向架构 (Architecture-Oriented) | 面向详细设计 (Detail-Oriented) |
|---|---|
| `README_ArchDesign.md` — 模块分解、依赖、权衡 | `README_DetailDesign.md` — 类设计、API 签名 |
| `README_UsageDesign.md` — 公共边界、CLI/API 契约 | `README_StateDesign.md` — 状态机、生命周期、并发 |
| `README_ErrorDesign.md` — 容错、故障安全状态 | |
| `README_ResourceDesign.md` — 资源分配、内存/CPU 预算 | |
| `README_PerfDesign.md` — 性能预算、延迟限制 | |
| `README_CompatDesign.md` — 兼容性矩阵、平台版本 | |
| `README_DiagnosisDesign.md` — 可观测性、日志、遥测 | |
| `README_VerifyDesign.md` — 验证拓扑、测试策略 | |

这些不是在初始化时一次性生成的模板——它们由 SPEC 命令按需创建，仅在项目需要该维度的文档时生成。

**6. 按命令的模型层级指导。** 每个 SPEC 命令都分配了一个模型层级——SOTA reasoning 用于架构决策，High Performance 用于多制品推理和审查，Flash Speed 用于确定性的生命周期移动。这避免了在简单任务上过度支付计算开销，也避免了在架构级别的决策上投入不足。

---

## UT 流程 — CaTDD 的嵌入式验证引擎

这是决定性的差异化因素。**Spec Kit 和 OpenSpec 都没有测试方法论。** 它们描述构建什么以及按什么顺序，止步于实现阶段。CaTDD 走得更远：它将完整的、按类别驱动的 TDD 方法论嵌入到规格生命周期中。

### 双流架构

```
                        SPEC Flow (Px-SpecFlow)
                        以用户故事为中心的生命周期
                                │
                ┌───────────────┼───────────────┐
                ▼               ▼               ▼
          Pre-Story        Design & Plan     Implementation
        (import, analyze,  (intent, arch,    (test design,
         open)              detail)           impl, review)
                                                  │
                                                  ▼
                                          SPEC_designUnitTests
                                                  │
                              ┌───────────────────┼───────────────────┐
                              ▼                   ▼                   ▼
                         P0-FuncTestsFlow    P1-DesignTestsFlow   P2-QualityTestsFlow
                              │                   │                   │
                    Typical→Edge→Misuse→Fault  State→Cap→Concur   Perf→Robust→Compat→Config
                              │                   │                   │
                              ▼                   ▼                   ▼
                         UT_implTestCase (RED→GREEN cycle for each TC)
```

当 `SPEC_designUnitTests` 运行时，它生成的不是"编写测试"这样的通用任务，而是路由到 CaTDD 的 UT 流程中——P0 功能验证、P1 面向设计的测试、P2 质量属性。每个流程有其自己的命令序列、审查关卡和 Design Source Gate（设计源关卡）要求。

### UT 流程提供的、其他规格工具都不具备的能力

**1. 按类别驱动的测试设计。** 12 种测试类别，每种有其自己的 method prompt（`CaTDD_methodPrompt4Cat-*.md`）、设计骨架契约、使用时机/避免时机规则和常见错误清单。一个设计 Typical 骨架的 CodeAgent 阅读 `4Cat-Typical.md` 后，会精确知道应用什么模式、词汇和约束。

**2. 嵌入测试文件的 US/AC/TC 可追溯性。** 规格说明**不**存在于单独的文档中。User Story、Acceptance Criteria 和 Test Case 规格以结构化注释的形式存在于与测试代码相同的文件中。当规格变化时，注释随之变化。当注释变化时，LLM 重新生成测试。不存在规格与代码之间的间隙。

**3. P1 和 P2 的 Design Source Gate（设计源关卡）。** 在任何 P1 或 P2 骨架起草之前，必须存在所需的项目根设计文档：

| P1 类别 | 所需源文件 |
|---|---|
| State | `README_StateDesign.md` 或 `README_ArchDesign.md` 中的 `State Design` 章节 |
| Capability | `README_DetailDesign.md` |
| Concurrency | `README_ResourceDesign.md` |

如果设计源缺失，UT 命令**停止并请求开发者**——不做猜测，不凭空编造架构决策。

**4. 集成到生命周期的 TDD RED→GREEN 纪律。** 每个测试用例都有状态标记：
```
⚪ TODO/PLANNED  →  🔴 RED/FAILING  →  🟢 GREEN/PASSED
```
`SPEC_implUnitTests` 命令调用 `UT_implTestCase`，遵循严格的循环：编写测试（RED），实现最小化生产代码（GREEN），审查（TRACE）。故事在所有必需的 TC 都为 GREEN 之前不能关闭。

**5. 各层的质量关卡。** 直到所有 P0 测试为 GREEN，你不得从 P0 推进到 P1。直到架构验证通过（无死锁、无竞态条件、ThreadSanitizer 干净），你不得从 P1 推进到 P2。每个关卡是开发者在继续之前审查并批准的检查点。

---

## 三向对比

| 维度 | GitHub Spec Kit | OpenSpec | CaTDD Px-SpecFlow |
|---|---|---|---|
| **重心** | 文档 (`spec.md`, `plan.md`) | 变更 (`openspec/changes/`) | **用户故事**（生命周期状态）|
| **生命周期状态** | 3 种隐式 (spec → plan → tasks) | 3 种显式 (propose → apply → archive) | **6 种显式** (pending → analyzed → todo → doing → abort/done) |
| **中止机制** | 无（手动关闭 issue/PR）| 无（手动删除变更文件夹）| **`SPEC_abortUserStory`** — 保留在 `abortUS/`，有重新分析路径 |
| **意图对齐** | 自由形式的澄清对话 | 自由形式的对话 | **相互意图契约** (`SPEC_clearStoryIntent`) |
| **测试方法论** | 无嵌入（仅检查清单）| 无嵌入 | **嵌入的 CaTDD** — P0/P1/P2 UT 流程，12 种类别 |
| **规格-代码差距** | spec.md → plan.md → code (3 个文档) | proposal.md → design.md → code (3 个文档) | **无差距** — US/AC/TC 注释与测试代码存在于同一文件 |
| **TDD 集成** | 不存在 | 不存在 | **RED→GREEN 循环**，配 ⚪→🔴→🟢 状态标记 |
| **注释鲜活的设计** | 否 — 文档与代码分离 | 否 — 文档与代码分离 | **是** — 设计骨架存在于测试文件中 |
| **优先级框架** | 无 | 无 | **P0(核心)→P1(设计)→P2(质量)→P3(附加)** |
| **设计源关卡** | 无 | 无 | **是** — P1/P2 要求确认的 README_* 文档 |
| **模型层级指导** | 不存在 | 推荐高推理模型 | **按命令层级映射** (SOTA/HighPerf/Flash) |
| **审查关卡** | `/speckit.analyze` (跨制品) | `/opsx:verify` (实现后) | **6 个审查关卡**：架构→详细→故事→测试→代码→提交 |
| **制品持久化** | 文件系统 (specs 目录) | 文件系统 (changes 目录) | **团队共享的 `.catdd/spec/`，每种制品有提交策略** |
| **项目根文档** | Spec + plan，然后手动 | Proposal + design，然后手动 | **11 种 README* SPEC 文档类型**，通过 SPEC 命令按需创建 |
| **既有代码库 (Brownfield)** | 主要是全新项目 (greenfield) | **优先既有代码库** (为现有代码库设计) | **两者皆可** — 将现有代码分析为 US/AC/TC |
| **安装方式** | `uv tool install specify-cli` (Python) | `npm install -g @fission-ai/openspec` (TypeScript) | Markdown prompt 文件 (agent 无关) |
| **Agent 集成** | 30+ | 25+ | Copilot, Cline, Continue, utCodeAgentCLI |
| **定制化** | Extensions + presets + overrides | 社区 schemas | `methodPrompts/` 为真理之源，`slashCommands/` 为命令层，`agentSkills/` 为包 |

---

## 为什么 CaTDD 是 BEYOND 的

Spec Kit 和 OpenSpec 都是有价值的工具，它们解决了规格优先的问题，但只解决了一半。

**Spec Kit** 给你一个结构化的流水线：constitution → spec → plan → tasks → implement。它告诉你构建什么，按什么顺序，用什么技术。但当实现完成时，你只有代码——除了检查清单，没有系统性的正确性证明。

**OpenSpec** 给你流动的变更管理：propose → apply → archive。它告诉你什么变了，设计是什么，运行什么任务。但归档后，你有一个已完成的变更——但没有嵌入式的验证来证明该变更满足自己的验收标准。

**CaTDD Px-SpecFlow** 两者都给你——而且走得更远：

1. **它管理用户故事的全生命周期**，从原始导入到已验证闭环，并在范围或假设错误时提供显式的中止路径。

2. **它在设计开始前对齐人类与 LLM 的意图**，避免了 LLM 驱动开发中最昂贵的错误：完美地构建了错误的东西。

3. **它嵌入完整的测试方法论 (UT P0/P1/P2)** 到规格生命周期中。每个用户故事的验收标准由按类别驱动的测试用例验证。每个测试用例驱动一个 RED→GREEN TDD 循环。每个 GREEN 测试证明故事的一个片段是正确的。

4. **它消除规格-代码间隙。** 规格说明以结构化注释 (`@[US]`, `@[AC]`, `@[TC]`) 存在于与测试代码相同的文件中。当代码变化时，注释随之变化。当注释变化时，测试随之变化。规格与验证不可分离。

5. **它按领域重要性分类验证。** P0 测试你的核心域（使你的业务独特的内容）。P1 测试你的架构。P2 测试你的质量属性。这是 DDD 的战略设计应用于验证——它告诉 LLM 不仅要"测试这个"，还要"测试这个，因为它对业务至关重要"。

### 规格驱动堆栈

将它们看作规格驱动开发堆栈的层次：

```
┌────────────────────────────────────────────────┐
│  CaTDD Px-SpecFlow + UT flows                   │
│  "证明它是正确的"                                 │
│  用户故事生命周期 + 嵌入式 TDD                     │
├────────────────────────────────────────────────┤
│  Spec Kit / OpenSpec                            │
│  "决定构建什么以及如何构建"                        │
│  以文档为中心或以变更为中心                        │
├────────────────────────────────────────────────┤
│  AI Coding Agents (Copilot, Cline, Claude, ...) │
│  "生成代码"                                      │
└────────────────────────────────────────────────┘
```

Spec Kit 和 OpenSpec 运行在中间层——它们结构化构建什么。CaTDD 运行在顶层——它验证构建出来的东西是否正确。它们不是竞争对手，而是互补的。

但如果你只能选一个，必须在"知道构建什么"和"知道构建出来的东西是正确的"之间做出选择——CaTDD 给了你不同于任何单独的规格优先工具的验证保证。

> **Comments is Verification Design. LLM Generates Code. Iterate Forward Together.**
