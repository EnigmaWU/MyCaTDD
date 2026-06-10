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
  CaTDD_methodPrompt4Cat-Typical.md
  CaTDD_methodPrompt4Cat-Edge.md
  CaTDD_methodPrompt4Cat-Misuse.md
  CaTDD_methodPrompt4Cat-Fault.md
  CaTDD_methodPrompt4Cat-State.md
  CaTDD_methodPrompt4Cat-Capability.md
  CaTDD_methodPrompt4Cat-Concurrency.md
  CaTDD_methodPrompt4Cat-Performance.md
  CaTDD_methodPrompt4Cat-Robust.md
  CaTDD_methodPrompt4Cat-Compatibility.md
  CaTDD_methodPrompt4Cat-Configuration.md
  CaTDD_methodPrompt4Cat-DemoExample.md
  CaTDD_designAndImplTemplate.cxx
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
2. 阅读 `CaTDD_methodPrompt.md`，了解完整方法契约。
3. 复制 `CaTDD_designAndImplTemplate.cxx`，或把其中的分区结构适配到你的语言。
4. 捕获 Stage-0 自由草稿：场景、示例、风险与开放问题。
5. 根据下面的优先级顺序，将草稿归类。
6. 在实现代码之前，把 US/AC/TC 注释写进测试文件。
7. 为下一个 TC 生成或编写一个失败测试。
8. 只实现让该 TC 通过所需的最小生产代码。
9. 更新 TC 状态标记，并保持注释与行为同步。
10. 每次只推进一个 TC，持续重复。

## Usage Example

在包含 `methodPrompts/` 的目标项目中运行：

```bash
mkdir -p Test
# C++ target
cp methodPrompts/CaTDD_designAndImplTemplate.cxx Test/UT_YourFeature_Typical.cxx
# TypeScript target
cp methodPrompts/CaTDD_designAndImplTemplate.ts Test/UT_YourFeature_Typical.ts
```

类别专属测试文件使用 `UT_<Feature>_<Category>.<ext>`，例如 `UT_YourFeature_Typical.cxx`、`UT_YourFeature_Typical.ts` 或 `UT_YourFeature_Edge.ts`。

然后让 CodeAgent 执行，或手工使用方法提示词：

```text
Read methodPrompts/README_UserGuide_ZH.md and methodPrompts/CaTDD_methodPrompt.md.
Use methodPrompts/CaTDD_methodPrompt4Cat-Typical.md to fill the Typical skeleton in Test/UT_YourFeature_Typical.cxx or Test/UT_YourFeature_Typical.ts.
Preserve US/AC/TC traceability and leave unclear product intent as questions.
```

预期结果：

- `Test/UT_YourFeature_Typical.cxx` 或 `Test/UT_YourFeature_Typical.ts` 包含 OVERVIEW 分区。
- 它包含带有 US/AC/TC 注释的 UNIT TESTING DESIGN 分区。
- 它包含可进入 Red-Green TDD 的 UNIT TESTING IMPLEMENTATION 分区。
- 它包含所选 TC 的 TODO/TRACKING 状态标记。

## 优先级框架

除非项目风险另有要求，默认使用以下优先级顺序。

| 优先级 | 类 | 分类 | 目的 |
| --- | --- | --- | --- |
| P0 | P0 Functional | Typical -> Edge -> Misuse -> Fault | 证明合法行为正确工作，非法行为优雅失败。 |
| P1 | P1 Design | State -> Capability -> Concurrency | 证明生命周期、容量与线程安全等设计行为。 |
| P2 | P2 Quality | Performance -> Robust -> Compatibility -> Configuration | 证明质量属性与环境变化。 |
| P3 | P3 Addons | Demo/Example | 证明面向文档、示例与入门的流程。 |

## 方法提示词地图

| 需求 | 使用 |
| --- | --- |
| 学习完整方法契约 | `CaTDD_methodPrompt.md` |
| 设计核心 happy-path 行为 | `CaTDD_methodPrompt4Cat-Typical.md` |
| 设计合法边缘场景、极限值和边界值 | `CaTDD_methodPrompt4Cat-Edge.md` |
| 设计非法调用者行为或错误 API 使用 | `CaTDD_methodPrompt4Cat-Misuse.md` |
| 设计依赖、资源或环境故障处理 | `CaTDD_methodPrompt4Cat-Fault.md` |
| 设计生命周期和有限状态机验证 | `CaTDD_methodPrompt4Cat-State.md` |
| 设计容量和最大能力验证 | `CaTDD_methodPrompt4Cat-Capability.md` |
| 设计线程安全或竞态条件验证 | `CaTDD_methodPrompt4Cat-Concurrency.md` |
| 设计延迟、吞吐量或资源使用检查 | `CaTDD_methodPrompt4Cat-Performance.md` |
| 设计压力、重复、长稳或稳定性检查 | `CaTDD_methodPrompt4Cat-Robust.md` |
| 设计跨平台、版本或集成检查 | `CaTDD_methodPrompt4Cat-Compatibility.md` |
| 设计功能开关、配置或环境变化 | `CaTDD_methodPrompt4Cat-Configuration.md` |
| 设计面向文档的演示和示例 | `CaTDD_methodPrompt4Cat-DemoExample.md` |
| 从完整骨架开始编写 C++ 测试文件 | `CaTDD_designAndImplTemplate.cxx` |

## 注释骨架

每个分类骨架都应保留以下最小形态：

```text
//=================================================================================================
// [Class] / [Category] Design Skeleton
//=================================================================================================
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

- 每个 TC 至少回链到一个 AC 和一个 US。
- 分类名称与方法提示词地图一致。
- 在扩展可选 P1/P2 之前，先处理 P0 Functional 覆盖。
- 每个已实现测试都遵循 SETUP -> BEHAVIOR -> VERIFY -> CLEANUP。
- 每个测试聚焦一个行为，并只使用少量关键断言。
- 实现后注释与代码保持一致。
- 开放问题要明确写出，而不是静默猜测。

## 下一步

如果手工使用，继续阅读 `CaTDD_methodPrompt.md`，以及与你下一个测试设计需求匹配的分类提示词。

如果需要自动化或半自动化流程，后续再加入本仓库的 `slashCommands/` 层。它很有用，但不是独立采用 `methodPrompts/` 的必需条件。
