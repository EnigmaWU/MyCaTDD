# 04 asyncCodeAgent

## 什么是 Code Agent？

代码 agent（Code Agent）是一种自主执行开发任务的软件工具。它读取方法规格、规划工作、调用命令、生成代码、运行测试、收集结果，并将经验教训反馈回方法论体系中。它不是一个聊天机器人——它是一个无需持续人工提示即可运行的执行引擎。

在 CaTDD 中，代码 agent 是四层架构中的第三层。它位于 methodPrompts（定义做什么）和 slashCommands（定义如何调用步骤）之下，以及 agentSkills（为其他 agent 封装能力）之上。代码 agent 是**智能执行层**——它闭合了从可复用的 CaTDD 知识到规范化的 CaTDD 原生执行之间的循环。

---

## 两种代码 Agent

MyCaTDD 定义了两种职责各异的代码 agent：

### utCodeAgentCLI —— 单元测试 Agent

`utCodeAgentCLI` 是 CaTDD 原生的单元测试 agent。它专注于一个关注点：将开发者目标转化为经过验证的单元测试。

**做什么**：
- 接收开发者目标（例如"为 EventQueue API 设计和实现 P0 功能测试"）
- 依据 CaTDD 方法约束（优先级顺序、类别规则、质量关卡）规划工作
- 调用标准化的 slash 命令步骤（`UT_designTypicalSkeleton`、`UT_implTestCase` 等）
- 收集执行追踪记录（运行了什么、通过了什么、失败了什么、被阻塞了什么）
- 反思结果（结果是否正确？是否发生了意外情况？）
- 将可复用模式反馈给 methodPrompts 和 slashCommands

**不做什么**：
- 不决定产品意图——由开发者掌控
- 不重新定义 CaTDD 方法语义——由 methodPrompts 掌控
- 不管理 SpecFlow 生命周期——由 specCodeAgentCLI 掌控（或由开发者直接驱动）

### specCodeAgentCLI —— 规格 Agent

`specCodeAgentCLI` 是面向 SpecCoding 的 agent。它专注于模块级从输入到输出的流转——从 Issue 导入到故事关闭的完整生命周期。

**做什么**：
- 基于 Px-SpecFlow 生命周期规则运作
- 在测试设计和实现阶段复用 utCodeAgentCLI 的单元测试优势
- 组织从规格意图到可执行检查的场景级验证
- 保持 Spec 流程、验证检查点和实现结果之间的可追溯性

**工作管线**：

```text
开发者目标 → specCodeAgentCLI（生命周期编排）
                      │
                      ▼
                 SPEC_* 命令（导入、分析、设计、审查）
                      │
                      ▼ （准备进行测试时）
                 utCodeAgentCLI（单元测试设计与执行）
                      │
                      ▼
                 UT_* 命令（设计骨架、实现 TC、审查）
                      │
                      ▼
                 SPEC_* 命令（审查代码、提交、关闭故事）
```

两个 agent 共同自动化了从"我们有一个功能请求"到"测试通过、代码已提交、故事已关闭"的完整路径。

---

## CaTDD 原生契约

CaTDD 原生的代码 agent 不是通用的 LLM 封装器。它与 CaTDD 方法论之间有一个明确的契约：

1. **保留评论骨架契约** —— agent 必须读取、保留和更新 `@[US]`、`@[AC]`、`@[TC]`、`@[Category]` 和状态标记。这些是结构性的，而非装饰性的。

2. **遵循优先级纪律** —— agent 必须先在 P0 完成之后再进行 P1，先在 Typical 完成之后再进行 Edge，并尊重上下文相关的优先级调整和风险评分。

3. **维护 US/AC/TC 可追溯性** —— 每个测试用例必须追溯到一条验收标准，每条验收标准必须追溯到一个用户故事。agent 必须在跨文件场景下保留这些链接。

4. **尊重质量关卡** —— agent 必须在每个关卡处停止，并在推进到下一优先级级别之前验证标准。不允许跳过关卡。

5. **遵守状态标记** —— agent 必须保持 ⚪→🔴→🟢 标记准确无误，并在测试文件和 TODO 跟踪区间保持同步。

