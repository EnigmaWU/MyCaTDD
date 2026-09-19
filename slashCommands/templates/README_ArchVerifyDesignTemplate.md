# {{ProjectName}} Architecture-Level Verification Design

This is the SpecCoding template for project-root `README_ArchVerifyDesign.md`. Create or update it from `SPEC_takeArchDesign` and revise it from `SPEC_updateArchDesign`; `SPEC_reviewArchDesign` gates it. Use it when a story changes verification topology, the level-and-boundary map, the target runtime environment, peer/dependency doubles, evidence ownership, or system-scope quality scenarios.

`README_ArchVerifyDesign.md` is a stable design artifact. It answers *with which other components, in which runtime environment, do we prove this*, and it owns `SysTesting` and `UserTesting` strategy. It does not own test-point discovery or CaTDD category design — [README_DetailVerifyDesign.md](README_DetailVerifyDesign.md) owns those and promotes obligations here by TP ID. Keep live RED/GREEN status, run output, and temporary trace churn in story TASKs, test files, or `README_VerifyStatusTraces.md`.

## Story and Design Inputs

- Story: {{US identifier and title}}
- Active story artifact: {{.catdd/spec/doingUS path}}
- Architecture design: [README_ArchDesign.md](README_ArchDesign.md)
- Detail-level verification design: [README_DetailVerifyDesign.md](README_DetailVerifyDesign.md)
- Related design surfaces: [README_UsageDesign.md](README_UsageDesign.md), [README_ErrorDesign.md](README_ErrorDesign.md), [README_PerfDesign.md](README_PerfDesign.md), [README_CompatDesign.md](README_CompatDesign.md), [README_DiagnosisDesign.md](README_DiagnosisDesign.md), [README_SecurityDesign.md](README_SecurityDesign.md)
- Target runtime environments: {{host simulation / container / target board / HIL / staging / production-like}}
- Dynamic trace artifact: {{README_VerifyStatusTraces.md / story TASKs / test-file comments / not needed}}

## Level-and-Boundary Map

<!-- How: Declare which levels exist for this SUT and what each one does not prove.
  Do not restate CaTDD categories here; category and test-point design belong to README_DetailVerifyDesign.md. -->

| TestLevel | Assembly under test | What it proves | What it does NOT prove | Design owner |
| --- | --- | --- | --- | --- |
| `SysTesting` | {{declared SUT + real peers/dependencies in {{environment}}}} | {{contract and interaction behavior proven at this assembly}} | {{behaviors left to UnitTesting or unproven here}} | This document |
| `UserTesting` | {{deployed composition and end-to-end user flow}} | {{full-flow outcome, prerequisites, and observed evidence}} | {{internal design properties not observable end to end}} | This document |
| `UnitTesting` | {{only list units that need this environment, e.g. on-target driver checks}} | {{what the isolated check proves}} | {{environment or integration behavior it cannot prove}} | [README_DetailVerifyDesign.md](README_DetailVerifyDesign.md) |

Rules:

- Every in-scope `SysTesting`/`UserTesting` obligation traces to a promoted TP ID; this document never restates category design.
- A level listed here without a real environment, or without a double-credibility decision, is a GAP rather than coverage.

## Verification Constraints and Goals

<!-- How: Start from WHAT must be proven at system scope and WHY it matters before choosing mechanics. -->

| Constraint / Goal | Source | Why It Matters | Observable Evidence |
| --- | --- | --- | --- |
| {{cross-component contract or topology constraint}} | {{US/AC/arch/detail design}} | {{risk or value protected}} | {{system test result, captured evidence, review artifact}} |
| {{system-scope quality or compatibility constraint}} | {{perf/compat/security/diagnosis design}} | {{failure avoided}} | {{measurement, matrix result, manual/HIL note}} |

## Target Runtime Environment Matrix

| Env ID | Composition and versions | OS / kernel / libc / board / toolchain | Difference from dev host | Levels verified | Evidence artifact |
| --- | --- | --- | --- | --- | --- |
| {{ENV-1}} | {{components and pinned versions}} | {{target runtime facts}} | {{permissions, paths, locale, network, lifecycle}} | {{SysTesting/UserTesting}} | {{log, report, hardware lab record}} |

## Peer, Dependency, and Double Credibility

