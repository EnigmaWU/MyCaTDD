# UT_designCapabilitySkeleton

## Purpose

Design a CaTDD Capability skeleton from project-root `README_DetailDesign.md` and stable functional behavior.

Use this command after P0 functional skeletons exist and the component exposes modes, feature flags, limits, supported operations, or intentionally unsupported behavior.

## CoT Pattern

**ReACT** — Reasoning + Acting. P1 categories may not be invented from imagination — they must trace to a confirmed design source. The loop therefore opens with a hard design-source gate, and closes by checking that every capability boundary is observable through a functional scenario.

### ReACT Execution

Repeat until every capability boundary traces to both a design source and an observable behavior.

1. **Thought** — Design-source gate first: check project-root `README_DetailDesign.md` exists. If it is missing, output a **WARNING**, ask the developer where the capability design lives, and stop before drafting anything. Then read it as the capability design source and read the functional skeletons for observable behavior links.
2. **Action** — Draft only the Capability skeleton with the full `@[...]` metadata set, distinguishing supported, limited, conditional, and unsupported capabilities. Preserve unrelated categories.
3. **Observation** — Check each AC traces to a statement in the design source and to a functional scenario that makes the boundary visible. An AC with no design-source backing is invented → back to **Thought**. Look for missing capability boundaries, hidden feature coupling, and unclear unsupported behavior.
4. **Stop** — Exit when every AC is doubly traced. Recommend `UT_designStateSkeleton`, `UT_designConcurrencySkeleton`, or `UT_reviewDesignTestsSkeleton`.

### Worked Example

Adding capability coverage after P0 is stable:

```text
/UT_designCapabilitySkeleton
feature_name: payment gateway routing
target_test_file: services/payment/SysTests/UT_Gateway.ts
```

Expected result:

- **Thought**: `README_DetailDesign.md` exists → gate passes. It declares two supported gateways, one behind a feature flag, and states that simultaneous dual-gateway routing is unsupported.
- **Action**: US-05 drafted with AC-12 (supported gateway routes), AC-13 (flagged gateway only routes when enabled), AC-14 (dual-gateway request is refused, not silently single-routed).
- **Observation**: a fourth AC claimed a third gateway is "planned" — not in the design source → invented → back to **Thought** → dropped.
- **Observation**: AC-14's refusal is observable through the existing Misuse scenario → doubly traced.
- **Stop**: three traced ACs. Recommended `UT_reviewDesignTestsSkeleton`.

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

## Conflict Guard

This command designs Capability coverage only. It should not redefine Capability category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
