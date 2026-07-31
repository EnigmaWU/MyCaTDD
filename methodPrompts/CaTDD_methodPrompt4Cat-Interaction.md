# CaTDD method prompt for Category: Interaction

Use this prompt when designing P1 Design-oriented tests for internal collaboration, orchestration, sequence rules, and component handoff contracts.

## Position

Interaction is the third P1 Design category by default, after State and Capability and before Concurrency.

```text
P1 Design = State -> Capability -> Interaction -> Concurrency
```

Interaction proves that collaborators communicate in the intended order with the intended responsibility split. Sequence diagrams are a common source artifact, but the category is Interaction because the concern is the design relationship, not the diagram notation.

## Use When

- A sequence diagram, collaboration diagram, or interaction contract defines call order.
- An orchestrator, mediator, adapter, plugin host, pipeline, or workflow delegates to multiple components.
- Correctness depends on component A calling B before C, translating before dispatch, or committing after validation.
- The design defines callback, event, hook, plugin, or handoff contracts between collaborators.

## Do Not Use When

- The concern is only lifecycle state transition; use State.
- The concern is only a component limit or responsibility boundary; use Capability.
- The concern is simultaneous access, race freedom, or synchronization; use Concurrency.
- The concern is external API request/response behavior; use P0 Functional.

## Design Focus

- Name the collaborators and their responsibilities.
- Define the expected sequence or handoff contract.
- Verify observable collaboration without overfitting to private implementation details.
- Prefer stable interaction seams, fakes, spies, or contract fixtures over brittle mocks.

## Design Skeleton

```text
// @[Class]: P1 Design
// @[Category]: Interaction
// @[Intent]: Prove collaborator sequence and handoff design.
// @[UseWhen]: Correct behavior depends on internal component collaboration order or delegation.
// @[AvoidWhen]: The scenario is mainly state, capacity, concurrency, or external contract behavior.
// @[Collaborators]: [orchestrator, adapters, services, plugins, callbacks]
// @[SequenceRule]: [required order or handoff contract]
// @[TC]: verify[Flow]_by[InteractionScenario]_expect[CollaboratorsCoordinate]
```

## US/AC/TC Pattern

```text
US-n: As a maintainer of the component design,
      I want [collaborators] to coordinate through [sequence or handoff rule],
      So that [design responsibility remains clear and stable].

AC-n: GIVEN [collaborators and required interaction contract],
      WHEN [the orchestrated behavior runs],
      THEN [the expected collaboration sequence occurs],
       AND [each collaborator owns only its intended responsibility].

TC-n:
  @[Name]: verify[Flow]_by[InteractionScenario]_expect[CollaboratorsCoordinate]
  @[Purpose]: Validate internal collaboration or sequence design.
  @[Brief]: Arrange collaborators, execute the flow, verify handoff order and responsibility split.
  @[Expect]: Required collaborators are invoked in the intended order with the intended contract.
```

## Naming Examples

```text
verifyPipeline_byValidRequest_expectValidateThenTransformThenPersist
verifyPluginHost_byLoadRequest_expectLoadInitializeExecuteDispose
verifyAdapterFlow_byExternalPayload_expectTranslateBeforeDispatch
verifyOrchestrator_byPolicyFailure_expectAbortBeforeCommit
```

## Checklist

- Which collaborators participate in the design interaction?
- What sequence, handoff, or delegation rule is being protected?
- Which source artifact defines the rule: sequence diagram, DetailDesign, ArchDesign, or interface contract?
- Can the test observe the interaction without depending on irrelevant private details?
- Should this be a P0 contract test instead because the behavior is externally visible?

## Common Mistakes

- Naming the category Sequence and tying it to one diagram notation.
- Verifying every private call instead of the design-significant handoff.
- Mixing collaboration correctness with concurrency correctness.
- Treating an external API workflow as P1 when no internal design rule is being protected.
