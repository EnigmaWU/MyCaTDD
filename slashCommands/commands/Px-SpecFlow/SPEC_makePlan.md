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
- `readme_spec_files`: optional project-root `README*` SPEC docs that already influence the next step.
- `related_docs`: optional issue, feature, review, architecture, detail-design, or test notes relevant to next-step planning.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A team-shared `.catdd/spec/doingUS/*-TASKs.md` task artifact coupled with the opened user story.
- The task artifact records the active story, current readiness, skipped or satisfied prerequisites, candidate next steps, selected next step, and rationale.
- The task artifact uses Markdown checkbox tasks: `[ ]` for pending work, `[x]` for satisfied or completed work.
- After creating or updating the artifact, print the current TASKs checklist in the command response so developers can see `[ ]` and `[x]` status immediately.
- The selected next command should be chosen by lifecycle position and work orientation, depending on what the opened story actually needs next.
- Explicit notes about whether architecture design, detail design, review, or direct unit-test design can be skipped because existing artifacts are already sufficient.
- Open questions or blockers that must be resolved before the selected next command can run safely.

## Planning Decision Rules

- Distinguish initial design from follow-up design revision:
	- Initial architecture design routes to `SPEC_takeArchDesign`.
	- follow-up architecture revision routes to `SPEC_updateArchDesign` when prior architecture exists and the story is closing a known architecture gap, review finding, or story-level architecture feedback.
	- Initial detail design routes to `SPEC_takeDetailDesign`.
	- follow-up detail revision routes to `SPEC_updateDetailDesign` when prior detail design exists and the story is closing a known detail-design gap, review finding, or story-level detail feedback.
- Distinguish design-oriented work from implementation-oriented work:
	- Design-oriented work routes to the appropriate architecture/detail take-or-update command before review.
	- Implementation-oriented work routes to `SPEC_reviewUserStory` when existing design may be enough but readiness still needs a gate.
	- Implementation-oriented work routes to `SPEC_designUnitTests` only when story, architecture, and detail readiness are already sufficient.
- If developer and CodeAgent intent are not aligned, route to `SPEC_clearStoryIntent` before design or implementation-oriented work.

## Prompt Template

Ask the assistant to examine the opened story, create or update the paired `*-TASKs.md` artifact in `.catdd/spec/doingUS/`, express the work as Markdown checkbox tasks, print the checklist after planning is made, compare the realistic next lifecycle options, distinguish initial design from follow-up design revision, distinguish design-oriented work from implementation-oriented work, and choose the next `SPEC_*` command that best fits the story's current readiness without inventing missing design or skipping needed checks.

## Conflict Guard

Do not jump directly into implementation from planning. If the next safe step is unclear, stop with questions for the developer instead of guessing.

ONE-MORE-THING: ask developer if something not sure
