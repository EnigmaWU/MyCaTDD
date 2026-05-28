# UT_designCompatibilitySkeleton

## Purpose

Design a CaTDD Compatibility skeleton from project-root `README_CompatDesign.md` and stable behavior.

Use this command after P0 functional coverage exists and the component must behave consistently across supported environments or interoperate across versions.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: P0/P1 skeletons that define stable behavior.
- `compat_design_doc`: required project-root `README_CompatDesign.md` with supported platform, version, protocol, format, toolchain, or integration boundaries.

## Preconditions

- Project-root `README_CompatDesign.md` must exist before drafting the Compatibility skeleton.
- WARNING: If project-root `README_CompatDesign.md` is missing, stop before drafting the Compatibility skeleton and warn the developer.
- If `README_CompatDesign.md` is stale or incomplete, warn the developer and recommend updating it with `SPEC_takeDetailDesign` or `SPEC_updateDetailDesign` before continuing.

## Method References

- [../../flows/P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [../../templates/README_CompatDesignTemplate.md](../../templates/README_CompatDesignTemplate.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Compatibility.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Compatibility.md)

## Output Contract

- A Compatibility quality skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries for supported versions, platforms, protocols, formats, or integration boundaries.
- Traceability to functional or design scenarios that must remain compatible.

## Prompt Template

Ask the assistant to:

1. Check whether project-root `README_CompatDesign.md` exists before drafting any skeleton content.
2. If `README_CompatDesign.md` is missing, output a WARNING and stop before drafting the Compatibility skeleton.
3. Read `README_CompatDesign.md` as the compatibility design source, then read existing skeletons for behavior links.
4. Use the Compatibility method prompt as the category source of truth.
5. Draft only the Compatibility skeleton and preserve unrelated categories.
6. Identify missing version boundaries, platform assumptions, protocol drift, or unsupported combinations.
7. Recommend whether to continue to another P2 category or `UT_reviewQualityTestsSkeleton`.

## Conflict Guard

This command designs Compatibility coverage only. It should not redefine Compatibility category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
