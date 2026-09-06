# CaTDD 独立用户指南

面向只使用 `methodPrompts/` 的开发者与 CodeAgent 的 Comment-alive Test-Driven Development 指南。

CaTDD 由 EnigmaWU 发明。IOC 是帮助 CaTDD 从想法演化为可复用方法论的 PlayKata 模块与验证场。

## 使用者

如果你属于以下角色，请使用本指南：

- 只把 `methodPrompts/` 复制到目标项目中的开发者。
- 将 `methodPrompts/` 作为方法真理源读取的 CodeAgent。
- 想在使用 `slashCommands` 或安装脚本之前，先手工应用 CaTDD 的维护者。
- 正在学习如何把注释变成活的验证设计的团队成员。

## 内容

CaTDD 表示 Comment-alive Test-Driven Development。

核心思想是：

```text
Comments is Verification Design.
LLM Generates Code.
Iterate Forward Together.
```

在 CaTDD 中，结构化注释不是被动文档，而是人类与 LLM 用来创建、审查、实现并演进测试的验证设计。

最小设计链路是：

```text
US: User Story -> 为什么这个行为有价值
AC: Acceptance Criteria -> 必须满足什么条件
TC: Test Case -> 如何具体验证
```

## 使用时机

在以下情况使用独立的 `methodPrompts/`：

- 想在不安装 CodeAgent 适配器的情况下，把 CaTDD 引入项目。
- 需要稳定的方法参考来做手工验证设计。
- 想给 CodeAgent 足够的方法上下文，让它设计 US/AC/TC 骨架。
- 正在编写新测试、转换已有测试，或审查测试设计质量。

不要把本指南当作项目业务意图的替代品。如果业务行为、验收标准或风险优先级不清楚，应询问开发者或产品负责人。

## 位置

将 `methodPrompts/` 放在目标项目根目录，或放在开发者与 CodeAgent 都能读取的位置。

推荐的独立目录结构：

```text
methodPrompts/
  README.md
  README_ZH.md
  README_UserGuide.md
  README_UserGuide_ZH.md
  CaTDD_methodPrompt.md
  CaTDD_methodPrompt-categorySemantics.md
  CaTDD_methodPrompt-testPointDiscovery.md
  CaTDD_methodPrompt-workflow.md
  CaTDD_methodPrompt-testStructure.md
  CaTDD_methodPrompt-fileNaming.md
  CaTDD_methodPrompt-agentWorkflow.md
  CaTDD_methodPrompt-troubleshooting.md
  CaTDD_methodPrompt-examples.md
  CaTDD_methodPrompt4Cat-Typical.md
  CaTDD_methodPrompt4Cat-Edge.md
  CaTDD_methodPrompt4Cat-Misuse.md
  CaTDD_methodPrompt4Cat-Fault.md
  CaTDD_methodPrompt4Cat-State.md
  CaTDD_methodPrompt4Cat-Capability.md
  CaTDD_methodPrompt4Cat-Interaction.md
  CaTDD_methodPrompt4Cat-Concurrency.md
  CaTDD_methodPrompt4Cat-Performance.md
  CaTDD_methodPrompt4Cat-Robust.md
  CaTDD_methodPrompt4Cat-Compatibility.md
  CaTDD_methodPrompt4Cat-Configuration.md
  CaTDD_methodPrompt4Cat-Diagnosis.md
  CaTDD_methodPrompt4Cat-Security.md
  CaTDD_methodPrompt4Cat-DemoExample.md
  CaTDD_designAndImplTemplate.cxx
  CaTDD_designAndImplTemplate.ts
  CaTDD_designAndImplTemplate.py
  CaTDD_designAndImplTemplate.go
```

## 原因

独立的 `methodPrompts/` 应该可以单独发挥作用。

只拿到这个目录的开发者仍然应该能够：

- 理解 CaTDD 的方法意图。
- 选择正确的分类提示词。
- 编写 US/AC/TC 验证设计。
- 让 LLM 根据注释生成测试。
- 在测试与生产代码演进时保持注释鲜活。

本文件存在的目的，是让使用者不依赖仓库根目录指南、幻灯片、安装脚本、`slashCommands` 或 `agentSkills` 包，也能开始使用 CaTDD 方法。

## 方法

开始编写 CaTDD 测试文件时，按以下流程执行。

