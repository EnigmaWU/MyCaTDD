# UT_designConfigurationSkeleton

## Purpose

Design a CaTDD Configuration skeleton from stable behavior and runtime, build-time, deployment, feature-flag, or environment configuration variations.

Use this command after P0 functional coverage exists and behavior depends on configuration state or supported configuration combinations.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: P0/P1 skeletons that define stable behavior.
- `configuration_matrix`: optional runtime, build, deployment, environment, or feature-flag matrix.

## Method References

- [../../flows/P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Configuration.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Configuration.md)

## Output Contract

- A Configuration quality skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries for default, explicit, unsupported, conflicting, or environment-specific configuration behavior.
- Traceability to functional or design scenarios that vary by configuration.

## Prompt Template

Ask the assistant to:

1. Read existing skeletons and supplied configuration matrix.
2. Use the Configuration method prompt as the category source of truth.
3. Draft only the Configuration skeleton and preserve unrelated categories.
4. Identify missing defaults, invalid combinations, environment assumptions, or configuration precedence gaps.
5. Recommend whether to continue to another P2 category or `UT_reviewQualityTestsSkeleton`.

## Conflict Guard

This command designs Configuration coverage only. It should not redefine Configuration category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
