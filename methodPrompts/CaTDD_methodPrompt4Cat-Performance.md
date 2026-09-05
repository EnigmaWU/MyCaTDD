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

First apply the source inventory and applicable sweep in [CaTDD_methodPrompt-testPointDiscovery.md](CaTDD_methodPrompt-testPointDiscovery.md). Record candidates in `discovery_ledger`; apply the Discovery Gate before implementation. Domain examples are optional prompts, not requirements or coverage quotas; use source-defined limits and oracles.

When this category applies, consider test points such as:

- A named metric with units and target: p50/p95/p99 latency, throughput, CPU, memory, allocation count, startup time, or response size.
- A defined workload shape: data size, operation mix, concurrency level, warm/cold state, fixture complexity, and measurement duration.
- A comparison that matters to the design: before/after optimization, bounded regression, algorithmic growth, or budget under supported configuration.
- Resource-use behavior under representative load without turning the test into a Robust soak or Capability limit check.
- Measurement guardrails: stable environment, enough samples, allowed tolerance, and metadata that explains failures.
- Domain-specific questions:
  - *Embedded Linux*: Which deadline, jitter, allocation, or resource budget is specified for which build, scheduler, workload, and target? Do not substitute host or sanitizer timing for target evidence, or a percentile for a hard deadline.
  - *Microservices*: Which latency/throughput/resource target and comparison relation applies to the documented request mix and deployment? Obtain the threshold from the performance source.
  - *LLM Agents*: Which first-token, end-to-end, token-throughput, or cost budget is specified for the selected model, input size, and tool workload? Record variance and measurement conditions rather than inventing a target.

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
