# SPEC_abortUserStory

## Purpose

Abort an active user story when continuing it in place would hide a scope, assumption, design, test, or product-quality problem, while preserving all useful evidence for the next round.

## CoT Pattern

**Linear** -- Direct execution. Given a selected active story and an explicit structured abort reason, this command moves the active story and its paired task artifact from `.catdd/spec/doingUS/` to `.catdd/spec/abortUS/` while preserving traceability and normalizing lifecycle lanes. It does not decide new product intent or repair the story in place.

### Linear Execution

Run these steps once, in order. There is no retry loop; any failed check stops and asks the developer.

1. Validate there is exactly one active target story in `.catdd/spec/doingUS/` for the selected story ID.
2. Validate `abort_reason` carries all four required fields. Stop and ask if any is missing; do not infer them.
3. Capture the structured `abort_reason` in the aborted artifact.
4. Move the story and its paired tasks artifact from `doingUS` to `abortUS`.
5. Verify lane normalization — the story ID must not remain in both `doingUS` and `abortUS`.
6. Record `followup_intent`, defaulting to `SPEC_analyzeAbortedUserStory` and noting that developer intent is pending.
7. Report the aborted paths and the next command: `SPEC_analyzeAbortedUserStory` for evidence-first refinement, or `SPEC_importIssue` for a fresh improvement input.

### Worked Example

Halfway through implementation the story's core assumption turns out to be wrong:

```text
/SPEC_abortUserStory
doing_user_story: .catdd/spec/doingUS/20260904-payment-retry-UserStory.md
abort_reason:
  primary_gap_type: assumption-gap
  problem_summary: The gateway is not idempotent, so blind retries can double-charge.
  evidence_refs: services/payment/SysTests/UT_Retry-Fault.ts (TC-RETRY-009 FAILS)
  unsafe_if_continue: Continuing would ship a retry path that can charge a customer twice.
```

Expected result:

1. Exactly one active story matches the ID → check passes.
2. All four `abort_reason` fields present → check passes.
3. Abort reason captured verbatim in the aborted artifact, including the failing test reference.
4. Story and tasks moved to `.catdd/spec/abortUS/`.
5. Lane check: ID no longer present in `doingUS` → normalized.
6. `followup_intent` omitted by developer → defaulted to `SPEC_analyzeAbortedUserStory` and recorded as pending.
7. Reported: `next_command = SPEC_analyzeAbortedUserStory`. No replacement story is invented here.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `doing_tasks_file`: optional active `.catdd/spec/doingUS/*-UserStory-Tasks.md` task artifact paired with the story.
- `abort_reason`: the blocking problem that makes the current story unsafe to continue.
  - Required structure (minimum):
    - `primary_gap_type`: one of `scope-gap | assumption-gap | design-gap | implementation-gap | quality-gap`.
    - `problem_summary`: one concise sentence.
    - `evidence_refs`: at least one concrete artifact path or verification reference.
    - `unsafe_if_continue`: one concise sentence explaining why in-place continuation is unsafe.
- `followup_intent`: one of `SPEC_analyzeAbortedUserStory | SPEC_importIssue | undecided`.
  - Default when omitted: `SPEC_analyzeAbortedUserStory`.
- `execution_mode`: optional `manualMode | autonomousMode` (default: `manualMode`). In `autonomousMode`, upon aborting the unsafe story, exit with a non-zero exit code while preserving diagnostic evidence.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)

## Output Contract

- A `.catdd/spec/abortUS/*-UserStory.md` team-shared aborted story artifact preserving source trace, current status, abort reason, and unresolved questions.
- A paired `.catdd/spec/abortUS/*-UserStory-Tasks.md` team-shared task artifact when the story was planned through `SPEC_makePlan`.
- Local `.catdd/spec/doingUS/` active work state removed or marked aborted after the aborted artifact is created.
- Lane normalization guarantee:
  - After completion, the same story ID must not remain simultaneously active in both `.catdd/spec/doingUS/` and `.catdd/spec/abortUS/`.
  - The aborted lane must be the single source of truth for that story ID.
- Next recommended command: `SPEC_analyzeAbortedUserStory` when the next work should reuse the preserved story evidence, or `SPEC_importIssue` when the problem should become a new improvement/refinement input for the next round.

## Conflict Guard

Do not use abort to silently discard work. Preserve the story, task checklist, source trace, abort reason, and any useful verification evidence.
Do not continue implementation after aborting. The next round must start from `SPEC_analyzeAbortedUserStory` or `SPEC_importIssue`.
Do not invent the replacement story.
If `followup_intent` is unclear, default to `SPEC_analyzeAbortedUserStory` and explicitly record that developer follow-up intent is pending.
Do not leave duplicate copies of the same story ID across `doingUS` and `abortUS` after abort completes.

ONE-MORE-THING: ask developer if something not sure
