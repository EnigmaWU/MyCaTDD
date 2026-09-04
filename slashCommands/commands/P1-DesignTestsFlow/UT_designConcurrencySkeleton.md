# UT_designConcurrencySkeleton

## Purpose

Design a CaTDD Concurrency skeleton from project-root `README_ResourceDesign.md` and stable functional behavior.

Use this command after P0 functional skeletons exist and the component can be called concurrently, scheduled asynchronously, interrupted, canceled, or accessed from multiple owners.

## CoT Pattern

**ReACT** — Reasoning + Acting. P1 categories may not be invented from imagination — they must trace to a confirmed design source. The loop opens with a hard design-source gate, and closes by checking that each concurrency risk is actually observable rather than theoretical.

### ReACT Execution

Repeat until every concurrency AC traces to both a design source and an observable behavior.

1. **Thought** — Design-source gate first: check project-root `README_ResourceDesign.md` exists. If it is missing, output a **WARNING**, ask the developer where the concurrency/resource design lives, and stop before drafting anything. Then read it as the resource and contention design source and read the functional skeletons for observable behavior links.
2. **Action** — Draft only the Concurrency skeleton with the full `@[...]` metadata set, covering ordering, interleaving, reentrancy, cancellation, shared ownership, and synchronization. Preserve unrelated categories.
3. **Observation** — Check each AC traces to a stated resource/ownership rule and is observable through a functional scenario. An AC describing a race the design source never permits is invented → back to **Thought**. Look for missing ordering rules, race risks, lock ownership gaps, and async lifecycle conflicts.
4. **Stop** — Exit when every AC is doubly traced. Recommend `UT_designStateSkeleton`, `UT_designCapabilitySkeleton`, or `UT_reviewDesignTestsSkeleton`.

### Worked Example

Adding concurrency coverage for the gateway adapter:

```text
/UT_designConcurrencySkeleton
feature_name: payment gateway routing
target_test_file: services/payment/SysTests/UT_Gateway.ts
```

Expected result:

- **Thought**: `README_ResourceDesign.md` exists → gate passes. It states the connection pool is shared and that an in-flight authorize may be canceled.
- **Action**: US-06 drafted with AC-15 (concurrent authorizes do not share a connection), AC-16 (canceling an in-flight authorize releases its connection), AC-17 (reentrant capture is rejected).
- **Observation**: a fourth AC asserted ordering guarantees between two independent authorizes — the design source explicitly makes ordering unspecified → asserting it would invent a contract → back to **Thought** → dropped and raised as a design question.
- **Observation**: AC-16's release is observable via the pool counter used in the Fault scenarios → doubly traced.
- **Stop**: three traced ACs, one design question. Recommended `UT_reviewDesignTestsSkeleton`.

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

## Conflict Guard

This command designs Concurrency coverage only. It should not redefine Concurrency category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
