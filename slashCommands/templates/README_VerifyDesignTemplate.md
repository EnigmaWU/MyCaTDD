# {{ProjectName}} Verification Design

This is the SpecCoding template for `README_VerifyDesign.md`. Create or update it from `SPEC_designUnitTests` when verification constraints, strategy, CaTDD category coverage, Agile Testing Quadrants, fixture boundaries, or evidence handoff decisions change.

`README_VerifyDesign.md` is a stable design artifact. Keep live RED/GREEN status, last-run command output, and temporary trace churn in story TASKs, test files, or `README_VerifyStatusTraces.md` if that companion exists.

## Story and Design Inputs

- Story: {{US identifier and title}}
- Active story artifact: {{.catdd/spec/doingUS path}}
- Detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Usage design: [README_UsageDesign](README_UsageDesign.md)
- Error design: [README_ErrorDesign](README_ErrorDesign.md)
- Target verification level: {{UnitTesting / ModuleTesting / UserTesting / mixed}}
- Target test files or future file pattern: `test_{{feature_token}}_{{category_token}}.{{ext}}`
- Dynamic trace artifact: {{README_VerifyStatusTraces.md / story TASKs / test-file comments / not needed}}

## Verification Constraints and Goals

<!-- How: Start from WHAT must be proven and WHY it matters before choosing test mechanics.
  Do not list every TC here; capture the design pressure that makes verification necessary. -->

| Constraint / Goal | Source | Why It Matters | Observable Evidence |
| --- | --- | --- | --- |
| {{functional contract to prove}} | {{US/AC/detail/usage/error design}} | {{risk or value protected}} | {{test result, review evidence, generated file, behavior}} |
| {{quality or design constraint}} | {{arch/perf/resource/compat design}} | {{failure avoided}} | {{measurement, inspection, check, exploratory note}} |

## Testing Definition

- **UnitTesting**: verifies behavior at subPackage/subModule/Class/function scope.
- **ModuleTesting**: verifies behavior at module-level Package/Service/Interface scope.
- **UserTesting**: verifies end-to-end user flow with demo/examples.

Rules:

- If the module is simple, treat `UnitTesting == ModuleTesting`.
- If the module is complex, keep `UnitTesting` at sub-level scope and `ModuleTesting` at module-level scope.
- `UnitTesting` and `ModuleTesting` both use CaTDD categories.
- `UserTesting` is not CaTDD category testing; it is full-flow verification.
- Agile Testing Quadrants are a taxonomy for test intent, not a sequence of phases.

## Strategy Selection

<!-- How: Apply CaTDD category method and Agile Testing Quadrants together.
  CaTDD answers priority/category. Quadrants answer audience and intent.
  (→ SKILL: apply-agile-testing-quadrants + comment-alive-test-driven-development) -->

| Decision | Selected Strategy | Rationale | Not Selected / Deferred |
| --- | --- | --- | --- |
| Verification level | {{UnitTesting / ModuleTesting / UserTesting / mixed}} | {{why this level proves the goal}} | {{levels not needed now}} |
| Automation balance | {{automated / manual / exploratory / mixed}} | {{why this is enough}} | {{manual or automated work deferred}} |
| Fixture boundary | {{real dependency / fake / mock / golden file / simulator}} | {{why this boundary is credible}} | {{boundary not used and why}} |
| Evidence location | {{test file / TASKs / README_VerifyStatusTraces.md / CI}} | {{why evidence belongs there}} | {{what stays out of this design doc}} |

## CaTDD x Agile Testing Quadrants Coverage