6. **向上游层次反馈** —— 当 agent 发现一个应该可复用的模式时，将其反馈给 slashCommands（作为新的命令流程）和 methodPrompts（作为方法论的改进）。

---

## Agent 工作流检查清单

CaTDD 方法提示词定义了一个包含四个阶段的完整 Agent 工作流检查清单。这是每个 CodeAgent 的执行脚本：

### 阶段 1：理解（只读分析）

在任何设计或实现之前，agent 必须：

1. **读取组件接口文件** —— 定位并读取 API 头文件，识别公共函数、数据结构、常量、签名和返回类型。

2. **研究现有的相关测试** —— 搜索已有的测试文件，审查相似的测试模式，识别可复用的 fixture 和辅助函数。

3. **识别依赖关系和约束** —— 检查构建文件中的依赖关系，审查设计文档，必要时阅读源码实现，注意特殊的构建要求。

4. **与开发者澄清模糊之处** —— 如果 API 行为不明确，提出具体问题。如果需求模棱两可，提出替代方案。如果上下文不充分，请求具体的文件。

**检查点 1 输出**：

```
"我已分析了 [组件]。它提供 [关键能力]。

审查的文件：
- 接口：Include/[HeaderFile.h]
- 实现：Source/[SourceFile.c]
- 已有测试：Test/UT_[Related].cxx
- 文档：README_[Topic].md

关键 API：[列出 3-5 个主要函数]
依赖关系：[列出主要依赖项]
不明确的方面：[如有，列出问题]

是否继续进入测试设计？"
```

Agent 在此处停止。在开发者确认理解正确之前，不推进到设计阶段。

### 阶段 2：设计（编写注释——尚无代码）

Agent 在结构化注释中创建全面的测试设计：

1. **填充 OVERVIEW 区域** —— WHAT、WHERE、WHY、SCOPE（范围内 vs 范围外）、KEY CONCEPTS。

2. **定义覆盖矩阵维度** —— 识别 2-3 个关键维度以实现系统化覆盖，创建展示维度组合的表格，将组合映射到潜在的用户故事。

3. **编写用户故事（2-5 个）** —— 作为 [角色]，我想要 [能力]，以便 [价值]。每个故事应独立有价值。覆盖成功和错误两种场景。

4. **编写验收标准（每个 US 2-4 条）** —— GIVEN/WHEN/THEN 格式，可独立测试，对预期行为和错误码描述具体。

5. **细化测试用例（每条 AC 至少 1 个）** —— 名称、目的、简述、步骤、期望、备注。使用优先级框架进行分类。全部标记为 ⚪ TODO。

6. **填充 TODO 跟踪区** —— 列出所有计划中的测试用例，包含状态、优先级指示器和所有依赖/阻塞说明。

**检查点 2 输出**：

```
"[组件] 的测试设计已完成：
- 覆盖范围：[X] 个用户故事，[Y] 条验收标准，[Z] 个测试用例
- 优先级分布：P0=[数量]，P1=[数量]，P2=[数量]
- 已覆盖的关键场景：[列出 3-5 个主要场景]
- 预估实现工作量：[粗略估算]

是否继续进入实现阶段？"
```

Agent 在此处也停止。设计审批必须先于实现。

### 阶段 3：实现（TDD Red→Green 循环）

这是最详细的阶段，因为它覆盖了按优先级级别执行的完整 Red→Green 循环。

#### 3A：Fast-Fail Six（快速验证）

Agent 优先实现以下六个测试，因为它们能尽早捕获 API 契约违规：

1. Null/Empty 输入处理
2. Zero/Negative 超时
3. Duplicate 注册/订阅
4. 非法调用顺序（init 前、cleanup 后）
5. Buffer full/empty 边界
6. Double-close/re-init 幂等性

全部六个标记为 🔴 RED，运行，确认全部失败，报告。

#### 3B：P0 功能 —— ValidFunc（Typical + Edge）

Agent 依次完成 Typical 然后 Edge 测试：
- 实现测试（四阶段：SETUP/BEHAVIOR/VERIFY/CLEANUP）
- 标记为 🔴 RED
- 运行，确认 RED（失败）
- 实现最小量产品代码
- 运行，确认 GREEN（通过）
- 标记为 🟢 GREEN
- 提交
- 移至下一个测试

