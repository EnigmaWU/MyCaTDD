# {{ProjectName}} Resource Design

This is the SpecCoding template for project-root `README_ResourceDesign.md`. Create or update it from `SPEC_takeDetailDesign` when a story changes finite resource ownership, allocation policy, memory, CPU, power, handles, timers, threads, buffers, bandwidth, or contention behavior.

## Story Context

- Story: {{US identifier and title}}
- Source artifact: {{.catdd/spec/doingUS path or issue link}}
- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Related performance design: [README_PerfDesign.md](README_PerfDesign.md)
- Related verification design: [README_VerifyDesign.md](README_VerifyDesign.md)

## Resource Inventory

| Resource | Owner | Limit/Budget | Allocation Policy | Release Policy | Exhaustion Behavior |
| --- | --- | --- | --- | --- | --- |
| {{Resource}} | {{Owner}} | {{Limit}} | {{Static/pool/dynamic/borrowed}} | {{Release rule}} | {{reject/throttle/drop/degrade/fail-fast}} |

## Resource Budget Scenarios

<!-- How: Define finite-resource scenarios as measurable constraints.
	If a resource has no meaningful limit, mark why instead of inventing a budget. -->

| Scenario | Resource Pressure | Environment | Expected Response | Response Measure | CaTDD Category |
| --- | --- | --- | --- | --- | --- |
| {{normal use}} | {{resource use}} | {{environment}} | {{response}} | {{numeric budget or observable bound}} | `funcValidTypical` |
| {{limit reached}} | {{resource use}} | {{environment}} | {{response}} | {{limit/rejection/degradation measure}} | `funcValidEdge` |
| {{resource exhaustion}} | {{resource use}} | {{environment}} | {{response}} | {{no leak/no corruption/no deadlock measure}} | `funcInvalidFault` |

## Contention and Backpressure

| Resource | Contention Scenario | Backpressure Policy | Failure Behavior | Telemetry |
| --- | --- | --- | --- | --- |
| {{Resource}} | {{Scenario}} | {{Queue/drop/throttle/reject}} | {{Error/degrade/retry}} | {{Counter/log/trace}} |

## Lifetime and Ownership

| Resource | Creator | Borrower / Consumer | Transfer Rule | Cleanup Rule | Leak Prevention Evidence |
| --- | --- | --- | --- | --- | --- |
| {{resource}} | {{owner}} | {{consumer}} | {{create/borrow/recycle/destroy}} | {{normal and failure cleanup}} | {{guard/test/counter/static check}} |

## Resource Tradeoffs

| Decision | Improves | Costs / Risks | Alternative | Verification Evidence |
| --- | --- | --- | --- | --- |
| {{pool/static allocation/drop policy/etc.}} | {{latency/reliability/memory safety}} | {{memory/complexity/throughput/quality}} | {{alternative}} | {{test/measurement/review}} |

## CaTDD Verification Handoff

| Feature Token | Category Token | Suggested Test File | Resource Concern | Notes |
| --- | --- | --- | --- | --- |
| `{{feature_token}}` | `funcValidEdge` | `test_{{feature_token}}_funcValidEdge.{{ext}}` | {{valid boundary/resource limit}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |
| `{{feature_token}}` | `funcInvalidFault` | `test_{{feature_token}}_funcInvalidFault.{{ext}}` | {{resource unavailable/exhausted/failing}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |
| `{{feature_token}}` | `qualityRobust` | `test_{{feature_token}}_qualityRobust.{{ext}}` | {{leak prevention/repeated use/backpressure stability}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |

## Embedded and Digital Media Resource Points

Embedded software points:

- Memory resources: {{static RAM, stack, heap, DMA buffer, cacheable/non-cacheable region}}
- Execution resources: {{ISR time, task priority, timer, mutex, semaphore, queue}}
- Hardware resources: {{peripheral, channel, descriptor, bus bandwidth, power rail}}
- Power resources: {{clock domain, sleep state, wake source, battery/thermal budget}}

digital video/audio points:

- Buffer resources: {{frame pool, audio ring buffer, jitter buffer, metadata queue}}
- Compute resources: {{decoder, encoder, scaler, mixer, DSP/GPU/NPU path}}
- Bandwidth resources: {{memory bandwidth, storage I/O, network bitrate, render bandwidth}}
- Quality tradeoff: {{drop policy, resample policy, bitrate adaptation, frame pacing}}

## Usage Example

Run from the repository root to instantiate this resource-design template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_ResourceDesign.md"
cp slashCommands/templates/README_ResourceDesignTemplate.md "$TMP_DOC"
sed -n '1,120p' "$TMP_DOC"
```

Expected result: the temporary file shows resource inventory, contention policy, ownership, lifetime, and domain-specific resource sections.

## Review Checklist

- Every finite resource has an owner, budget, allocation policy, and release policy.
- Resource budget scenarios define measurable responses at normal, limit, and exhaustion points.
- Contention and backpressure behavior are explicit.
- Lifetime ownership and cleanup evidence are explicit.
- Resource tradeoffs document the cost of the selected policy.
- CaTDD handoff maps resource behavior to Edge, Fault, or Robust categories.
- Embedded software finite resources and digital video/audio buffers/compute/bandwidth are covered when relevant.
