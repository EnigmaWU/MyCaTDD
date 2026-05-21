# UT_designRobustSkeleton

## Purpose

Design a CaTDD Robust skeleton from stable behavior and resilience, recovery, degradation, or fault-tolerance risks.

Use this command after P0 functional coverage exists and the component must continue safely through stress, partial failure, degraded inputs, or environmental instability.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: P0/P1 skeletons that define stable behavior.
- `robustness_risks`: optional stress, degradation, recovery, retry, timeout, or field-failure notes.

## Method References

- [../../flows/P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Robust.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Robust.md)

## Output Contract

- A Robust quality skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries for resilience, recovery, degradation, bounded retry, timeout, or stable failure behavior.
- Traceability to functional or design scenarios that must survive robustness pressure.

## Prompt Template

Ask the assistant to:

1. Read existing skeletons and supplied robustness risks.
2. Use the Robust method prompt as the category source of truth.
3. Draft only the Robust skeleton and preserve unrelated categories.
4. Identify missing recovery rules, unbounded retry loops, degradation gaps, or unclear failure semantics.
5. Recommend whether to continue to another P2 category or `UT_reviewQualityTestsSkeleton`.

## Conflict Guard

This command designs Robust coverage only. It should not redefine Robust category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