#### 3C：P0 功能 —— InvalidFunc（Misuse + Fault）

同样的循环，先 Misuse 后 Fault 测试。

**关卡 P0 检查点**：在推进到 P1 之前，agent 必须验证：
- 所有 P0 ValidFunc 测试为 GREEN（Typical + Edge）
- 所有 P0 InvalidFunc 测试为 GREEN（Misuse + Fault）
- Fast-Fail Six 全部通过
- 被测试模块的代码覆盖率 ≥80%
- 无内存泄漏（使用 sanitizer 运行）
- 无关键功能 Bug

Agent 报告关卡状态并询问："P0 完成。是否继续 P1？"

#### 3D：P1 设计导向测试（如适用）

State → Capability → Concurrency，遵循相同的 RED→GREEN 循环。

**关卡 P1 要求**：ThreadSanitizer/AddressSanitizer 干净，无死锁，无竞态条件，架构按设计要求验证通过。

#### 3E：P2 质量导向测试（如需要）

Performance → Robust → Compatibility → Configuration。

**关卡 P2 要求**：性能 SLO 已满足，压力/浸泡测试通过，生产就绪标准达标。

### 阶段 4：收尾与文档

Agent：
1. 重构测试以提升清晰度（提取公共 fixture、移除重复、简化）
2. 更新文档（确保注释反映实际实现，清除过时的 TODO 条目）
3. 记录已知限制或问题
4. 将所有已完成的测试标记为 🟢 GREEN
5. 提供完成报告

**最终检查点**：

```
"[组件] 的测试已完成：
✅ 已实现测试：[数量]（P0=[n], P1=[n], P2=[n]）
✅ 测试覆盖率：[百分比]%
✅ 全部测试通过：[是/否]
⚠️ 已知问题：[如有，列出]
🚫 阻塞项：[如有，列出]

下一步：[建议]"
```

---

## Agent 故障排除：六大常见问题

CaTDD 方法提示词为 agent 定义了故障排除指南。六大问题覆盖了最常见的失败模式：

### 问题 1：测试编译失败

**Agent 解决方式**：
1. 根据项目的 include 模式检查 #include 语句
2. 根据头文件验证函数签名（而非假设）
3. 检查缺失的测试工具函数
4. 向开发者反馈具体错误详情以及已检查过的内容

### 问题 2：测试设计似乎不完整或有误

**Agent 解决方式**：
1. 验证对齐性：TC → AC → US 可追溯链
2. 检查覆盖矩阵的完备性（预期 vs 实际场景）
3. 根据已知行为验证测试期望
4. 审查 Fast-Fail Six 清单中遗漏的覆盖项

### 问题 3：产品代码行为不明确

**Agent 解决方式**：
1. 在代码库中搜索相似模式（错误码、AC 示例、命名模式）
2. 按顺序阅读组件文档：spec → 架构 → 术语表 → 设计文档 → 源码注释
3. 检查已有测试中的行为规格
4. 向开发者提供 2-3 个具体备选方案（而非开放式地提问"这应该怎么做？"）

### 问题 4：测试意外失败

**Agent 解决方式**：
1. 验证测试设置是否正确（初始化、前置条件、资源创建）
2. 添加诊断输出（打印实际值 vs 预期值、中间状态）
3. 检查测试隔离性（先前测试的清理情况、全局状态污染）
4. 向开发者报告发现结果，附带具体的预期值/实际值和诊断输出

### 问题 5：无法继续 / 被阻塞

**Agent 解决方式**：
1. 明确说明阻塞因素：缺少什么、影响、已考虑的权宜方案
2. 在 TODO 区域使用 🚫 BLOCKED 标记记录，注明依赖关系和预估工作量
3. 提出具体的后续步骤，包含选项（例如：先实现缺失的 API、推迟被阻塞的测试、使用硬编码常量并标记 TODO）
4. 继续未阻塞的工作——绝不空闲等待

### 问题 6：测试在应该失败时却通过了（RED 阶段）

