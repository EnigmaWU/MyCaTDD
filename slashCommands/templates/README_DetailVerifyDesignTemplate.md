# {{ProjectName}} Detail-Level Verification Design

This is the SpecCoding template for project-root `README_DetailVerifyDesign.md`. Create or update it from `SPEC_takeDetailDesign` and revise it from `SPEC_updateDetailDesign`; `SPEC_reviewDetailDesign` gates it. Use it when a story changes test points, CaTDD category coverage, submodule seams, fixtures, oracles, or per-module verification strategy.

`README_DetailVerifyDesign.md` is a stable design artifact. It answers *which test points does this module and its submodules own, and how are they classified*, and it owns `UnitTesting` strategy. Apply the method prompts directly: `CaTDD_methodPrompt-testPointDiscovery.md` owns discovery, the `discovery_ledger`, and the Discovery Gate; `CaTDD_methodPrompt-categorySemantics.md` owns category routing; `CaTDD_methodPrompt-testStructure.md` and `CaTDD_methodPrompt-fileNaming.md` own `@[TestLevel]`, comment shape, and file names. Resolve those prompts under `methodPrompts/` in the CaTDD source repository or `.catdd/methodPrompts/` in an installed project.

`SysTesting` and `UserTesting` obligations are promoted to [README_ArchVerifyDesign.md](README_ArchVerifyDesign.md) under the same TP ID. Keep live RED/GREEN status, run output, and temporary trace churn in story TASKs, test files, or `README_VerifyStatusTraces.md`.

## Story and Design Inputs

- Story: {{US identifier and title}}
- Active story artifact: {{.catdd/spec/doingUS path}}
- Detail design: [README_DetailDesign.md](README_DetailDesign.md)
- State design: [README_StateDesign.md](README_StateDesign.md)
- Architecture-level verification design: [README_ArchVerifyDesign.md](README_ArchVerifyDesign.md)
- Related design surfaces: [README_ErrorDesign.md](README_ErrorDesign.md), [README_ResourceDesign.md](README_ResourceDesign.md), [README_PerfDesign.md](README_PerfDesign.md), [README_CompatDesign.md](README_CompatDesign.md), [README_DiagnosisDesign.md](README_DiagnosisDesign.md), [README_SecurityDesign.md](README_SecurityDesign.md)
- SUT and target verification level: {{declared SUT}} / {{UnitTesting / mixed, with ModuleTesting only as a scope qualifier}}
- Target test files or future file pattern: `test_{{feature_token}}_{{category_token}}.{{ext}}`
- Dynamic trace artifact: {{README_VerifyStatusTraces.md / story TASKs / test-file comments / not needed}}

## Verification Constraints and Goals

<!-- How: Start from WHAT must be proven for this module and WHY it matters before choosing test mechanics.
  Do not list every TC here; capture the design pressure that makes verification necessary. -->

| Constraint / Goal | Source | Why It Matters | Observable Evidence |
| --- | --- | --- | --- |
| {{functional contract to prove}} | {{US/AC/detail/usage/error design}} | {{risk or value protected}} | {{test result, review evidence, generated file, behavior}} |
| {{design or quality constraint}} | {{state/resource/perf/compat/security design}} | {{failure avoided}} | {{assertion, measurement, inspection, exploratory note}} |

## Behavior Inventory

Build this from sources before consulting existing skeletons. Existing tests are reconciliation input, not the inventory.

