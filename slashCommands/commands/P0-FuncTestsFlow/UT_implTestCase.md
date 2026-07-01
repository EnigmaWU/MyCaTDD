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
- For REFACTOR stage, an ordered no-behavior-change cleanup report covering design comments, test code, production code, and final GREEN regression proof.
- Verification command or manual check result when available.

## Prompt Template

Ask the assistant to:

1. Locate the selected TC and its linked US/AC.
2. Implement the test in RED stage first when behavior is missing.
3. Implement minimal production code for GREEN only after RED is meaningful.
4. Refactor only after the selected TC is GREEN and only inside the requested scope.
5. In REFACTOR stage, apply this order:
	- First, refine and clear design comments: follow the CaTDD template, preserve US/AC/TC markers, and make key points glance-readable.
	- Second, refactor test code for readability without changing the TC purpose, AC meaning, coverage intent, or expected behavior.
	- If a key missing behavior, edge case, acceptance point, or test purpose is discovered, stop expanding the current TC and ask the developer to add or select a new test case.
	- Third, refactor production code for readability and local structure only, with no behavior, API, contract, or observable state change.
	- Last, rerun the focused TC and relevant regression scope; the final state must remain GREEN before marking REFACTOR complete.
6. Update TC status without deleting design comments.

## Conflict Guard

Do not batch unrelated TCs. CaTDD implementation should move one selected TC at a time unless the developer asks for a batch.
REFACTOR must not smuggle new behavior into an existing TC; missing points require a new TC or explicit developer approval.
