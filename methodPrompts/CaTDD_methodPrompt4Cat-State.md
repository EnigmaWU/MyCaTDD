# CaTDD method prompt for Category: State

Use this prompt when designing P1 Design-oriented tests for lifecycle, state machines, and state transition logic.

## Position

State is the first P1 Design category.

```text
P1 Design = State -> Capability -> Concurrency
```

State proves that the implementation follows the intended lifecycle and transition rules.

## Use When

- The component has explicit states such as Init, Ready, Running, Stopped, Error, Closed.
- The same operation behaves differently depending on current state.
- Invalid transitions must be rejected predictably.
- A state machine or lifecycle is part of the design intent.

## Do Not Use When

- The test only covers one normal stateless operation; use Typical.
- The main concern is a valid limit value; use Edge.
- The caller violates a state precondition but state is not the central design topic; Misuse may be enough.
- The transition risk comes from thread interleaving; combine with or move to Concurrency.

## Design Focus

- Draw or list the intended states and allowed transitions before writing tests.
- Test both allowed transitions and rejected transitions.
- Verify observable state, not only return codes.
- Include cleanup paths such as close, reset, stop, and recovery from error.

## Design Skeleton

```text
// @[Class]: P1 Design
// @[Category]: State
// @[Intent]: Prove lifecycle and state-machine transitions match design intent.
// @[UseWhen]: Operations depend on current state or lifecycle phase.
// @[AvoidWhen]: The scenario is only stateless happy path, simple edge value, or caller misuse.
// @[StateModel]: [states and allowed transitions]
// @[US]/@[AC]: [traceability IDs]
// @[TC]: verify[Lifecycle]_by[TransitionSequence]_expect[TargetState]
```

## US/AC/TC Pattern

```text
US-n: As a component owner,
      I want [object/service] to follow its lifecycle rules,
      So that callers can reason about valid operations in each state.

AC-n: GIVEN [object/service in state S],
      WHEN [transition/action A occurs],
      THEN [state becomes T or transition is rejected],
       AND [observable side effects match the state model].

TC-n:
  @[Name]: verify[Lifecycle]_by[TransitionSequence]_expect[TargetState]
  @[Purpose]: Validate an allowed or rejected state transition.
  @[Brief]: Move through named states and verify each observable state result.
  @[Expect]: Correct state, return result, and side effects.
```

## Naming Examples

```text
verifyServiceLifecycle_byInitStartStop_expectStoppedState
verifyConnection_byReconnectAfterClose_expectConnectedState
verifySession_byExpiredToken_expectRejectedState
verifyStateTransition_byStopBeforeStart_expectInvalidState
```

## Checklist

- Are all states named and observable?
- Are allowed transitions covered before invalid transitions?
- Does the test verify final state and important intermediate states?
- Are reset/cleanup/error states included when relevant?
- Should a state-related P1 Misuse case be promoted here because lifecycle is the design core?

## Common Mistakes

- Testing state only through return codes when a state query or observable side effect exists.
- Combining too many transitions in one test without a clear purpose.
- Forgetting rejected transitions and recovery transitions.
- Treating every illegal sequence as State; use Misuse if lifecycle is not the design focus.
