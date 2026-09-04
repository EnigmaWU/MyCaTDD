# UT_designStateSkeleton

## Purpose

Design a CaTDD State skeleton from a confirmed state design source and stable functional behavior.

Use this command after P0 functional skeletons exist and the component has meaningful lifecycle, transition, ownership, or persistence behavior.

## CoT Pattern

**ReACT** — Reasoning + Acting. P1 categories may not be invented from imagination — they must trace to a confirmed design source. The loop opens with a two-tier design-source gate, and closes by checking that each state transition is observable through functional behavior.

### ReACT Execution

Repeat until every state AC traces to both a design source and an observable behavior.

1. **Thought** — Design-source gate first, in order: check project-root `README_StateDesign.md`; if absent, check whether `README_ArchDesign.md` contains a `State Design` chapter. If neither source exists, output a WARNING and ask the developer where the state design lives or stop before drafting the State skeleton. Then read the confirmed source and the functional skeletons for observable behavior links.
2. **Action** — Draft only the State skeleton with the full `@[...]` metadata set, covering transitions, lifecycle boundaries, ownership, persistence, and recovery. Preserve unrelated categories.
3. **Observation** — Check each AC names a transition the design source defines, and links to a functional scenario that makes it observable. A transition the source never defines is invented → back to **Thought**. Look for missing states, invalid transitions, ambiguous ownership, and lifecycle gaps.
4. **Stop** — Exit when every AC is doubly traced. Recommend `UT_designCapabilitySkeleton`, `UT_designConcurrencySkeleton`, or `UT_reviewDesignTestsSkeleton`.

### Worked Example

Adding state coverage for the gateway adapter:

```text
/UT_designStateSkeleton
feature_name: payment gateway connection lifecycle
target_test_file: services/payment/SysTests/UT_Gateway.ts
```

Expected result:

- **Thought**: `README_StateDesign.md` is absent → fall through to tier two → `README_ArchDesign.md` does contain a `State Design` chapter → gate passes on the second source. It defines `idle → connecting → ready → degraded → idle`.
- **Action**: US-07 drafted with AC-18 (`connecting → ready` on successful handshake), AC-19 (`ready → degraded` on repeated timeout), AC-20 (`degraded → ready` on successful health probe).
- **Observation**: a fourth AC asserted a direct `degraded → connecting` transition — the source defines no such edge → invented → back to **Thought** → dropped and raised as a design gap.
- **Observation**: each remaining transition is observable through an existing Typical or Fault scenario → doubly traced.
- **Stop**: three traced ACs, one design gap reported. Recommended `UT_reviewDesignTestsSkeleton`.

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

## Conflict Guard

This command designs State coverage only. It should not redefine State category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
