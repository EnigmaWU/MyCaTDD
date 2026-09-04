# UT_designFaultSkeleton

## Purpose

Design a CaTDD Fault functional skeleton from failure conditions, dependency errors, and recoverable or reportable fault behavior.

Use this command after valid behavior and caller misuse are understood and the feature must specify how failures are surfaced, contained, retried, or recovered.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must draft coverage for failures the caller did not cause, and check two boundaries on every case: it must not be caller Misuse, and it must not drift into P2 Robust quality behavior.

### ReACT Execution

Repeat until every case is an externally caused, functionally specified fault.

1. **Thought** — Read `interface_or_protocol_file` and the existing functional skeletons for normal and invalid caller behavior. Using the Fault method prompt as the category source of truth, identify missing fault sources, recovery expectations, error reporting, retry limits, and containment rules.
2. **Action** — Draft only the Fault skeleton with the full `@[...]` metadata set. Preserve unrelated categories untouched.
3. **Observation** — Check both boundaries: a failure the caller caused belongs to Misuse → back to **Thought**; a case that is really about sustained degradation, stress, or resource exhaustion is P2 Robust, not P0 Fault → back to **Thought** and defer it. Check the US/AC/TC cardinality.
4. **Stop** — Exit when every case is externally caused and functionally specified. Recommend `UT_reviewFuncTestsSkeleton`.

### Worked Example

Specifying failure behavior for the authorize call:

```text
/UT_designFaultSkeleton
interface_or_protocol_file: services/payment/gatewayPort.h
feature_name: payment authorization
existing_skeletons: Typical (US-01), Edge (US-02), Misuse (US-03)
```

Expected result:

- **Thought**: external fault sources — gateway timeout, gateway 503, malformed response body. Each needs a stated reporting and containment expectation.
- **Action**: US-04 drafted with AC-09 (timeout surfaces `GatewayTimeout`, no silent retry), AC-10 (503 surfaces `GatewayUnavailable`), AC-11 (malformed JSON is contained, not propagated), each with one TC.
- **Observation**: a fourth case "gateway stays down for 10 minutes and the service keeps degrading gracefully" was drafted — that is sustained degradation, which is P2 Robust, not P0 Fault → back to **Thought** → deferred to `UT_designRobustSkeleton`.
- **Observation**: remaining three are single external failures with functional expectations; none is caller-caused; cardinality passes.
- **Stop**: Fault holds external failures only. Recommended `UT_reviewFuncTestsSkeleton`.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: Typical, Edge, Misuse, or related functional skeletons for consistency.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Fault.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Fault.md)

## Output Contract

- A Fault functional skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries that capture dependency failures, unavailable resources, timeouts, corrupted responses, or other reportable faults.
- Explicit separation between Fault behavior and caller Misuse behavior.

## Conflict Guard

This command designs Fault coverage only. It should not redefine Robust quality behavior or implement tests.

ONE-MORE-THING: ask developer if something not sure