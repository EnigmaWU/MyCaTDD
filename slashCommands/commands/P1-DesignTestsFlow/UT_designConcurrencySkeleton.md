# UT_designConcurrencySkeleton

## Purpose

Design a CaTDD Concurrency skeleton from stable functional behavior and shared execution, ordering, locking, or reentrancy risks.

Use this command after P0 functional skeletons exist and the component can be called concurrently, scheduled asynchronously, interrupted, canceled, or accessed from multiple owners.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: Typical, Edge, Misuse, Fault, State, Capability, or related skeletons.
- `concurrency_model`: optional thread, task, interrupt, async, queue, or locking notes.

## Method References

- [../../flows/P1-DesignTestsFlow.md](../../flows/P1-DesignTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Concurrency.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Concurrency.md)

## Output Contract

- A Concurrency design skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries for ordering, interleaving, reentrancy, cancellation, shared ownership, or synchronization behavior.
- Traceability to functional and design scenarios that make concurrency risk observable.

## Prompt Template

Ask the assistant to:

1. Read the functional skeletons and any supplied concurrency model.
2. Use the Concurrency method prompt as the category source of truth.
3. Draft only the Concurrency skeleton and preserve unrelated categories.
4. Identify missing ordering rules, race risks, lock ownership gaps, or async lifecycle conflicts.
5. Recommend whether to continue to `UT_designStateSkeleton`, `UT_designCapabilitySkeleton`, or `UT_reviewDesignTestsSkeleton`.

## Conflict Guard

This command designs Concurrency coverage only. It should not redefine Concurrency category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
