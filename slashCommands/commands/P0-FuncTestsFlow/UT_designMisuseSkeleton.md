# UT_designMisuseSkeleton

## Purpose

Design a CaTDD Misuse functional skeleton from invalid caller behavior, unsupported inputs, and contract violations.

Use this command after valid functional behavior is understood and the feature must specify how incorrect use is rejected or reported.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: Typical, Edge, or related functional skeletons for consistency.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Misuse.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Misuse.md)

## Output Contract

- A Misuse functional skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries that capture invalid inputs, unsupported operation order, missing preconditions, or caller contract violations.
- Explicit separation between caller misuse and environmental or dependency Fault behavior.

## Prompt Template

Ask the assistant to:

1. Read the interface or protocol as the behavior source.
2. Read existing valid functional skeletons for supported behavior boundaries.
3. Use the Misuse method prompt as the category source of truth.
4. Draft only the Misuse skeleton and preserve unrelated categories.
5. Identify invalid inputs, unsupported state-independent requests, missing required data, or contract violations.
6. Recommend whether to continue to `UT_designFaultSkeleton` or `UT_reviewFuncTestsSkeleton`.

## Conflict Guard

This command designs Misuse coverage only. It should not convert dependency failures or environmental failures into Misuse cases.

ONE-MORE-THING: ask developer if something not sure