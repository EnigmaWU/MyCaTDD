# UT_reviewDesignTestsSkeleton

## Purpose

Review the P1 design skeleton set before quality coverage or implementation continues.

Use this command when State, Capability, or Concurrency skeletons exist and the developer wants to know whether design coverage is coherent enough to proceed.

## Inputs

- `test_file_or_files`: skeleton files to review.
- `feature_name`: feature under review.
- `scope`: expected design scope.
- `design_sources`: confirmed P1 design sources used by the skeletons under review.
- `functional_skeletons`: related P0 Typical, Edge, Misuse, or Fault skeletons.

## Preconditions

- P1 MUST have DESIGN: every State, Capability, or Concurrency skeleton under review must trace to a confirmed design source.
- WARNING: If a P1 skeleton has no confirmed design source, ask the developer where the design lives or stop before approving the P1 review.

## Method References

- [../../flows/P1-DesignTestsFlow.md](../../flows/P1-DesignTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-State.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-State.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Capability.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Capability.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Concurrency.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Concurrency.md)

## Output Contract

- Coverage summary for State, Capability, and Concurrency.
- Conflicts, duplicated scenarios, missing AC/TC links, and unclear assumptions.
- A recommended next action: design more P1 skeleton, move to P2 QualityTestsFlow, select the next TC, or block for clarification.

## Prompt Template

Ask the assistant to:

1. Check that each skeleton has a clear Class/Category and US/AC/TC trace.
2. Verify that each P1 skeleton links to a confirmed design source before approving it.
3. Verify that State, Capability, and Concurrency scenarios are in the right category.
4. Identify missing lifecycle, capability-boundary, or concurrency coverage.
5. Avoid changing implementation code during review.
6. Recommend whether to proceed to `UT_tellMeNextImplTest` or P2 QualityTestsFlow.

## Conflict Guard

This command reviews design skeletons only. It should not redefine category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
