# SPEC_updateUserStory

## Purpose

Update requirement-oriented story artifacts for an active story by revising project-root `README_UserStories.md` (TODO/DONE + AC trace/status ledger) and paired `README_UserGuide.md` before design or implementation proceeds. Module or submodule `README_UserStory.md` may also be updated when the project uses module-local requirement docs.

## CoT Pattern

**ReACT** -- Reasoning + Acting. This command must inspect the active story and current requirement docs, apply the minimum requirement-level updates needed for consistency and traceability, and verify that story IDs and usage guidance stay aligned without drifting into architecture or detail design decisions.

### ReACT Execution

Repeat within `max_rework_attempts`; each pass must show changed evidence.

1. **Thought** — Compare the active story against `README_UserStories.md` and the paired `README_UserGuide.md`. List only the requirement-level deltas. Classify anything that is really an architecture or design decision and exclude it here.
2. **Action** — Apply the minimum edits: ledger TODO/DONE state, AC trace/status, usage guidance, and module `README_UserStory.md` when module-local docs are used. Keep US/AC IDs stable.
3. **Observation** — Verify every changed AC keeps its ID, the ledger matches the story file, and the user guide describes the same behavior the ACs assert. A renamed ID, a ledger/story mismatch, or new product scope beyond story intent returns to **Thought**.
4. **Stop** — Exit when requirement docs are consistent. Report the requirement-update checklist and `next_command = SPEC_reviewUserStory`; this gate is never skipped.

### Worked Example

Acting on a review finding that AC-04 was untestable:

```text
/SPEC_updateUserStory
doing_user_story: .catdd/spec/doingUS/20260904-payment-retry-UserStory.md
project_user_stories_doc: README_UserStories.md
update_scope: AC-04
```

Expected result:

- **Thought**: two deltas — AC-04's wording is unmeasurable, and the ledger marks AC-04 `DONE` while the story still lists it open. A third candidate change ("switch to a token-bucket retry") is a design decision → excluded.
- **Action**: AC-04 reworded to "p95 retry completion under 500ms"; ledger AC-04 reset to `TODO`; user guide retry section updated to match.
- **Observation**: AC-04 kept its ID, ledger now matches the story, and the guide asserts the same bound → consistent.
- **Stop**: checklist reports 1 AC reworded, 1 ledger fix, 1 guide alignment; `next_command = SPEC_reviewUserStory`.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `project_user_stories_doc`: project-root `README_UserStories.md` to update as the authoritative TODO/DONE and AC ledger.
- `module_user_story_doc`: optional module or submodule `README_UserStory.md` to update when module-local requirement docs are used.
- `module_user_guide_doc`: paired module or submodule `README_UserGuide.md` to align with the updated user story.
- `update_scope`: optional scope hint such as specific `US-*` or `AC-*` IDs.
- `projectContext_file`: optional project context.
- `max_rework_attempts`: optional maximum number of requirement rework attempts in the `SPEC_updateUserStory -> SPEC_reviewUserStory` cycle. Default: `3`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Updated project-root `README_UserStories.md` with requirement-level revisions, TODO/DONE state synchronization, and stable US/AC trace IDs.
- Updated module or submodule `README_UserStory.md` when module-local requirement docs are used.
- Updated paired `README_UserGuide.md` aligned to the revised requirement intent and usage behavior.
- Explicit trace links from the active doing story to updated requirement docs.
- Requirement-update checklist describing what changed and what remains open.
- Next recommended command is `SPEC_reviewUserStory`.

## Loop Guard

This update runs inside the `SPEC_updateUserStory -> SPEC_reviewUserStory` rework cycle, bounded by `max_rework_attempts` (default `3`). Stop on resolved findings, exhausted attempts, or repeated no-progress evidence; on stop, preserve the latest evidence and route to `SPEC_abortUserStory` or `ASK`, never a third silent retry.

## Conflict Guard

Do not invent new product scope outside the active story intent.
Do not update `README_UserStories.md` for a story whose ledger state is SUSPENDED; require `SPEC_resumeUserStory` first to resume before updating.
Do not move this step into architecture or detail-design decisions; route those to design-oriented commands.
Do not skip `SPEC_reviewUserStory` after updating requirement artifacts.

ONE-MORE-THING: ask developer if something not sure
