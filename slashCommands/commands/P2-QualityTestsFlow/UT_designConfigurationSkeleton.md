# UT_designConfigurationSkeleton

## Purpose

Design a CaTDD Configuration skeleton from project-root `README_DetailDesign.md` and stable behavior.

Use this command after P0 functional coverage exists and behavior depends on configuration state or supported configuration combinations.

## CoT Pattern

**ReACT** — Reasoning + Acting. The gate here is precedence: configuration bugs come from unstated defaults and unresolved conflicts between sources. Every AC must state which configuration wins and why, or it is not testable.

### ReACT Execution

Repeat until every AC states a defined outcome for its configuration combination.

1. **Thought** — Design-source gate first: check project-root `README_DetailDesign.md` exists. If it is missing, output a **WARNING** and stop before drafting anything. Then read it as the configuration design source and read existing skeletons for behavior links.
2. **Action** — Draft only the Configuration skeleton with the full `@[...]` metadata set, covering default, explicit, unsupported, conflicting, and environment-specific behavior. Preserve unrelated categories.
3. **Observation** — Check each AC names the resolved outcome: which default applies, which source wins on conflict, and which combinations are refused. An AC that asserts a precedence the design source never defines returns to **Thought** — report the gap instead of choosing a winner.
4. **Stop** — Exit when every AC has a defined outcome. Recommend another P2 category or `UT_reviewQualityTestsSkeleton`.

### Worked Example

Adding configuration coverage:

```text
/UT_designConfigurationSkeleton
feature_name: gateway selection configuration
target_test_file: services/payment/SysTests/UT_Gateway.ts
```

Expected result:

- **Thought**: `README_DetailDesign.md` exists → gate passes. It defines a default gateway, an env-var override, and refuses an empty gateway list.
- **Action**: US-11 drafted with AC-28 (default applies when unset), AC-29 (env var overrides the file value), AC-30 (empty list is refused at startup).
- **Observation**: a fourth AC asserted that a CLI flag beats the env var — the design source never defines that precedence → back to **Thought** → the precedence gap is reported rather than decided here.
- **Observation**: AC-28..AC-30 each name a resolved outcome → gate passes.
- **Stop**: three ACs with defined outcomes, one precedence gap reported. Recommended `UT_reviewQualityTestsSkeleton`.

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

## Conflict Guard

This command designs Configuration coverage only. It should not redefine Configuration category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
