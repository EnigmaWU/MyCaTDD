# CaTDD Method Prompt - Workflow

This subtopic defines the CaTDD execution flow from raw test ideas to RED/GREEN implementation and refactoring.

## Stage Model

CaTDD uses two design stages before implementation.

| Stage | Purpose | Output |
| --- | --- | --- |
| Stage-0: Freely Drafting | Capture raw scenarios, examples, risks, and questions without forcing structure too early. | FreelyDrafts, open questions, rough coverage dimensions |
| Stage-1: Classifying Design | Classify mature drafts into CaTDD classes/categories and convert them into US/AC/TC. | Category skeletons, US/AC/TC comments, TODO tracking |

## Phase 1: Design and Planning

1. Define the component or feature under test.
2. Declare the SUT explicitly in the test-file overview.
3. Identify coverage dimensions such as role, mode, state, resource, or environment.
4. Capture freely drafted scenarios and questions.
5. Classify drafts using `CaTDD_methodPrompt-categorySemantics.md`.
6. Select category-specific prompt files when deeper category guidance is needed.

## Phase 2: Structured Verification Design

1. Write User Stories using the role, capability, value structure.
2. Write Acceptance Criteria using GIVEN, WHEN, THEN.
3. Write Test Cases with structured metadata: `@[Name]`, `@[Purpose]`, `@[Brief]`, `@[Expect]`.
4. Keep TC names in `verifyBehavior_byCondition_expectResult` form.
5. Keep each test to no more than three key assertions; split if needed.
6. Put planned TCs in the TODO/tracking section.

## Mandatory Traceability

- P0 Functional design should include `Typical -> Edge -> Misuse -> Fault` unless scope is explicitly limited.
- Each US must map to at least one AC.
- Each AC must map to at least one TC.
- Each non-empty category file must trace to a source-of-truth artifact.
- Missing source evidence should stop design or become `@[NoTestPoints]: <reason>`.

## Phase 3: TDD Red-Green Cycle

For each selected TC:

1. Write the test first.
2. Run the test and confirm RED for the intended reason.
3. Implement the minimum production code needed for GREEN.
4. Run the focused test and confirm GREEN.
5. Run the relevant regression scope.
6. Update TC status markers.
7. Refactor design comments, test code, then production code while preserving behavior.

## Default Execution Order

| Order | Category Family |
| --- | --- |
| P0 | Typical -> Edge -> Misuse -> Fault |
| P1 | State -> Capability -> Concurrency |
| P2 | Performance -> Robust -> Compatibility -> Configuration |
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
- A missing required argument remains P0 Functional / Misuse.
- A missing dependency file remains P0 Functional / Fault when the caller is valid.

## Quality Gates

### Gate P0

Before leaving P0:

- Typical tests are GREEN.
- Edge tests are GREEN or explicitly scoped out.
- Misuse tests are GREEN or documented.
- Fault tests are GREEN or documented.
- No critical correctness bugs remain.

### Gate P1

Before moving from P1 to P2:

- State tests are GREEN when stateful behavior exists.
- Capability tests are GREEN when designed limits exist.
- Concurrency tests are GREEN when shared execution exists.
- Known race and deadlock risks are resolved or documented.

### Gate P2

Before release or P3:

- Performance tests meet defined budgets when budgets exist.
- Robust tests pass required stress or repetition checks.
- Compatibility tests cover supported boundary sets.
- Configuration tests cover defaults, precedence, and invalid config.

### Gate P3

Before treating demos/examples as done:

- Demo/Example tests are GREEN.
- Tutorial or README code executes as documented.
- Examples do not contradict P0/P1/P2 design decisions.