| Boundary | Real / fake / simulator / recorded | Why this is credible | Known blind spot | Mitigation or QUESTION |
| --- | --- | --- | --- | --- |
| {{peer service, device, provider, filesystem}} | {{chosen double}} | {{contract fidelity argument}} | {{behavior the double cannot reproduce}} | {{extra real-target check or open question}} |

## System-Scope Quality Scenarios

| Category | Stimulus -> response measure (units or exact predicate) | Environment | Evidence | Owner |
| --- | --- | --- | --- | --- |
| {{Performance/Robust/Compatibility/Configuration/Diagnosis/Security}} | {{source-backed threshold or symbolic predicate}} | {{ENV id}} | {{artifact}} | {{owner}} |

## Quadrant Balance and Evidence Ownership

<!-- How: This is a balance check over the whole verification strategy, applied after category routing.
  Row-level category coverage stays in README_DetailVerifyDesign.md; do not repeat it here. -->

| Agile quadrant | Levels that cover it | Environment / evidence owner | Uncovered-quadrant risk |
| --- | --- | --- | --- |
| Q1 Technology/Support | {{SysTesting/UserTesting entries}} | {{ENV id, runner, or owner}} | {{risk when this quadrant is thin, and its owner}} |
| Q2 Business/Support | {{level entries}} | {{owner}} | {{risk and owner}} |
| Q3 Business/Critique | {{exploratory, UAT, or manual session}} | {{owner}} | {{risk and owner}} |
| Q4 Technology/Critique | {{system-scope quality, chaos, soak, HIL}} | {{owner}} | {{risk and owner}} |

Rules:

- This table decides balance across levels, environments, and evidence; the category-to-quadrant rows stay in [README_DetailVerifyDesign.md](README_DetailVerifyDesign.md).
- A quadrant with no level, environment, or evidence owner is a GAP recorded here, not a silent omission.

## Promoted Test Points from Detail Design

| TP ID | Obligation (from detail ledger) | Promoted level | Environment | Evidence owner | Detail design reference |
| --- | --- | --- | --- | --- | --- |
| {{TP-xx}} | {{obligation text}} | {{SysTesting/UserTesting}} | {{ENV id}} | {{owner}} | [README_DetailVerifyDesign.md](README_DetailVerifyDesign.md) |

## Evidence, Gates, and Equipment Ownership

| Gate / evidence | Runs where | Owner | Artifact | Status meaning |
| --- | --- | --- | --- | --- |
| {{CI stage, contract check, HIL run, manual session}} | {{runner, lab, or checklist}} | {{team or role}} | {{path, log, or report}} | {{planned / designed / implemented / reviewed}} |

## Embedded and Digital Media Verification Points

Embedded software points:

- Hardware-in-the-loop topology: {{board, harness, debug probe, power control}}
- Timing evidence: {{ISR latency, watchdog window, bus timeout measured on target}}
- Resource evidence: {{static RAM, stack, heap, DMA buffer budget on target}}
- Fault injection: {{bus error, brownout, timeout, reset, overrun on target}}

digital video/audio points:

- Pipeline topology: {{capture -> decode -> render -> sink composition under test}}
- Media quality evidence: {{frame drop, audio underrun, stutter, artifact observed end to end}}
- Sync evidence: {{A/V drift, timestamp discontinuity, seek/flush across components}}
- Format matrix: {{codec, resolution, frame rate, sample rate, channel layout combinations}}

## Usage Example

Run from the repository root to instantiate this architecture-level verification-design template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_ArchVerifyDesign.md"
cp slashCommands/templates/README_ArchVerifyDesignTemplate.md "$TMP_DOC"
sed -n '1,180p' "$TMP_DOC"
```

Expected result: the temporary file shows the level-and-boundary map, runtime environment matrix, double credibility, system-scope quality scenarios, promoted TP IDs, evidence ownership, and domain verification points.

## Review Checklist

- The level-and-boundary map states what each level proves and what it explicitly does not prove.
- Every `SysTesting`/`UserTesting` obligation traces to a promoted TP ID instead of restating category design.
- The environment matrix names real runtime differences, not only the dev host.
- Every double has a credibility argument and a named blind spot.
- System-scope quality scenarios carry source-backed thresholds or exact predicates, with units and environment.
- Evidence ownership and equipment prerequisites are explicit, including manual/HIL capture.
- Live status is handed off to `README_VerifyStatusTraces.md` or story TASKs instead of bloating this design.
