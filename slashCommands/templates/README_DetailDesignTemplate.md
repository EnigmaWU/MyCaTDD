# {{ProjectName}} Detail Design

This is the SpecCoding template for project-root `README_DetailDesign.md`. Create or update it from `SPEC_takeDetailDesign` and revise it from `SPEC_updateDetailDesign` when a story changes detailed behavior, acceptance criteria, interfaces, state, or design decisions.

## Story Context

- Story: {{US identifier and title}}
- Source artifact: {{.catdd/spec/doingUS path or issue link}}
- Related overview: [README.md](README.md)
- Related user stories: [README_UserStories.md](README_UserStories.md)

## Requirements

| Requirement | Source | Notes |
| --- | --- | --- |
| {{Requirement}} | {{US/AC/source}} | {{Constraint or assumption}} |

## Outcome to Implementation Model

<!-- How: Work backward from desired outcome to exact implementation inputs.
	This keeps detailed design from becoming a list of classes without a reason.
	(→ SKILL: apply-oopsi-model) -->

| Layer | Detail Design Answer |
| --- | --- |
| Outcome | {{valuable result this implementation must enable}} |
| Outputs | {{observable response, file, state, event, diagnostic, or rendered result}} |
| Process | {{implementation steps or collaboration flow}} |
| Scenarios | {{happy path, edge, misuse, fault, state, quality scenarios}} |
| Inputs | {{API args, config, env, files, events, dependencies, state}} |

## Acceptance Criteria

| AC ID | Given | When | Then | Design Impact |
| --- | --- | --- | --- | --- |
| AC-{{n}} | {{context}} | {{action}} | {{observable result}} | {{module/API/state change}} |

## Interface Design

| Interface | Caller / Owner | Input | Output | Error Behavior | Compatibility Note |
| --- | --- | --- | --- | --- | --- |
| {{API/command/file/event}} | {{caller or owning module}} | {{Input}} | {{Output}} | {{Error handling}} | {{version/config/backward-compat concern}} |

## Input and Output Dictionary

<!-- How: Define data fields precisely enough for implementation and tests.
	Mark unknown limits as TBD; do not guess domain values. (→ SKILL: build-data-dictionary) -->

| Element | Structure / Primitive | Type / Format | Required | Allowed Values / Limits | Owner | Validation / Default |
| --- | --- | --- | --- | --- | --- | --- |
| {{ElementName}} | {{structure/primitive}} | {{string/int/path/json/etc.}} | {{yes/no}} | {{range, enum, pattern, or TBD}} | {{module/component}} | {{rule, default, or question}} |

## Behavior Design

| Step | Actor / Component | Input | Action | Output / State Change | Failure Handling |
| --- | --- | --- | --- | --- | --- |
| 1 | {{component}} | {{input/state}} | {{action}} | {{output/state}} | {{edge/fault behavior}} |
| 2 | {{component}} | {{input/state}} | {{action}} | {{output/state}} | {{edge/fault behavior}} |

## Behavior Scenarios

<!-- How: Keep implementation scenarios testable. Every row should be convertible to AC/TC. -->

| Scenario | Given | When | Then | CaTDD Category | Test Seed |
| --- | --- | --- | --- | --- | --- |
| {{happy path}} | {{context}} | {{operation}} | {{observable result}} | `funcValidTypical` | {{verifyOperation_byCondition_expectOutcome}} |
| {{valid boundary}} | {{context}} | {{operation}} | {{observable result}} | `funcValidEdge` | {{verifyOperation_byBoundary_expectOutcome}} |
| {{invalid caller}} | {{context}} | {{operation}} | {{observable result}} | `funcInvalidMisuse` | {{verifyOperation_byMisuse_expectRejection}} |
| {{dependency fault}} | {{context}} | {{operation}} | {{observable result}} | `funcInvalidFault` | {{verifyOperation_byFault_expectGracefulFailure}} |

## State and Data

| State/Data | Owner | Lifecycle | Invariant |
| --- | --- | --- | --- |
| {{State or data}} | {{Owner}} | {{Create/update/delete}} | {{Invariant}} |

## Constraints Carried from Architecture

<!-- How: Preserve architecture quality scenarios as detail-level constraints.
	If a detail decision changes an architecture-significant tradeoff, promote it to an ADR. -->

| Source ASR / Decision | Detail Constraint | Implementation Impact | Verification Impact |
| --- | --- | --- | --- |
| {{ASR/decision}} | {{constraint}} | {{API/state/resource choice}} | {{test or review evidence}} |

## Embedded and Digital Media Detail Points

Embedded software points:

- Interrupt behavior: {{ISR trigger, priority, debounce, deadline}}
- Driver interaction: {{register access, HAL call, error code, retry policy}}
- Resource lifetime: {{static allocation, heap use, stack budget, buffer lifetime}}
- Fault handling: {{watchdog, brownout, peripheral reset, timeout recovery}}

digital video/audio points:

- Media timing: {{frame duration, sample period, PTS/DTS behavior}}
- Buffer behavior: {{underrun, overrun, frame drop, backpressure}}
- Format behavior: {{resolution, frame rate, sample rate, channel layout, bit depth}}
- User-observable quality: {{glitch, lip-sync, latency, stutter, artifact tolerance}}

## Error and Edge Handling

| Condition | Type | Expected Behavior | Diagnostic / Recovery | Test Category |
| --- | --- | --- | --- | --- |
| {{valid edge condition}} | Edge | {{Expected behavior}} | {{diagnostic or none}} | `funcValidEdge` |
| {{misuse condition}} | Misuse | {{Expected behavior}} | {{diagnostic or none}} | `funcInvalidMisuse` |
| {{fault condition}} | Fault | {{Expected behavior}} | {{cleanup/retry/fail-fast}} | `funcInvalidFault` |

## CaTDD Verification Handoff

| Feature Token | Category Token | Suggested Test File | Source Scenario / AC | Notes |
| --- | --- | --- | --- | --- |
| `{{feature_token}}` | `funcValidTypical` | `test_{{feature_token}}_funcValidTypical.{{ext}}` | {{Scenario / AC}} | {{TC seeds}} |
| `{{feature_token}}` | `funcValidEdge` | `test_{{feature_token}}_funcValidEdge.{{ext}}` | {{Scenario / AC}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |
| `{{feature_token}}` | `funcInvalidMisuse` | `test_{{feature_token}}_funcInvalidMisuse.{{ext}}` | {{Scenario / AC}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |
| `{{feature_token}}` | `funcInvalidFault` | `test_{{feature_token}}_funcInvalidFault.{{ext}}` | {{Scenario / AC}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |

## Open Questions

- {{Question}}

## Usage Example

Run from the repository root to instantiate this detail-design template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_DetailDesign.md"
cp slashCommands/templates/README_DetailDesignTemplate.md "$TMP_DOC"
sed -n '1,120p' "$TMP_DOC"
```

Expected result: the temporary file shows detail-design sections for requirements, outcome-to-implementation mapping, acceptance criteria, interfaces, data dictionary, behavior scenarios, state, constraints, and CaTDD verification handoff.

## Review Checklist

- Every acceptance criterion has a design impact or explicit non-impact.
- Outcome, outputs, process, scenarios, and inputs are explicit.
- Interface and state changes are clear enough to drive tests.
- Data elements have type, ownership, allowed values or TBD questions.
- Behavior scenarios are convertible to CaTDD category files.
- Architecture constraints are carried into implementation and verification impact.
- Open questions are visible before implementation begins.