| Source reference | Operation / rule / invariant / quality predicate | In-scope variants and dimensions | Questions raised |
| --- | --- | --- | --- |
| {{path#section, rule ID, revision}} | {{what the source promises}} | {{inputs, states, peers, environments}} | {{QUESTION ledger rows or none}} |

## Test-Level Assignment and Routing

| TP ID | Category | `TestLevel` | Peer reality | Owning design | Promotion reference |
| --- | --- | --- | --- | --- | --- |
| {{TP-xx}} | {{Typical/Edge/Misuse/Fault/State/Capability/Interaction/Concurrency/Performance/Robust/Compatibility/Configuration/Diagnosis/Security/DemoExample}} | {{UnitTesting/SysTesting/UserTesting}} | {{real peer, target runtime, fake, stub, recorded}} | {{this document / README_ArchVerifyDesign.md}} | {{promoted TP row in the architecture design or n/a}} |

Rules:

- Use one canonical level token. `ModuleTesting` is a superseded name and survives only as a module-scope qualifier; route by peer reality instead.
- A `SysTesting` or `UserTesting` row keeps its TP ID, discovery evidence, and disposition here, and is promoted to the architecture design for strategy.
- Unresolved level applicability is a QUESTION, never an assumed routing decision.

## CaTDD x Agile Testing Quadrants Coverage

| CaTDD method axis | Agile quadrant axis | Verification design meaning | Required Now | Suggested test file / evidence |
| --- | --- | --- | --- | --- |
| P0 Functional: Typical | Q1 Technology/Support, Q2 Business/Support | Prove core contract and business-visible success path. | {{Yes/No}} | `test_{{feature}}_funcValidTypical.{{ext}}` |
| P0 Functional: Edge | Q1 Technology/Support, Q2 Business/Support, sometimes Q3 Business/Critique | Prove valid boundaries, options, limits, and surprising-but-valid behavior. | {{Yes/No}} | `test_{{feature}}_funcValidEdge.{{ext}}` |
| P0 Functional: Misuse | Q1 Technology/Support, Q3 Business/Critique | Prove invalid caller behavior is rejected or contained. | {{Yes/No}} | `test_{{feature}}_funcInvalidMisuse.{{ext}}` |
| P0 Functional: Fault | Q1 Technology/Support, Q4 Technology/Critique | Prove valid caller behavior under dependency, resource, or runtime failure. | {{Yes/No}} | `test_{{feature}}_funcInvalidFault.{{ext}}` |
| P1 Design: State | Q1 Technology/Support, Q4 Technology/Critique | Prove lifecycle states, transitions, and invariants. | {{Yes/No}} | `test_{{feature}}_designState.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P1 Design: Capability | Q1 Technology/Support, Q4 Technology/Critique | Prove capability boundaries and component contracts. | {{Yes/No}} | `test_{{feature}}_designCapability.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P1 Design: Interaction | Q1 Technology/Support, Q4 Technology/Critique | Prove delegation, ordering, and handoff contracts inside the module boundary. | {{Yes/No}} | `test_{{feature}}_designInteraction.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P1 Design: Concurrency | Q1 Technology/Support, Q4 Technology/Critique | Prove synchronization, ordering, contention, or race behavior. | {{Yes/No}} | `test_{{feature}}_designConcurrency.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P2 Quality: Performance | Q4 Technology/Critique | Prove latency, throughput, timing, or load envelope. | {{Yes/No}} | `test_{{feature}}_qualityPerformance.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P2 Quality: Robust | Q4 Technology/Critique, sometimes Q3 Business/Critique | Prove resilience under stress, malformed environments, or repeated use. | {{Yes/No}} | `test_{{feature}}_qualityRobust.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P2 Quality: Compatibility | Q4 Technology/Critique | Prove version, platform, protocol, format, or migration compatibility. | {{Yes/No}} | `test_{{feature}}_qualityCompatibility.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P2 Quality: Configuration | Q4 Technology/Critique | Prove config precedence, defaults, invalid config, and environment behavior. | {{Yes/No}} | `test_{{feature}}_qualityConfiguration.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P2 Quality: Diagnosis | Q4 Technology/Critique | Prove required diagnostic fields, correlation, and redaction. | {{Yes/No}} | `test_{{feature}}_qualityDiagnosis.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P2 Quality: Security | Q4 Technology/Critique | Prove policy-defined denial, containment, integrity, and permitted effects. | {{Yes/No}} | `test_{{feature}}_qualitySecurity.{{ext}}` or `@[NoTestPoints]: <reason>` |
| P3 Addons: DemoExample | Q2 Business/Support, Q3 Business/Critique | Prove a user-facing demo or usage example remains executable and understandable. | {{Yes/No}} | `test_{{feature}}_addonDemoExample.{{ext}}` or `@[NoTestPoints]: <reason>` |

Row-level category coverage lives here. Quadrant balance across levels, environments, and evidence ownership belongs to [README_ArchVerifyDesign.md](README_ArchVerifyDesign.md); do not restate it in this table.

## Test-Point Discovery Ledger

Keep one feature-level inventory and `discovery_ledger` in living comments, alongside this design. `CaTDD_methodPrompt-testPointDiscovery.md` owns the row fields, dispositions (`DESIGNED / QUESTION / EXCLUDED / REFERRED / GAP`), and readiness semantics.

```text
TP ID | Source/rule | Setup/action | Observable oracle | Category/TestLevel | Disposition/evidence
TP-01 | [source/R1] | [condition]  | [expected result]  | Typical/UnitTesting | DESIGNED: [file, US/AC/TC IDs]
TP-02 | [source/R2] | [condition]  | unknown            | provisional         | QUESTION: [question, decision owner]
```

Discovery Gate report:

```text
Disposition counts: DESIGNED / QUESTION / EXCLUDED / REFERRED / GAP
Verification design routing: detail design (UnitTesting TP IDs) / promoted to architecture design (SysTesting, UserTesting TP IDs)
discovery_status: PASS | GAPS | BLOCKED
ready_for_implementation: yes | no
Residual risk and next action: ...
```

## Submodule Verification Strategy

| Submodule / unit | SUT boundary | Seams, fakes, fixtures | Oracle | Owned TP IDs |
| --- | --- | --- | --- | --- |
| {{submodule or class}} | {{declared boundary}} | {{seam and data design}} | {{observable result}} | {{TP-xx}} |

## Test Approach Design

| Approach Area | Decision | Why This Fits | Review Signal |
| --- | --- | --- | --- |
| SUT declaration | {{system/module/function/CLI/service under test}} | {{why this boundary is correct}} | {{test overview names SUT}} |
| Fixture data | {{inline/golden/generated/synthetic/production-like}} | {{why this data proves the goal}} | {{data source and cleanup clear}} |
| Mocking / simulation | {{none/mock/fake/simulator/subprocess/test server}} | {{why the real dependency is or is not used}} | {{boundary documented in tests}} |
| Assertions | {{observable outputs/state/errors/timing}} | {{why these assertions prove behavior}} | {{<=3 key assertions per TC or split}} |
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

A category with no applicable test points keeps its file as a living decision with `@[NoTestPoints]: <reason>`. A missing source is a QUESTION, not a not-applicable decision.

## Embedded and Digital Media Verification Points

Embedded software points:

- Hardware interaction test points: {{register/HAL/peripheral behavior to verify at unit scope}}
- Timing test points: {{ISR latency, watchdog window, timeout, jitter, RTOS scheduling partitions}}
- Resource test points: {{static RAM, stack, heap, DMA buffer, cache coherency limits}}
- Fault test points: {{bus error, brownout, timeout, reset, overrun, underrun injection seams}}

digital video/audio points:

- Pipeline test points: {{decode/render/capture/playback stage partitions to verify}}
- Media quality test points: {{frame drop, audio underrun, stutter, artifact, glitch thresholds}}
- Sync test points: {{A/V sync drift, timestamp discontinuity, seek/flush behavior}}
- Format test points: {{codec, resolution, frame rate, sample rate, channel layout partitions}}

Environment, HIL topology, and equipment ownership for these points belong to [README_ArchVerifyDesign.md](README_ArchVerifyDesign.md); this document owns the test points and their categories.

## Usage Example

Run from the repository root to instantiate this detail-level verification-design template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_DetailVerifyDesign.md"
cp slashCommands/templates/README_DetailVerifyDesignTemplate.md "$TMP_DOC"
sed -n '1,200p' "$TMP_DOC"
```

Expected result: the temporary file shows verification constraints, the behavior inventory, test-level assignment and routing, CaTDD x Agile quadrant coverage, the discovery ledger shape, submodule strategy, test approach, evidence handoff, and deferred risk.

## Review Checklist

- The behavior inventory and `discovery_ledger` were built from sources before existing skeletons were read.
- Every rule and applicable sweep dimension links to a ledger row with a disposition.
- Every row carries one canonical `TestLevel` token; `ModuleTesting` appears only as a module-scope qualifier.
- Every `SysTesting`/`UserTesting` row names its promotion into `README_ArchVerifyDesign.md` under the same TP ID.
- P0 Functional coverage is decided before P1/P2 promotion, or an explicit `@[NoTestPoints]: <reason>` decision exists.
- Room is made for Q3 exploratory and Q4 technology-critique needs instead of silently omitting them.
- Verification methods and execution environments are distinct from expected behavior.
- Live US/AC/TC status is handed off to the right dynamic evidence location instead of bloating this design.
