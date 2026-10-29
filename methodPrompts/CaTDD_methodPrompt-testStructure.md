# CaTDD Method Prompt - Test Structure

This subtopic defines the comment skeleton, US/AC/TP/TC structure, coverage matrix, naming conventions, and tracking shape used by CaTDD test files.

## Comment Skeleton

Every class/category skeleton **MUST** preserve this minimum shape.

```text
//=================================================================================================
// [Class] / [Category] Design Skeleton
//=================================================================================================
// @[SUT]: [Declared SUT matching file overview]
// @[TestLevel]: UnitTesting (or SysTesting / UserTesting)
// @[TestScope]: mockSysRtm (or realSysRtm)
// @[Class]: P0 Functional / ValidFunc
// @[Category]: Typical
// @[Intent]: What this category proves for this component
// @[UseWhen]: When this category applies
// @[AvoidWhen]: When to move the scenario to another category
// @[US]: User Story IDs covered by this category
// @[AC]: Acceptance Criteria IDs covered by this category
// @[TP]: Test Point IDs covered by this category
// @[TC]: Test Cases, status, and expected TDD next action
//=================================================================================================
```

Each tracked test case **MUST** carry one `@[Status]` line that names both scopes explicitly, so a case can be green on doubles while the real runtime is still outstanding:

```text
// @[Status]: mockSysRtm <marker> | realSysRtm <marker>
```

`mockSysRtm` is the first scope and is where `CLOSED` is earned. `realSysRtm` uses the same markers plus `➖ N/A`, which may only be used with a recorded reason that the case has no runtime-meaningful behavior.

### Test Level and Verification Design Ownership

`@[TestLevel]` declares where a test point is executed. Use exactly one canonical token:

| `@[TestLevel]` | Means | Verification design stage that owns the strategy |
| --- | --- | --- |
| `UnitTesting` | One unit is the SUT, verified inside its own boundary under the project's `sut_unit_convention`. When the project has no subdivision, `UnitTesting` and `SysTesting` name the same SUT and are equivalent. | The detail-level verification design owns the behavior inventory, `discovery_ledger`, and CaTDD category design. |
| `SysTesting` | The composition of units is the SUT: the module in a multi-submodule project, or the whole project when it has no subdivision. | The architecture-level verification design owns the composition boundary, the `TestScope` strategy, and double credibility. The TP row stays in the detail ledger and is promoted by ID. |
| `UserTesting` | A `SysTesting` scope oriented to usage scenarios: documented end-to-end, demo, and example flows. | The architecture-level verification design; it is not CaTDD category testing. |

`TestLevel` says how much of the developed system is inside the SUT. What the SUT's runtime is made of is a separate axis, declared independently so any level can run at either scope:

| `@[TestScope]` | Means |
| --- | --- |
| `mockSysRtm` | The SUT's system runtime - peers, dependencies, runtime environment - is replaced by doubles. The first scope, always attempted first, and the scope that earns `CLOSED`. |
| `realSysRtm` | The SUT runs against its real system runtime. The second scope: it adds evidence and never replaces a `mockSysRtm` closure. |

`ModuleTesting` is a retired level name and is never used. Module-level scope is `SysTesting` when the module is the declared SUT, so it is not a fourth value beside the three level values.

This layer names design stages, not workflow artifacts. The mapping from these stages to project documents is owned by the workflow layer.

## Coverage Matrix

Use coverage matrices to make hidden combinations visible before writing test code.

Build dimensions from source rules, not from tests already written. Link each applicable cell to TP IDs in the discovery ledger, or record a source-backed not-applicable reason. Document feasible-combination constraints and sampling limits; blank cells are unexamined, not covered. Apply the **Discovery Gate** in [CaTDD_methodPrompt-testPointDiscovery.md](CaTDD_methodPrompt-testPointDiscovery.md).

### Discovery Evidence in Living Comments

Keep one feature-level inventory and `discovery_ledger` in FreelyDrafts or the OVERVIEW / UNIT TESTING DESIGN comments; category files link to it. These comments supplement, not replace, US/AC/TP/TC or TODO status. The discovery subtopic owns the disposition/readiness semantics.

