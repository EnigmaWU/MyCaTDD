# utCodeAgentCLI

This directory represents the CLI code-agent execution layer.

## Role in the 4-layer model

`utCodeAgentCLI` is the intelligent execution layer.

- Developers define goals; the agent plans and executes tasks.
- It applies method constraints from `methodPrompts`.
- It can invoke standardized steps from `slashCommands`.
- It is this repository's own CaTDD-native code agent concept, built with CaTDD deeply in mind.

## CaTDD-native contract

`utCodeAgentCLI` should be based on both upstream layers:

- `methodPrompts` provides the language-agnostic CaTDD method contract.
- `slashCommands` provides code-agent-agnostic reusable prompt commands.
- `utCodeAgentCLI` adds planning, execution, trace collection, and reflection as an opinionated CaTDD-native agent workflow.

It may target many programming languages, but it should preserve CaTDD's comment skeletons, US/AC/TC traceability, category classification, and RED/GREEN status discipline.

## Typical contents

- CLI task entry prompts
- Goal templates and execution checklists
- Reflection loops and iteration notes

## Upstream / Downstream

- Upstream input:
  - `methodPrompts` for methodological constraints
  - `slashCommands` for reusable execution units
  - `agentSkill` for packaged domain workflows
- Downstream output:
  - Executed tasks, traces, and feedback for method improvement

## Maintenance rule

When recurring planning/execution/reflection patterns emerge, formalize them and feed improvements back to `slashCommands` and `methodPrompts`.
