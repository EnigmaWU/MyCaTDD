# UT_designConcurrencySkeleton

## Purpose

Design a CaTDD Concurrency skeleton from project-root `README_ResourceDesign.md` and stable functional behavior.

Use this command after P0 functional skeletons exist and the component can be called concurrently, scheduled asynchronously, interrupted, canceled, or accessed from multiple owners.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: Typical, Edge, Misuse, Fault, State, Capability, or related skeletons.
- `resource_design_doc`: required project-root `README_ResourceDesign.md` with shared ownership, contention, backpressure, lifetime, and resource coordination decisions.

## Preconditions

- Project-root `README_ResourceDesign.md` must be confirmed before drafting the Concurrency skeleton.
- WARNING: If project-root `README_ResourceDesign.md` is missing, ask the developer where the concurrency/resource design lives or stop before drafting the Concurrency skeleton.
- If `README_ResourceDesign.md` is stale or incomplete, warn the developer and recommend updating it with `SPEC_takeDetailDesign` or `SPEC_updateDetailDesign` before continuing.

## Method References

- [../../flows/P1-DesignTestsFlow.md](../../flows/P1-DesignTestsFlow.md)
- [../../templates/README_ResourceDesignTemplate.md](../../templates/README_ResourceDesignTemplate.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Concurrency.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Concurrency.md)

## Output Contract

- A Concurrency design skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries for ordering, interleaving, reentrancy, cancellation, shared ownership, or synchronization behavior.
- Traceability to functional and design scenarios that make concurrency risk observable.

## Prompt Template

Ask the assistant to:

1. Check whether project-root `README_ResourceDesign.md` exists before drafting any skeleton content.
2. If `README_ResourceDesign.md` is missing, output a WARNING and ask the developer where the concurrency/resource design lives or stop before drafting the Concurrency skeleton.
3. Read `README_ResourceDesign.md` as the resource and contention design source, then read the functional skeletons for observable behavior links.
4. Use the Concurrency method prompt as the category source of truth.
5. Draft only the Concurrency skeleton and preserve unrelated categories.
6. Identify missing ordering rules, race risks, lock ownership gaps, or async lifecycle conflicts.
7. Recommend whether to continue to `UT_designStateSkeleton`, `UT_designCapabilitySkeleton`, or `UT_reviewDesignTestsSkeleton`.

## Conflict Guard

This command designs Concurrency coverage only. It should not redefine Concurrency category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