1. 阅读 `README.md`，选择相关方法提示词。
2. 阅读 `CaTDD_methodPrompt.md`，把它作为主入口。
3. 阅读需要的 `CaTDD_methodPrompt-*.md` 子主题，获取详细方法指导。
4. 复制 `CaTDD_designAndImplTemplate.cxx`、`CaTDD_designAndImplTemplate.ts`、`CaTDD_designAndImplTemplate.py` 或 `CaTDD_designAndImplTemplate.go`，或把其中的分区结构适配到你的语言。
5. 声明 SUT、范围内的类别族、适用领域、测试层级与执行环境。先从来源列出验证义务，再把已有测试当作覆盖证据。通过 Example Mapping 捕获 Stage-0 示例与开放问题。
6. 使用 [CaTDD_methodPrompt-testPointDiscovery.md](CaTDD_methodPrompt-testPointDiscovery.md) 进行适用的 P0/P1/P2/P3 扫描。OOPSI 与业务规则提取只是功能工作流的可选辅助；设计模型和质量约束使用各自的来源。在活注释中的 `discovery_ledger` 记录候选点与来源。
7. 按验证视角归类草稿，不按规则类型、领域或优先级归类。下面的优先级用于执行排序，并可按风险调整。
8. 在实现代码之前，把 US/AC/TC 注释写进测试文件。
9. 独立审查 source -> ledger -> US/AC/TC 及反向链接。只有 cardinality 和 Discovery Gate 都通过、声明范围内 `ready_for_implementation: yes` 时，才为下一个 TC 编写失败测试。
10. 只实现让该 TC 通过所需的最小生产代码。
11. 更新 TC 状态标记，并保持注释与行为同步。
12. 每次只推进一个 TC，持续重复。

### 领域与验证范围

CaTDD 首先面向 **Embedded Linux（嵌入式 Linux）**，其次是 **Microservices（微服务）**，第三是 **LLM Agents（LLM 智能体）**。这是使用侧重点，不是历史演化顺序或强制技术栈。只选择适用领域；不要假设每个嵌入式组件都包含内核代码，或每个智能体都支持多个供应商。

- 嵌入式开发应区分用户态、内核与设备边界，以及主机、模拟器、目标板或 HIL 证据。主机夹具或 sanitizer 运行不能证明真实硬件行为或目标时序。
- 记录 `verification_method`（自动、人工或混合）、执行环境、预期观察与证据采集方式。精确的策略/字段谓词和有明确步骤的人工观察都是合法 oracle；只有数值预算才必须提供数值阈值。
- 路由与处置状态分开记录。范围内未解决的转交仍是 GAP/QUESTION，并保留目的地与负责人；REFERRED 只用于已接受的范围外转交，不代表已覆盖。范围变更必须明确批准。

## Usage Example

在包含 `methodPrompts/` 的目标项目中运行：

```bash
mkdir -p Test
# C++ target
cp methodPrompts/CaTDD_designAndImplTemplate.cxx Test/test_your_feature_funcValidTypical.cxx
# TypeScript target
cp methodPrompts/CaTDD_designAndImplTemplate.ts Test/test_your_feature_funcValidTypical.ts
# Python target
cp methodPrompts/CaTDD_designAndImplTemplate.py Test/test_your_feature_funcValidTypical.py
# Go target
cp methodPrompts/CaTDD_designAndImplTemplate.go Test/test_your_feature_funcValidTypical_test.go
```

类别专属测试文件使用 `test_{feature}_{category}.<ext>`，例如 `test_your_feature_funcValidTypical.cxx`、`test_your_feature_funcValidTypical.ts` 或 `test_your_feature_funcInvalidMisuse.py`。`{feature}` 应来自模块接口的 usage scenarios，`{category}` 使用 `CaTDD_methodPrompt.md` 中的 CaTDD category filename tokens。

每个 `{feature}` 应创建或保留所有 CaTDD category 文件；若某个 category 没有适用 test points，在该文件中标记 `@[NoTestPoints]: <reason>`，不要静默省略。

每个 test point 都应放在匹配其 verification lens 的 category 中。P0 证明外部 contract，P1 证明内部 design model，P2 证明 operating envelope，P3 证明 learning surface。风险可以让某个 category 提前执行，但不能重命名该 category。若某个 category 缺少 source-of-truth artifact，应询问缺失的设计，或标记 `@[NoTestPoints]: <reason>`。

然后让 CodeAgent 执行，或手工使用方法提示词：

