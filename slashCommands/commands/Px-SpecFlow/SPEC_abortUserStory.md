# SPEC_abortUserStory

## Purpose

Abort an active user story when continuing it in place would hide a scope, assumption, design, test, or product-quality problem, while preserving all useful evidence for the next round.

## CoT Pattern

**Linear** -- Direct execution. Given a selected active story and an explicit structured abort reason, this command moves the active story and its paired task artifact from `.catdd/spec/doingUS/` to `.catdd/spec/abortUS/` while preserving traceability and normalizing lifecycle lanes. It does not decide new product intent or repair the story in place.

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

## Execution Checklist

1. Validate there is exactly one active target story in `.catdd/spec/doingUS/` for the selected story ID.
2. Capture structured `abort_reason` fields in the aborted artifact.
3. Move story and paired tasks artifact from `doingUS` to `abortUS`.
4. Verify lane normalization (no duplicate same-ID story across `doingUS` and `abortUS`).
5. Record `followup_intent` in the aborted story/tasks artifact.
6. Recommend next command:

- `SPEC_analyzeAbortedUserStory` for evidence-first refinement (default).
- `SPEC_importIssue` for a fresh improvement/refinement input.

## Prompt Template

Ask the assistant to preserve the active story and paired tasks in `.catdd/spec/abortUS/`, record a structured abort reason, normalize lanes so there is no duplicate active/aborted copy of the same story, avoid inventing replacement requirements, and recommend whether the next round should analyze aborted evidence or import a new issue.

## Conflict Guard

Do not use abort to silently discard work. Preserve the story, task checklist, source trace, abort reason, and any useful verification evidence.
Do not continue implementation after aborting. The next round must start from `SPEC_analyzeAbortedUserStory` or `SPEC_importIssue`.
Do not invent the replacement story.
If `followup_intent` is unclear, default to `SPEC_analyzeAbortedUserStory` and explicitly record that developer follow-up intent is pending.
Do not leave duplicate copies of the same story ID across `doingUS` and `abortUS` after abort completes.

ONE-MORE-THING: ask developer if something not sure
