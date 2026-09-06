# CaTDD method prompt

**Short name**: CaTDD (Comment-alive Test-Driven Development)

This file is the main entry point and stable contract for CaTDD. Keep it short enough for humans to read. Detailed method material lives in sibling subtopic files named `CaTDD_methodPrompt-*.md`.

## Purpose

CaTDD turns design intent into executable tests by writing structured living comments first, then evolving those comments into RED/GREEN tests and production code.

`Comment-alive` means:

- Design details live in the test and source file as structured comments.
- Comments evolve with code instead of drifting in separate documents.
- Comments are first-class artifacts that humans and LLMs can parse.
- US/AC/TC structure bridges human intent and machine-executable tests.

## Subtopic Map

| Need | Read |
| --- | --- |
| Category semantics, category identity, source-of-truth gate | `CaTDD_methodPrompt-categorySemantics.md` |
| Source-first behavior inventory, multi-class sweeps (P0–P3), domain archetypes, test-point ledger, Discovery Gate, and escaped-bug feedback | `CaTDD_methodPrompt-testPointDiscovery.md` |
| Stage model, RED/GREEN cycle, risk-based ordering, quality gates | `CaTDD_methodPrompt-workflow.md` |
| Comment skeleton, coverage matrix, US/AC/TC, test structure | `CaTDD_methodPrompt-testStructure.md` |
| Canonical `test_{feature}_{category}.<ext>` file naming | `CaTDD_methodPrompt-fileNaming.md` |
| Agent checkpoints and operating discipline | `CaTDD_methodPrompt-agentWorkflow.md` |
| Troubleshooting and recovery paths | `CaTDD_methodPrompt-troubleshooting.md` |
| Worked examples and category placement examples | `CaTDD_methodPrompt-examples.md` |
| Deep dive for one CaTDD category | `CaTDD_methodPrompt4Cat-*.md` |
| Language-specific design and implementation skeletons | `CaTDD_designAndImplTemplate.cxx`, `CaTDD_designAndImplTemplate.ts` |

## Design Skeleton Contract

In CaTDD, **design** means a reusable comment skeleton inside the test or source file, not only an external explanation document.

Each skeleton is organized by:

- **Class**: the priority family, such as `P0 Functional`, `P1 Design`, `P2 Quality`, or `P3 Addons`.
- **Category**: the specific verification angle, such as `Typical`, `Edge`, `Misuse`, `Fault`, `State`, `Capability`, `Interaction`, `Concurrency`, `Performance`, `Robust`, `Compatibility`, `Configuration`, `Diagnosis`, `Security`, or `Demo/Example`.

Minimum skeleton shape:

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

For full structure guidance, read `CaTDD_methodPrompt-testStructure.md`.

## Category Semantics

CaTDD categories are not labels added after tests are written. They are:

- Thinking lenses before design: what kind of confidence does this test provide?
- Routing rules during skeleton creation: which category file owns this test point?
- Review gates before implementation: what source artifact justifies this test?

The class names define the verification lens:

| Class | Confidence Lens | Core Question |
| --- | --- | --- |
| P0 Functional | Contract | Does the user-visible contract behave correctly? |
| P1 Design | Model | Does the internal state, capability, interaction, or concurrency model hold? |
| P2 Quality | Envelope | Does the behavior remain acceptable under quality constraints? |
| P3 Addons | Learning Surface | Does the demo, example, or guide remain executable and useful? |

`P0/P1/P2/P3` gives the default verification order, not absolute business priority. Risk may move a category earlier in execution order, but it does not rename or reclassify the test.

Category fine in place: choose the category by verification lens, then adjust execution order by risk.

For full category guidance, read `CaTDD_methodPrompt-categorySemantics.md`.

## Mandatory Traceability Constraints

- P0 Functional design must include the full category set in order: `Typical -> Edge -> Misuse -> Fault` unless the developer explicitly limits scope.
- Each US must map to at least one AC.
- Each AC must map to at least one TC.
- Design output must declare the SUT (System Under Test) explicitly in the test-file overview section, for example `SUT: utCodeAgentCLI`. The declared SUT boundary establishes the contract dividing line: caller violations of the SUT's public interface are `P0 Misuse`, while failures of external dependencies or runtime environment outside the SUT are `P0 Fault`.
- Unit Testing (UT) scope must adhere to the project's agreed `sut_unit_convention` (e.g. `module-interface`, `submodule-interface`, `class`, `header-file`, `function`, or `component`).
- Every non-empty category file must trace to a source-of-truth artifact.
- If the source is missing, ask the developer or mark the category file with `@[NoTestPoints]: <reason>`; do not invent test points.

## Test-Point Discovery Contract

US/AC/TC cardinality proves linkage, not completeness: an entirely missing behavior cannot fail a link check.

