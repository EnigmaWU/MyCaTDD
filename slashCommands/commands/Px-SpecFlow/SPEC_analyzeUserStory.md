# SPEC_analyzeUserStory

## Purpose

Analyze an aborted user story, preserve its abort evidence, and generate a later todo user-story artifact when the same intent needs a corrected next round.

## CoT Pattern

**ReACT** -- Reasoning + Acting. This command must inspect the aborted story, abort reason, task checklist, and related design/test/product evidence, reason about what remains valid, draft a corrected independently testable user story, and verify traceability before accepting the output. When replacement intent is unclear, the reasoning loop surfaces questions instead of inventing requirements.

## Inputs

- `aborted_user_story`: aborted story under `.catdd/spec/abortUS/`.
- `aborted_tasks_file`: optional `.catdd/spec/abortUS/*-TASKs.md` task artifact paired with the aborted story.
- `projectContext_file`: current project context.
- `related_docs`: optional README SPEC docs, review findings, test output, implementation notes, or reproduction evidence.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/todoUS/*-UserStory.md` team-shared persistent user story artifact for the corrected next round.
- Source trace from the new todo story back to the aborted story and its paired tasks when present.
- A corrected, independently testable user-story slice with preserved valid intent, rejected invalid assumptions, acceptance scenarios, risks, non-goals, and open questions.
- The aborted story remains preserved in `.catdd/spec/abortUS/` as historical evidence.

## Prompt Template

Ask the assistant to re-analyze the aborted story as evidence, keep valid intent, explicitly reject invalid assumptions, write a corrected todo story for the next round, and avoid silently continuing the aborted story in place.

## Conflict Guard

Do not mutate the aborted story into active work. Create a new todo story when the corrected intent is clear enough.
Do not invent replacement requirements. If the abort reason changes product intent or acceptance criteria, ask the developer before writing the corrected todo story.
If the problem is better represented as a new defect or improvement input, recommend `SPEC_importIssue` instead of forcing user-story re-analysis.

ONE-MORE-THING: ask developer if something not sure