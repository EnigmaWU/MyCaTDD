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
// @[StoryIdAlias]: Registered short aliases for those stories
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

## Artifact Ownership

| Artifact | Authoritative home | References elsewhere |
| --- | --- | --- |
| Story ID, `StoryIdAlias`, `CreatedAt` | Committed project story registry; in SpecFlow, `README_UserStories.md`. | Story/task metadata and test overviews preserve the registered mapping. |
| US and AC definitions | The requirements source named by that registry: the current todo/doing story or formal module `README_UserStory.md`. | Working copies and design/test comments reference the source; they are not independently mutable requirements. |
| TP definitions and ownership | The verification-design document; in SpecFlow, `README_DetailVerifyDesign.md` owns the authoritative TP definitions and `discovery_ledger`. | Architecture verification references/promotes the same TP IDs. Test files reference TPs, not a second authoritative ledger. |
| TC design and execution | Test files, including living comments, assertions, and scope-specific status. | The verification ledger records each TP's covering TC ID and test-file location. |

Standalone CaTDD uses the project's declared verification-design document for the TP ledger. FreelyDrafts may capture provisional discovery notes, but those notes must be reconciled into that document before design approval. Tests remain comment-alive: their TC intent, source links, and execution evidence stay beside the code. A referenced TP definition or ownership change goes through the verification-design owner before test metadata is synchronized.

## Coverage Matrix

Use coverage matrices to make hidden combinations visible before writing test code.

Build dimensions from source rules, not from tests already written. Link each applicable cell to TP IDs in the discovery ledger, or record a source-backed not-applicable reason. Document feasible-combination constraints and sampling limits; blank cells are unexamined, not covered. Apply the **Discovery Gate** in [CaTDD_methodPrompt-testPointDiscovery.md](CaTDD_methodPrompt-testPointDiscovery.md).

### Discovery References in Living Comments

Keep one feature-level inventory and `discovery_ledger` in the verification-design document. OVERVIEW / UNIT TESTING DESIGN comments link to it and carry TC-to-TP references, not competing TP definitions. The discovery subtopic owns disposition/readiness semantics.

```text
// DISCOVERY SCOPE: [SUT, feature, in-scope classes, test level, approved limits]
// DOMAIN / EXECUTION ENVIRONMENT: [profile(s), user-space/kernel boundary, host/simulator/target/HIL as relevant]
// DISCOVERY LEDGER: [verification-design document and section]
// @[StoryIdAlias]: [registered alias, not a new local ID]
// @[TP]: [qualified TP IDs defined in that document]
// @[Trace]: <StoryIdAlias> | <AC ID> | <TP ID> | <TC ID>
// DISCOVERY REVIEW: [current gate-evidence reference; no independently edited duplicate report]
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
StoryIdAlias: US-YYMMDD.HHMMSS
CreatedAt: [verified creation instant in ISO 8601 with +08:00 offset]
```

### Acceptance Criteria

```text
<StoryIdAlias>-AC-<n>: GIVEN [initial context and preconditions],
                       WHEN [specific trigger, action, or event],
                       THEN [expected observable outcome stated with MUST / MUST NOT (or conditional SHOULD / optional MAY)].
```

### Test Point

```text
<StoryIdAlias>-TP-<n>: [source-backed verification obligation and observable oracle]
  Owning AC ID: <StoryIdAlias>-AC-<n>
  Covering TC ID: <StoryIdAlias>-TC-<n> [or unassigned: GAP while drafting]
  Test file: [path to the TC declaration]
```

In a complete design, each US MUST have at least one AC, each AC MUST link to at least one TP, each TP MUST map to exactly one TC, and each TC MUST cover at least one TP. A TC MAY cover multiple TPs. Unassigned TPs may remain during discovery or drafting, but they are open coverage gaps and MUST block design completion. If one obligation requires independent test cases, split it into distinct TPs so each TP still maps to exactly one TC.

Each TP has exactly one owning AC. Unknown ownership is a QUESTION, not a fabricated link. A TC lists all covered TP IDs and their owning AC IDs; it may cover TPs from different ACs when each obligation is explicitly verified. Child numbers do not imply relationships. The ledger, TC metadata, and trace rows must agree in both directions.

