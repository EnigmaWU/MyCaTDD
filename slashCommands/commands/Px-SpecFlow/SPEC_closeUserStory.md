# SPEC_closeUserStory

## Purpose

Close an active user story after implementation, review, commit, and CI are complete.

## CoT Pattern

**Linear** — Direct execution. Given verified commit and CI evidence, this command moves the story artifact to done state deterministically and normalizes story-specific trace links to the done location. If any lifecycle gate (review, commit, CI) remains unresolved, the observation stops and asks the developer instead of closing.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `doing_tasks_file`: optional active `.catdd/spec/doingUS/*-TASKs.md` task artifact paired with the story.
- `readme_spec_files`: optional project-root `README*` SPEC files updated by the story.
- `commit_ref`: completed commit.
- `ci_summary`: CI result or accepted verification summary.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)

## Output Contract

- A `.catdd/spec/doneUS/*-UserStory.md` team-shared completed story artifact.
- A paired `.catdd/spec/doneUS/*-TASKs.md` team-shared task artifact when the story was planned through `SPEC_makePlan`.
- Local `.catdd/spec/doingUS/` work state removed or marked closed after the completed artifact is created.
- Story-specific references that still point to `.catdd/spec/doingUS/` are updated to `.catdd/spec/doneUS/` after closure so trace paths remain valid.
- Completion summary with traceability to source issue or feature, project-root README SPEC docs, tests, code, commit, and CI.
- Remaining follow-up work, if any.

## Prompt Template

Ask the assistant to close only verified work and preserve enough history for later review.

## Conflict Guard

Do not close if product intent, acceptance criteria, tests, review, commit, or CI status remains unresolved.
Do not leave stale story-specific trace links pointing to `.catdd/spec/doingUS/` after closure.

ONE-MORE-THING: ask developer if something not sure
