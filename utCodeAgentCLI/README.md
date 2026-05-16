# utCodeAgentCLI

This directory represents the CLI code-agent execution layer.

## Role in the 4-layer model

`utCodeAgentCLI` is the intelligent execution layer.

- Developers define goals; the agent plans and executes tasks.
- It applies method constraints from `methodPrompts`.
- It can invoke standardized steps from `slashCommands`.

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