| CaTDD method axis | Agile quadrant axis | Verification design meaning | Required Now | Suggested test file / evidence |
| --- | --- | --- | --- | --- |
| P0 Functional: Typical | Q1 Technology/Support, Q2 Business/Support | Prove core contract and business-visible success path. | {{Yes/No}} | `test_{{feature}}_funcValidTypical.{{ext}}` |
| P0 Functional: Edge | Q1 Technology/Support, Q2 Business/Support, sometimes Q3 Business/Critique | Prove valid boundaries, options, limits, and surprising-but-valid behavior. | {{Yes/No}} | `test_{{feature}}_funcValidEdge.{{ext}}` |
| P0 Functional: Misuse | Q1 Technology/Support, Q3 Business/Critique | Prove invalid caller behavior is rejected or contained. | {{Yes/No}} | `test_{{feature}}_funcInvalidMisuse.{{ext}}` |
| P0 Functional: Fault | Q1 Technology/Support, Q4 Technology/Critique | Prove valid caller behavior under dependency, resource, or runtime failure. | {{Yes/No}} | `test_{{feature}}_funcInvalidFault.{{ext}}` |
| P1 Design: State | Q1 Technology/Support, Q4 Technology/Critique | Prove lifecycle states, transitions, and invariants. | {{Yes/No}} | `test_{{feature}}_designState.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P1 Design: Capability | Q1 Technology/Support, Q4 Technology/Critique | Prove capability boundaries and component contracts. | {{Yes/No}} | `test_{{feature}}_designCapability.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P1 Design: Concurrency | Q1 Technology/Support, Q4 Technology/Critique | Prove synchronization, ordering, contention, or race behavior. | {{Yes/No}} | `test_{{feature}}_designConcurrency.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P2 Quality: Performance | Q4 Technology/Critique | Prove latency, throughput, timing, or load envelope. | {{Yes/No}} | `test_{{feature}}_qualityPerformance.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P2 Quality: Robust | Q4 Technology/Critique, sometimes Q3 Business/Critique | Prove resilience under stress, malformed environments, or repeated use. | {{Yes/No}} | `test_{{feature}}_qualityRobust.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P2 Quality: Compatibility | Q4 Technology/Critique | Prove version, platform, protocol, format, or migration compatibility. | {{Yes/No}} | `test_{{feature}}_qualityCompatibility.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P2 Quality: Configuration | Q4 Technology/Critique | Prove config precedence, defaults, invalid config, and environment behavior. | {{Yes/No}} | `test_{{feature}}_qualityConfiguration.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P3 Addons: DemoExample | Q2 Business/Support, Q3 Business/Critique | Prove a user-facing demo or usage example remains executable and understandable. | {{Yes/No}} | `test_{{feature}}_addonDemoExample.{{ext}}` or `@[NoTestPoints]: <reason>` |

## Test Approach Design

| Approach Area | Decision | Why This Fits | Review Signal |
| --- | --- | --- | --- |
| SUT declaration | {{system/module/function/CLI/service under test}} | {{why this boundary is correct}} | {{test overview names SUT}} |
| Fixture data | {{inline/golden/generated/synthetic/production-like}} | {{why this data proves the goal}} | {{data source and cleanup clear}} |
| Mocking / simulation | {{none/mock/fake/simulator/subprocess/test server}} | {{why real dependency is or is not used}} | {{boundary documented in tests}} |
| Assertions | {{observable outputs/state/errors/timing}} | {{why these assertions prove behavior}} | {{≤3 key assertions per TC or split}} |
| Exploratory need | {{none/manual session/UAT/chaos/perf run}} | {{why automation is insufficient or unnecessary}} | {{Q3/Q4 evidence handoff}} |

## Lightweight Evidence Handoff

<!-- This table is only a handoff summary. Keep live detailed status elsewhere. -->

| Verification Area | US/AC Scope | Evidence Owner | Evidence Location | Status Meaning |
| --- | --- | --- | --- | --- |
| {{area}} | {{US/AC range}} | {{test file / TASKs / CI / manual note}} | {{path or command}} | {{planned / designed / implemented / reviewed}} |

## Risks and Deferred Coverage

| Risk / Deferred Area | Reason | Owner / Trigger | Required Evidence Before Close |
| --- | --- | --- | --- |
| {{risk or deferred coverage}} | {{why it is not covered now}} | {{owner or condition}} | {{evidence needed}} |

## Embedded and Digital Media Verification Points

Embedded software points:

- Hardware interaction tests: {{register/HAL/peripheral behavior to verify}}
- Timing tests: {{ISR latency, watchdog window, timeout, jitter, RTOS scheduling}}
- Resource tests: {{static RAM, stack, heap, DMA buffer, cache coherency}}
- Fault injection: {{bus error, brownout, timeout, reset, overrun, underrun}}

digital video/audio points:

- Pipeline tests: {{decode/render/capture/playback stage to verify}}
- Media quality tests: {{frame drop, audio underrun, stutter, artifact, glitch}}
- Sync tests: {{A/V sync drift, timestamp discontinuity, seek/flush behavior}}
- Format tests: {{codec, resolution, frame rate, sample rate, channel layout}}

## Usage Example

Run from the repository root to instantiate this verification-design template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_VerifyDesign.md"
cp slashCommands/templates/README_VerifyDesignTemplate.md "$TMP_DOC"
sed -n '1,180p' "$TMP_DOC"
```

Expected result: the temporary file shows verification constraints, strategy selection, CaTDD x Agile Testing Quadrants coverage, test approach decisions, evidence handoff, and deferred-risk sections.

## Review Checklist

- Verification constraints and goals explain WHAT must be proven and WHY.
- Strategy selection explains level, automation balance, fixture boundary, and evidence location.
- CaTDD categories and Agile Testing Quadrants are both used as design axes.
- P0 Functional coverage is addressed before P1/P2 promotion, or explicit `@[NoTestPoints]: <reason>` decisions exist.
- Q3 exploratory and Q4 technology-critique needs are considered instead of silently omitted.
- Live US/AC/TC status is handed off to the right dynamic evidence location instead of bloating this design doc.
- Deferred coverage has an explicit reason, owner or trigger, and required close evidence.
