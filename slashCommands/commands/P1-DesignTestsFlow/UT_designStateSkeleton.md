# UT_designStateSkeleton

## Purpose

Design a CaTDD State skeleton from stable functional behavior, lifecycle rules, or existing state documentation.

Use this command after P0 functional skeletons exist and the component has meaningful lifecycle, transition, ownership, or persistence behavior.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: Typical, Edge, Misuse, Fault, or related Design skeletons.
- `state_model`: optional state diagram, state table, or lifecycle notes.

## Method References

- [../../flows/P1-DesignTestsFlow.md](../../flows/P1-DesignTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-State.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-State.md)

## Output Contract

- A State design skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries that focus on state transitions, lifecycle boundaries, ownership, persistence, or recovery.
- Explicit links back to the functional scenarios that make the state behavior observable.

## Prompt Template

Ask the assistant to:

1. Read the functional skeletons and any supplied state model.
2. Use the State method prompt as the category source of truth.
3. Draft only the State skeleton and preserve unrelated categories.
4. Identify missing states, invalid transitions, ambiguous ownership, or lifecycle gaps.
5. Recommend whether to continue to `UT_designCapabilitySkeleton`, `UT_designConcurrencySkeleton`, or `UT_reviewDesignTestsSkeleton`.

## Conflict Guard

This command designs State coverage only. It should not redefine State category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
