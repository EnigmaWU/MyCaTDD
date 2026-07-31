# CaTDD method prompt for Category: Performance

Use this prompt when designing P2 Quality tests for speed, latency, throughput, and resource-use characteristics.

## Position

Performance belongs to P2 Quality-oriented testing.

```text
P2 Quality = Performance -> Robust -> Compatibility -> Configuration -> Diagnosis -> Security
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

## TestPointsInMind

When this category applies, consider test points such as:

- A named metric with units and target: p50/p95/p99 latency, throughput, CPU, memory, allocation count, startup time, or response size.
- A defined workload shape: data size, operation mix, concurrency level, warm/cold state, fixture complexity, and measurement duration.
- A comparison that matters to the design: before/after optimization, bounded regression, algorithmic growth, or budget under supported configuration.
- Resource-use behavior under representative load without turning the test into a Robust soak or Capability limit check.
- Measurement guardrails: stable environment, enough samples, allowed tolerance, and metadata that explains failures.

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
