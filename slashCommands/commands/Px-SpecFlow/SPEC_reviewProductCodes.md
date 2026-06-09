# SPEC_reviewProductCodes

## Purpose

Review product code, tests, and traceability before commit or abort routing.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the changed product and test files, reason about behavior, traceability to README SPEC docs, minimality, and quality risk, produce a review finding, and verify that the finding clearly routes to the next action (commit, return to design/test work, abort, or ask the developer). The reasoning loop stops when all review criteria are explicitly addressed or a quality failure is reported.

## Inputs

- `changed_files`: product and test files changed for the active story.
- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `readme_spec_files`: optional project-root `README*` SPEC files relevant to the changed code.
- `verification_output`: test, lint, build, or manual verification output.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- Review result for committed-scope product/test changes: pass, update design, add tests, abort story, or ask developer.
- Findings prioritized by correctness, traceability to project-root README SPEC docs, and quality risk.
- Next recommended command: `SPEC_commitWorks`, `SPEC_updateDetailDesign`, `SPEC_designUnitTests`, `SPEC_abortUserStory`, or `SPEC_importIssue`.

## Prompt Template

Ask the assistant to review behavior, tests, traceability, minimality, and project-context consistency.

## Conflict Guard

Do not commit when quality is not met or when verification evidence is missing without explanation.

ONE-MORE-THING: ask developer if something not sure
