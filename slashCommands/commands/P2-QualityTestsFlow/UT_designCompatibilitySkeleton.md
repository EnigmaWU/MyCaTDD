# UT_designCompatibilitySkeleton

## Purpose

Design a CaTDD Compatibility skeleton from stable behavior and version, platform, protocol, format, or integration compatibility requirements.

Use this command after P0 functional coverage exists and the component must behave consistently across supported environments or interoperate across versions.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: P0/P1 skeletons that define stable behavior.
- `compatibility_matrix`: optional platform, version, protocol, format, toolchain, or integration matrix.

## Method References

- [../../flows/P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Compatibility.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Compatibility.md)

## Output Contract

- A Compatibility quality skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries for supported versions, platforms, protocols, formats, or integration boundaries.
- Traceability to functional or design scenarios that must remain compatible.

## Prompt Template

Ask the assistant to:

1. Read existing skeletons and supplied compatibility matrix.
2. Use the Compatibility method prompt as the category source of truth.
3. Draft only the Compatibility skeleton and preserve unrelated categories.
4. Identify missing version boundaries, platform assumptions, protocol drift, or unsupported combinations.
5. Recommend whether to continue to another P2 category or `UT_reviewQualityTestsSkeleton`.

## Conflict Guard

This command designs Compatibility coverage only. It should not redefine Compatibility category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
