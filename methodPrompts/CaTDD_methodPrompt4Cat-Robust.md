# CaTDD method prompt for Category: Robust

Use this prompt when designing P2 Quality tests for stability under stress, repetition, resource churn, or long-running operation.

## Position

Robust belongs to P2 Quality-oriented testing.

```text
P2 Quality = Performance -> Robust -> Compatibility -> Configuration
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
