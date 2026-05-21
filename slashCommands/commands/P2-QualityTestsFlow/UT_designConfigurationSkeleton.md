# UT_designConfigurationSkeleton

## Purpose

Design a CaTDD Configuration skeleton from project-root `README_DetailDesign.md` and stable behavior.

Use this command after P0 functional coverage exists and behavior depends on configuration state or supported configuration combinations.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: P0/P1 skeletons that define stable behavior.
- `detail_design_doc`: required project-root `README_DetailDesign.md` with runtime, build, deployment, environment, feature-flag, default, and precedence decisions.

## Preconditions

- Project-root `README_DetailDesign.md` must exist before drafting the Configuration skeleton.
- WARNING: If project-root `README_DetailDesign.md` is missing, stop before drafting the Configuration skeleton and warn the developer.
- If `README_DetailDesign.md` is stale or incomplete, warn the developer and recommend updating it with `SPEC_takeDetailDesign` or `SPEC_updateDetailDesign` before continuing.

## Method References

- [../../flows/P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [../../templates/README_DetailDesignTemplate.md](../../templates/README_DetailDesignTemplate.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Configuration.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Configuration.md)

## Output Contract

- A Configuration quality skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries for default, explicit, unsupported, conflicting, or environment-specific configuration behavior.
- Traceability to functional or design scenarios that vary by configuration.

## Prompt Template

Ask the assistant to:

1. Check whether project-root `README_DetailDesign.md` exists before drafting any skeleton content.
2. If `README_DetailDesign.md` is missing, output a WARNING and stop before drafting the Configuration skeleton.
3. Read `README_DetailDesign.md` as the configuration design source, then read existing skeletons for behavior links.
4. Use the Configuration method prompt as the category source of truth.
5. Draft only the Configuration skeleton and preserve unrelated categories.
6. Identify missing defaults, invalid combinations, environment assumptions, or configuration precedence gaps.
7. Recommend whether to continue to another P2 category or `UT_reviewQualityTestsSkeleton`.

## Conflict Guard

This command designs Configuration coverage only. It should not redefine Configuration category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