**Agent 解决方式**：
1. 验证测试确实被执行（添加 printf、添加临时失败断言）
2. 检查该功能是否已存在（产品代码是否在预期位置？）
3. 验证测试断言是否有实际意义（不仅仅是"发生了某事"）
4. 必要时更新测试设计——如果功能已完成则标记 GREEN，如果测试太弱则增强

---

## Agent 的"该做与不该做"契约

方法提示词为 agent 定义了明确的行为规则：

**该做（DO）**：
- 尽早提出澄清问题（阶段 1）——在设计开始之前
- 在检查点处等待人工审批——绝不自行推进
- 每次测试操作后立即更新 TODO 区域——状态必须反映实际
- 严格遵循 RED→GREEN 纪律——绝不跳过 RED 阶段
- 每次达成 GREEN 后提交——小规模、可追溯的提交
- 频繁运行测试，立即报告失败——避免在最后出现意外

**不该做（DON'T）**：
- 不经设计直接跳到实现——设计就是评论骨架
- 在编写测试之前实现产品代码——违反 TDD
- 让测试一直保持 RED 而不处理——RED 意味着"需要行动"
- 将多个功能批量放入一个测试——一个 TC，一个行为
- 凭空猜测需求——改为提出询问
- 在完成 P0 之前实现 P1/P2——优先级纪律是不可妥协的

---

## 追踪收集与反思

CaTDD 代码 agent 不仅仅是一个执行器——它是一个**学习者**。在完成一个会话后，它会收集：

### 执行追踪

- 调用了哪些命令及其顺序
- 读取和写入了哪些文件
- 设计和实现了哪些测试用例
- 哪些通过了（GREEN），哪些失败了（RED），哪些被阻塞（🚫）
- 遇到了哪些错误以及如何解决
- 向开发者提出了哪些问题以及收到了哪些答复

### 反思记录

- 是否存在跨多个测试文件重复出现的模式？
- 是否有对该组件而言不需要的类别？
- 事后回想，是否有本应更早优先处理的类别？
- 开发者的回复是否持续暗示方法提示词存在缺口？
- 某个故障排除方式是否应该成为 agent 的标准行为？

### 反馈循环

Agent 将反思记录反馈给上游层次：

```
Agent 发现模式 → 规范化为 slash 命令 → 添加到 slashCommands/
Agent 发现方法缺口 → 改进方法提示词 → 更新 methodPrompts/
Agent 发现可复用技能 → 封装为 agent 技能 → 更新 agentSkills/
```

这就是双向改进循环的实际运作。每次 agent 执行都会为未来所有执行改进方法论。

---

## utCodeAgentCLI 架构

在当前仓库阶段，`utCodeAgentCLI` 是一份已文档化的架构和设计契约——可运行的 CLI 实现正在进行中。该架构将两个系统分开：

1. **AgentSDK**：一个通用的 LLM agent 运行时库。它了解目标、消息、工具、会话、权限、追踪、钩子、适配器和执行控制。**它不了解 CaTDD。**

2. **utCodeAgentCLI**：构建于 AgentSDK 之上的 CaTDD 应用程序。它解析 CLI 参数，将 CaTDD 行为解析为可移植的 slash 命令，注入方法提示词引用，保留 US/AC/TC 可追溯性，并记录 CaTDD 执行追踪。**它是一个编排器，而非方法所有者。**

这种分离是架构中最重要的风险缓解措施：一个便捷的 CLI 很容易滑向重复 CaTDD 语义、自行定义类别含义或绕过可移植 slash 命令契约。通过保持 AgentSDK 通用化、utCodeAgentCLI 轻薄化，架构防止了方法漂移。

### 测试文件状态模型

utCodeAgentCLI 通过正式的状态模型跟踪每个测试文件：

```
EMPTY ──(designSkeleton)──► DESIGNED ──(implTestCase)──► PARTIAL
                                  │                          │
                                  │                          ▼
                                  │                 FULLY_RED ──(用户修复)──► ALL_GREEN
                                  │
                                  └──(在 DESIGNED 上执行 designSkeleton)──► DESIGNED（添加 TC）
```

