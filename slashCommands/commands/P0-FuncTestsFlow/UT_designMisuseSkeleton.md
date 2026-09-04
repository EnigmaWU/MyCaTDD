# UT_designMisuseSkeleton

## Purpose

Design a CaTDD Misuse functional skeleton from invalid caller behavior, unsupported inputs, and contract violations.

Use this command after valid functional behavior is understood and the feature must specify how incorrect use is rejected or reported.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must draft coverage for invalid **caller** behavior and check the attribution of every case — the recurring mistake is filing a dependency or environment failure as Misuse, which hides a real Fault requirement.

### ReACT Execution

Repeat until every case is attributable to the caller.

1. **Thought** — Read `interface_or_protocol_file` and the existing valid functional skeletons to know exactly where supported behavior ends. Using the Misuse method prompt as the category source of truth, identify invalid inputs, unsupported state-independent requests, missing required data, and contract violations.
2. **Action** — Draft only the Misuse skeleton with the full `@[...]` metadata set. Preserve unrelated categories untouched.
3. **Observation** — Check attribution: ask who caused the failure. Caused by the caller → Misuse. Caused by a dependency, resource, or environment → Fault → back to **Thought** and hand it over; never convert an environmental failure into a Misuse case. Check the US/AC/TC cardinality.
4. **Stop** — Exit when every case is caller-attributable and the cardinality check passes. Recommend `UT_designFaultSkeleton` or `UT_reviewFuncTestsSkeleton`.

### Worked Example

Specifying rejection behavior for the authorize call:

```text
/UT_designMisuseSkeleton
interface_or_protocol_file: services/payment/gatewayPort.h
feature_name: payment authorization
existing_skeletons: Typical (US-01), Edge (US-02)
```

Expected result:

- **Thought**: supported range is `[1, 999999]`, so `amount = 0` and a negative amount are caller violations. Calling `capture` before `authorize` is an unsupported request order. A missing card token is missing required data.
- **Action**: US-03 drafted with AC-06 (zero/negative amount rejected), AC-07 (capture-before-authorize rejected), AC-08 (missing token rejected), each with one TC.
- **Observation**: a fourth case "gateway returns HTTP 503" was drafted — the *gateway* caused that, not the caller → wrong attribution → back to **Thought** → handed to `UT_designFaultSkeleton`.
- **Observation**: remaining three are all caller-caused; cardinality passes.
- **Stop**: Misuse holds caller violations only. Recommended `UT_designFaultSkeleton`.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: Typical, Edge, or related functional skeletons for consistency.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Misuse.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Misuse.md)

## Output Contract

- A Misuse functional skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries that capture invalid inputs, unsupported operation order, missing preconditions, or caller contract violations.
- Explicit separation between caller misuse and environmental or dependency Fault behavior.

## Conflict Guard

This command designs Misuse coverage only. It should not convert dependency failures or environmental failures into Misuse cases.

ONE-MORE-THING: ask developer if something not sure