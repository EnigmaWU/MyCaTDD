# CaTDD Method Prompt - Workflow

This subtopic defines the CaTDD execution flow from raw test ideas to RED/GREEN implementation and refactoring.

## Stage Model

CaTDD uses two design stages before implementation.

| Stage | Purpose | Output |
| --- | --- | --- |
| Stage-0: Freely Drafting | Inventory source-backed obligations; use Example Mapping and applicable domain/class sweeps to discover examples and questions breadth-first. Use OOPSI/business-rule aids only for suitable functional sources. | FreelyDrafts, source/rule inventory, discovery dimensions, candidate ledger |
| Stage-1: Classifying Design | Classify mature drafts into P0, P1, P2, P3 category skeletons, reconcile every candidate in the living ledger, and pass the Discovery Gate before approving US/AC/TC. | Category skeletons, discovery ledger, independent review evidence, TODO tracking |

## Phase 1: Design and Planning

1. Define the component or feature under test.
2. Declare the SUT, in-scope classes, domain profile(s), test level, and execution environment explicitly in the test-file overview. Embedded Linux is the primary usage context, followed by Microservices and LLM Agents; do not force unrelated profiles into a slice.
3. Inventory all in-scope source rules before treating existing tests as coverage evidence.
4. Use [CaTDD_methodPrompt-testPointDiscovery.md](CaTDD_methodPrompt-testPointDiscovery.md) for Example Mapping and applicable P0/P1/P2/P3 sweeps. Capture source-defined examples, verification methods, and questions in living comments; domain hints never supply thresholds or product policy.
5. Classify drafts using `CaTDD_methodPrompt-categorySemantics.md`.
6. Select category-specific prompt files when deeper category guidance is needed.

## Phase 2: Structured Verification Design

1. Write User Stories using the role, capability, value structure.
2. Write Acceptance Criteria using GIVEN, WHEN, THEN.
3. Write Test Cases with structured metadata: `@[Name]`, `@[Purpose]`, `@[Brief]`, `@[Expect]`.
4. Keep TC names in `verifyBehavior_byCondition_expectResult` form.
5. Keep each test to no more than three key assertions; split if needed.
6. Put planned TCs in the TODO/tracking section.
7. Reconcile the discovery ledger, then run the source-first independent challenge and **Discovery Gate** from [CaTDD_methodPrompt-testPointDiscovery.md](CaTDD_methodPrompt-testPointDiscovery.md). Missing in-scope oracles, sources, or obligations prevent readiness even when every written AC has a TC.

## Mandatory Traceability

- P0 Functional design should include `Typical -> Edge -> Misuse -> Fault` unless scope is explicitly limited.
- Each US must map to at least one AC.
- Each AC must map to at least one TC.
- Each non-empty category file must trace to a source-of-truth artifact.
- Missing source evidence should stop design or become `@[NoTestPoints]: <reason>`.
- A missing-source `@[NoTestPoints]` is BLOCKED, not evidence that coverage is unnecessary. Report discovery dispositions and residual risk separately from linkage counts.

## Phase 3: TDD Red-Green Cycle

For each selected TC:

1. Write the test first following the 4-phase layout (SETUP -> BEHAVIOR -> VERIFY -> CLEANUP).
2. Run the test and confirm **meaningful 🔴 RED** under the **Semantic Falsification Gate**:
   - The test must fail strictly on a domain assertion failure (`AssertionError`, `Expected X but got Y`).
   - If it fails due to syntax errors, missing imports, unhandled exceptions in setup, or fixture crashes, it is **`⚠️ BROKEN_TEST`**, not RED. Do not write production code until the test executes cleanly and fails on its assertion.
   - Enforce the **Anti-Test-Theater Rule**: assertions must verify real SUT state mutation or domain invariants, never mock returns directly without transformation.
3. Implement the minimum production code needed for 🟢 GREEN. Never modify the test to manufacture a pass.
4. Run the focused test and confirm GREEN.
5. Run the relevant regression scope.
6. Update TC status markers.
7. Refactor design comments, test code, then production code while preserving behavior.

## Default Execution Order

| Order | Category Family |
| --- | --- |
| P0 | Typical -> Edge -> Misuse -> Fault |
| P1 | State -> Capability -> Interaction -> Concurrency |
| P2 | Performance -> Robust -> Compatibility -> Configuration -> Diagnosis -> Security |
| P3 | Demo/Example |

Risk may change this execution order but must not change category identity.

## Risk-Based Ordering

Use this score when deciding whether to execute a category earlier:

```text
Risk Score = Impact x Likelihood x Uncertainty
Impact:      1 low -> 3 critical
Likelihood:  1 rare -> 3 frequent
Uncertainty: 1 known -> 3 unknown
```

| Score | Execution Adjustment |
| --- | --- |
| 18-27 | Move category immediately after Edge |
| 12-17 | Move up two positions from default |
| 9-11 | Move up one position from default |
| 1-8 | Keep default position |

Examples:

- A release-blocking latency scenario remains P2 Quality / Performance even if executed early.
- A severe race-condition scenario remains P1 Design / Concurrency when it proves synchronization correctness.
- A sequence-diagram call order scenario remains P1 Design / Interaction when it proves collaborator handoff design.
- A structured log or trace evidence scenario remains P2 Quality / Diagnosis when it proves explainability.
- A secret-leak or authorization scenario remains P2 Quality / Security when it proves a protection property.
- A missing required argument remains P0 Functional / Misuse.
- A missing dependency file remains P0 Functional / Fault when the caller is valid.

## Quality Gates

### Gate P0

Before leaving P0:

- The Discovery Gate passes for the declared P0 scope; all in-scope questions and design gaps are resolved, with exclusions/referrals visible.
- Typical tests are GREEN.
- Edge tests are GREEN or explicitly scoped out.
- Misuse tests are GREEN or documented.
- Fault tests are GREEN or documented.
- No critical correctness bugs remain.

### Gate P1

Before moving from P1 to P2:

- State tests are GREEN when stateful behavior exists.
- Capability tests are GREEN when designed limits exist.
- Interaction tests are GREEN when sequence, collaboration, or handoff rules exist.
- Concurrency tests are GREEN when shared execution exists.
- Known race and deadlock risks are resolved or documented.

### Gate P2

Before release or P3:

- Performance tests meet defined budgets when budgets exist.
- Robust tests pass required stress or repetition checks.
- Compatibility tests cover supported boundary sets.
- Configuration tests cover defaults, precedence, and invalid config.
- Diagnosis tests cover actionable evidence when observability or failure explainability is required.
- Security tests cover defined threat, policy, trust-boundary, or protection requirements.

### Gate P3

Before treating demos/examples as done:

- Demo/Example tests are GREEN.
- Tutorial or README code executes as documented.
- Examples do not contradict P0/P1/P2 design decisions.
