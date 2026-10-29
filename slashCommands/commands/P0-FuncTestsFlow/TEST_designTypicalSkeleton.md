# TEST_designTypicalSkeleton

## Purpose

Design a CaTDD Typical functional skeleton from an interface, protocol, existing draft, or behavior contract.

Use this command when a developer has a defined behavior source and wants to specify the primary valid behavior before implementation.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must read the behavior source, draft the Typical skeleton, and check that what it captured is genuinely the primary valid path rather than a boundary or failure case that belongs to another category.

### ReACT Execution

Repeat until the Typical skeleton holds only primary valid behavior.

1. **Thought** — Read `interface_or_protocol_file` as the behavior source and the Typical method prompt as the category source of truth. Identify the main valid behavior, its normal preconditions, and expected outcomes.
2. **Action** — Draft only the Typical skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, `@[TP]`, `@[TC]`. Preserve unrelated categories untouched.
3. **Observation** — Check category fit: anything relying on a boundary value, an invalid caller input, or a dependency failure does not belong here → back to **Thought** and hand it to Edge, Misuse, or Fault. Check the [US/AC/TP/TC cardinality](../../../methodPrompts/CaTDD_methodPrompt-testStructure.md#usactptc-contract) for the declared scope; unassigned TPs block completion.
4. **Stop** — Exit when the skeleton holds only the success path and passes the cardinality check. Recommend `TEST_designEdgeSkeleton` or `TEST_reviewFuncTestsSkeleton`.

## Usage Example

Specifying the primary valid path for an authorize call. IDs below are abbreviated; generated artifacts use registered Story IDs and qualified AC/TP/TC IDs.

```text
/TEST_designTypicalSkeleton
interface_or_protocol_file: services/payment/gatewayPort.h
feature_name: payment authorization
target_test_file: services/payment/SysTests/UT_Gateway.ts
```

Expected result:

- **Thought**: primary valid behavior is "a valid card and amount produce an approved authorization". Normal precondition: gateway reachable.
- **Action**: US-01 drafted with AC-01 (approved authorization returned) and AC-02 (authorization id echoed back). TP-01 checks approval and TP-02 checks the echoed id; TC-01 covers both with distinct assertions and explicit AC/TP links.
- **Observation**: a third AC was drafted for "amount at the maximum allowed value" — that is a valid *boundary*, not the primary path → category mismatch → back to **Thought** → handed to `TEST_designEdgeSkeleton`, not kept here.
- **Observation**: US-01 has 2 ACs, each with 1 TP; both TPs map only to TC-01, which covers both obligations → cardinality passes.
- **Stop**: Typical skeleton holds the success path only. Recommended `TEST_designEdgeSkeleton`.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: optional related skeletons for consistency.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Typical.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Typical.md)

## Output Contract

- A Typical functional skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, `@[TP]`, and `@[TC]`.
- US/AC/TP/TC entries that capture the primary valid behavior and expected success path.
- Explicit separation from Edge, Misuse, Fault, and later-category coverage.

## Conflict Guard

This command designs Typical coverage only. It should not design Edge, Misuse, Fault, or implementation test code.

ONE-MORE-THING: ask developer if something not sure