```text
// DISCOVERY SCOPE: [SUT, feature, in-scope classes, test level, approved limits]
// DOMAIN / EXECUTION ENVIRONMENT: [profile(s), user-space/kernel boundary, host/simulator/target/HIL as relevant]
// SOURCES / RULES: [artifact#section or rule ID -> behavior, model invariant, quality predicate, or guide outcome]
// DIMENSIONS: [applicable P0/P1/P2/P3 sweep dimension/partition/combination -> TP IDs or reason not applicable]
// SAMPLING: [feasible dimensions/constraints, selection method, omissions/rationale, risk-significant additions; or not applicable]
// REVIEW: [reviewer/process or labeled self-review, sources, independently derived operation/outcome checklist, residual risk]
// TP ID | Source/rule | Setup/action | Observable oracle | Category/level | Disposition/evidence
// TP-01 | [source/R1] | [condition]  | [expected result]  | Typical/unit   | DESIGNED: [file, US/AC/TP/TC IDs]
// TP-02 | [source/R2] | [condition]  | unknown            | provisional    | QUESTION: [question, decision owner]
// VERIFICATION METHOD by TP ID: [automated/manual/hybrid procedure, environment, evidence capture]
// SCOPE / ROUTING by TP ID: [in/out of scope, destination and owner if applicable; independent of disposition]
// Discovery Gate: [PASS/GAPS/BLOCKED, review evidence, residual risk]
// ready_for_implementation: [yes/no for this scope; not release readiness]
```

### Basic 2D Matrix

```text
Dimension 1 | Dimension 2 | Key Scenarios
Value A     | Value X     | US-1: Core happy path
Value A     | Value Y     | US-2: Edge condition
Value B     | Value X     | US-3: Error handling
```

### Common Dimensions

| Component Type / Domain | Useful Dimensions |
| --- | --- |
| Event system | Service role x client role x mode |
| State machine | State x operation x edge condition |
| Concurrent queue | Concurrency x resource level x operation |
| CLI | command mode x input source x validation outcome |
| Embedded Linux | SUT layer x operation x resource/device condition x host/target environment; separate user-space, kernel, shared RAM, and MMIO/DMA boundaries |
| Microservice | Endpoint/workflow x caller role x dependency outcome across supported deployments |
| LLM Agent | Goal/task x tool permission x provider/session condition; identify whether the SUT is the orchestrator, adapter, or tool |

## Test Naming Convention

Use this TC function name shape:

```text
verifyBehavior_byCondition_expectResult
```

Examples:

```text
verifyServiceRegistration_byValidName_expectSuccess
verifyEventPost_byFullQueue_expectNonBlockReturn
verifyCommandExec_byMultipleClients_expectIsolatedExecution
verifyStateTransition_byInvalidSequence_expectError
```

## US/AC/TP/TC Contract

### User Story

```text
US-<story>: As a [specific role/persona],
            I want [specific capability or feature],
            So that [concrete business value or benefit].
```

### Acceptance Criteria

```text
US-<story>-AC-<n>: GIVEN [initial context and preconditions],
                   WHEN [specific trigger, action, or event],
                   THEN [expected observable outcome stated with MUST / MUST NOT (or conditional SHOULD / optional MAY)].
```

### Test Point

```text
US-<story>-TP-<n>: [source-backed verification obligation and observable oracle]
```

In a complete design, each US MUST have at least one AC, each AC MUST link to at least one TP, each TP MUST map to exactly one TC, and each TC MUST cover at least one TP. A TC MAY cover multiple TPs. Unassigned TPs may remain during discovery or drafting, but they are open coverage gaps and MUST block design completion. If one obligation requires independent test cases, split it into distinct TPs so each TP still maps to exactly one TC.

### Test Case

```text
US-<story>-TC-<n>:
  @[US]: US-<story>
  @[AC]: US-<story>-AC-<n>
  @[TP]: US-<story>-TP-<n>
  @[TC]: US-<story>-TC-<n>
  @[Name]: verifyBehavior_byCondition_expectResult
  @[Purpose]: Why this test matters
  @[Brief]: Setup, behavior, verify, cleanup in one sentence
  @[Expect]: Observable expected result (MUST / MUST NOT obligation using canonical README_UbiLang.md terms)
  @[Notes]: Optional dependencies, gotchas, or assumptions
```

## Project-Wide Traceability IDs

This contract applies to each project using CaTDD, whether invoked through SpecFlow or independently. A project's registered Story ID is the stable identity for its requirements and verification evidence; a filename, test-local `US-1`, or role label is not a project-wide identity by itself.

