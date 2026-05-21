# UT_reviewQualityTestsSkeleton

## Purpose

Review the P2 quality skeleton set before implementation, release-risk review, or TC-by-TC execution continues.

Use this command when Performance, Robust, Compatibility, or Configuration skeletons exist and the developer wants to know whether quality coverage is coherent enough to proceed.

## Inputs

- `test_file_or_files`: skeleton files to review.
- `feature_name`: feature under review.
- `scope`: expected quality scope.
- `functional_skeletons`: related P0 skeletons.
- `design_skeletons`: optional related P1 skeletons.

## Method References

- [../../flows/P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Performance.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Performance.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Robust.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Robust.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Compatibility.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Compatibility.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Configuration.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Configuration.md)

## Output Contract

- Coverage summary for Performance, Robust, Compatibility, and Configuration.
- Conflicts, duplicated scenarios, missing AC/TC links, unmeasurable quality targets, and unclear assumptions.
- A recommended next action: design more P2 skeleton, select the next TC, proceed to implementation, or block for clarification.

## Prompt Template

Ask the assistant to:

1. Check that each skeleton has a clear Class/Category and US/AC/TC trace.
2. Verify that Performance, Robust, Compatibility, and Configuration scenarios are in the right category.
3. Identify missing measurable targets, robustness gaps, compatibility boundaries, or configuration combinations.
4. Avoid changing implementation code during review.
5. Recommend whether to proceed to `UT_tellMeNextImplTest`.

## Conflict Guard

This command reviews quality skeletons only. It should not redefine category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
