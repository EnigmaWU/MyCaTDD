# UT_reviewImplTestCase

## Purpose

Review one implemented CaTDD test case against its US/AC/TC skeleton.

Use this command after `UT_implTestCase` or when the developer suspects a test implementation drifted away from the design comments.

## Inputs

- `selected_tc`: TC identifier and name.
- `test_file`: file containing the implemented TC.
- `test_result`: optional test output or failure summary.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- Alignment check between implementation and US/AC/TC.
- Missing assertions, excessive assertions, setup/cleanup gaps, and status issues.
- Recommendation: keep, fix implementation, revise skeleton, or select next TC.

## Prompt Template

Ask the assistant to:

1. Compare implementation steps against the TC design comments.
2. Check that assertions verify the promised expectation.
3. Check that setup, behavior, verify, and cleanup are clear.
4. Report drift instead of silently rewriting design intent.
5. Recommend the next command.

## Conflict Guard

If the implementation and skeleton disagree, do not choose automatically which one is truth. Report the conflict and ask whether method design or implementation should change.
