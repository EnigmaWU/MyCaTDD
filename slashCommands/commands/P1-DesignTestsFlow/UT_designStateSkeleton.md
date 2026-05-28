# UT_designStateSkeleton

## Purpose

Design a CaTDD State skeleton from a confirmed state design source and stable functional behavior.

Use this command after P0 functional skeletons exist and the component has meaningful lifecycle, transition, ownership, or persistence behavior.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: Typical, Edge, Misuse, Fault, or related Design skeletons.
- `state_design_doc`: required state design source, either project-root `README_StateDesign.md` or a `State Design` chapter in project-root `README_ArchDesign.md`, with the state model, transition rules, ownership rules, and lifecycle decisions.

## Preconditions

- Project-root `README_StateDesign.md` or a `State Design` chapter in project-root `README_ArchDesign.md` must be confirmed before drafting the State skeleton.
- WARNING: If neither state design source exists, ask the developer where the state design lives or stop before drafting the State skeleton.
- If the confirmed state design source is stale or incomplete, warn the developer and recommend updating it with `SPEC_takeDetailDesign` or `SPEC_updateDetailDesign` before continuing.

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
2. If `README_StateDesign.md` is missing, check whether project-root `README_ArchDesign.md` contains a `State Design` chapter.
3. If neither source exists, output a WARNING and ask the developer where the state design lives or stop before drafting the State skeleton.
4. Read the confirmed state design source, then read the functional skeletons for observable behavior links.
5. Use the State method prompt as the category source of truth.
6. Draft only the State skeleton and preserve unrelated categories.
7. Identify missing states, invalid transitions, ambiguous ownership, or lifecycle gaps.
8. Recommend whether to continue to `UT_designCapabilitySkeleton`, `UT_designConcurrencySkeleton`, or `UT_reviewDesignTestsSkeleton`.

## Conflict Guard

This command designs State coverage only. It should not redefine State category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
