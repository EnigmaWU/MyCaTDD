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
- The test is about collaborator sequence or handoff design; use Interaction.
- The test is about concurrent interleavings; use Concurrency.

## Design Focus

- Separate valid edge behavior from invalid misuse behavior.
- Make the boundary explicit: min, max, exactly full, one before full, one after full, first call, last call.
- State whether the expected result is success or a documented non-failure edge result.
- Keep each test centered on one edge so failures are diagnostic.

## TestPointsInMind

When this category applies, consider test points such as:

- Named valid boundaries: zero, empty, first, last, minimum, maximum, exactly full, one below full, or last allowed item.
- Valid mode variations that change behavior while keeping the caller correct: sync/async, blocking/non-blocking, timeout/no-timeout, callback/polling.
- Boundary transitions that should remain safe: from empty to one item, from one item to empty, from capacity-1 to capacity, or from first to next.
- Documented non-success edge results that are still valid contract behavior, such as timeout, no data, queue full, or already up to date.
- The point where the scenario stops being Edge and becomes Misuse, Fault, Capability, Performance, State, or Concurrency.

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
- Should this scenario move to Capability, Performance, State, Interaction, Concurrency, Diagnosis, Security, or another source-backed category instead?

## Common Mistakes

- Mixing invalid misuse cases into Edge because both are "not normal".
- Treating capacity stress as Edge when the intent is maximum ability verification.
- Testing many boundaries in one test instead of isolating the failing condition.
- Using "Boundary" and "Edge" as two separate categories; in CaTDD, Edge is canonical.
