# CaTDD method prompt for Category: Robust

Use this prompt when designing P2 Quality tests for stability under stress, repetition, resource churn, or long-running operation.

## Position

Robust belongs to P2 Quality-oriented testing.

```text
P2 Quality = Performance -> Robust -> Compatibility -> Configuration -> Diagnosis -> Security
```

Robust proves that the system remains stable after repeated or sustained use.

## Use When

- The scenario repeats operations many times.
- The test checks soak behavior, stress behavior, memory/resource leaks, or stability over time.
- The risk is degradation after sustained operation rather than one isolated fault.

## Do Not Use When

- The scenario is one injected external failure; use Fault.
- The scenario is a latency/throughput target; use Performance.
- The scenario is a maximum designed amount; use Capability.

## TestPointsInMind

When this category applies, consider test points such as:

- Repeated operation cycles that should preserve the same invariant after many runs, not just once.
- Long-running or soak behavior with explicit duration, count, resource churn, reconnect cycles, restart cycles, or cleanup cycles.
- Stability under mixed valid use: alternating modes, repeated open/close, start/stop loops, enqueue/dequeue churn, or recover-and-continue flows.
- Leak and residue checks: memory, handles, temp files, subscriptions, timers, threads, queues, or global state return to baseline.
- Failure triage evidence that makes a late-cycle failure diagnosable without requiring huge unstructured logs.

## Design Skeleton

```text
// @[Class]: P2 Quality
// @[Category]: Robust
// @[Intent]: Prove stable behavior across repeated or sustained operation.
// @[UseWhen]: Repetition, stress, soak, or resource churn is the primary risk.
// @[AvoidWhen]: The scenario is a single fault, capacity limit, or benchmark target.
// @[DurationOrCount]: [time window or repeat count]
// @[Invariant]: [what must remain true]
// @[TC]: verify[Operation]_by[StressCondition]_expect[StableInvariant]
```

## Checklist

- Is the repeat count or duration explicit?
- What invariant proves stability?
- Are cleanup and resource checks included?
- Can failures be diagnosed without reading huge logs?
