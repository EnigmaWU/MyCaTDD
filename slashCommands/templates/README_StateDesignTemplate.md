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

## State Scope and Intent

<!-- How: Define why this state model exists before enumerating transitions.
	If the story has no real lifecycle or invariant risk, record `@[NoTestPoints]: <reason>`
	in the verification handoff instead of inventing states. (→ SKILL: elicit-requirements-models) -->

| Question | Design Answer |
| --- | --- |
| What object or workflow has state? | {{object, session, resource, stream, hardware, or pipeline}} |
| Why state matters now | {{risk, behavior, race, recovery, user-visible result}} |
| Initial state | {{state}} |
| Terminal states | {{states or none}} |
| Invalid states to reject | {{states or combinations that must never happen}} |

## State Transitions

| From | Event | Guard | Action | To | Failure Behavior |
| --- | --- | --- | --- | --- | --- |
| {{From}} | {{Event}} | {{Guard}} | {{Action}} | {{To}} | {{Failure behavior}} |

## Transition Scenario Matrix

| Scenario | Given State | Event / Command | Expected State | Observable Output | CaTDD Category |
| --- | --- | --- | --- | --- | --- |
| {{valid transition}} | {{state}} | {{event}} | {{state}} | {{output/side effect}} | `designState` |
| {{invalid transition}} | {{state}} | {{event}} | {{unchanged/error state}} | {{diagnostic/rejection}} | `funcInvalidMisuse` |
| {{fault during transition}} | {{state}} | {{event}} | {{recovered/degraded/error state}} | {{diagnostic/recovery}} | `funcInvalidFault` |

## Invariants

| Invariant | Applies In States | Violation Detection | Recovery / Rejection | Verification Seed |
| --- | --- | --- | --- | --- |
| {{Invariant that must hold across transitions}} | {{states}} | {{assertion/check/hook}} | {{reject/recover/fail-fast}} | {{TC seed}} |

## Concurrency and Ownership

| Shared State | Writer | Reader | Synchronization | Race/Fault Risk |
| --- | --- | --- | --- | --- |
| {{State/data}} | {{Writer}} | {{Reader}} | {{Lock/queue/atomic/ISR mask}} | {{Risk}} |

## CaTDD Verification Handoff

| Feature Token | Category Token | Suggested Test File | State Concern | Notes |
| --- | --- | --- | --- | --- |
| `{{feature_token}}` | `designState` | `test_{{feature_token}}_designState.{{ext}}` | {{valid transitions, invariants, lifecycle}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |
| `{{feature_token}}` | `designConcurrency` | `test_{{feature_token}}_designConcurrency.{{ext}}` | {{shared-state race or ownership concern}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |

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
- State scope and invalid states are explicit.
- Transition scenarios include valid, invalid, and fault paths when relevant.
- Invariants define detection and recovery/rejection behavior.
- Shared state has explicit ownership and synchronization.
- CaTDD handoff maps state concerns to `designState` or explicit no-test-points decisions.
- Embedded software hardware states and digital video/audio pipeline states are covered when relevant.
