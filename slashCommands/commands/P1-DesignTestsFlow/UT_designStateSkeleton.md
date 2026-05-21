# UT_designStateSkeleton

## Purpose

Design a CaTDD State skeleton from project-root `README_StateDesign.md` and stable functional behavior.

Use this command after P0 functional skeletons exist and the component has meaningful lifecycle, transition, ownership, or persistence behavior.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: Typical, Edge, Misuse, Fault, or related Design skeletons.
- `state_design_doc`: required project-root `README_StateDesign.md` with the state model, transition rules, ownership rules, and lifecycle decisions.

## Preconditions

- Project-root `README_StateDesign.md` must exist before drafting the State skeleton.
- WARNING: If project-root `README_StateDesign.md` is missing, stop before drafting the State skeleton and warn the developer.
- If `README_StateDesign.md` is stale or incomplete, warn the developer and recommend updating it with `SPEC_takeDetailDesign` or `SPEC_updateDetailDesign` before continuing.

## Method References

- [../../flows/P1-DesignTestsFlow.md](../../flows/P1-DesignTestsFlow.md)
- [../../templates/README_StateDesignTemplate.md](../../templates/README_StateDesignTemplate.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-State.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-State.md)

## Output Contract

- A State design skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries that focus on state transitions, lifecycle boundaries, ownership, persistence, or recovery.
- Explicit links back to the functional scenarios that make the state behavior observable.

## Prompt Template

Ask the assistant to:

1. Check whether project-root `README_StateDesign.md` exists before drafting any skeleton content.
2. If `README_StateDesign.md` is missing, output a WARNING and stop before drafting the State skeleton.
3. Read `README_StateDesign.md` as the state design source, then read the functional skeletons for observable behavior links.
4. Use the State method prompt as the category source of truth.
5. Draft only the State skeleton and preserve unrelated categories.
6. Identify missing states, invalid transitions, ambiguous ownership, or lifecycle gaps.
7. Recommend whether to continue to `UT_designCapabilitySkeleton`, `UT_designConcurrencySkeleton`, or `UT_reviewDesignTestsSkeleton`.

## Conflict Guard

This command designs State coverage only. It should not redefine State category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
