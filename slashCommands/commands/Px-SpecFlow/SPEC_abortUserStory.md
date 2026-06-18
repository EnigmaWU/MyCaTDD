# SPEC_abortUserStory

## Purpose

Abort an active user story when continuing it in place would hide a scope, assumption, design, test, or product-quality problem.

## CoT Pattern

**Linear** -- Direct execution. Given a selected active story and an explicit abort reason, this command moves the active story and its paired task artifact from `.catdd/spec/doingUS/` to `.catdd/spec/abortUS/` while preserving traceability. It does not decide new product intent or repair the story in place.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `doing_tasks_file`: optional active `.catdd/spec/doingUS/*-TASKs.md` task artifact paired with the story.
- `abort_reason`: the blocking problem that makes the current story unsafe to continue.
- `followup_intent`: whether the developer wants `SPEC_analyzeAbortedUserStory` on the aborted evidence or a new `SPEC_importIssue` improvement/refinement round.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)

## Output Contract

- A `.catdd/spec/abortUS/*-UserStory.md` team-shared aborted story artifact preserving source trace, current status, abort reason, and unresolved questions.
- A paired `.catdd/spec/abortUS/*-TASKs.md` team-shared task artifact when the story was planned through `SPEC_makePlan`.
- Local `.catdd/spec/doingUS/` active work state removed or marked aborted after the aborted artifact is created.
- Next recommended command: `SPEC_analyzeAbortedUserStory` when the next work should reuse the preserved story evidence, or `SPEC_importIssue` when the problem should become a new improvement/refinement input for the next round.

## Prompt Template

Ask the assistant to preserve the active story and paired tasks in `.catdd/spec/abortUS/`, record why the story was aborted, avoid inventing replacement requirements, and recommend whether the next round should analyze the aborted story evidence or import a new issue.

## Conflict Guard

Do not use abort to silently discard work. Preserve the story, task checklist, source trace, abort reason, and any useful verification evidence.
Do not continue implementation after aborting. The next round must start from `SPEC_analyzeAbortedUserStory` or `SPEC_importIssue`.
Do not invent the replacement story. Ask the developer when follow-up intent is unclear.

ONE-MORE-THING: ask developer if something not sure