| 文件状态 | 描述 |
|---|---|
| **EMPTY** | 文件中不存在 CaTDD 骨架 TC |
| **DESIGNED** | 所有 TC 为 `@[Status:PLANNED]` — 设计完成，尚未实现 |
| **PARTIAL** | 混合 PLANNED、RED 和 GREEN — 部分已实现，部分未实现 |
| **FULLY_RED** | 所有 TC 为 RED 或 GREEN，无 PLANNED — 全部测试代码已编写 |
| **ALL_GREEN** | 所有 TC 为 GREEN — 测试通过，覆盖达成 |

CLI 拥有 `PLANNED → RED` 的转换（编写测试代码）。`RED → GREEN` 的转换是**用户拥有的**——CLI 读取 GREEN 状态但永远不写入它。这保留了 TDD 契约：由人（或人工批准的产品代码）将 RED 变为 GREEN。

### 行为状态契约

每个 `--behave` 值都与文件状态有精确的契约：

| 行为 | 要求 | 产出（TC 状态） | 产出（文件状态） |
|---|---|---|---|
| `design*Skeleton` | Any | 新 TC → PLANNED | DESIGNED 或 PARTIAL |
| `review*Skeleton` | DESIGNED, PARTIAL, FULLY_RED | 不变 | 不变 |
| `tellMeNextImplTest` | 至少 1 个 PLANNED TC | 不变 | 不变 |
| `implTestCase` | 目标 TC 为 PLANNED | 目标 TC → RED | PARTIAL 或 FULLY_RED |
| `implTestFile` | 至少 1 个 PLANNED TC | 所有 PLANNED → RED | FULLY_RED |
| `designAndImplTest` | Any | 所有 TC → RED | FULLY_RED |

**状态保留保证**：
1. 绝不降级状态（RED → PLANNED 永不发生）
2. 绝不在无明确意图的情况下覆盖已实现的 TC
3. 状态不匹配的行为以清晰错误退出
4. 每次状态转换都记录在执行追踪中

### 核心组件

| 组件 | 职责 |
|---|---|
| **Parser** | 解析开发者命令：`--goal`、`--target`、`--input`、`--behave`、`--model-tier` |
| **Planner** | 将目标分解为有序的 slash 命令调用序列 |
| **Executor** | 针对 CodeAgent 运行时（模型提供方 + 工具表面）调用 slash 命令 |
| **Adapter** | 将可移植的命令契约适配到特定的模型运行时（Copilot API、Cline 协议、直接 LLM） |
| **Trace** | 收集结构化执行日志：命令、TC、状态转换、时间戳、错误 |
| **Diagnostics** | 验证执行质量：RED→GREEN 完整性、关卡合规、可追溯性保留 |
| **State** | 管理 agent 会话状态：活跃目标、当前阶段、待处理检查点 |
| **Error** | 处理 agent 错误：模型失败、畸形输出、缺失工作制品、前置条件不满足 |

### CLI 接口设计

```bash
utCodeAgentCLI \
  --goal "Design and implement P0 functional tests for EventQueue" \
  --target codeAgents/utCodeAgentCLI/tests/UT_EventQueue.ts \
  --input spec/EventQueue.h \
  --behave designFuncTestsSkeleton \
  --model-tier high-performance
```

`--target` 参数定义测试空间范围：一个 TestFile 中的一个 TestCase，一个 TestFile，或若干 TestFiles。`--input` 参数携带源/上下文，如接口、协议、模式、草稿或产品源代码。`--behave` 参数指定一个兼容的 UT slash 命令行为或一个稳定的 CLI 别名。

### 运行时决策

utCodeAgentCLI 架构设计包含以下决策：

- **V1（PoC）**：TypeScript/Node.js —— 快速原型开发，便于为 Copilot 和类似 agent 集成 Adapter SDK
- **V2（生产）**：Go —— 编译后单一二进制文件，零运行时依赖，易于分发
- **Python**：已评估但未选择 —— 并发 agent 会话的性能问题，协议契约的类型检查较弱

### 用户故事层次结构

utCodeAgentCLI 的需求按角色而非功能组织：

