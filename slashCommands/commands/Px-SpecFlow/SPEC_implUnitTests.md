# SPEC_implUnitTests

## Purpose

Implement selected CaTDD test cases for the active user story.

## CoT Pattern

**Linear** — Direct execution. Given the selected TC entries and the test framework, this command implements the test case code deterministically without branching. If tests cannot run or fail unexpectedly, the observation surfaces the issue rather than continuing to product code.

## Inputs

- `selected_tc`: one or more selected TC entries.
- `target_test_files`: test files to update.
- `test_framework`: project test framework.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [P0-FuncTestsFlow](../../flows/P0-FuncTestsFlow.md)
- [CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- Implemented test case code in committed test files, tied to selected TC comments.
- Test status update showing red/green state when known.
- Next recommended command: `SPEC_implProductCodes` or another `SPEC_implUnitTests` pass.

## Prompt Template

Ask the assistant to implement the selected test cases only and keep unrelated test skeletons untouched.

## Conflict Guard

Respect test-first order. If tests cannot run or fail unexpectedly, report that before implementing product code.

ONE-MORE-THING: ask developer if something not sure
