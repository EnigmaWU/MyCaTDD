# UT_designPerformanceSkeleton

## Purpose

Design a CaTDD Performance skeleton from project-root `README_PerfDesign.md` and stable behavior.

Use this command after P0 functional coverage exists and performance behavior is part of product risk or acceptance.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: P0/P1 skeletons that define stable behavior.
- `performance_design_doc`: required project-root `README_PerfDesign.md` with latency, throughput, jitter, memory, CPU, power, timing, or resource goals.

## Preconditions

- Project-root `README_PerfDesign.md` must exist before drafting the Performance skeleton.
- WARNING: If project-root `README_PerfDesign.md` is missing, stop before drafting the Performance skeleton and warn the developer.
- If `README_PerfDesign.md` is stale or incomplete, warn the developer and recommend updating it with `SPEC_takeDetailDesign` or `SPEC_updateDetailDesign` before continuing.

## Method References

- [../../flows/P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [../../templates/README_PerfDesignTemplate.md](../../templates/README_PerfDesignTemplate.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Performance.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Performance.md)

## Output Contract

- A Performance quality skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries that make performance expectations measurable and bounded.
- Traceability to functional or design scenarios that must remain correct under performance constraints.

## Prompt Template

Ask the assistant to:

1. Check whether project-root `README_PerfDesign.md` exists before drafting any skeleton content.
2. If `README_PerfDesign.md` is missing, output a WARNING and stop before drafting the Performance skeleton.
3. Read `README_PerfDesign.md` as the performance design source, then read existing skeletons for behavior links.
4. Use the Performance method prompt as the category source of truth.
5. Draft only the Performance skeleton and preserve unrelated categories.
6. Identify missing metrics, measurement boundaries, load assumptions, or pass/fail thresholds.
7. Recommend whether to continue to another P2 category or `UT_reviewQualityTestsSkeleton`.

## Conflict Guard

This command designs Performance coverage only. It should not redefine Performance category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