### Test Case

```text
<StoryIdAlias>-TC-<n>:
  @[US]: US-<story>
  @[StoryIdAlias]: <StoryIdAlias>
  @[AC]: [qualified owning AC IDs for the covered TPs]
  @[TP]: [all covered, qualified TP IDs]
  @[TC]: <StoryIdAlias>-TC-<n>
  @[Trace]: <StoryIdAlias> | <AC ID> | <TP ID> | <TC ID>
  @[Name]: verifyBehavior_byCondition_expectResult
  @[Purpose]: Why this test matters
  @[Brief]: Setup, behavior, verify, cleanup in one sentence
  @[Expect]: Observable expected result (MUST / MUST NOT obligation using canonical README_UbiLang.md terms)
  @[Notes]: Optional dependencies, gotchas, or assumptions
  @[Status]: mockSysRtm <marker> | realSysRtm <marker>
```

## Project-Wide Traceability IDs

This contract applies to each project using CaTDD, whether invoked through SpecFlow or independently. A project's registered Story ID is the stable identity for its requirements and verification evidence; a filename, test-local `US-1`, or role label is not a project-wide identity by itself.

- Maintain one committed project-wide story registry. In SpecFlow, use the Story Ledger in `README_UserStories.md`; standalone CaTDD projects use their agreed committed requirements ledger. The registry identifies each Story ID and its current authoritative story/AC source. Story text and acceptance outcomes remain authoritative in that source, not in duplicated registry summaries.
- Preserve an existing unambiguous project-wide Story ID, including IDs already registered from an import. For a new project Story ID, use the human-readable form `US-<whoName>-<doWhat>`. Write `<whoName>` and `<doWhat>` in lowerCamelCase, with hyphens only separating the `US`, actor, and behavior segments. Derive `<whoName>` from the actor or role in the story's "As a ..." statement and `<doWhat>` from its observable "I want ..." behavior (for example, `US-eventProducer-postEventsWithoutBlocking`). If the actor or behavior is unclear, ask rather than inventing either. The registered Story ID is the stable project-wide identity; keep it when titles, filenames, lifecycle state, or implementation details change.
- Before registering a new Story ID, check the project registry and story declarations across all lifecycle lanes and module requirement sources, then check the integrated project again when concurrent branches are merged. If the candidate collides, refine it with meaningful domain, component, actor, or behavior context; do not append an opaque UUID or arbitrary number solely to force uniqueness. Stop and ask when the distinction cannot be named unambiguously. References and declared historical copies are not new independent stories.
- Register exactly one permanent `StoryIdAlias` per Story ID, together with `CreatedAt`. Format the verified story-creation instant in UTC+08:00 as `US-YYMMDD.HHMMSS`; retain the full ISO 8601 instant with `+08:00` in `CreatedAt`. Capture it once, not separately for each field. The alias is a short identity reference, not a replacement for the human-readable Story ID or a date to regenerate when editing.
- For a newly created project story identity, capture its actual creation instant at registration. Importing an existing identity preserves its verified original instant; dates on an external source remain separate provenance. A first import that creates a genuinely new project identity records that new identity's creation, not a fabricated date for the external requirement.
- Check alias uniqueness before registration and again during integration, including imports and concurrent branches. An alias must not shadow another story's canonical ID. A same-second collision between independent stories MUST stop registration for reconciliation; never reuse an alias, append an unapproved suffix, or invent a different creation time. Repeated references to the same registered story are not collisions. Reject mismatched Story ID/alias/time pairs.
- Preserve external or local source IDs as labeled aliases. If a source ID is already registered as the project-wide identity, preserve it; otherwise assign the new human-readable project ID and retain the source ID as an alias without rewriting source text or historical evidence.
- New child declarations use `<StoryIdAlias>-AC-<n>`, `<StoryIdAlias>-TP-<n>`, and `<StoryIdAlias>-TC-<n>`. `<StoryIdAlias>` is the complete registered alias, including `US-`; `<n>` is a stable token unique within that story and artifact kind. TP tokens are story-scoped, not reset under each AC. Allocate without reuse and never infer AC ownership or TC coverage from matching suffixes.
- Resolve either a Story ID or `StoryIdAlias` through the registry before reading or writing trace references. Preserve the pair across lifecycle moves, title/file changes, and revisions. A new independent successor gets its own pair and creation instant; a revision of the same story retains them.
- Existing registered child IDs remain valid legacy identities. Introducing alias-prefixed forms for them requires an explicit old-ID-to-new-ID mapping and synchronized active references; it does not create new ACs, TPs, or TCs. Do not silently rewrite archives or imported source text. For an existing story without an alias, use a verified creation instant only; a date without a known time is insufficient. Report the missing decision and block alias allocation rather than inventing midnight or using the migration time. Legacy references remain readable while migration is pending.
- Preserve the same ID when a story or test point moves between files, lifecycle states, categories, or test levels. Copies, revisions, and declared partial-closure slices are references to the same identity, not automatically duplicate stories. A materially different AC or test obligation receives a new ID with an explicit supersession or lineage link; do not silently reuse an old ID for a different meaning.
- Keep legacy or external local IDs as labeled aliases, with their source and revision when needed. On ambiguous ownership, conflicting imports, or reused historical AC meanings, stop and request reconciliation rather than guessing or rewriting history. A new independent split or follow-up story gets its own Story ID and traces to its parent and original ACs.
- Place the full alias-qualified IDs on new AC, verification-ledger TP, and test-file TC declarations. Carry those IDs into relevant design, test, and product-code trace references. A fixed-string search for `StoryIdAlias` must find the current declarations and trace rows in its family. A long Story ID search resolves the alias in the registry first; it need not occur in every child declaration. Follow explicit legacy or inherited references to their original owning sources.
- In a complete design, each US MUST have at least one AC, each AC MUST link to at least one TP, each TP MUST map to exactly one TC, and each TC MUST cover at least one TP. A TC MAY cover multiple TPs, including TPs linked to different ACs when every relationship is explicit. Unassigned draft TPs are coverage gaps and MUST block design completion; if an obligation needs independent test cases, split it into separate TPs. Shared evidence retains one owning ID and explicitly lists every related Story ID and qualified AC/TP reference. Do not duplicate IDs or invent coverage merely to make a link.
- Each TC's metadata identifies its `@[US]` (canonical Story ID), `@[StoryIdAlias]`, `@[AC]`, `@[TP]`, and `@[TC]`. Use `@[Trace]: <StoryIdAlias> | <AC ID> | <TP ID> | <TC ID>` once per actual relationship. Each TP's ledger row names its owning AC and sole covering TC; each TC lists every TP it covers. Reject unknown IDs, conflicting owners, missing or extra coverage links, and duplicate aliases. A trace line is a reference, never a second TP definition.
- Shared or inherited evidence retains its original owning IDs. A referencing story's trace row starts with that story's alias and may reference another registered owner's AC/TP/TC IDs only with explicit inheritance/sharing provenance. Do not require all four fields to share a prefix in that case, reparent a TP silently, or invent a duplicate TC. Unresolved or missing sources remain questions or gaps under the Discovery Gate; a grep hit is not proof of verification.

