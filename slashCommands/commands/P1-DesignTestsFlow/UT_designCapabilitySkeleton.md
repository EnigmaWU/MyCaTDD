# UT_designCapabilitySkeleton

## Purpose

Design a CaTDD Capability skeleton from stable functional behavior and explicit feature capability boundaries.

Use this command after P0 functional skeletons exist and the component exposes modes, feature flags, limits, supported operations, or intentionally unsupported behavior.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: Typical, Edge, Misuse, Fault, State, or related skeletons.
- `capability_matrix`: optional list of supported, unsupported, limited, or conditional capabilities.

## Method References

- [../../flows/P1-DesignTestsFlow.md](../../flows/P1-DesignTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Capability.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Capability.md)

## Output Contract

- A Capability design skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries that distinguish supported, limited, conditional, and unsupported capabilities.
- Traceability to functional scenarios that prove capability boundaries are visible and intentional.

## Prompt Template

Ask the assistant to:

1. Read the functional skeletons and any supplied capability matrix.
2. Use the Capability method prompt as the category source of truth.
3. Draft only the Capability skeleton and preserve unrelated categories.
4. Identify missing capability boundaries, hidden feature coupling, or unclear unsupported behavior.
5. Recommend whether to continue to `UT_designStateSkeleton`, `UT_designConcurrencySkeleton`, or `UT_reviewDesignTestsSkeleton`.

## Conflict Guard

This command designs Capability coverage only. It should not redefine Capability category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
