# UT_designRobustSkeleton

## Purpose

Design a CaTDD Robust skeleton from project-root `README_ErrorDesign.md` and stable behavior.

Use this command after P0 functional coverage exists and the component must continue safely through stress, partial failure, degraded inputs, or environmental instability.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: P0/P1 skeletons that define stable behavior.
- `error_design_doc`: required project-root `README_ErrorDesign.md` with error taxonomy, fault handling, recovery, degradation, retry, timeout, or stable failure semantics.

## Preconditions

- Project-root `README_ErrorDesign.md` must exist before drafting the Robust skeleton.
- WARNING: If project-root `README_ErrorDesign.md` is missing, stop before drafting the Robust skeleton and warn the developer.
- If `README_ErrorDesign.md` is stale or incomplete, warn the developer and recommend updating it with `SPEC_takeDetailDesign` or `SPEC_updateDetailDesign` before continuing.

## Method References

- [../../flows/P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [../../templates/README_ErrorDesignTemplate.md](../../templates/README_ErrorDesignTemplate.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Robust.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Robust.md)

## Output Contract

- A Robust quality skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries for resilience, recovery, degradation, bounded retry, timeout, or stable failure behavior.
- Traceability to functional or design scenarios that must survive robustness pressure.

## Prompt Template

Ask the assistant to:

1. Check whether project-root `README_ErrorDesign.md` exists before drafting any skeleton content.
2. If `README_ErrorDesign.md` is missing, output a WARNING and stop before drafting the Robust skeleton.
3. Read `README_ErrorDesign.md` as the error and recovery design source, then read existing skeletons for behavior links.
4. Use the Robust method prompt as the category source of truth.
5. Draft only the Robust skeleton and preserve unrelated categories.
6. Identify missing recovery rules, unbounded retry loops, degradation gaps, or unclear failure semantics.
7. Recommend whether to continue to another P2 category or `UT_reviewQualityTestsSkeleton`.

## Conflict Guard

This command designs Robust coverage only. It should not redefine Robust category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
