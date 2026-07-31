# {{ProjectName}} Performance Design

This is the SpecCoding template for project-root `README_PerfDesign.md`. Create or update it from `SPEC_takeDetailDesign` when a story changes latency, throughput, memory, CPU, power, thermal behavior, real-time scheduling, or media quality-of-service constraints.

## Story Context

- Story: {{US identifier and title}}
- Source artifact: {{.catdd/spec/doingUS path or issue link}}
- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Related verification design: [README_VerifyDesign.md](README_VerifyDesign.md)

## Performance Budgets

| Budget | Target | Worst Case | Measurement Method | Owner | Decision If Exceeded |
| --- | --- | --- | --- | --- | --- |
| {{Latency/CPU/RAM/bandwidth/power}} | {{Target}} | {{Worst case}} | {{How measured}} | {{Owner}} | {{optimize/degrade/reject/defer}} |

## Quality Attribute Scenarios

<!-- How: Express performance as measurable scenarios, not vague adjectives.
	Each response measure should be numeric or explicitly qualitative with rationale.
	(→ SKILL: apply-architectural-tactics) -->

| Scenario | Source | Stimulus | Environment | Response | Response Measure | Priority |
| --- | --- | --- | --- | --- | --- | --- |
| {{scenario name}} | {{user/system/load source}} | {{event/load}} | {{normal/peak/degraded}} | {{system response}} | {{latency/throughput/jitter/CPU/RAM/power threshold}} | {{H/M/L}} |

## Real-Time Path

```text
{{Input event/frame/sample}} -> {{critical path}} -> {{observable output}}
```

## Load and Stress Conditions

| Condition | Expected Behavior | Degradation Policy | Telemetry |
| --- | --- | --- | --- |
| {{Load condition}} | {{Expected behavior}} | {{Drop/throttle/retry/fail-fast}} | {{Counter/log/trace}} |

## Performance Tradeoffs

| Decision | Improves | Costs / Risks | Alternative | Verification Evidence |
| --- | --- | --- | --- | --- |
| {{buffering/cache/batching/threading/allocation decision}} | {{latency/throughput/jitter/power}} | {{memory/complexity/freshness/quality}} | {{alternative}} | {{measurement or test}} |

## Embedded and Digital Media Performance Points

Embedded software points:

- Interrupt latency: {{max ISR latency, interrupt disable time, timer jitter}}
- CPU and memory: {{CPU budget, stack/heap/static RAM, allocation policy}}
- DMA and bus bandwidth: {{copy avoidance, cache coherency, memory bandwidth}}
- Power and thermal: {{sleep ratio, clock scaling, thermal throttling, watchdog window}}

digital video/audio points:

- Video budget: {{resolution, frame rate, decode/render deadline, frame drop policy}}
- Audio budget: {{sample rate, callback period, buffer depth, underrun limit}}
- A/V sync: {{clock source, drift tolerance, lip-sync threshold, resync policy}}
- Bitrate and quality: {{codec profile, bitrate target, jitter buffer, artifact tolerance}}

## Measurement Plan

| Metric | Tool/Probe | Scenario | Pass Criteria | Failure Routing |
| --- | --- | --- | --- | --- |
| {{Metric}} | {{Profiler/counter/trace/probe}} | {{Scenario}} | {{Threshold}} | {{optimize/update design/defer/abort story}} |

## CaTDD Verification Handoff

| Feature Token | Category Token | Suggested Test File | Performance Concern | Notes |
| --- | --- | --- | --- | --- |
| `{{feature_token}}` | `qualityPerformance` | `test_{{feature_token}}_qualityPerformance.{{ext}}` | {{latency/throughput/jitter/resource budget}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |
| `{{feature_token}}` | `funcValidEdge` | `test_{{feature_token}}_funcValidEdge.{{ext}}` | {{valid boundary load or limit}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |
| `{{feature_token}}` | `qualityRobust` | `test_{{feature_token}}_qualityRobust.{{ext}}` | {{sustained load, stress, or repeated execution}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |

## Usage Example

Run from the repository root to instantiate this performance-design template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_PerfDesign.md"
cp slashCommands/templates/README_PerfDesignTemplate.md "$TMP_DOC"
sed -n '1,120p' "$TMP_DOC"
```

Expected result: the temporary file shows performance budgets, real-time path, load conditions, and embedded/media performance sections.

## Review Checklist

- Every performance goal has a numeric budget or an explicit reason why it is qualitative.
- Quality attribute scenarios use source, stimulus, environment, response, and response measure.
- Tradeoffs are documented when improving one performance attribute costs another quality.
- Measurement method and pass criteria are defined before implementation is considered complete.
- Measurement failures route to a concrete next action.
- CaTDD handoff maps performance concerns to category-specific test files or no-test-points decisions.
- Embedded software timing and digital video/audio QoS constraints are covered when relevant.