| 角色 | 故事数 | 关注点 |
|---|---|---|
| **USER** | 10 个故事 | 引导式发现（NEW-USER）和精准控制（EXPERIENCED-USER） |
| **INVENTOR** | 3 个故事 | 方法委托验证、可追溯性完整性、诊断证明 |
| **DEVELOPER** | 5 个故事 | 错误消息、日志记录、交互模式、适配器接口、可靠性策略执行 |

**USER 旅程**：NEW-USER 遵循引导式发现（验证 → 设计所有骨架 → 审查所有层级 → 选择下一个 → 设计与实现）。EXPERIENCED-USER 使用精准控制（验证 → 单一类别设计 → 层级审查 → 实现一个 TC → 审查实现）。两种路径都生成机器可读的执行追踪。

**INVENTOR 需求**确保 CLI 是 CaTDD 的忠实代理：它必须引用 `methodPrompts` 获取类别语义（绝不硬编码）、必须经过 `slashCommands` 实现可移植执行（绝不绕过）、必须生成结构化的追踪文件以证明这些约束得到了满足。

**DEVELOPER 需求**涵盖运行时质量：为每种已知失败模式提供确定性错误消息、可配置级别的结构化日志、审查关卡的交互式确认模式（含 CI 安全的非交互回退方案）、针对不同模型运行时的清晰适配器边界，以及可执行的可靠性/安全契约。

### 非需求（utCodeAgentCLI 不拥有什么）

与 CLI 做什么同样重要的是它明确不做什么：

| 关注点 | 所有者 |
|---|---|
| 定义 CaTDD 类别、纪律规则或方法含义 | `methodPrompts/` |
| 定义可移植的 slash 命令执行逻辑 | `slashCommands/` |
| 将 CaTDD 封装为通用 CodeAgent 技能 | `agentSkills/` |
| 编译、运行或验证测试代码 | 用户的构建系统 |
| 生成产品/源代码 | CLI 仅生成测试代码 |
| 管理 git 分支、提交或版本控制 | 用户的工作流程 |
| 将 TC 从 RED 转为 GREEN | 用户的 TDD 工作流程 |

### 架构层重要需求（ASR）

utCodeAgentCLI 架构定义了六项在架构边界层面运作的可靠性/安全需求：

| ASR | 需求 | 信号 |
|---|---|---|
| **ASR-R1** | 重试与修正循环在预算耗尽时应为有界且确定性 | 明确的重试预算拥有者和确定性的耗尽路径 |
| **ASR-R2** | 未知或不支持的行为路由应为确定性且可诊断 | 无静默强制转换；明确的诊断回退 |
| **ASR-R3** | 故障处理应区分暂时性和永久性类别，并具有明确路由 | 故障分类法和类别特定的控制流 |
| **ASR-R4** | 多步执行应定义快照/回滚或补偿边界 | 步骤边界一致性模型和失败后的变更控制 |
| **ASR-R5** | 升级策略应定义阈值和非交互行为 | 明确的升级触发器和 CI 安全的中止动作 |
| **ASR-R6** | Shell 执行应强制执行安全策略和敏感路径保护 | 白名单执行模型、敏感路径把关、脱敏策略 |

这些 ASR 可追溯到 DEVELOPER 需求（US-DEV-05）中的可执行 US/AC 契约。每个 ASR 都映射到具体的验收标准——它们不是空洞的愿景声明，而是产出可验证验收信号的架构层需求。

### 架构决策记录（ADR）

关键架构决策以 ADR 形式被正式记录：

**ADR：运行时语言** —— utCodeAgentCLI 采用阶段性运行时决策：
- **V1（PoC）**：TypeScript on Node.js —— 目标适配器生态（Copilot SDK、MCP、OpenCode）原生基于 Node/TypeScript，因此 TS/Node 提供一流的适配器，无需跨语言桥接
- **V2（生产）**：Go —— 因其静态单一二进制输出而被预选用于生产分发；待生产范围开启后由后续 ADR 确认
- **Python**：已评估但未选择 —— 脚本编写速度的优势在 PoC 中无法胜过适配器集成成本

ADR 记录了完整的决策过程：问题、决策、状态、备选方案对比矩阵（3 种语言 × 5 项标准）、论证、影响，以及可追溯到源故事和受影响工作制品的链接。这相当于将 DDD 的知识消化法应用到了架构决策中。

