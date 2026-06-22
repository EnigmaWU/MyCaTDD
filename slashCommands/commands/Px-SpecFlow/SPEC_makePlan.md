# SPEC_makePlan

## Purpose

Create or update the task artifact paired with the active user story and decide which `SPEC_*` command should run next.

## CoT Pattern

**ToT** — Tree of Thoughts. This command must inspect the opened story, current project context, optional mutual-intent notes, and any existing design evidence, branch across the plausible next lifecycle paths, compare them against the story's current readiness, and choose the smallest correct next step without skipping required quality gates.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `tasks_file`: paired `.catdd/spec/doingUS/*-TASKs.md` file to create or update for the opened story.
- `projectContext_file`: current project context.
- `mutual_intent_contract`: optional intent-clearing notes produced by `SPEC_clearStoryIntent`.
- `module_user_story_doc`: optional module or submodule `README_UserStory.md` affected by the active story.
- `module_user_guide_doc`: optional paired module or submodule `README_UserGuide.md` affected by the active story.
- `project_user_stories_doc`: project-root `README_UserStories.md` ledger for TODO/DONE and AC trace status.
- `readme_spec_files`: optional project-root `README*` SPEC docs that already influence the next step.
- `related_docs`: optional issue, feature, review, architecture, detail-design, or test notes relevant to next-step planning.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A team-shared `.catdd/spec/doingUS/*-TASKs.md` task artifact coupled with the opened user story.
- The task artifact records the active story, current readiness, work orientation, skipped or satisfied prerequisites, candidate next steps, rejected next steps, selected next step, and rationale.
- The task artifact uses Markdown checkbox tasks: `[ ]` for pending work, `[x]` for satisfied or completed work.
- After creating or updating the artifact, print the current TASKs checklist in the command response so developers can see `[ ]` and `[x]` status immediately.
- The selected next command should be chosen by lifecycle position and work orientation, depending on what the opened story actually needs next.
- Explicit notes about whether requirement updates, architecture design, detail design, review, or direct unit-test design can be skipped because existing artifacts are already sufficient.
- Explicit trace to the requirement source for the active story: issue/feature pending input, imported user-story input, or module/submodule `README_UserStory.md` plus paired `README_UserGuide.md`.
- Explicit check of project-level `README_UserStories.md` consistency: TODO/DONE state and AC trace/status must match lifecycle artifacts. SUSPENDED stories should be routed to `SPEC_resumeUserStory` before planning continues.
- Open questions or blockers that must be resolved before the selected next command can run safely.

## Planning Decision Rules

- Evaluate lifecycle readiness in this order and stop at the first required next command:
 1. Intent unclear or developer/CodeAgent intent not aligned: route to `SPEC_clearStoryIntent`.
 2. Requirement-oriented work: route to `SPEC_updateUserStory` when project-level `README_UserStories.md` ledger or paired `README_UserGuide.md` (and module requirement docs when used) must be updated.
 3. Requirement update already done but not reviewed: route to `SPEC_reviewUserStory`.
 4. Design-oriented work: route to the appropriate architecture/detail take-or-update command.
 5. Implementation-oriented work with sufficient requirement and design readiness: route to `SPEC_designUnitTests`.
 6. Completed and verified work: route to `SPEC_commitWorks`, then `SPEC_closeUserStory`.
- Distinguish initial design from follow-up design revision:
 	- Initial architecture design routes to `SPEC_takeArchDesign`.
 	- follow-up architecture revision routes to `SPEC_updateArchDesign` when prior architecture exists and the story is closing a known architecture gap, review finding, or story-level architecture feedback.
 	- Initial detail design routes to `SPEC_takeDetailDesign`.
 	- follow-up detail revision routes to `SPEC_updateDetailDesign` when prior detail design exists and the story is closing a known detail-design gap, review finding, or story-level detail feedback.
- Distinguish requirement-oriented, design-oriented, and implementation-oriented work:
 	- Requirement-oriented work updates formal requirement surfaces: project-root `README_UserStories.md` (TODO/DONE + AC trace/status), paired `README_UserGuide.md`, module/submodule requirement docs when used, US/AC IDs, acceptance wording, usage-facing behavior, priority/dependency notes, and trace links. It routes to `SPEC_updateUserStory` before design commands.
 	- Requirement-oriented work routes to `SPEC_reviewUserStory` after `SPEC_updateUserStory`. Passing review can close requirement-only work through `SPEC_commitWorks` and `SPEC_closeUserStory`, or transfer to design-oriented next steps.
 	- Design-oriented work routes to the appropriate architecture/detail take-or-update command before review.
 	- Implementation-oriented work routes to `SPEC_designUnitTests` only when requirement docs, architecture, and detail readiness are already sufficient. Do not add a `SPEC_reviewUserStory` gate after `SPEC_reviewDetailDesign`.
- If developer and CodeAgent intent are not aligned, route to `SPEC_clearStoryIntent` before design or implementation-oriented work.
- If the story changes both requirements and design, route to `SPEC_updateUserStory` first, then review the story, then transfer to design-oriented next steps.
- If required requirement/design evidence is missing, mark the affected checklist item `[ ]`, reject downstream commands in the rationale, and ask the developer instead of guessing.

## Prompt Template

Ask the assistant to examine the opened story, create or update the paired `*-TASKs.md` artifact in `.catdd/spec/doingUS/`, express the work as Markdown checkbox tasks, print the checklist after planning is made, compare the realistic next lifecycle options, distinguish requirement-oriented, design-oriented, and implementation-oriented work, distinguish initial design from follow-up design revision, and choose the next `SPEC_*` command that best fits the story's current readiness without inventing missing requirements/design or skipping needed checks.

## Conflict Guard

Do not jump directly into implementation from planning. If the next safe step is unclear, stop with questions for the developer instead of guessing.
Do not plan a story whose `README_UserStories.md` ledger state is SUSPENDED; route to `SPEC_resumeUserStory` first to resume before continuing planning.
Do not skip `SPEC_updateUserStory` when the active story changes requirement surfaces, especially project-root `README_UserStories.md` or `README_UserGuide.md`.
Do not route to design-oriented commands before requirement-oriented updates are reviewed when requirement intent is still changing.

ONE-MORE-THING: ask developer if something not sure
