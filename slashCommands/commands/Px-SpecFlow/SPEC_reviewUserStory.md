# SPEC_reviewUserStory

## Purpose

Review the active user story, project-level requirement ledger (`README_UserStories.md`), usage guidance, and acceptance criteria after requirement-oriented updates.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the story and requirement artifacts, reason about clarity, completeness, traceability, and testability, produce a review finding, and verify that the finding is actionable before reporting. The reasoning loop routes to requirement revision when intent, usage guidance, or acceptance criteria cannot be tested.

### ReACT Execution

Run this loop; each pass must produce changed evidence or it is the last pass.

1. **Thought** — Read `doing_user_story`, `project_user_stories_doc`, and the paired `module_user_guide_doc`. For each AC, decide whether it is (a) testable through a CaTDD skeleton, (b) traced to a US/AC id in the ledger, (c) consistent with the ledger's TODO/DONE state. Name the ACs that fail any of the three.
2. **Action** — Write the review result as one verdict — `pass`, `revise requirements`, `transfer to design`, `close requirement-only`, or `ask developer` — with one finding line per failing AC.
3. **Observation** — Check every finding names a file, an AC id, and a concrete fix. If a finding is vague, or if the ledger check was skipped, go back to **Thought**.
4. **Stop** — Exit when the verdict is stable and all findings are actionable. Report the verdict, findings, assumptions, and next command.

On `revise requirements`, route to `SPEC_updateUserStory` and re-enter this loop only after the story file actually changed.

### Worked Example

After `SPEC_updateUserStory` rewrote AC-03 and AC-04 of the active story, run:

```text
/SPEC_reviewUserStory
doing_user_story: .catdd/spec/doingUS/20260904-payment-retry-UserStory.md
project_user_stories_doc: README_UserStories.md
module_user_guide_doc: services/payment/README_UserGuide.md
```

Expected result — one ReACT pass:

- **Thought**: AC-01/02/03 are testable; AC-04 says "retry should be fast" with no threshold, so it fails testability. Ledger shows AC-04 as `DONE` while the story still lists it as open.
- **Action**: verdict `revise requirements`; findings — `AC-04: replace "fast" with a measurable bound (e.g. p95 < 500ms)` and `README_UserStories.md:AC-04 status DONE contradicts doingUS story`.
- **Observation**: both findings name a file, an AC id, and a fix → actionable, loop exits.
- Next command: `SPEC_updateUserStory`.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `project_user_stories_doc`: project-root `README_UserStories.md` updated by `SPEC_updateUserStory`.
- `module_user_story_doc`: optional module or submodule `README_UserStory.md` updated by `SPEC_updateUserStory` when module-local requirement docs are used.
- `module_user_guide_doc`: paired module or submodule `README_UserGuide.md` updated by `SPEC_updateUserStory`.
- `detail_design`: optional design section or project-root README SPEC docs when reviewing transfer from requirement-oriented work into design-oriented work.
- `readme_spec_files`: optional project-root `README*` SPEC files relevant to the story.
- `projectContext_file`: current project context.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Review result recorded against team-shared `.catdd/spec/doingUS/` work state: pass, revise requirements, transfer to design-oriented work, close requirement-only work, or ask developer.
- Explicit consistency check that `README_UserStories.md` TODO/DONE story state and AC trace/status match lifecycle artifacts and active story content.
- Missing acceptance criteria, ambiguity, README SPEC doc gaps, edge cases, measurable outcomes, and risk list from a clarify/analyze/checklist-style review gate.
- Next recommended command: `SPEC_updateUserStory`, `SPEC_commitWorks`, `SPEC_takeArchDesign`, `SPEC_updateArchDesign`, `SPEC_takeDetailDesign`, or `SPEC_updateDetailDesign`.

## Loop Guard

On revise findings, route to `SPEC_updateUserStory` and record structured findings. The `SPEC_updateUserStory -> SPEC_reviewUserStory` rework cycle is bounded by `max_rework_attempts` (default `3`) and the `Px-SpecFlow` Loop Guard stop conditions: after repeated no-progress or exhausted attempts, route to `SPEC_abortUserStory` or `ASK`, never a third silent retry. Do not claim requirement-review progress without changed evidence between passes.

## Conflict Guard

Do not approve a story when acceptance criteria cannot be tested through CaTDD skeletons.
Do not approve requirement updates when `README_UserStories.md` TODO/DONE state or AC trace/status is inconsistent with story lifecycle artifacts.
Do not review a story whose `README_UserStories.md` ledger state is SUSPENDED; require `SPEC_resumeUserStory` first to resume before reviewing.
Do not route directly from requirement review to unit-test design; transfer to design-oriented work first when architecture or detail design is still needed.
Do not use this command as the automatic gate after `SPEC_reviewDetailDesign`; detail-design review owns that design gate.

ONE-MORE-THING: ask developer if something not sure
