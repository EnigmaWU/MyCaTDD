# specCodeAgentCLI

`specCodeAgentCLI` represents the SpecCoding-oriented CLI code-agent layer in `codeAgents/`.

This README is the WHAT / WHY entry point for this layer.

## What

`specCodeAgentCLI` focuses on module-level flow from input to output.

Its intended behavior is:

- Based on Px-SpecFlow.
- Reuses `utCodeAgentCLI` unit-testing strengths.
- Organizes scenario-level verification from spec intent to executable checks.
- Keeps traceability between spec flow, validation checkpoints, and implementation outcomes.

At the current repository stage, this directory documents the intended layer contract. It does not yet contain a runnable CLI implementation.

## Why

`specCodeAgentCLI` exists to make spec-driven module flow execution first-class, instead of treating it as only a side effect of unit-level orchestration.

It keeps a clear boundary:

- `utCodeAgentCLI` centers on unit testing design and execution.
- `specCodeAgentCLI` centers on module-level flow from input to output.
- Both can share upstream CaTDD method and command assets.

This split lets the repository evolve dedicated agent behavior for unit and spec flow concerns while preserving a consistent CaTDD contract.

