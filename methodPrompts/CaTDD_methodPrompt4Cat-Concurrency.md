# CaTDD method prompt for Category: Concurrency

Use this prompt when designing P1 Design-oriented tests for thread safety, synchronization, race conditions, and parallel API usage.

## Position

Concurrency is the third P1 Design category by default, but it can be promoted when thread safety is architectural core.

```text
P1 Design = State -> Capability -> Concurrency
```

Concurrency proves that correct behavior survives simultaneous access and interleaving.

## Use When

- Multiple threads, tasks, processes, clients, or callbacks can access shared state.
- The design claims thread safety, lock-free behavior, ordering guarantees, or no deadlocks.
- Race conditions, lost updates, duplicate handling, or deadlocks are realistic risks.
- Sanitizers or deterministic scheduling can be used to increase confidence.

## Do Not Use When

- The operation is single-threaded and only uses many items; use Capability or Performance as appropriate.
- The concern is throughput under load rather than correctness under interleaving; use Performance.
- The concern is lifecycle transitions without simultaneous access; use State.
- The scenario cannot be made deterministic enough to diagnose failures; first improve observability or fixtures.

## Design Focus

- Name the shared resource and the concurrent actors.
- Define the interleaving or contention pattern being verified.
- Prefer deterministic barriers/latches over arbitrary sleeps.
- Verify correctness invariants: all work processed once, no lost update, no corruption, no deadlock, stable final state.

## Design Skeleton

```text
// @[Class]: P1 Design
// @[Category]: Concurrency
// @[Intent]: Prove thread-safety and correctness under simultaneous access.
// @[UseWhen]: Multiple actors can access shared state or interleave operations.
// @[AvoidWhen]: The scenario is only capacity, performance load, or single-threaded lifecycle.
// @[ActorsAndResource]: [actors, shared resource, synchronization strategy]
// @[Invariant]: [what must remain true]
// @[TC]: verify[Operation]_by[ConcurrentPattern]_expect[CorrectInvariant]
```

## US/AC/TC Pattern

```text
US-n: As a concurrent API consumer,
      I want [operation] to be safe under [parallel access pattern],
      So that [shared state remains correct].

AC-n: GIVEN [N actors share resource R with controlled synchronization],
      WHEN [actors perform operation O concurrently],
      THEN [correctness invariant I holds],
       AND [the operation completes without deadlock/race symptoms].

TC-n:
  @[Name]: verify[Operation]_by[ConcurrentPattern]_expect[CorrectInvariant]
  @[Purpose]: Validate thread-safety or interleaving correctness.
  @[Brief]: Coordinate concurrent actors, execute the operation, verify final invariants.
  @[Expect]: No lost/duplicated work, no corruption, no deadlock, sanitizer clean when available.
```

## Naming Examples

```text
verifyEventPost_byMultipleThreads_expectAllEventsDeliveredOnce
verifyRegistry_byConcurrentRegisterUnregister_expectConsistentState
verifyQueuePop_byParallelConsumers_expectNoDuplicateItems
verifyCacheUpdate_byRacingWriters_expectLastWriteConsistent
```

## Checklist

- What shared state or resource is under contention?
- Which actors run concurrently, and how are they synchronized to start?
- What invariant proves correctness after interleaving?
- Can the test detect deadlock without becoming flaky?
- Should ThreadSanitizer, race detectors, or repeated runs be part of verification?

## Common Mistakes

- Using sleeps as the main synchronization mechanism.
- Checking only that threads finished, not that the final state is correct.
- Combining performance load testing with concurrency correctness in one test.
- Treating nondeterministic flakes as acceptable instead of improving control and diagnostics.
