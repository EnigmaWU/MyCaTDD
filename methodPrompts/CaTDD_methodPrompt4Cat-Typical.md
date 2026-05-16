# CaTDD method prompt for Category: Typical

Use this prompt when designing P0 Functional tests for core happy-path behavior.

## Position

Typical is the first CaTDD category in P0 Functional testing.

```text
P0 Functional = ValidFunc(Typical + Edge) + InvalidFunc(Misuse + Fault)
```

Typical proves that the feature works correctly under normal, intended use.

## Use When

- The scenario is the most common user or API workflow.
- Inputs, state, environment, and dependencies are valid.
- The goal is to prove the main behavior before exploring limits or failures.
- A new public API needs its first executable specification.

## Do Not Use When

- The scenario is mainly about min/max values, empty values, or mode limits; use Edge.
- The caller violates the API contract; use Misuse.
- A dependency, resource, process, network, disk, or environment fails; use Fault.
- The main risk is lifecycle, capacity, or thread safety; consider State, Capability, or Concurrency.

## Design Focus

- Identify the shortest complete workflow that delivers user value.
- Verify observable behavior rather than implementation details.
- Keep setup ordinary and valid.
- Prefer one behavior per test with no more than three key assertions.

## Design Skeleton

```text
// @[Class]: P0 Functional / ValidFunc
// @[Category]: Typical
// @[Intent]: Prove the core happy-path workflow under ordinary valid use.
// @[UseWhen]: Inputs, state, dependencies, environment, and caller behavior are valid.
// @[AvoidWhen]: The scenario is mainly Edge, Misuse, Fault, State, Capability, or Concurrency.
// @[US]: [US IDs]
// @[AC]: [AC IDs]
// @[TC]: verify[CoreBehavior]_by[ValidCondition]_expect[SuccessResult]
```

## US/AC/TC Pattern

```text
US-n: As a [normal user/API consumer],
      I want [core capability],
      So that [primary value is delivered].

AC-n: GIVEN [valid initial state and ordinary inputs],
      WHEN [the normal action is executed],
      THEN [the expected success result is observable].

TC-n:
  @[Name]: verify[CoreBehavior]_by[ValidCondition]_expect[SuccessResult]
  @[Purpose]: Prove the main workflow works before testing variants.
  @[Brief]: Execute the standard path with valid setup and verify the core result.
  @[Expect]: Success code/state/output plus the primary observable side effect.
```

## Naming Examples

```text
verifyServiceRegister_byValidName_expectSuccess
verifyEventPost_bySubscribedConsumer_expectCallbackInvoked
verifyCommandExec_byValidPing_expectPongResponse
verifyFileSave_byWritablePath_expectPersistedContent
```

## Checklist

- Does the test represent a real normal workflow?
- Are all preconditions valid and ordinary?
- Is the expected result specific enough to fail when the feature is wrong?
- Does the test avoid mixing in edge, misuse, fault, or performance concerns?
- Can this test be read as the first example of how to use the feature?

## Common Mistakes

- Calling a scenario Typical only because it is easy to test.
- Adding too many assertions and turning one happy path into a broad integration test.
- Hiding undefined behavior behind vague expectations such as "works" or "ok".
- Designing Edge/Misuse/Fault behavior before the main success path is clear.
