# P0 FuncTestsFlow

`P0 FuncTestsFlow` is the first slash-command flow to import because it covers the most common developer entry points for functional unit tests.

## Method Alignment

Slash flow `P0 FuncTestsFlow` uses the same priority as CaTDD method category `P0 Functional`:

```text
P0 Functional = ValidFunc + InvalidFunc
ValidFunc = Typical + Edge
InvalidFunc = Misuse + Fault
```

The flow commands orchestrate execution; category meaning remains in `methodPrompts`.

## Developer Stories

- As a Developer, when I have demo tests, I want to convert them into CaTDD functional skeletons so that existing examples become living verification design.
- As a Developer, when I have a defined interface or protocol, I want to use CaTDD to design the Typical skeleton so that core behavior is specified before implementation.
- As a Developer, when I already have Typical, Edge, Misuse, Fault, or later category skeletons, I want to select and implement the next test case so that TDD proceeds one TC at a time.

## Flow Diagram

```mermaid
flowchart LR
    Demo["Existing demo tests"] --> Convert["UT_convertDemoToTypical"]
    Protocol["Interface or protocol"] --> DesignTypical["UT_designCatSkeleton<br/>Cat=Typical"]

    Convert --> Typical["Typical skeleton"]
    DesignTypical --> Typical
    Typical --> Edge["UT_designCatSkeleton<br/>Cat=Edge"]
    Edge --> Misuse["UT_designCatSkeleton<br/>Cat=Misuse"]
    Misuse --> Fault["UT_designCatSkeleton<br/>Cat=Fault"]
    Fault --> ReviewSkeleton["UT_reviewFuncTestsSkeleton"]

    ReviewSkeleton --> NextTC["UT_tellMeNextImplTest"]
    NextTC --> Impl["UT_implTestCase"]
    Impl --> ReviewImpl["UT_reviewImplTestCase"]
    ReviewImpl --> NextTC
```

## Command Sequence

1. Use [../commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md](../commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md) when the starting point is an existing demo test.
2. Use [../commands/P0-FuncTestsFlow/UT_designCatSkeleton.md](../commands/P0-FuncTestsFlow/UT_designCatSkeleton.md) with `Cat=Typical` when the starting point is an interface or protocol.
3. Reuse `UT_designCatSkeleton` with `Cat=Edge`, `Cat=Misuse`, and `Cat=Fault` to complete the functional skeleton set.
4. Use [../commands/P0-FuncTestsFlow/UT_reviewFuncTestsSkeleton.md](../commands/P0-FuncTestsFlow/UT_reviewFuncTestsSkeleton.md) before implementation begins.
5. Use [../commands/P0-FuncTestsFlow/UT_tellMeNextImplTest.md](../commands/P0-FuncTestsFlow/UT_tellMeNextImplTest.md) to select the next TC.
6. Use [../commands/P0-FuncTestsFlow/UT_implTestCase.md](../commands/P0-FuncTestsFlow/UT_implTestCase.md) and [../commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md](../commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md) for TC-by-TC execution.

## Conflict Guard

- Existing demo tests are input material. They do not automatically belong to CaTDD `P3 Demo/Example`.
- `UT_convertDemoToTypical` extracts core behavior from demo tests into `P0 Functional / Typical` skeletons.
- Category semantics must come from `methodPrompts/CaTDD_methodPrompt4Cat-*.md`.
- Commands must stay language agnostic. Use C++ names such as `UT_FeatureX-Typical.cxx` only as examples.
