# P1 DesignTestsFlow

`P1 DesignTestsFlow` is the second slash-command flow priority. It starts after core functional behavior is stable enough to reason about design properties.

## Method Alignment

Slash flow `P1 DesignTestsFlow` uses the same priority as CaTDD method category `P1 Design`:

- State
- Capability
- Concurrency

The flow commands orchestrate execution; category meaning remains in `methodPrompts`.

## Entry Conditions

- P0 functional skeletons exist, especially Typical and Edge.
- The component has meaningful lifecycle, capacity, or concurrency behavior.
- The developer wants to design behavior beyond input/output correctness.

## Future Command Candidates

- `UT_designStateSkeleton`
- `UT_designCapabilitySkeleton`
- `UT_designConcurrencySkeleton`
- `UT_reviewDesignTestsSkeleton`

## Conflict Guard

DesignTestsFlow must reference `methodPrompts/CaTDD_methodPrompt4Cat-State.md`, `Capability.md`, and `Concurrency.md` instead of redefining those category meanings here.
