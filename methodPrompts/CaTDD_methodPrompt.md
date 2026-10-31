# CaTDD method prompt

**Short name**: CaTDD (Comment-alive Test-Driven Development)

This file is the main entry point and stable contract for CaTDD. Keep it short enough for humans to read. Detailed method material lives in sibling subtopic files named `CaTDD_methodPrompt-*.md`.

## Purpose

CaTDD turns design intent into executable tests by writing structured living comments first, then evolving those comments into RED/GREEN tests and production code.

`Comment-alive` means:

- TC design details live beside the test/source code in comments, doc comments, or docstrings. US/AC and authoritative TP definitions stay in their owning requirements and verification-design documents.
- Comments evolve with code instead of drifting in separate documents.
- Comments are first-class artifacts that humans and LLMs can parse.
- US/AC/TP/TC structure bridges human intent and machine-executable tests.

## Subtopic Map

| Need | Read |
| --- | --- |
| Category semantics, category identity, source-of-truth gate | `CaTDD_methodPrompt-categorySemantics.md` |
| Source-first behavior inventory, multi-class sweeps (P0–P3), domain archetypes, test-point ledger, Discovery Gate, and escaped-bug feedback | `CaTDD_methodPrompt-testPointDiscovery.md` |
| Stage model, RED/GREEN cycle, risk-based ordering, quality gates | `CaTDD_methodPrompt-workflow.md` |
| Comment skeleton, coverage matrix, US/AC/TP/TC, test structure | `CaTDD_methodPrompt-testStructure.md` |
| Canonical `test_{feature}_{category}.<ext>` file naming | `CaTDD_methodPrompt-fileNaming.md` |
| Agent checkpoints and operating discipline | `CaTDD_methodPrompt-agentWorkflow.md` |
| Troubleshooting and recovery paths | `CaTDD_methodPrompt-troubleshooting.md` |
| Worked examples and category placement examples | `CaTDD_methodPrompt-examples.md` |
| Deep dive for one CaTDD category | `CaTDD_methodPrompt4Cat-*.md` |
| Language-specific design and implementation skeletons | `CaTDD_designAndImplTemplate.cxx`, `CaTDD_designAndImplTemplate.ts`, `CaTDD_designAndImplTemplate.py`, `CaTDD_designAndImplTemplate.go` |

## Design Skeleton Contract

In CaTDD, **TC design** means a reusable comment skeleton inside the test or source file. It references authoritative US/AC and TP definitions rather than replacing their documents.

Each skeleton is organized by:

- **Class**: the priority family, such as `P0 Functional`, `P1 Design`, `P2 Quality`, or `P3 Addons`.
- **Category**: the specific verification angle, such as `Typical`, `Edge`, `Misuse`, `Fault`, `State`, `Capability`, `Interaction`, `Concurrency`, `Performance`, `Robust`, `Compatibility`, `Configuration`, `Diagnosis`, `Security`, or `Demo/Example`.

Minimum skeleton shape:

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
// @[StoryIdAlias]: Registered short aliases for those stories
// @[AC]: Acceptance Criteria IDs covered by this category
// @[TP]: Test Point IDs covered by this category
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

