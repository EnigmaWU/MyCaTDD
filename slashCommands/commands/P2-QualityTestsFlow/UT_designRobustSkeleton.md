# UT_designRobustSkeleton

## Purpose

Design a CaTDD Robust skeleton from project-root `README_ErrorDesign.md` and stable behavior.

Use this command after P0 functional coverage exists and the component must continue safely through stress, partial failure, degraded inputs, or environmental instability.

## CoT Pattern

**ReACT** — Reasoning + Acting. Robust is easily confused with P0 Fault. The loop's gate is duration and pressure: Fault specifies the response to *one* failure, Robust specifies survival under *sustained or compounding* pressure. Every AC is checked against that boundary.

### ReACT Execution

Repeat until every AC is genuinely about sustained pressure and sourced.

1. **Thought** — Design-source gate first: check project-root `README_ErrorDesign.md` exists. If it is missing, output a **WARNING** and stop before drafting anything. Then read it as the error and recovery design source and read existing skeletons for behavior links.
2. **Action** — Draft only the Robust skeleton with the full `@[...]` metadata set, covering resilience, recovery, degradation, bounded retry, timeout, and stable failure. Preserve unrelated categories.
3. **Observation** — Check the Fault boundary: an AC describing the response to a single discrete failure belongs to P0 Fault → back to **Thought**. Check that every retry rule is **bounded** — an unbounded retry is a defect to report, not a behavior to specify. Look for missing recovery rules, degradation gaps, and unclear failure semantics.
4. **Stop** — Exit when every AC is sustained-pressure and sourced. Recommend another P2 category or `UT_reviewQualityTestsSkeleton`.

### Worked Example

Adding robustness coverage:

```text
/UT_designRobustSkeleton
feature_name: payment gateway resilience
target_test_file: services/payment/SysTests/UT_Gateway.ts
```

Expected result:

- **Thought**: `README_ErrorDesign.md` exists → gate passes. It defines a circuit breaker after 5 consecutive failures and a bounded retry of 3.
- **Action**: US-09 drafted with AC-22 (breaker opens after 5 consecutive failures), AC-23 (service degrades to queueing rather than erroring while the breaker is open), AC-24 (breaker half-opens and recovers).
- **Observation**: a fourth AC read "a single gateway timeout returns `GatewayTimeout`" — that is one discrete failure, already covered by P0 Fault AC-09 → wrong category → back to **Thought** → removed, not duplicated.
- **Observation**: all retry behavior is bounded at 3 → no unbounded loop to report.
- **Stop**: three sustained-pressure ACs, sourced. Recommended `UT_reviewQualityTestsSkeleton`.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: P0/P1 skeletons that define stable behavior.
- `error_design_doc`: required project-root `README_ErrorDesign.md` with error taxonomy, fault handling, recovery, degradation, retry, timeout, or stable failure semantics.

## Preconditions

- Project-root `README_ErrorDesign.md` must exist before drafting the Robust skeleton.
- WARNING: If project-root `README_ErrorDesign.md` is missing, stop before drafting the Robust skeleton and warn the developer.
- If `README_ErrorDesign.md` is stale or incomplete, warn the developer and recommend updating it with `SPEC_takeDetailDesign` or `SPEC_updateDetailDesign` before continuing.

## Method References

- [../../flows/P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [../../templates/README_ErrorDesignTemplate.md](../../templates/README_ErrorDesignTemplate.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Robust.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Robust.md)

## Output Contract

- A Robust quality skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries for resilience, recovery, degradation, bounded retry, timeout, or stable failure behavior.
- Traceability to functional or design scenarios that must survive robustness pressure.

## Conflict Guard

This command designs Robust coverage only. It should not redefine Robust category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