- Maintain one committed project-wide story registry. In SpecFlow, use the Story Ledger in `README_UserStories.md`; standalone CaTDD projects use their agreed committed requirements ledger. The registry identifies each Story ID and its current authoritative story/AC source. Story text and acceptance outcomes remain authoritative in that source, not in duplicated registry summaries.
- Preserve an existing unambiguous project-wide Story ID, including IDs already registered from an import. For a new project Story ID, use the human-readable form `US-<whoName>-<doWhat>`. Write `<whoName>` and `<doWhat>` in lowerCamelCase, with hyphens only separating the `US`, actor, and behavior segments. Derive `<whoName>` from the actor or role in the story's "As a ..." statement and `<doWhat>` from its observable "I want ..." behavior (for example, `US-eventProducer-postEventsWithoutBlocking`). If the actor or behavior is unclear, ask rather than inventing either. The registered Story ID is the stable project-wide identity; keep it when titles, filenames, lifecycle state, or implementation details change.
- Before registering a new Story ID, check the project registry and story declarations across all lifecycle lanes and module requirement sources, then check the integrated project again when concurrent branches are merged. If the candidate collides, refine it with meaningful domain, component, actor, or behavior context; do not append an opaque UUID or arbitrary number solely to force uniqueness. Stop and ask when the distinction cannot be named unambiguously. References and declared historical copies are not new independent stories.
- Preserve external or local source IDs as labeled aliases. If a source ID is already registered as the project-wide identity, preserve it; otherwise assign the new human-readable project ID and retain the source ID as an alias without rewriting source text or historical evidence.
- Under each Story ID, use unique, stable qualified identifiers: `US-<story>-AC-<n>`, `US-<story>-TP-<n>`, and `US-<story>-TC-<n>`. Here `US-<story>` is the complete registered Story ID and `<n>` is a stable child token scoped to that story. Short tokens such as `01`, `02` are readable and sufficient because the full qualified ID includes the project-wide Story ID. Allocate child tokens without reuse and check for collisions again during integration; do not silently renumber accepted IDs.
- Preserve the same ID when a story or test point moves between files, lifecycle states, categories, or test levels. Copies, revisions, and declared partial-closure slices are references to the same identity, not automatically duplicate stories. A materially different AC or test obligation receives a new ID with an explicit supersession or lineage link; do not silently reuse an old ID for a different meaning.
- Keep legacy or external local IDs as labeled aliases, with their source and revision when needed. On ambiguous ownership, conflicting imports, or reused historical AC meanings, stop and request reconciliation rather than guessing or rewriting history. A new independent split or follow-up story gets its own Story ID and traces to its parent and original ACs.
- Place the full qualified IDs on each AC, discovery-ledger TP, and TC declaration. Carry the corresponding Story IDs and AC/TP/TC references into relevant design, verification, test, and product-code boundaries using language-appropriate comments or an explicit source-to-symbol trace when comments are unsuitable. A literal search for the Story ID must find its declared ACs, TPs, TCs, and trace references.
- In a complete design, each US MUST have at least one AC, each AC MUST link to at least one TP, each TP MUST map to exactly one TC, and each TC MUST cover at least one TP. A TC MAY cover multiple TPs, including TPs linked to different ACs when every relationship is explicit. Unassigned draft TPs are coverage gaps and MUST block design completion; if an obligation needs independent test cases, split it into separate TPs. Shared evidence retains one owning ID and explicitly lists every related Story ID and qualified AC/TP reference. Do not duplicate IDs or invent coverage merely to make a link.
- Each TC's metadata must identify its relevant `@[US]`, `@[AC]`, and `@[TP]` values as well as its qualified `@[TC]` ID. When an AC, TP, or TC is shared or inherited, put the referencing Story ID and the original qualified ID together on the same trace line; for test evidence use `@[Trace]: <StoryID> | <AC ID> | <TP ID> | <TC ID>`. Record each actual relationship separately and retain the original owning ID rather than inventing copies. Unresolved or missing sources remain questions or gaps under the Discovery Gate; an ID or a grep hit is not proof of implementation or verification.

## Usage Example

For the story "As an event producer, I want to post events without blocking," propose `US-eventProducer-postEventsWithoutBlocking`. In a SpecFlow project, run this from the project root before registration:

```bash
rg -n --hidden --fixed-strings 'US-eventProducer-postEventsWithoutBlocking' README_UserStories.md .catdd/spec
```

Review matches to distinguish a registered story declaration from references or examples. Also check known module story sources before registration. Then use that same ID in qualified child identifiers; the following descriptions are illustrative, not inferred project requirements:

