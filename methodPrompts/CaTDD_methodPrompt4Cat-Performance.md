# CaTDD method prompt for Category: Performance

Use this prompt when designing P2 Quality tests for speed, latency, throughput, and resource-use characteristics.

## Position

Performance belongs to P2 Quality-oriented testing.

```text
P2 Quality = Performance -> Robust -> Compatibility -> Configuration
```

Performance proves that the feature is fast or efficient enough under defined conditions.

## Use When

- The product has SLOs, latency budgets, throughput targets, memory budgets, or CPU-use expectations.
- A design decision depends on speed or resource consumption.
- A regression in time or resource use would damage user value.

## Do Not Use When

- The concern is maximum supported amount, not speed; use Capability.
- The concern is long-running stability or repeated cycles; use Robust.
- The concern is correctness under multiple threads; use Concurrency.

## Design Skeleton

```text
// @[Class]: P2 Quality
// @[Category]: Performance
// @[Intent]: Prove latency, throughput, or resource-use target under defined conditions.
// @[UseWhen]: A measurable performance target exists.
// @[AvoidWhen]: The scenario is about capacity, robustness, or concurrency correctness.
// @[Metric]: [latency/throughput/memory/cpu]
// @[Target]: [threshold and unit]
// @[TC]: verify[Operation]_by[MeasuredCondition]_expect[PerformanceTarget]
```

## Checklist

- Is the target measurable and written with units?
- Is the workload size explicit?
- Is the environment stable enough for the result to be meaningful?
- Does the test avoid mixing correctness and benchmark goals in one unclear check?
