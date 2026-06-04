# SPEC_takePlan

## Purpose

Create or update the planning artifact paired with the active user story and decide which `SPEC_*` command should run next.

## CoT Pattern

**ToT** — Tree of Thoughts. This command must inspect the opened story, current project context, optional mutual-intent notes, and any existing design evidence, branch across the plausible next lifecycle paths, compare them against the story's current readiness, and choose the smallest correct next step without skipping required quality gates.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `plan_file`: paired `.catdd/spec/doingUS/*-PLANING.md` file to create or update for the opened story.
- `projectContext_file`: current project context.
- `mutual_intent_contract`: optional intent-clearing notes produced by `SPEC_clearStoryIntent`.
- `readme_spec_files`: optional project-root `README*` SPEC docs that already influence the next step.
- `related_docs`: optional issue, feature, review, architecture, detail-design, or test notes relevant to next-step planning.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A team-shared `.catdd/spec/doingUS/*-PLANING.md` planning artifact coupled with the opened user story.
- The planning artifact records the active story, current readiness, skipped or satisfied prerequisites, candidate next steps, selected next step, and rationale.
- The selected next command should be one of `SPEC_clearStoryIntent`, `SPEC_takeArchDesign`, `SPEC_takeDetailDesign`, `SPEC_reviewUserStory`, or `SPEC_designUnitTests`, depending on what the opened story actually needs next.
- Explicit notes about whether architecture design, detail design, review, or direct unit-test design can be skipped because existing artifacts are already sufficient.
- Open questions or blockers that must be resolved before the selected next command can run safely.

## Prompt Template

Ask the assistant to examine the opened story, create or update the paired `*-PLANING.md` artifact in `.catdd/spec/doingUS/`, compare the realistic next lifecycle options, and choose the next `SPEC_*` command that best fits the story's current readiness without inventing missing design or skipping needed checks.

## Conflict Guard

Do not jump directly into implementation from planning. If the next safe step is unclear, stop with questions for the developer instead of guessing.

ONE-MORE-THING: ask developer if something not sure
