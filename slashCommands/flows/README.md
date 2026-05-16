# slashCommands Flows

This directory records the workflow-level command plans for CaTDD slash commands.

## Priority Alignment

Flow priority uses the same Pn numbering as `methodPrompts`:

- `P0 FuncTestsFlow`: functional test command flow for CaTDD `P0 Functional`.
- `P1 DesignTestsFlow`: design-oriented test command flow for CaTDD `P1 Design`.
- `P2 QualityTestsFlow`: quality-oriented test command flow for CaTDD `P2 Quality`.

`P3 Addons` remains the method category for demo/example-oriented commands when those are added later.

## Flow List

- [P0-FuncTestsFlow.md](P0-FuncTestsFlow.md)
- [P1-DesignTestsFlow.md](P1-DesignTestsFlow.md)
- [P2-QualityTestsFlow.md](P2-QualityTestsFlow.md)

## Import Rule

Flow documents may describe command order and orchestration, but they must not redefine CaTDD category semantics. Category meaning stays in `methodPrompts/CaTDD_methodPrompt4Cat-*.md`.
