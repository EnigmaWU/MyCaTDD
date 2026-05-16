# UT_reviewFuncTestsSkeleton

## Purpose

Review the P0 functional skeleton set before test-case implementation begins.

Use this command when Typical, Edge, Misuse, or Fault skeletons exist and the developer wants to know whether they are coherent enough to implement.

## Inputs

- `test_file_or_files`: skeleton files to review.
- `feature_name`: feature under review.
- `scope`: expected functional scope.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- Coverage summary for Typical, Edge, Misuse, and Fault.
- Conflicts, duplicated scenarios, missing AC/TC links, and unclear assumptions.
- A recommended next action: design more skeleton, select next TC, or block for clarification.

## Prompt Template

Ask the assistant to:

1. Check that each skeleton has a clear Class/Category and US/AC/TC trace.
2. Verify that scenarios are in the right category.
3. Identify missing core functional coverage.
4. Avoid changing implementation code during review.
5. Recommend whether to proceed to `UT_tellMeNextImplTest`.

## Conflict Guard

This command reviews functional skeleton design. It should not redefine category rules or implement tests.
