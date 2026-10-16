# P0 FuncTestsFlow

`P0 FuncTestsFlow` is the first slash-command flow to import because it covers the most common developer entry points for functional unit tests.

## Method Alignment

Slash flow `P0 FuncTestsFlow` uses the same priority as CaTDD method category `P0 Functional`:

```text
P0 Functional = ValidFunc + InvalidFunc
ValidFunc = Typical + Edge
InvalidFunc = Misuse + Fault
```

The flow commands connect existing CodeAgent invocation surfaces to execution steps; category meaning remains in `methodPrompts`.

When `SPEC_designUnitTests` identifies P0 Functional coverage for an active story, this flow provides the matching category-design contracts. `SPEC_designUnitTests` remains the story-level orchestration command, while `TEST_designFuncTestsSkeleton` owns the full Typical, Edge, Misuse, and Fault skeleton design contract and the category-specific `UT_design*Skeleton` commands own their individual skeleton contracts. These commands are design steps; executable test bodies still belong to later implementation flow.

## Developer Stories

- As a Developer, when I have demo tests, I want to convert them into CaTDD functional skeletons so that existing examples become living verification design.
- As a Developer, when I have a defined interface or protocol, I want to use CaTDD to design the Typical skeleton so that core behavior is specified before implementation.
- As a Developer, when I already have Typical, Edge, Misuse, Fault, or later category skeletons, I want to select and implement the next test case so that TDD proceeds one TC at a time.
- As a Developer, when an implemented TC is GREEN but hard to read or maintain, I want to refactor that single test case without changing behavior or losing US/AC/TC traceability.

## Flow Diagram

```mermaid
flowchart LR
    Demo["Existing demo tests"] --> Convert["TEST_convertDemoToTypical"]
    Protocol["Interface or protocol"] --> DesignTypical["TEST_designTypicalSkeleton"]
    Protocol --> DesignFunc["TEST_designFuncTestsSkeleton<br/>Typical+Edge+Misuse+Fault"]

    Convert --> Typical["Typical skeleton"]
    DesignTypical --> Typical
    Typical --> Edge["TEST_designEdgeSkeleton"]
    Edge --> Misuse["TEST_designMisuseSkeleton"]
    Misuse --> Fault["TEST_designFaultSkeleton"]
    Fault --> FuncSet["P0 functional skeleton set"]
    DesignFunc --> FuncSet
    FuncSet --> ReviewSkeleton["TEST_reviewFuncTestsSkeleton"]

    ReviewSkeleton --> NextTC["TEST_tellMeNextImplTest"]
    NextTC --> Impl["TEST_implTestCase"]
    Impl --> ReviewImpl["TEST_reviewImplTestCase"]
    ReviewImpl --> NextTC
    ReviewImpl -. "cleanup when GREEN" .-> Refact["TEST_refactTestCase"]
    Refact --> ReviewImpl
```

## Command Sequence

1. Use [TEST_convertDemoToTypical](../commands/P0-FuncTestsFlow/TEST_convertDemoToTypical.md) when the starting point is an existing demo test.
2. Use [TEST_designTypicalSkeleton](../commands/P0-FuncTestsFlow/TEST_designTypicalSkeleton.md) when the starting point is an interface or protocol and the primary valid behavior should be designed first.
3. Use [TEST_designEdgeSkeleton](../commands/P0-FuncTestsFlow/TEST_designEdgeSkeleton.md), [TEST_designMisuseSkeleton](../commands/P0-FuncTestsFlow/TEST_designMisuseSkeleton.md), and [TEST_designFaultSkeleton](../commands/P0-FuncTestsFlow/TEST_designFaultSkeleton.md) to complete the P0 functional skeleton set.
4. Use [TEST_designFuncTestsSkeleton](../commands/P0-FuncTestsFlow/TEST_designFuncTestsSkeleton.md) when the full Typical, Edge, Misuse, and Fault skeleton set should be designed as one behavior.
5. Use [TEST_reviewFuncTestsSkeleton](../commands/P0-FuncTestsFlow/TEST_reviewFuncTestsSkeleton.md) before implementation begins. Hand off behavior sources, declared scope, and the discovery ledger for an independent source-first review. Both cardinality and the [Discovery Gate](../../methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md) must pass; four populated categories alone are insufficient.
6. Use [TEST_tellMeNextImplTest](../commands/P0-FuncTestsFlow/TEST_tellMeNextImplTest.md) to select the next TC.
7. Use [TEST_implTestCase](../commands/P0-FuncTestsFlow/TEST_implTestCase.md) and [TEST_reviewImplTestCase](../commands/P0-FuncTestsFlow/TEST_reviewImplTestCase.md) for TC-by-TC execution.
8. Use [TEST_refactTestCase](../commands/P0-FuncTestsFlow/TEST_refactTestCase.md) only after a selected TC is GREEN and reviewed, then run [TEST_reviewImplTestCase](../commands/P0-FuncTestsFlow/TEST_reviewImplTestCase.md) again to prove no skeleton drift.

## Conflict Guard

- Existing demo tests are input material. They do not automatically belong to CaTDD `P3 Demo/Example`.
- `TEST_convertDemoToTypical` extracts core behavior from demo tests into `P0 Functional / Typical` skeletons.
- Category semantics must come from `methodPrompts/CaTDD_methodPrompt4Cat-*.md`.
- Commands must stay language agnostic. Use canonical CaTDD file names such as `test_feature_x_funcValidTypical.cxx` only as examples (`UT_<Feature>-<Category>` names are deprecated; see `methodPrompts/CaTDD_methodPrompt-fileNaming.md`).
- `TEST_designFuncTestsSkeleton` and the category-specific `UT_design*Skeleton` commands own skeleton design, not executable implementation bodies.
- `TEST_refactTestCase` is a no-behavior-change cleanup step for one GREEN TC. Missing behavior, missing coverage, or wrong category routing must go back to design or implementation commands instead of being added during refactor.