- In **Stage-0: Freely Drafting**, inventory source-backed obligations and use Example Mapping to discover examples and questions breadth-first. OOPSI and business-rule extraction are optional aids for functional workflows, not prerequisites for every class.
- CaTDD serves primarily Embedded Linux, secondarily Microservices, and thirdly LLM Agents. Select applicable domain profiles for the declared SUT; these are usage priorities, not a historical lineage, mandatory technology stack, or category order.
- Before approving skeletons in **Stage-1: Classifying Design**, reconcile the applicable P0 Functional, P1 Design, P2 Quality, and P3 Addons sweeps in [CaTDD_methodPrompt-testPointDiscovery.md](CaTDD_methodPrompt-testPointDiscovery.md). Classify by verification lens, not rule type or domain.
- Maintain an unbroken **TestEvidenceChain**: every test must establish an unbroken chain answering **WHY** we need the test point (source artifact -> rule/invariant -> Test Point (TP) -> observable oracle -> CaTDD category) and **HOW** we execute the test correctly (US/AC/TC -> Test Case (TC) -> RED/GREEN test).
- Distinguish Acceptance Criteria (AC) from Test Point (TP): AC is formulated from the **User/Caller perspective** (`GIVEN context, WHEN action, THEN outcome`) defining what external rule must hold for acceptance. TP is formulated from the **Developer/Defensive perspective** (`GIVEN technical state/partition, WHEN action/interleaving, THEN observable oracle`) defining the concrete technical probe (nominal path, boundary offset, caller misuse, dependency fault, race condition) required to verify whether that AC holds. One AC typically unpacks into multiple TPs ($1:N$); equating $TP == AC$ causes boundary and failure omissions.
- Distinguish Test Point (TP) from Test Case (TC): A TP is a source-backed verification obligation (the target) discovered in Stage-0/Stage-1; a TC is an executable specification artifact (the arrow) implementing that obligation under US/AC. They are not strictly 1:1 ($1:0$ exposes a GAP; $1:N$ and $N:1$ are valid when justified). Equating $TC == TP$ obscures missing test points.
- Discovery to Categorization: In Stage-0 (Freely Drafting), discover TPs breadth-first across sources and sweeps without premature category lock-in; in Stage-1 (Classifying Design), route each discovered TP to its proper CaTDD category based on its verification lens (Contract -> P0, Model -> P1, Envelope -> P2, Learning Surface -> P3).
- Enforce **Source-First** review: inspect authoritative source artifacts and independently derive expected obligations before consulting existing test files or skeletons.
- Keep a `discovery_ledger` in living design comments: each candidate has a source/rule, scenario, observable oracle, verification method/environment, category/test level, scope/routing metadata, and one disposition (DESIGNED, QUESTION, EXCLUDED, REFERRED, or GAP). A handoff does not close an unresolved in-scope obligation.
- Oracles may be numeric budgets or exact predicates; manual/hybrid evidence is valid when the procedure and expected observation are specified. Never infer product limits, precedence, or recovery behavior from a domain example.
- Apply the **Discovery Gate** independently from source to skeleton as well as from skeleton to source. Category presence, TC counts, and passing tests do not prove all relevant points were discovered.
- Unresolved in-scope questions or uncovered obligations prevent implementation readiness. Missing-source `@[NoTestPoints]` is blocked evidence, not a coverage exemption.
- Report readiness for the declared scope, exclusions, referrals, and residual risk. Learn from escaped bugs without promising zero omissions or inventing product behavior.

## Category Source-of-Truth Gate

Use the category's source artifact to decide whether a test point is valid.

| Class | Category Family | Primary Source of Truth | Missing Source Behavior |
| --- | --- | --- | --- |
| P0 Functional | Typical / Edge / Misuse / Fault | User Story, Acceptance Criteria, UsageDesign, API contract | Ask for AC/usage contract or mark `@[NoTestPoints]` |
| P1 Design | State / Capability / Interaction / Concurrency | ArchDesign, DetailDesign, StateDesign, sequence or interaction diagrams | Ask where the design model lives before drafting tests |
| P2 Quality | Performance / Robust / Compatibility / Configuration / Diagnosis / Security | PerfDesign, ResourceDesign, CompatDesign, ErrorDesign, DiagnosisDesign, SecurityDesign, threat model, VerifyDesign | Ask for measurable constraints, compatibility rules, diagnostic evidence, security policy, or config matrix |
| P3 Addons | Demo/Example | UserGuide, README examples, demo scripts | Ask for executable example intent or mark `@[NoTestPoints]` |

## Workflow Summary

