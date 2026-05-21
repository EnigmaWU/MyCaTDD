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

## Acceptance Criteria

| AC ID | Given | When | Then | Design Impact |
| --- | --- | --- | --- | --- |
| AC-{{n}} | {{context}} | {{action}} | {{observable result}} | {{module/API/state change}} |

## Interface Design

| Interface | Input | Output | Error Behavior |
| --- | --- | --- | --- |
| {{API/command/file}} | {{Input}} | {{Output}} | {{Error handling}} |

## Behavior Design

```text
1. {{Step}}
2. {{Step}}
3. {{Step}}
```

## State and Data

| State/Data | Owner | Lifecycle | Invariant |
| --- | --- | --- | --- |
| {{State or data}} | {{Owner}} | {{Create/update/delete}} | {{Invariant}} |

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

- {{Edge or fault condition}} -> {{Expected behavior}}
- {{Misuse condition}} -> {{Expected behavior}}

## Open Questions

- {{Question}}

## Usage Example

Run from the repository root to instantiate this detail-design template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_DetailDesign.md"
cp slashCommands/templates/README_DetailDesignTemplate.md "$TMP_DOC"
sed -n '1,120p' "$TMP_DOC"
```

Expected result: the temporary file shows detail-design sections for requirements, acceptance criteria, interfaces, behavior, and state.

## Review Checklist

- Every acceptance criterion has a design impact or explicit non-impact.
- Interface and state changes are clear enough to drive tests.
- Open questions are visible before implementation begins.
