# CaTDD method prompt for Category: Misuse

Use this prompt when designing P0 Functional tests for wrong caller behavior, invalid API usage, and contract violations.

## Position

Misuse belongs to P0 Functional InvalidFunc testing.

```text
P0 Functional = ValidFunc(Typical + Edge) + InvalidFunc(Misuse + Fault)
```

Misuse proves that the system rejects wrong use safely and clearly.

## Use When

- The caller uses the API in the wrong order.
- Required inputs are missing, malformed, or contract-breaking.
- A handle, object, token, pointer, identifier, or state is invalid because of caller behavior.
- The system should return a clear error without crashing, leaking resources, or corrupting state.

## Do Not Use When

- The input is unusual but still valid; use Edge.
- A dependency or environment fails despite correct caller behavior; use Fault.
- The problem is a lifecycle state transition that is central to the design; consider State.
- The problem is resource exhaustion outside the caller's direct misuse; consider Fault or Robust.

## Design Focus

- Identify the API contract being violated.
- Verify the exact error result and that no partial side effect occurred.
- Prefer deterministic misuse over vague "bad input" cases.
- Preserve system state so the next valid call can still succeed when appropriate.

## TestPointsInMind

First apply the source inventory and applicable sweep in [CaTDD_methodPrompt-testPointDiscovery.md](CaTDD_methodPrompt-testPointDiscovery.md). Record candidates in `discovery_ledger`; apply the Discovery Gate before implementation. Domain examples are optional prompts, not requirements or coverage quotas; use source-defined limits and oracles.

When this category applies, consider test points such as:

- Missing, malformed, conflicting, or contract-breaking caller input that the API explicitly rejects.
- Every named caller constraint: both invalid sides of a valid range, cross-field contradictions, mutually exclusive options, and invalid combinations of individually valid inputs when the source defines them.
- Error precedence for simultaneous violations only when specified; otherwise record the unresolved policy instead of inventing an order.
- Wrong call sequence caused by the caller, such as use before init, double close, commit before validate, or operation after dispose.
- Invalid caller-owned references: stale handle, unknown ID, wrong object type, expired local session, or duplicate registration.
- Rejection behavior that proves no partial mutation, resource leak, queued work, persisted record, or hidden side effect occurred.
- Recovery after misuse when the contract promises the component can still accept a subsequent valid call.
- Domain-specific questions:
  - *Embedded Linux*: Which invalid operation codes, offsets, handles, or buffer arguments must the API reject? Do not invent safe rejection for undefined behavior outside its contract.
  - *Microservices*: Which missing fields, malformed payloads, or conflicting caller options violate a stated request contract? Keep protection-policy proofs in Security.
  - *LLM Agents*: At a tool executor's caller boundary, which unknown tools or invalid argument types must be rejected? If the SUT instead consumes a malformed upstream model response, reconsider Fault rather than labeling it caller misuse.

## Design Skeleton

```text
// @[Class]: P0 Functional / InvalidFunc
// @[Category]: Misuse
// @[Intent]: Prove invalid caller behavior is rejected safely and clearly.
// @[UseWhen]: The caller violates a named API precondition or call sequence.
// @[AvoidWhen]: The caller is valid and the failure comes from environment, resource, dependency, or runtime fault.
// @[US]: [US IDs]
// @[AC]: [AC IDs]
// @[TC]: verify[Operation]_by[MisuseCondition]_expect[ErrorResult]
```

## US/AC/TC Pattern

```text
US-n: As an API provider,
      I want invalid caller behavior to be rejected clearly,
      So that misuse does not corrupt state or hide bugs.

AC-n: GIVEN [a caller violates a named API precondition],
      WHEN [the operation is called],
      THEN [a documented error is returned],
       AND [no invalid side effect occurs].

TC-n:
  @[Name]: verify[Operation]_by[MisuseCondition]_expect[ErrorResult]
  @[Purpose]: Prove the API defends its contract.
  @[Brief]: Execute the invalid call sequence or invalid parameter use.
  @[Expect]: Clear error, no crash, no state/resource corruption.
```

## Naming Examples

```text
verifyClose_byDoubleClose_expectInvalidHandle
verifyPost_byBeforeInit_expectNotInitialized
verifyRegister_byDuplicateName_expectAlreadyExists
verifyExec_byInvalidHandle_expectInvalidParam
```

## Checklist

- Has each source precondition and relevant invalid partition been reconciled to a TC or explicit gap/question?
- Which API contract is being violated?
- Is the misuse caused by the caller rather than the environment?
- Is the expected error result explicit?
- Does the test verify no partial mutation or leak when that matters?
- Is recovery possible after misuse, and should the test verify it?

## Common Mistakes

- Classifying null/empty inputs automatically as Misuse without checking whether they are valid Edge cases.
- Testing a dependency failure as Misuse even though the caller behaved correctly.
- Only checking for "not success" instead of the documented error.
- Ignoring state after the rejected call.
