# UT_designFaultSkeleton

## Purpose

Design a CaTDD Fault functional skeleton from failure conditions, dependency errors, and recoverable or reportable fault behavior.

Use this command after valid behavior and caller misuse are understood and the feature must specify how failures are surfaced, contained, retried, or recovered.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: Typical, Edge, Misuse, or related functional skeletons for consistency.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Fault.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Fault.md)

## Output Contract

- A Fault functional skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries that capture dependency failures, unavailable resources, timeouts, corrupted responses, or other reportable faults.
- Explicit separation between Fault behavior and caller Misuse behavior.

## Prompt Template

Ask the assistant to:

1. Read the interface or protocol as the behavior source.
2. Read existing functional skeletons for normal and invalid caller behavior.
3. Use the Fault method prompt as the category source of truth.
4. Draft only the Fault skeleton and preserve unrelated categories.
5. Identify missing fault sources, recovery expectations, error reporting, retry limits, or containment rules.
6. Recommend whether to continue to `UT_reviewFuncTestsSkeleton`.

## Conflict Guard

This command designs Fault coverage only. It should not redefine Robust quality behavior or implement tests.

ONE-MORE-THING: ask developer if something not sure