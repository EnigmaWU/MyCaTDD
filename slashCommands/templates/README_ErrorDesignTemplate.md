# {{ProjectName}} Error Design

This is the SpecCoding template for project-root `README_ErrorDesign.md`. Create or update it from `SPEC_takeDetailDesign` when a story changes error taxonomy, fault handling, recovery policy, degradation behavior, retry behavior, timeout behavior, or user-visible failure semantics.

## Story Context

- Story: {{US identifier and title}}
- Source artifact: {{.catdd/spec/doingUS path or issue link}}
- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Related diagnosis design: [README_DiagnosisDesign.md](README_DiagnosisDesign.md)
- Related verification design: [README_VerifyDesign.md](README_VerifyDesign.md)

## Error Taxonomy

| Error | Category | Cause | User/System Impact | Recoverable | Owner |
| --- | --- | --- | --- | --- | --- |
| {{Error code/name}} | {{Misuse/fault/resource/timeout/state/media}} | {{Cause}} | {{Impact}} | {{Yes/No/Partial}} | {{module/team}} |

## Error Scenario Model

<!-- How: Separate invalid caller behavior from valid caller behavior under failure.
	Misuse normally maps to `funcInvalidMisuse`; dependency/resource/runtime failure maps to
	`funcInvalidFault`. (→ SKILL: validate-requirements-criteria) -->

| Scenario | Given | When | Then | Error Type | CaTDD Category |
| --- | --- | --- | --- | --- | --- |
| {{invalid caller scenario}} | {{context}} | {{bad input/action}} | {{reject/protect}} | Misuse | `funcInvalidMisuse` |
| {{dependency fault scenario}} | {{valid context}} | {{dependency/resource fails}} | {{recover/degrade/fail deterministically}} | Fault | `funcInvalidFault` |

## Error Handling Policy

| Error | Detection Point | Handling | Retry/Backoff | Escalation | Diagnostic Evidence |
| --- | --- | --- | --- | --- | --- |
| {{Error}} | {{Where detected}} | {{Return/log/reset/drop/degrade}} | {{Policy}} | {{Notify/fail-safe/recover}} | {{log/counter/trace/status}} |

## Degradation and Recovery

| Degradation Mode | Trigger | Reduced Capability | Recovery Trigger | User-Visible Behavior | Data Integrity Rule |
| --- | --- | --- | --- | --- | --- |
| {{mode}} | {{fault or threshold}} | {{fallback behavior}} | {{condition that returns to normal}} | {{message/status/output/error result}} | {{what must never be corrupted or lost}} |

## Error Precedence Rules

| If These Conditions Coexist | Report This Error First | Rationale | Test Seed |
| --- | --- | --- | --- |
| {{multiple invalid inputs/faults}} | {{primary error}} | {{why this is most actionable}} | {{verifyErrorPrecedence_byCondition_expectPrimaryError}} |

## CaTDD Verification Handoff

| Feature Token | Category Token | Suggested Test File | Error Concern | Notes |
| --- | --- | --- | --- | --- |
| `{{feature_token}}` | `funcInvalidMisuse` | `test_{{feature_token}}_funcInvalidMisuse.{{ext}}` | {{invalid caller / contract violation}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |
| `{{feature_token}}` | `funcInvalidFault` | `test_{{feature_token}}_funcInvalidFault.{{ext}}` | {{dependency/resource/runtime failure}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |
| `{{feature_token}}` | `qualityRobust` | `test_{{feature_token}}_qualityRobust.{{ext}}` | {{degradation/recovery over repeated or stressed faults}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |

## Embedded and Digital Media Error Points

Embedded software points:

- Hardware faults: {{bus error, peripheral timeout, watchdog, brownout, sensor fault}}
- Driver failures: {{register access failure, DMA error, interrupt storm, calibration failure}}
- Fail-safe behavior: {{safe output state, reset policy, degraded mode, persistent fault}}
- Retry limits: {{max retries, cooldown, watchdog window, recovery timeout}}

digital video/audio points:

- Media faults: {{decode error, malformed stream, timestamp discontinuity, unsupported format}}
- Pipeline failures: {{buffer underrun/overrun, frame drop, render failure, device disconnect}}
- Quality degradation: {{mute, frame skip, resolution downgrade, bitrate adaptation}}
- Sync recovery: {{resync, flush, seek recovery, clock rebase, stream restart}}

## Usage Example

Run from the repository root to instantiate this error-design template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_ErrorDesign.md"
cp slashCommands/templates/README_ErrorDesignTemplate.md "$TMP_DOC"
sed -n '1,120p' "$TMP_DOC"
```

Expected result: the temporary file shows error taxonomy, handling policy, degradation, recovery, and domain-specific error sections.

## Review Checklist

- Every important error has a detection point, handling policy, and escalation rule.
- Misuse and fault scenarios are separated before test design.
- Error precedence is explicit when multiple failures can coexist.
- Diagnostic evidence is defined for every important error path.
- Recovery and degradation are explicit rather than hidden in implementation.
- CaTDD handoff maps errors to misuse, fault, or robust categories.
- Embedded software hardware faults and digital video/audio media faults are covered when relevant.
