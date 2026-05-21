# {{ProjectName}} Resource Design

This is the SpecCoding template for project-root `README_ResourceDesign.md`. Create or update it from `SPEC_takeDetailDesign` when a story changes finite resource ownership, allocation policy, memory, CPU, power, handles, timers, threads, buffers, bandwidth, or contention behavior.

## Story Context

- Story: {{US identifier and title}}
- Source artifact: {{.catdd/spec/doingUS path or issue link}}
- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Related performance design: [README_PerfDesign.md](README_PerfDesign.md)
- Related verification design: [README_VerifyDesign.md](README_VerifyDesign.md)

## Resource Inventory

| Resource | Owner | Limit/Budget | Allocation Policy | Release Policy |
| --- | --- | --- | --- | --- |
| {{Resource}} | {{Owner}} | {{Limit}} | {{Static/pool/dynamic/borrowed}} | {{Release rule}} |

## Contention and Backpressure

| Resource | Contention Scenario | Backpressure Policy | Failure Behavior | Telemetry |
| --- | --- | --- | --- | --- |
| {{Resource}} | {{Scenario}} | {{Queue/drop/throttle/reject}} | {{Error/degrade/retry}} | {{Counter/log/trace}} |

## Lifetime and Ownership

- Ownership transfer: {{Producer -> consumer rule}}
- Lifetime boundary: {{Create, borrow, recycle, destroy}}
- Cleanup rule: {{Normal cleanup and failure cleanup}}
- Leak prevention: {{Guard, test, counter, static check}}

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
- Contention and backpressure behavior are explicit.
- Embedded software finite resources and digital video/audio buffers/compute/bandwidth are covered when relevant.