### 管线集成

utCodeAgentCLI 设计用于融入开发管线：

```
开发者目标 → utCodeAgentCLI
                      │
                      ├── 读取 methodPrompts/（方法约束）
                      ├── 读取 slashCommands/（执行单元）
                      │
                      ├── 规划：将目标分解为命令序列
                      ├── 执行：通过模型运行时调用命令
                      ├── 追踪：收集结构化执行日志
                      ├── 反思：分析结果、识别模式
                      │
                      └── 输出：已验证的测试 + 追踪日志 + 对各层的反馈
```

---

## specCodeAgentCLI 架构

`specCodeAgentCLI` 编排更大范围的生命周期。它基于 Px-SpecFlow，并在单元测试阶段复用 `utCodeAgentCLI`。

### 层次契约

| 关注点 | 所有者 |
|---|---|
| SpecCoding 生命周期规则 | Px-SpecFlow（位于 slashCommands/flows） |
| 生命周期编排与排序 | specCodeAgentCLI |
| 单元测试设计与实现 | utCodeAgentCLI（作为子 agent 调用） |
| CaTDD 方法语义 | methodPrompts |
| 可移植的命令执行单元 | slashCommands |

### 编排流程

```text
1. 接收：导入 Issue/功能请求
2. 分析：转化为用户故事 → todoUS/
3. 开启：移至 doingUS/
4. 澄清意图：对齐开发者和 agent 的意图
5. 规划：分类工作方向，创建任务工作制品
6. 路由：
   ┌─ 需求导向 → updateUserStory → reviewUserStory → commit/close
   ├─ 设计导向 → takeArchDesign → review → takeDetailDesign → review
   └─ 实现导向 → designUnitTests → implUnitTests → implProductCodes
                                                                  ↓
                                                            reviewProductCodes
                                                                  ↓
                                                          commitWorks → closeUserStory
```

在每一步，specCodeAgentCLI 调用相应的 SPEC 命令，并在开发者（拥有产品意图）、SPEC 命令（拥有生命周期规则）和 utCodeAgentCLI（拥有测试执行）之间传递控制权。

### 子 Agent 模式

specCodeAgentCLI 将 utCodeAgentCLI 作为子 agent 对待：

```
specCodeAgentCLI："故事 US-5 已就绪，可以开始实现。设计和实现 P0 测试。"
       │
       ▼
utCodeAgentCLI： 读取 methodPrompts，读取测试文件，规划，执行，收集追踪记录
       │
       ▼
utCodeAgentCLI： 返回："已设计 3 个 Typical、2 个 Edge、1 个 Misuse 测试。已实现 3 个 GREEN。剩余 3 个 ⚪ TODO。"
       │
       ▼
specCodeAgentCLI：更新故事状态。路由至 SPEC_reviewProductCodes。
```

这种分离将单元测试逻辑排除在生命周期编排器之外，也将生命周期逻辑排除在单元测试 agent 之外。

---

## 异步代码 Agent 工作流

代码 agent 异步运行——你定义一个目标，调用 agent，并在完成后接收结果。这支持以下几种模式：

### 发射后不管

```
开发者：utCodeAgentCLI --goal "为 EventQueue 设计所有 P0 骨架"
Agent：  [自主工作数分钟]
Agent：  返回："P0 骨架已完成。4 个类别、8 个 US、14 条 AC、22 个 TC。可进行审查。"
```

开发者定义目标后去处理其他工作，Agent 完成后返回结果。

### 并行 Agent 会话

```
会话 A：utCodeAgentCLI --goal "EventQueue 的 P0 测试"
会话 B：utCodeAgentCLI --goal "CommandExecutor 的 P0 测试"
会话 C：specCodeAgentCLI --goal "分析待处理 Issue 转化为故事"
```

多个 agent 并发运行，每个聚焦于不同的范围。开发者批量审查结果。

### 管线串联

