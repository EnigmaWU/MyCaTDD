# UT_designPerformanceSkeleton

## Purpose

Design a CaTDD Performance skeleton from stable behavior and explicit latency, throughput, memory, timing, or resource goals.

Use this command after P0 functional coverage exists and performance behavior is part of product risk or acceptance.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: P0/P1 skeletons that define stable behavior.
- `performance_targets`: optional latency, throughput, jitter, memory, CPU, power, or resource goals.

## Method References

- [../../flows/P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Performance.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Performance.md)

## Output Contract

- A Performance quality skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries that make performance expectations measurable and bounded.
- Traceability to functional or design scenarios that must remain correct under performance constraints.

## Prompt Template

Ask the assistant to:

1. Read existing skeletons and supplied performance targets.
2. Use the Performance method prompt as the category source of truth.
3. Draft only the Performance skeleton and preserve unrelated categories.
4. Identify missing metrics, measurement boundaries, load assumptions, or pass/fail thresholds.
5. Recommend whether to continue to another P2 category or `UT_reviewQualityTestsSkeleton`.

## Conflict Guard

This command designs Performance coverage only. It should not redefine Performance category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
