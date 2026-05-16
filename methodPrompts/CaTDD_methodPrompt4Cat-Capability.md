# CaTDD method prompt for Category: Capability

Use this prompt when designing P1 Design-oriented tests for designed capacity, limits, and maximum ability.

## Position

Capability is the second P1 Design category.

```text
P1 Design = State -> Capability -> Concurrency
```

Capability proves that the implementation matches the intended capacity contract.

## Use When

- The design promises a default, maximum, minimum, or configurable capacity.
- You need to verify how many connections, events, users, commands, files, messages, or resources are supported.
- The test should document a discovered or guaranteed limit.
- Capacity affects API behavior, product claims, or deployment planning.

## Do Not Use When

- The scenario is a simple edge value around one input parameter; use Edge.
- The concern is speed, latency, or throughput; use Performance.
- The concern is repeated stability after many cycles; use Robust.
- The concern is simultaneous access and race conditions; use Concurrency.

## Design Focus

- Define the capacity source: constant, configuration, API query, documented product limit, or discovered limit.
- Test exact limit behavior: below limit, at limit, above limit.
- Distinguish "maximum supported" from "fast enough".
- Capture whether exceeding capacity is an error, backpressure, queueing, rejection, or degradation.

## Design Skeleton

```text
// @[Class]: P1 Design
// @[Category]: Capability
// @[Intent]: Prove designed capacity, maximum ability, and over-limit behavior.
// @[UseWhen]: The design promises a default, maximum, minimum, or configurable capacity.
// @[AvoidWhen]: The scenario is about speed, repeated stability, or thread interleaving.
// @[CapacitySource]: [constant/config/API/product claim/discovered limit]
// @[US]/@[AC]: [traceability IDs]
// @[TC]: verify[Capability]_by[CapacityCondition]_expect[LimitBehavior]
```

## US/AC/TC Pattern

```text
US-n: As a deployer or API consumer,
      I want [component] to support [capacity],
      So that [the system can be sized and used predictably].

AC-n: GIVEN [capacity limit is configured or documented],
      WHEN [the system is used at/above that limit],
      THEN [accepted work succeeds up to the limit],
       AND [excess work is handled with documented behavior].

TC-n:
  @[Name]: verify[Capability]_by[CapacityCondition]_expect[LimitBehavior]
  @[Purpose]: Validate maximum designed ability and behavior beyond it.
  @[Brief]: Drive usage to the capacity point and verify accepted/rejected work.
  @[Expect]: Capacity contract is met and excess handling is clear.
```

## Naming Examples

```text
verifyConnections_byMaxConfiguredClients_expectAllAccepted
verifyQueueCapacity_byOneOverLimit_expectBackpressureResult
verifyMessageSize_byMaxAllowedBytes_expectAccepted
verifyServiceRegistry_byMaxServices_expectCapacityReached
```

## Checklist

- What is the source of the capacity limit?
- Does the test cover below, exactly at, and above the limit when useful?
- Is the expected over-capacity behavior documented?
- Is this about ability, not latency or throughput?
- Does the test avoid depending on machine speed or environment noise?

## Common Mistakes

- Calling a performance benchmark Capability because it uses many items.
- Hard-coding a capacity that should be read from configuration or API.
- Verifying only rejection above the limit without proving success at the limit.
- Mixing concurrent capacity with thread-safety unless Concurrency is also the intent.
