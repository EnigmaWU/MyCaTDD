# UT_implTestCase

## Purpose

Implement one selected CaTDD test case while preserving the comment-alive design skeleton.

Use this command after `UT_tellMeNextImplTest` has selected a TC or the developer has explicitly named one TC.

## Inputs

- `selected_tc`: TC identifier and name.
- `test_file`: file to update.
- `source_files`: production files related to the behavior.
- `stage`: optional `RED`, `GREEN`, or `REFACTOR` focus.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- Test implementation for exactly one selected TC.
- Preserved US/AC/TC comments and status markers.
- Minimal production changes only when needed for the requested TDD stage.
- Verification command or manual check result when available.

## Prompt Template

Ask the assistant to:

1. Locate the selected TC and its linked US/AC.
2. Implement the test in RED stage first when behavior is missing.
3. Implement minimal production code for GREEN only after RED is meaningful.
4. Refactor only after the test passes and only inside the requested scope.
5. Update TC status without deleting design comments.

## Conflict Guard

Do not batch unrelated TCs. CaTDD implementation should move one selected TC at a time unless the developer asks for a batch.