```
specCodeAgentCLI（分析 Issue → todoUS/ 中的故事）
       │
       ▼ （触发条件：故事移至 doingUS）
specCodeAgentCLI（产出详细设计 → AC 设计完成）
       │
       ▼ （触发条件：设计审查 PASS）
utCodeAgentCLI（设计 P0 测试 → 实现 → 验证）
       │
       ▼ （触发条件：所有 P0 测试 GREEN）
specCodeAgentCLI（审查代码 → 提交 → 关闭 → doneUS）
```

每次 agent 调用触发管线中的下一步。开发者设置一次管线，然后监控检查点。

---

## Agent 与开发者检查点的关系

代码 agent 是自主的，但并非无监督。CaTDD 工作流内嵌了检查点，开发者必须在 agent 继续之前批准：

| 检查点 | Agent 状态 | 开发者动作 |
|---|---|---|
| 理解之后（阶段 1） | "是否继续进入测试设计？" | 审查理解摘要。确认或修正。 |
| 设计之后（阶段 2） | "是否继续进入实现阶段？" | 审查 US/AC/TC 设计。批准或要求修改。 |
| 关卡 P0 之后 | "P0 完成。是否继续 P1？" | 审查 P0 结果。决定是否需要 P1。 |
| 关卡 P1 之后 | "架构已验证。是否继续 P2？" | 审查架构测试结果。决定是否需要 P2。 |
| 实现之后 | "测试完成。是否提交？" | 审查最终报告。提交或要求变更。 |

Agent 遵守检查点契约：在每个关卡处停止并等待开发者输入。它不会自行推进。这保留了开发者对质量决策的掌控。

---

## Agent 技能 vs 代码 Agent

有必要区分两个相关但不同的概念：

| 概念 | 是什么 | 位于何处 |
|---|---|---|
| **agentSkills** | 面向通用 CodeAgent（Copilot、Cline）的可复用能力包 | `agentSkills/` — 技能定义 + 生成的包 |
| **codeAgents** | 内建方法论知识的 CaTDD 原生 CLI agent | `codeAgents/` — 架构 + 未来实现 |

**agentSkills** 的含义是："这是一个技能包。任何 CodeAgent 都可以加载并遵循 CaTDD。"

**codeAgents** 的含义是："我们是 CaTDD 原生 agent。我们了解方法，自主规划，并反馈学习成果。"

它们面向不同的受众：

- **agentSkills** 面向使用 Copilot/Cline/Continue 的开发者，希望其现有 agent 遵循 CaTDD。
- **codeAgents** 面向 CaTDD 项目本身——构建不依赖任何第三方 agent 的一流自动化。

Copilot 用户加载 `comment-alive-test-driven-development` 技能包。CaTDD 原生用户直接调用 `utCodeAgentCLI`。两者遵循相同的方法，产出相同的结构化输出。区别在于执行引擎。

---

## 代码 Agent 的未来

当前仓库记录了两个 agent 的预期层次契约。可运行实现在设计和开发中。架构包括：

- **基于 TypeScript 的 V1（PoC）**用于 utCodeAgentCLI —— 快速迭代 AgentSDK 集成
- **基于 Go 的 V2（生产）**用于 utCodeAgentCLI —— 编译后二进制文件，零运行时依赖
- **SpecFlow 原生执行**用于 specCodeAgentCLI —— 内建可追溯性的生命周期编排

核心洞察：代码 agent 不是方法论的事后补充，而是 CaTDD 演进路径的**终点**：

```
手动执行（methodPrompts）
       ↓
命令化执行（slashCommands）
       ↓
Agent 驱动执行（codeAgents）
       ↓
打包可复用能力（agentSkills）
```

每一层自动化了上一层更多的手动工作。代码 agent 是手动变为自主的转折点。

---

## 从自动化到集成

代码 agent 将 CaTDD 工作流自动化。但自动化建立在永恒的软件工程准则之上——即软件工程知识宝典。下一章 **applyClassicSWE** 将展示如何通过 CaTDD 对 TDD、BDD 和 DDD 三大流派的综合，在 LLM 时代充分释放这三门学科的完整表达能力。

Agent 生成测试。管线运行测试。团队审查测试。CaTDD 不会取代你的工程文化——它用结构化、可追溯、LLM 可读的验证设计来强化它。
