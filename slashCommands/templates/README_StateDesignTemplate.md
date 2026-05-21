# {{ProjectName}} State Design

This is the SpecCoding template for project-root `README_StateDesign.md`. Create or update it from `SPEC_takeDetailDesign` when a story changes state machines, lifecycle transitions, concurrency ownership, hardware state, buffer ownership, or media pipeline state.

## Story Context

- Story: {{US identifier and title}}
- Source artifact: {{.catdd/spec/doingUS path or issue link}}
- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Related verification design: [README_VerifyDesign.md](README_VerifyDesign.md)

## State Model

| State | Meaning | Owner | Entry Condition | Exit Condition |
| --- | --- | --- | --- | --- |
| {{State}} | {{Meaning}} | {{Module/task/object}} | {{Condition}} | {{Condition}} |

## State Transitions

| From | Event | Guard | Action | To | Failure Behavior |
| --- | --- | --- | --- | --- | --- |
| {{From}} | {{Event}} | {{Guard}} | {{Action}} | {{To}} | {{Failure behavior}} |

## Invariants

- {{Invariant that must hold across transitions}}
- {{State ownership or ordering constraint}}

## Concurrency and Ownership

| Shared State | Writer | Reader | Synchronization | Race/Fault Risk |
| --- | --- | --- | --- | --- |
| {{State/data}} | {{Writer}} | {{Reader}} | {{Lock/queue/atomic/ISR mask}} | {{Risk}} |

## Embedded and Digital Media State Points

Embedded software points:

- Hardware lifecycle: {{reset/init/configured/running/sleep/error/recovery states}}
- ISR/task handoff: {{event flag, queue, semaphore, priority inversion risk}}
- DMA state: {{idle/queued/in-flight/complete/error ownership and cache state}}
- Peripheral fault state: {{timeout, bus error, underrun, overrun, watchdog recovery}}

digital video/audio points:

- Pipeline state: {{idle/open/prebuffering/playing/paused/seeking/flushing/error}}
- Stream sync state: {{clock master, PTS baseline, drift correction, discontinuity}}
- Buffer state: {{empty/filling/ready/consuming/recycle/drop}}
- Format state: {{codec configured, resolution/sample-rate change, reconfiguration}}

## Usage Example

Run from the repository root to instantiate this state-design template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_StateDesign.md"
cp slashCommands/templates/README_StateDesignTemplate.md "$TMP_DOC"
sed -n '1,120p' "$TMP_DOC"
```

Expected result: the temporary file shows state model, transition, concurrency, and embedded/media state sections.

## Review Checklist

- Every transition has a guard, action, target state, and failure behavior.
- Shared state has explicit ownership and synchronization.
- Embedded software hardware states and digital video/audio pipeline states are covered when relevant.
