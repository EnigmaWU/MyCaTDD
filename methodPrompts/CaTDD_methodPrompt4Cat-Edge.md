# CaTDD method prompt for Category: Edge

Use this prompt when designing P0 Functional tests for valid edge cases, boundary values, limits, and mode variations.

## Position

Edge belongs to P0 Functional ValidFunc testing.

```text
P0 Functional = ValidFunc(Typical + Edge) + InvalidFunc(Misuse + Fault)
```

Edge proves that the feature still works correctly at the edges of valid use. In older material, "Boundary" is an alias for this category.

## Use When

- Inputs are valid but unusual: empty, zero, minimum, maximum, first, last, full, or near-limit.
- Modes are valid but behavior changes by mode: block, non-block, timeout, sync, async, callback, polling.
- The feature should return a defined result at a limit without crashing or drifting.
- A Typical test exists and you now need to cover the valid shape around it.

## Do Not Use When

- The caller violates the API contract; use Misuse.
- The environment or dependency fails; use Fault.
- The test is about maximum designed capacity as an architectural promise; use Capability.
- The test is about performance at high volume; use Performance.
- The test is about concurrent interleavings; use Concurrency.

## Design Focus

- Separate valid edge behavior from invalid misuse behavior.
- Make the boundary explicit: min, max, exactly full, one before full, one after full, first call, last call.
- State whether the expected result is success or a documented non-failure edge result.
- Keep each test centered on one edge so failures are diagnostic.

## Design Skeleton

```text
// @[Class]: P0 Functional / ValidFunc
// @[Category]: Edge
// @[Intent]: Prove valid edge values, limits, and mode variations.
// @[UseWhen]: The caller is valid, but the condition is empty, zero, min, max, full, first, last, or mode-specific.
// @[AvoidWhen]: The scenario is caller misuse, external fault, capacity, performance, state, or concurrency.
// @[US]: [US IDs]
// @[AC]: [AC IDs]
// @[TC]: verify[Behavior]_by[EdgeCondition]_expect[DocumentedResult]
```

## US/AC/TC Pattern

```text
US-n: As a [valid API consumer],
      I want [capability] to behave predictably at [edge/limit],
      So that [the caller can handle the condition safely].

AC-n: GIVEN [valid setup at a named edge condition],
      WHEN [the operation is executed],
      THEN [the documented edge behavior is returned],
       AND [state/resources remain consistent].

TC-n:
  @[Name]: verify[Behavior]_by[EdgeCondition]_expect[DocumentedResult]
  @[Purpose]: Validate a valid limit or mode variation.
  @[Brief]: Drive the component to the edge and perform one operation.
  @[Expect]: Defined result, no crash, no resource/state corruption.
```

## Naming Examples

```text
verifyWait_byZeroTimeout_expectImmediateTimeout
verifyQueuePush_byExactlyFullQueue_expectQueueFullResult
verifyRead_byEmptyBuffer_expectNoDataAvailable
verifyRead_byLastAvailableItem_expectSuccess
```

## Checklist

- Is the input/state still within the documented valid or handled contract?
- Is the exact edge named in the TC name?
- Is "one below / exactly / one above" considered when relevant?
- Is the expected behavior documented rather than guessed?
- Should this scenario move to Capability, Performance, State, or Concurrency instead?

## Common Mistakes

- Mixing invalid misuse cases into Edge because both are "not normal".
- Treating capacity stress as Edge when the intent is maximum ability verification.
- Testing many boundaries in one test instead of isolating the failing condition.
- Using "Boundary" and "Edge" as two separate categories; in CaTDD, Edge is canonical.
