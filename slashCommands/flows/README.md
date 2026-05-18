# slashCommands Flows

This directory records the workflow-level command plans for CaTDD slash commands.

Flow documents connect existing CodeAgent invocation surfaces to CaTDD method steps. They can describe orchestration and command order, but the method definitions remain in `methodPrompts`.

Compared with `methodPrompts`, these files are more flow-first and automation-friendly. They explain how a CodeAgent should move through a method, not what the method means.

## Priority Alignment

Flow priority uses the same Pn numbering as `methodPrompts`:

- `P0 FuncTestsFlow`: functional test command flow for CaTDD `P0 Functional`.
- `P1 DesignTestsFlow`: design-oriented test command flow for CaTDD `P1 Design`.
- `P2 QualityTestsFlow`: quality-oriented test command flow for CaTDD `P2 Quality`.

`P3 Addons` remains the method category for demo/example-oriented commands when those are added later.

`Px SpecFlow` is a cross-priority SpecCoding lifecycle. It orchestrates project context, issue/story/design/test/code/review/CI/closure work and may call P0/P1/P2 category flows, but it is not itself a CaTDD category priority.

## Flow List

- [Px-SpecFlow.md](Px-SpecFlow.md)
- [P0-FuncTestsFlow.md](P0-FuncTestsFlow.md)
- [P1-DesignTestsFlow.md](P1-DesignTestsFlow.md)
- [P2-QualityTestsFlow.md](P2-QualityTestsFlow.md)

## Import Rule

Flow documents may describe command order and orchestration, but they must not redefine CaTDD category semantics, priority order, or skeleton design rules. Category meaning stays in `methodPrompts/CaTDD_methodPrompt4Cat-*.md`.

`SPEC_*` commands may orchestrate across artifacts and lower-level `UT_*` commands, but they must still treat `methodPrompts` as source of truth.