- Use the [Project-Wide Traceability IDs](CaTDD_methodPrompt-testStructure.md#project-wide-traceability-ids) contract: register a stable Story ID and carry full story-qualified AC/TP/TC IDs through design, test, and product-code trace references.
- Keep the human-readable Story ID and permanent `StoryIdAlias` together in the registry. New AC/TP/TC IDs use the alias prefix; each TP explicitly identifies its owning AC and covering TC, and each TC lists every TP it covers. Resolve legacy/shared evidence through explicit mappings, not guessed prefixes.
- P0 Functional design **MUST** include the full category set in order: `Typical -> Edge -> Misuse -> Fault` unless the developer explicitly limits scope.
- Each US **MUST** map to at least one AC.
- Each AC **MUST** map to at least one TP in a complete verification design.
- Each TP **MUST** map to exactly one TC in a complete verification design; each TC **MUST** cover at least one TP and **MAY** cover multiple TPs.
- Unassigned draft TPs are open coverage gaps and **MUST** block design completion. If one obligation needs independent test cases, split it into distinct TPs so each TP maps to exactly one TC.
- Design output **MUST** declare the SUT (System Under Test) explicitly in the test-file overview section, for example `SUT: utCodeAgentCLI`. The declared SUT boundary establishes the contract dividing line: caller violations of the SUT's public interface are `P0 Misuse`, while failures of external dependencies or runtime environment outside the SUT are `P0 Fault`.
- Unit Testing (UT) scope **MUST** adhere to the project's agreed `sut_unit_convention` (e.g. `module-interface`, `submodule-interface`, `class`, `header-file`, `function`, or `component`).
- Every non-empty category file **MUST** trace to a source-of-truth artifact.
- If the source is missing, the agent **MUST** ask the developer or mark the category file with `@[NoTestPoints]: <reason>`; it **MUST NOT** invent test points.
- Normative & Ubiquitous Language Rule (`EPIC E1.4 & I2.1`): mandatory requirements, acceptance outcomes (`THEN`), design invariants ($K$), and `@[Expect]` oracles **MUST** use controlled modal keywords (`MUST` for mandatory obligations, `MUST NOT` for prohibitions, `SHOULD` only when paired with a recorded exception condition, `MAY` for optional behavior) and **MUST** use canonical terms from `README_UbiLang.md` without synonym drift.

## Test-Point Discovery Contract

US/AC/TP/TC cardinality proves linkage, not completeness: an entirely missing behavior cannot fail a link check.

- In **Stage-0: Freely Drafting**, inventory source-backed obligations and use Example Mapping to discover examples and questions breadth-first. OOPSI and business-rule extraction are optional aids for functional workflows, not prerequisites for every class.
- CaTDD serves primarily Embedded Linux, secondarily Microservices, and thirdly LLM Agents. Select applicable domain profiles for the declared SUT; these are usage priorities, not a historical lineage, mandatory technology stack, or category order.
- Before approving skeletons in **Stage-1: Classifying Design**, reconcile the applicable P0 Functional, P1 Design, P2 Quality, and P3 Addons sweeps in [CaTDD_methodPrompt-testPointDiscovery.md](CaTDD_methodPrompt-testPointDiscovery.md). Classify by verification lens, not rule type or domain.
- Maintain an unbroken **TestEvidenceChain**: every test must establish an unbroken chain answering **WHY** we need the test point (source artifact -> rule/invariant -> Test Point (TP) -> observable oracle -> CaTDD category) and **HOW** we execute the test correctly (US/AC/TP/TC -> Test Case (TC) -> RED/GREEN test).
- Distinguish Acceptance Criteria (AC) from Test Point (TP): AC is formulated from the **User/Caller perspective** (`GIVEN context, WHEN action, THEN outcome`) defining what external rule must hold for acceptance. TP is formulated from the **Developer/Defensive perspective** (`GIVEN technical state/partition, WHEN action/interleaving, THEN observable oracle`) defining the concrete technical probe (nominal path, boundary offset, caller misuse, dependency fault, race condition) required to verify whether that AC holds. One AC typically unpacks into multiple TPs ($1:N$); equating $TP == AC$ causes boundary and failure omissions.
- Distinguish Test Point (TP) from Test Case (TC): A TP is a source-backed verification obligation (the target) discovered in Stage-0/Stage-1; a TC is an executable specification artifact (the arrow) implementing obligations under US/AC. Each TP MUST be covered by exactly one TC in a complete design. Each TC MUST cover at least one TP and MAY cover multiple TPs when its setup and assertions distinguish every obligation. An unassigned draft TP is a gap, not completed coverage; split an obligation into distinct TPs when independent test cases are needed.
- Discovery to Categorization: In Stage-0 (Freely Drafting), discover TPs breadth-first across sources and sweeps without premature category lock-in; in Stage-1 (Classifying Design), route each discovered TP to its proper CaTDD category based on its verification lens (Contract -> P0, Model -> P1, Envelope -> P2, Learning Surface -> P3).
- Enforce **Source-First** review: inspect authoritative source artifacts and independently derive expected obligations before consulting existing test files or skeletons.
- Keep authoritative TP definitions and the `discovery_ledger` in the verification-design document (`README_DetailVerifyDesign.md` in SpecFlow). Each candidate has an owning AC, covering TC or explicit gap, source/rule, scenario, oracle, verification method/environment, category/test level, scope/routing, and disposition. Test comments define TCs and reference TPs; they are not another TP authority. A handoff does not close an unresolved in-scope obligation.
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
3. Write US/AC/TP/TC comments, reconcile the ledger, and pass both the cardinality and Discovery Gate before implementation.
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
- Do not declare design complete from category presence or US/AC/TP/TC counts alone; pass the Discovery Gate for the declared scope.
- Do not reclassify a test because risk changed execution order.
- Do not expand a TC during refactor beyond its original AC meaning.

## Usage Example

Copy this self-contained request into a CodeAgent with the method available, or review it manually. The short IDs describe independent illustrative designs, not project artifact declarations:

```text
Review these TP/TC assignments using the CaTDD cardinality gate.
Assume the US, AC, and source links are valid. Do not implement code.
A: TP-01 -> TC-01; TP-02 -> TC-01.
B: TP-01 -> TC-01 and TC-02.
C: TP-01 -> no TC yet.
D: TC-01 -> no TP.
For each design, report whether its TP/TC cardinality is complete and why.
```

Expected result: A passes because one TC may cover multiple TPs. B fails because one TP has two TCs. C is an open draft gap that blocks completion. D fails because every TC must cover at least one TP.

## Maintenance Rule

When CaTDD method intent changes:

1. Update this main entry if the stable contract changes.
2. Update the matching `CaTDD_methodPrompt-*.md` subtopic for detailed guidance.
3. Update `README_UserGuide.md` and `README_UserGuide_ZH.md` if standalone users need to see the change.
4. Update category-specific `CaTDD_methodPrompt4Cat-*.md` only when a single category's deep guidance changes.