```text
US-eventProducer-postEventsWithoutBlocking-AC-01: User-visible acceptance outcome
US-eventProducer-postEventsWithoutBlocking-TP-01: Source-backed verification obligation
@[US]: US-eventProducer-postEventsWithoutBlocking
@[AC]: US-eventProducer-postEventsWithoutBlocking-AC-01
@[TP]: US-eventProducer-postEventsWithoutBlocking-TP-01
@[TC]: US-eventProducer-postEventsWithoutBlocking-TC-01
```

For a successor that reuses an existing AC, record both IDs together without reassigning the original AC:

```text
US-eventProducer-confirmIdempotency -> US-eventProducer-postEventsWithoutBlocking-AC-01 (inherited acceptance criterion)
```

The command lists occurrences containing the candidate ID, including qualified child IDs. Review the referenced artifacts and their evidence; a search cannot prove that an unmarked declaration is unrelated or that a test passed.

## Four-Phase Test Body

Use SETUP, BEHAVIOR, VERIFY, CLEANUP.

```cpp
TEST(CategoryName, verifyBehavior_byCondition_expectResult) {
    // === SETUP ===
    // Build fixtures and inputs.

    // === BEHAVIOR ===
    // Execute the behavior under test.

    // === VERIFY ===
    // Check no more than three key expectations.
    // ANTI-TEST-THEATER RULE:
    // - Assertions MUST verify real SUT state mutation or domain invariants.
    // - NEVER assert mock returns directly without SUT transformation (mock-testing-mock).
    // - Avoid vacuous truthiness assertions (e.g., assert result is not None).

    // === CLEANUP ===
    // Reset or release state when needed.
}
```

### Anti-Test-Theater & Semantic Falsification Gate

To prevent LLMs and agents from generating hollow tests or faking the RED phase:

1. **Semantic Falsification Gate (Valid 🔴 RED vs. ⚠️ BROKEN_TEST)**:
   - A test is validly `🔴 RED` **only if it fails on a semantic domain assertion** (e.g., `AssertionError`, `ASSERT_EQ mismatch`, `Expected X but got Y`).
   - If execution fails due to syntax errors, missing imports, unhandled exceptions in test setup, or fixture crashes, it is **`⚠️ BROKEN_TEST`**, not valid RED. Production code generation is blocked until the test harness compiles and executes cleanly.
2. **Anti-Tautology Assertions**:
   - Forbid asserting on mock-injected data without an intervening SUT state transition or computation.
   - Forbid bare null/truthiness checks (`assert != null`, `assert True`) when specific properties, schemas, or status codes are promised in `@[Expect]`.

## Category File Naming

Use category-specific files when the project is large enough that a single file hides intent.

```text
test_{feature}_{category}.<ext>
```

Rules:

- `{feature}` is a stable lower_snake_case usage slice.
- `{category}` uses the canonical token table in `CaTDD_methodPrompt-categorySemantics.md`.
- Start with `test_{feature}_freelyDrafts.<ext>` for exploration.
- Move mature test points into category-specific files.
- Empty-by-omission is forbidden; use `@[NoTestPoints]: <reason>`.

Examples:

```text
test_command_execution_funcValidTypical.cxx
test_command_execution_funcValidEdge.cxx
test_command_execution_funcInvalidMisuse.cxx
test_command_execution_funcInvalidFault.cxx
test_command_execution_designConcurrency.cxx
test_command_execution_qualityPerformance.cxx
test_command_execution_qualityDiagnosis.cxx
test_command_execution_qualitySecurity.cxx
```

## Implementation Tracking Template

Use a TODO/tracking block that records category, status, and next action.

```text
STATUS LEGEND:
  TODO/PLANNED: designed but not implemented
  RED/FAILING: test written, executing cleanly, and failing for the expected semantic domain assertion
  GREEN/PASSED: test written and passing
  BROKEN_TEST: failing for the wrong reason; repair the harness before writing production code
  ISSUES: known problem needing attention
  BLOCKED: cannot proceed due to a dependency or unresolved source

P0 Functional:
  [@AC-1,US-1] TC-1: verifyCore_byBasicOperation_expectSuccess - TODO
  [@AC-2,US-1] TC-1: verifyMisuse_byDoubleInit_expectError - TODO

P1 Design:
  [@AC-3,US-2] TC-1: verifyState_byInvalidTransition_expectRejected - TODO
  [@AC-3,US-2] TC-2: verifyFlow_byAdapterSequence_expectTranslateBeforeDispatch - TODO

P2 Quality:
  [@AC-4,US-3] TC-1: verifyPerformance_byHighLoad_expectWithinBudget - TODO
  [@AC-4,US-3] TC-2: verifyFailure_byTimeout_expectActionableDiagnosticEvidence - TODO
```
