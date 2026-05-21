# {{ProjectName}} Error Design

This is the SpecCoding template for project-root `README_ErrorDesign.md`. Create or update it from `SPEC_takeDetailDesign` when a story changes error taxonomy, fault handling, recovery policy, degradation behavior, retry behavior, timeout behavior, or user-visible failure semantics.

## Story Context

- Story: {{US identifier and title}}
- Source artifact: {{.catdd/spec/doingUS path or issue link}}
- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Related diagnosis design: [README_DiagnosisDesign.md](README_DiagnosisDesign.md)
- Related verification design: [README_VerifyDesign.md](README_VerifyDesign.md)

## Error Taxonomy

| Error | Category | Cause | User/System Impact | Recoverable |
| --- | --- | --- | --- | --- |
| {{Error code/name}} | {{Misuse/fault/resource/timeout/state/media}} | {{Cause}} | {{Impact}} | {{Yes/No/Partial}} |

## Error Handling Policy

| Error | Detection Point | Handling | Retry/Backoff | Escalation |
| --- | --- | --- | --- | --- |
| {{Error}} | {{Where detected}} | {{Return/log/reset/drop/degrade}} | {{Policy}} | {{Notify/fail-safe/recover}} |

## Degradation and Recovery

- Degradation mode: {{Reduced capability or fallback behavior}}
- Recovery trigger: {{Condition that returns to normal}}
- User-visible behavior: {{Message/status/output/error result}}
- Data integrity rule: {{What must never be corrupted or lost}}

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
- Recovery and degradation are explicit rather than hidden in implementation.
- Embedded software hardware faults and digital video/audio media faults are covered when relevant.