1. Inventory behavior from source artifacts and capture Stage-0 drafts using the discovery sweep.
2. Classify source-backed drafts by verification lens; retain unknowns and referrals in the test-point ledger.
3. Write US/AC/TC comments, reconcile the ledger, and pass both the cardinality and Discovery Gate before implementation.
4. Pick one TC and write the test first.
5. Run the test and confirm RED for the intended reason.
6. Implement the minimum production code to make the TC GREEN.
7. Refactor comments, test code, and production code while preserving behavior.
8. Repeat one TC at a time.

Default execution order:

| Order | Categories |
| --- | --- |
| P0 Functional | Typical -> Edge -> Misuse -> Fault |
| P1 Design | State -> Capability -> Interaction -> Concurrency |
| P2 Quality | Performance -> Robust -> Compatibility -> Configuration -> Diagnosis -> Security |
| P3 Addons | Demo/Example |

For detailed execution gates, read `CaTDD_methodPrompt-workflow.md`.

## File Naming Contract

Use this pattern for category-specific test files:

```text
test_{feature}_{category}.<ext>
```

- `{feature}` should be a stable lower_snake_case capability slice derived from module-interface usage scenarios.
- `{category}` must use a canonical CaTDD filename token.
- Start with `test_{feature}_freelyDrafts.<ext>` for exploration, then classify mature test points into category-specific files.
- Each `{feature}` should have one file for every canonical category token.
- If a category has no applicable test points, keep that file as a living decision with `@[NoTestPoints]: <reason>` and no executable TCs.
- Empty-by-omission is forbidden.

Canonical tokens:

| CaTDD class/category | Filename token |
| --- | --- |
| P0 Functional / ValidFunc / Typical | `funcValidTypical` |
| P0 Functional / ValidFunc / Edge | `funcValidEdge` |
| P0 Functional / InvalidFunc / Misuse | `funcInvalidMisuse` |
| P0 Functional / InvalidFunc / Fault | `funcInvalidFault` |
| P1 Design / State | `designState` |
| P1 Design / Capability | `designCapability` |
| P1 Design / Interaction | `designInteraction` |
| P1 Design / Concurrency | `designConcurrency` |
| P2 Quality / Performance | `qualityPerformance` |
| P2 Quality / Robust | `qualityRobust` |
| P2 Quality / Compatibility | `qualityCompatibility` |
| P2 Quality / Configuration | `qualityConfiguration` |
| P2 Quality / Diagnosis | `qualityDiagnosis` |
| P2 Quality / Security | `qualitySecurity` |
| P3 Addons / Demo/Example | `addonDemoExample` |

For detailed naming examples, read `CaTDD_methodPrompt-fileNaming.md`.

## Category Prompt Deep Dives

Use category-specific prompts when designing a category skeleton.

| Category | Prompt |
| --- | --- |
| Typical | `CaTDD_methodPrompt4Cat-Typical.md` |
| Edge | `CaTDD_methodPrompt4Cat-Edge.md` |
| Misuse | `CaTDD_methodPrompt4Cat-Misuse.md` |
| Fault | `CaTDD_methodPrompt4Cat-Fault.md` |
| State | `CaTDD_methodPrompt4Cat-State.md` |
| Capability | `CaTDD_methodPrompt4Cat-Capability.md` |
| Interaction | `CaTDD_methodPrompt4Cat-Interaction.md` |
| Concurrency | `CaTDD_methodPrompt4Cat-Concurrency.md` |
| Performance | `CaTDD_methodPrompt4Cat-Performance.md` |
| Robust | `CaTDD_methodPrompt4Cat-Robust.md` |
| Compatibility | `CaTDD_methodPrompt4Cat-Compatibility.md` |
| Configuration | `CaTDD_methodPrompt4Cat-Configuration.md` |
| Diagnosis | `CaTDD_methodPrompt4Cat-Diagnosis.md` |
| Security | `CaTDD_methodPrompt4Cat-Security.md` |
| Demo/Example | `CaTDD_methodPrompt4Cat-DemoExample.md` |

## Non-Negotiable Agent Rules

- Do not skip design comments before implementation.
- Do not write production code before a failing test exists for the selected TC.
- Do not guess missing product intent, acceptance criteria, source-of-truth design, or quality thresholds.
- Do not silently omit a category file.
- Do not declare design complete from category presence or US/AC/TC counts alone; pass the Discovery Gate for the declared scope.
- Do not reclassify a test because risk changed execution order.
- Do not expand a TC during refactor beyond its original AC meaning.

## Maintenance Rule

When CaTDD method intent changes:

1. Update this main entry if the stable contract changes.
2. Update the matching `CaTDD_methodPrompt-*.md` subtopic for detailed guidance.
3. Update `README_UserGuide.md` and `README_UserGuide_ZH.md` if standalone users need to see the change.
4. Update category-specific `CaTDD_methodPrompt4Cat-*.md` only when a single category's deep guidance changes.
