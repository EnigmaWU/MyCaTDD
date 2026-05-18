# SPEC_designUnitTests

## Purpose

Design CaTDD unit test skeletons for the active user story after story and detail design review pass.

## Inputs

- `doing_user_story`: active story under `doingUS/`.
- `detail_design`: reviewed design and acceptance criteria.
- `target_test_files`: test files to create or update.
- `category_scope`: P0 first, then P1/P2 if design or quality requires it.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../flows/P1-DesignTestsFlow.md](../../flows/P1-DesignTestsFlow.md)
- [../../flows/P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- CaTDD US/AC/TC skeletons linked to the active story.
- Category labels, priority gates, and initial TC status markers.
- Next recommended command: `SPEC_implUnitTests` or a specific `UT_*` command.

## Prompt Template

Ask the assistant to enter P0/P1/P2 test design flows as needed, preserving story-to-test traceability.

## Conflict Guard

Do not skip P0 Functional coverage before promoting design or quality categories.

ONE-MORE-THING: ask developer if something not sure
