# CaTDD Method Prompt - Test Structure

This subtopic defines the comment skeleton, US/AC/TC structure, coverage matrix, naming conventions, and tracking shape used by CaTDD test files.

## Comment Skeleton

Every class/category skeleton should preserve this minimum shape.

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

## Coverage Matrix

Use coverage matrices to make hidden combinations visible before writing test code.

### Basic 2D Matrix

```text
Dimension 1 | Dimension 2 | Key Scenarios
Value A     | Value X     | US-1: Core happy path
Value A     | Value Y     | US-2: Edge condition
Value B     | Value X     | US-3: Error handling
```

### Common Dimensions

| Component Type | Useful Dimensions |
| --- | --- |
| Event system | Service role x client role x mode |
| State machine | State x operation x edge condition |
| Concurrent queue | Concurrency x resource level x operation |
| CLI | command mode x input source x validation outcome |
| Microservice | endpoint x auth state x dependency state |

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

## US/AC/TC Contract

### User Story

```text
US-n: As a [specific role/persona],
      I want [specific capability or feature],
      So that [concrete business value or benefit].
```

### Acceptance Criteria

```text
AC-n: GIVEN [initial context and preconditions],
      WHEN [specific trigger, action, or event],
      THEN [expected observable outcome or behavior].
```

### Test Case

```text
[@AC-n,US-n]
TC-n:
  @[Name]: verifyBehavior_byCondition_expectResult
  @[Purpose]: Why this test matters
  @[Brief]: Setup, behavior, verify, cleanup in one sentence
  @[Expect]: Observable expected result
  @[Notes]: Optional dependencies, gotchas, or assumptions
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

    // === CLEANUP ===
    // Reset or release state when needed.
}
```

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
  RED/IMPLEMENTED: test written and failing for expected reason
  GREEN/PASSED: test written and passing
  ISSUES: known problem needing attention

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
