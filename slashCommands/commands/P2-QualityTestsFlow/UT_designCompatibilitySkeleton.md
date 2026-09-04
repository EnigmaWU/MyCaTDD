# UT_designCompatibilitySkeleton

## Purpose

Design a CaTDD Compatibility skeleton from project-root `README_CompatDesign.md` and stable behavior.

Use this command after P0 functional coverage exists and the component must behave consistently across supported environments or interoperate across versions.

## CoT Pattern

**ReACT** — Reasoning + Acting. The gate here is the supported matrix: every compatibility AC must name a version, platform, protocol, or format that the design source actually declares supported. Testing an undeclared combination invents a support commitment the product never made.

### ReACT Execution

Repeat until every AC names a declared supported combination.

1. **Thought** — Design-source gate first: check project-root `README_CompatDesign.md` exists. If it is missing, output a **WARNING** and stop before drafting anything. Then read it as the compatibility design source and read existing skeletons for behavior links.
2. **Action** — Draft only the Compatibility skeleton with the full `@[...]` metadata set, covering supported versions, platforms, protocols, formats, and integration boundaries. Preserve unrelated categories.
3. **Observation** — Check each AC against the declared support matrix. A combination the source never declares returns to **Thought** — record it as a question, do not silently promise support. Look for missing version boundaries, platform assumptions, protocol drift, and unsupported combinations that should be explicitly refused.
4. **Stop** — Exit when every AC maps to the matrix. Recommend another P2 category or `UT_reviewQualityTestsSkeleton`.

### Worked Example

Adding compatibility coverage:

```text
/UT_designCompatibilitySkeleton
feature_name: payment gateway protocol compatibility
target_test_file: services/payment/SysTests/UT_Gateway.ts
```

Expected result:

- **Thought**: `README_CompatDesign.md` exists → gate passes. It declares gateway API v2 and v3 supported, v1 explicitly unsupported.
- **Action**: US-10 drafted with AC-25 (v2 authorize succeeds), AC-26 (v3 authorize succeeds), AC-27 (v1 is refused with a clear version error rather than a parse failure).
- **Observation**: a fourth AC covered gateway API v4 — not in the matrix → asserting it would promise unshipped support → back to **Thought** → recorded as a question for the developer.
- **Observation**: AC-27 correctly tests an explicit refusal, which the matrix does declare.
- **Stop**: three matrix-backed ACs, one question. Recommended `UT_reviewQualityTestsSkeleton`.

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

## Conflict Guard

This command designs Compatibility coverage only. It should not redefine Compatibility category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
