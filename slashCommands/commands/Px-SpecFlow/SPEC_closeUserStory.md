# SPEC_closeUserStory

## Purpose

Close an active user story after implementation, review, commit, and CI are complete.

`SPEC_closeUserStory` may generate new lifecycle/meta changes (for example `doingUS -> doneUS` moves, story-link normalization, and project-context updates). Those post-close changes are not covered by the pre-close `commit_ref` and must be committed before closure is considered complete.

## CoT Pattern

**Linear** — Direct execution. Given verified commit and CI evidence, this command moves the story artifact to done state deterministically and normalizes story-specific trace links to the done location. If any lifecycle gate (review, commit, CI) remains unresolved, the observation stops and asks the developer instead of closing.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `doing_tasks_file`: optional active `.catdd/spec/doingUS/*-TASKs.md` task artifact paired with the story.
- `project_user_stories_doc`: project-root `README_UserStories.md` ledger to synchronize TODO/DONE and AC status.
- `suspended_user_story_files`: optional `.catdd/spec/suspendUS/*-UserStory.md` to confirm the story is not in suspended state before closing.
- `readme_spec_files`: optional project-root `README*` SPEC files updated by the story.
- `commit_ref`: completed commit.
- `ci_summary`: CI result or accepted verification summary.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)

## Output Contract

- A `.catdd/spec/doneUS/*-UserStory.md` team-shared completed story artifact.
- A paired `.catdd/spec/doneUS/*-TASKs.md` team-shared task artifact when the story was planned through `SPEC_makePlan`.
- Local `.catdd/spec/doingUS/` work state is removed after the completed artifact is created; do not keep a duplicate closed copy in doingUS.
- Story-specific references that still point to `.catdd/spec/doingUS/` are updated to `.catdd/spec/doneUS/` after closure so trace paths remain valid.
- Project-level `README_UserStories.md` is synchronized so the story moves from TODO/DOING to DONE and acceptance-criteria status is aligned with closure evidence.
- Project-context sync policy is applied after closure:
 	- Minor lifecycle impact (for example only story file movement or link normalization): remind the developer to run `SPEC_updateProjectContext`.
 	- Major lifecycle impact (for example next-command recommendation changes, pending/todo/doing/done summary changes, or project rules/constraints changed by this story): run `SPEC_updateProjectContext` in the same progress flow before declaring closure complete.
- Completion summary with traceability to source issue, feature, or imported user-story input, project-root README SPEC docs, tests, code, commit, and CI.
- Close-commit checkpoint result:
 	- If no file changed during close: report `close_commit_required = no`.
 	- If close generated file changes: report `close_commit_required = yes` and either:
  		- include `close_commit_ref` for the commit that captured close-generated changes, or
  		- include explicit handoff `next_command = /SPEC_commitWorks` and do not mark closure complete yet.
- Remaining follow-up work, if any.

## Prompt Template

Ask the assistant to close only verified work, preserve enough history for later review, apply post-close project-context sync policy (minor = remind, major = run `SPEC_updateProjectContext` in-flow), and enforce the post-close commit checkpoint for close-generated file changes.

## Conflict Guard

Do not close if product intent, acceptance criteria, tests, review, commit, or CI status remains unresolved.
Do not close if `README_UserStories.md` TODO/DONE or AC status is not synchronized with closure evidence.
Do not close a story whose README_UserStories.md ledger state is SUSPENDED; require `SPEC_resumeUserStory` first to resume before closing.
Do not leave stale story-specific trace links pointing to `.catdd/spec/doingUS/` after closure.
Do not leave the same story ID under both `.catdd/spec/doingUS/` and `.catdd/spec/doneUS/`.
Do not mark closure complete after major lifecycle impact until `SPEC_updateProjectContext` has been executed or explicitly delegated to the developer.
Do not mark closure complete when close-generated file changes remain uncommitted.
Do not treat the pre-close `commit_ref` as sufficient evidence for close-generated changes.

ONE-MORE-THING: ask developer if something not sure