```text
Read methodPrompts/README_UserGuide_ZH.md and methodPrompts/CaTDD_methodPrompt.md.
Before drafting, apply methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md.
Declare the SUT, class scope, applicable domain profiles, and test environment.
Build the source inventory and use Example Mapping plus the applicable sweeps.
Use OOPSI/business-rule aids only for suitable functional sources; never infer
limits, recovery policies, or technologies from domain examples.
Use methodPrompts/CaTDD_methodPrompt4Cat-Typical.md to fill the Typical skeleton in Test/test_your_feature_funcValidTypical.cxx or Test/test_your_feature_funcValidTypical.ts.
Preserve US/AC/TC traceability and leave unclear product intent as questions.
Keep a source-first behavior inventory and discovery_ledger in living comments.
Record verification_method, execution environment, observable oracle, and
evidence capture for each candidate; keep handoff routing separate from status.
Review sources independently of existing tests; report discovery_status,
ready_for_implementation, exclusions, referrals, and residual risks separately.
```

预期结果：

- `Test/test_your_feature_funcValidTypical.cxx` 或 `Test/test_your_feature_funcValidTypical.ts` 包含 OVERVIEW 分区。
- 它包含带有 US/AC/TC 注释的 UNIT TESTING DESIGN 分区。
- 它包含可进入 Red-Green TDD 的 UNIT TESTING IMPLEMENTATION 分区。
- 它包含所选 TC 的 TODO/TRACKING 状态标记。
- 来源规则与发现维度均链接到有证据的 ledger 条目：DESIGNED、QUESTION、EXCLUDED、REFERRED 或 GAP。有交代不等于已覆盖。
- 范围内未解决的来源/预期结果问题以及未设计的义务会阻止就绪。因缺少来源而填写的 `@[NoTestPoints]` 是 BLOCKED，不是不适用的证明。