## Usage Example

For a new story, capture a candidate creation instant and alias once, then check the registry and known story sources before registering either:

```bash
python3 - <<'PY'
from datetime import datetime, timedelta, timezone
created_at = datetime.now(timezone(timedelta(hours=8))).replace(microsecond=0)
print("CreatedAt:", created_at.isoformat())
print("StoryIdAlias:", created_at.strftime("US-%y%m%d.%H%M%S"))
PY
```

The following is an illustrative, internally consistent artifact set, not a registered project story. Its assumed contract rejects a full-queue post without changing the queue and accepts a post with room exactly once.

### Requirements and registry example

The registry maps the pair to the authoritative requirements source; AC declarations live in that source:

```text
Story ID: US-queueClient-postWithinCapacity
StoryIdAlias: US-261029.070004
CreatedAt: 2026-10-29T07:00:04+08:00
US-261029.070004-AC-01: A full-queue post MUST reject without changing the queue.
US-261029.070004-AC-02: A post with room MUST enqueue exactly once.
```

### Verification-design example

These are authoritative TP rows in the verification-design document, not test comments:

```text
TP ID | Owning AC ID | Covering TC ID | Source-backed obligation
US-261029.070004-TP-01 | US-261029.070004-AC-01 | US-261029.070004-TC-01 | Full queue returns the specified rejection.
US-261029.070004-TP-02 | US-261029.070004-AC-01 | US-261029.070004-TC-01 | Rejected post leaves the queue unchanged.
US-261029.070004-TP-03 | US-261029.070004-AC-02 | US-261029.070004-TC-02 | Accepted post adds exactly one event.
```

