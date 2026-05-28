# UT_designCapabilitySkeleton

## Purpose

Design a CaTDD Capability skeleton from project-root `README_DetailDesign.md` and stable functional behavior.

Use this command after P0 functional skeletons exist and the component exposes modes, feature flags, limits, supported operations, or intentionally unsupported behavior.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: Typical, Edge, Misuse, Fault, State, or related skeletons.
- `detail_design_doc`: required project-root `README_DetailDesign.md` with capability boundaries, supported modes, limits, and unsupported behavior.

## Preconditions

- Project-root `README_DetailDesign.md` must be confirmed before drafting the Capability skeleton.
- WARNING: If project-root `README_DetailDesign.md` is missing, ask the developer where the capability design lives or stop before drafting the Capability skeleton.
- If `README_DetailDesign.md` is stale or incomplete, warn the developer and recommend updating it with `SPEC_takeDetailDesign` or `SPEC_updateDetailDesign` before continuing.

## Method References

- [../../flows/P1-DesignTestsFlow.md](../../flows/P1-DesignTestsFlow.md)
- [../../templates/README_DetailDesignTemplate.md](../../templates/README_DetailDesignTemplate.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Capability.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Capability.md)

## Output Contract

- A Capability design skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries that distinguish supported, limited, conditional, and unsupported capabilities.
- Traceability to functional scenarios that prove capability boundaries are visible and intentional.

## Prompt Template

Ask the assistant to:

1. Check whether project-root `README_DetailDesign.md` exists before drafting any skeleton content.
2. If `README_DetailDesign.md` is missing, output a WARNING and ask the developer where the capability design lives or stop before drafting the Capability skeleton.
3. Read `README_DetailDesign.md` as the capability design source, then read the functional skeletons for observable behavior links.
4. Use the Capability method prompt as the category source of truth.
5. Draft only the Capability skeleton and preserve unrelated categories.
6. Identify missing capability boundaries, hidden feature coupling, or unclear unsupported behavior.
7. Recommend whether to continue to `UT_designStateSkeleton`, `UT_designConcurrencySkeleton`, or `UT_reviewDesignTestsSkeleton`.

## Conflict Guard

This command designs Capability coverage only. It should not redefine Capability category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