若要练习发现「US/AC/TC 链接完整但场景遗漏」，使用独立的 [exporter 审查示例](CaTDD_methodPrompt-testPointDiscovery.md#usage-example)。本方法旨在减少遗漏，但不保证部署后零缺陷；应把逃逸缺陷反馈为发现问题，而不只是增加 TC 数量。

## 优先级框架

除非项目风险另有要求，默认使用以下优先级顺序。

| 优先级 | 类 | 分类 | 目的 |
| --- | --- | --- | --- |
| P0 | P0 Functional | Typical -> Edge -> Misuse -> Fault | 证明合法行为正确工作，非法行为优雅失败。 |
| P1 | P1 Design | State -> Capability -> Interaction -> Concurrency | 证明生命周期、容量、协作者交互与线程安全等设计行为。 |
| P2 | P2 Quality | Performance -> Robust -> Compatibility -> Configuration -> Diagnosis -> Security | 证明质量属性、环境变化、诊断证据与保护属性。 |
| P3 | P3 Addons | Demo/Example | 证明面向文档、示例与入门的流程。 |

## 方法提示词地图

| 需求 | 使用 |
| --- | --- |
| 从主方法入口开始 | `CaTDD_methodPrompt.md` |
| 归类 test points 并保持 category identity 稳定 | `CaTDD_methodPrompt-categorySemantics.md` |
| 用全类扫描、领域原型与象限检查发现 source-backed test points | `CaTDD_methodPrompt-testPointDiscovery.md` |
| 执行 Stage-0、Stage-1、RED/GREEN 与质量门禁 | `CaTDD_methodPrompt-workflow.md` |
| 构建 US/AC/TC 注释、覆盖矩阵和 tracking blocks | `CaTDD_methodPrompt-testStructure.md` |
| 使用标准 `test_{feature}_{category}.<ext>` 命名 | `CaTDD_methodPrompt-fileNaming.md` |
| 指导 CodeAgent 执行 checkpoints | `CaTDD_methodPrompt-agentWorkflow.md` |
| 从设计、测试或分类阻塞中恢复 | `CaTDD_methodPrompt-troubleshooting.md` |
| 查看具体 category placement 示例 | `CaTDD_methodPrompt-examples.md` |
| 设计核心 happy-path 行为 | `CaTDD_methodPrompt4Cat-Typical.md` |
| 设计合法边缘场景、极限值和边界值 | `CaTDD_methodPrompt4Cat-Edge.md` |
| 设计非法调用者行为或错误 API 使用 | `CaTDD_methodPrompt4Cat-Misuse.md` |
| 设计依赖、资源或环境故障处理 | `CaTDD_methodPrompt4Cat-Fault.md` |
| 设计生命周期和有限状态机验证 | `CaTDD_methodPrompt4Cat-State.md` |
| 设计容量和最大能力验证 | `CaTDD_methodPrompt4Cat-Capability.md` |
| 设计协作者顺序、编排或交接验证 | `CaTDD_methodPrompt4Cat-Interaction.md` |
| 设计线程安全或竞态条件验证 | `CaTDD_methodPrompt4Cat-Concurrency.md` |
| 设计延迟、吞吐量或资源使用检查 | `CaTDD_methodPrompt4Cat-Performance.md` |
| 设计压力、重复、长稳或稳定性检查 | `CaTDD_methodPrompt4Cat-Robust.md` |
| 设计跨平台、版本或集成检查 | `CaTDD_methodPrompt4Cat-Compatibility.md` |
| 设计功能开关、配置或环境变化 | `CaTDD_methodPrompt4Cat-Configuration.md` |
| 设计可观测性、诊断证据或故障可解释性 | `CaTDD_methodPrompt4Cat-Diagnosis.md` |
| 设计 threat model 或 policy 下的保护属性检查 | `CaTDD_methodPrompt4Cat-Security.md` |
| 设计面向文档的演示和示例 | `CaTDD_methodPrompt4Cat-DemoExample.md` |
| 从完整骨架开始编写 C++ 测试文件 | `CaTDD_designAndImplTemplate.cxx` |
| 从完整骨架开始编写 TypeScript 测试文件 | `CaTDD_designAndImplTemplate.ts` |
| 从完整骨架开始编写 Python 测试文件 | `CaTDD_designAndImplTemplate.py` |
| 从完整骨架开始编写 Go 测试文件 | `CaTDD_designAndImplTemplate.go` |

## 注释骨架

每个分类骨架都应保留以下最小形态：

```text
//=================================================================================================
// [Class] / [Category] Design Skeleton
//=================================================================================================
// @[SUT]: [Declared SUT matching file overview]
// @[TestLevel]: UnitTesting (or SysTesting / UserTesting)
// @[Class]: P0 Functional / ValidFunc
// @[Category]: Typical
// @[Intent]: What this category proves for this component
// @[UseWhen]: When this category applies
// @[AvoidWhen]: When to move the scenario to another category
// @[US]: User Story IDs covered by this category
// @[AC]: Acceptance Criteria IDs covered by this category
// @[TC]: Test Cases, status, and expected TDD next action
//=================================================================================================
```

## 状态标记

使用明确的状态标记，让人类与 CodeAgent 都能安全接续工作。

| 标记 | 含义 | 下一步 |
| --- | --- | --- |
| TODO/PLANNED | 已设计但尚未实现 | 编写失败测试。 |
| RED/IMPLEMENTED | 测试已存在且按预期失败 | 实现生产代码。 |
| GREEN/PASSED | 测试通过 | 重构或选择下一个 TC。 |
| ISSUES | 已知问题需要处理 | 诊断并修复后再声明完成。 |
| BLOCKED | 缺少依赖或产品意图不清 | 先询问或解除阻塞。 |

## 质量检查清单

在声明 CaTDD 设计完成之前，检查：

- 范围内每个来源行为、模型规则、质量谓词、指南结果与适用发现维度都有 ledger 证据，而不只是分类文件存在。
- 独立的 source-first Discovery Gate 已通过；开放问题、范围排除、抽样限制、其他测试层级及 P1/P2 转交均保持可见。
- 每个 TC 至少回链到一个 AC 和一个 US。
- 分类名称与方法提示词地图一致。
- 已对账声明范围内适用的 P0/P1/P2/P3 扫描；执行优先级不能豁免范围内的设计或质量验证义务。
- 每个已实现测试都遵循 SETUP -> BEHAVIOR -> VERIFY -> CLEANUP。
- 每个测试聚焦一个行为，并只使用少量关键断言。
- 实现后注释与代码保持一致。
- 开放问题要明确写出，而不是静默猜测。

## 下一步

如果手工使用，继续阅读 `CaTDD_methodPrompt.md`，以及与你下一个测试设计需求匹配的分类提示词。

如果需要自动化或半自动化流程，后续再加入本仓库的 `slashCommands/` 层。它很有用，但不是独立采用 `methodPrompts/` 的必需条件。