### Test-file reference example

TC declarations reference the TP definitions and give each relationship its own searchable trace row:

```text
@[US]: US-queueClient-postWithinCapacity
@[StoryIdAlias]: US-261029.070004
@[TC]: US-261029.070004-TC-01
@[AC]: US-261029.070004-AC-01
@[TP]: US-261029.070004-TP-01, US-261029.070004-TP-02
@[Trace]: US-261029.070004 | US-261029.070004-AC-01 | US-261029.070004-TP-01 | US-261029.070004-TC-01
@[Trace]: US-261029.070004 | US-261029.070004-AC-01 | US-261029.070004-TP-02 | US-261029.070004-TC-01
@[Status]: mockSysRtm ⚪ TODO/PLANNED | realSysRtm ⚪ TODO/PLANNED

@[US]: US-queueClient-postWithinCapacity
@[StoryIdAlias]: US-261029.070004
@[TC]: US-261029.070004-TC-02
@[AC]: US-261029.070004-AC-02
@[TP]: US-261029.070004-TP-03
@[Trace]: US-261029.070004 | US-261029.070004-AC-02 | US-261029.070004-TP-03 | US-261029.070004-TC-02
@[Status]: mockSysRtm ⚪ TODO/PLANNED | realSysRtm ⚪ TODO/PLANNED
```

### Lookup and inherited evidence

From the project root, a literal search finds the family or an individual relationship; `-F` treats the alias's dot literally:

```bash
rg -n --hidden --glob '!.git/**' -F 'US-261029.070004' .
rg -n --hidden --glob '!.git/**' -F 'US-261029.070004-AC-01' .
rg -n --hidden --glob '!.git/**' -F 'US-261029.070004-TC-01' .
```

Expected: the alias locates the registry, ACs, TP ledger, and TC references; the AC locates its owned TPs; TC-01 locates both covered TPs. Distinguish declarations from examples and historical references. Zero matches do not establish uniqueness unless every authoritative source was searched.

An explicitly registered successor alias `US-261029.070006` may reference inherited evidence without changing the owning IDs:

```text
@[Trace]: US-261029.070006 | US-261029.070004-AC-01 | US-261029.070004-TP-01 | US-261029.070004-TC-01
```

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

Use a TODO/tracking block that records category, status, and next action. This excerpt references the Usage Example's existing AC/TP/TC identities; it does not define another TP ledger.

```text
STATUS LEGEND:
  TODO/PLANNED: designed but not implemented
  RED/FAILING: test written, executing cleanly, and failing for the expected semantic domain assertion
  GREEN/PASSED: test written and passing
  BROKEN_TEST: failing for the wrong reason; repair the harness before writing production code
  ISSUES: known problem needing attention
  BLOCKED: cannot proceed due to a dependency or unresolved source

P0 Functional / Typical:
  @[TC]: US-261029.070004-TC-02
  @[TP]: US-261029.070004-TP-03
  @[Trace]: US-261029.070004 | US-261029.070004-AC-02 | US-261029.070004-TP-03 | US-261029.070004-TC-02
  @[Status]: mockSysRtm ⚪ TODO/PLANNED | realSysRtm ⚪ TODO/PLANNED

P0 Functional / Edge:
  @[TC]: US-261029.070004-TC-01
  @[TP]: US-261029.070004-TP-01, US-261029.070004-TP-02
  @[Trace]: US-261029.070004 | US-261029.070004-AC-01 | US-261029.070004-TP-01 | US-261029.070004-TC-01
  @[Trace]: US-261029.070004 | US-261029.070004-AC-01 | US-261029.070004-TP-02 | US-261029.070004-TC-01
  @[Status]: mockSysRtm ⚪ TODO/PLANNED | realSysRtm ⚪ TODO/PLANNED
```
