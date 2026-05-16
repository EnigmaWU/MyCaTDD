# CaTDD method prompt for Category: Fault

Use this prompt when designing P0 Functional tests for failures caused by dependencies, resources, processes, networks, storage, or runtime environment.

## Position

Fault belongs to P0 Functional InvalidFunc testing.

```text
P0 Functional = ValidFunc(Typical + Edge) + InvalidFunc(Misuse + Fault)
```

Fault proves that the system fails right when the caller behaves correctly but the world around the system does not.

## Use When

- A network, disk, process, thread, clock, database, filesystem, or external service fails.
- A resource is exhausted: memory, file descriptors, queue storage, connection slots, disk space.
- The component must recover, degrade gracefully, retry, timeout, rollback, or report a clear failure.
- Reliability is a release-critical concern.

## Do Not Use When

- The caller breaks the API contract; use Misuse.
- The scenario is just a valid limit value; use Edge.
- The focus is long-running stability under repeated operations; use Robust.
- The focus is throughput or latency under load; use Performance.

## Design Focus

- Name the injected fault and the mechanism used to create it.
- Verify the failure result and the recovery or cleanup behavior.
- Avoid nondeterministic tests where the fault might not actually happen.
- Make external dependency boundaries explicit so the test can be repeated reliably.

## Design Skeleton

```text
// @[Class]: P0 Functional / InvalidFunc
// @[Category]: Fault
// @[Intent]: Prove graceful behavior when dependencies, resources, processes, or environment fail.
// @[UseWhen]: The caller is valid but an external/runtime fault is injected or simulated.
// @[AvoidWhen]: The scenario is caller misuse, simple valid edge behavior, or long-running robustness.
// @[US]: [US IDs]
// @[AC]: [AC IDs]
// @[TC]: verify[Operation]_by[InjectedFault]_expect[GracefulFailure]
```

## US/AC/TC Pattern

```text
US-n: As a reliable-system operator,
      I want [operation] to handle [external fault],
      So that [the system remains safe and diagnosable].

AC-n: GIVEN [valid caller behavior and injected dependency/resource fault],
      WHEN [the operation is executed],
      THEN [the documented failure result is returned],
       AND [cleanup/recovery/rollback behavior is observable].

TC-n:
  @[Name]: verify[Operation]_by[InjectedFault]_expect[GracefulFailure]
  @[Purpose]: Prove correct failure handling for an external/runtime fault.
  @[Brief]: Inject the fault, execute the operation, verify failure and recovery semantics.
  @[Expect]: Error result, diagnostic signal if applicable, no corruption/leak/deadlock.
```

## Naming Examples

```text
verifyConnect_byNetworkUnavailable_expectTimeoutError
verifyWrite_byDiskFull_expectNoPartialCommit
verifyPost_byQueueAllocationFailure_expectResourceError
verifyServiceRestart_byProcessCrash_expectRecoveredState
```

## Checklist

- Is the caller using the API correctly?
- What dependency, resource, or environment fault is injected?
- Is the injection deterministic enough for automation?
- What should happen to partial work after the fault?
- Should the component retry, rollback, cleanup, or fail fast?

## Common Mistakes

- Treating caller misuse as a fault.
- Depending on real random failures instead of controlled injection.
- Verifying only the error code and not cleanup/recovery.
- Mixing Fault with Robust soak/stress tests; keep the first fault test focused and repeatable.
