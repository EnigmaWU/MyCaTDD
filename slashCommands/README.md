# slashCommands

This directory contains reusable slash-command prompts that operationalize CaTDD methods.

## Role in the 4-layer model

`slashCommands` is the commandization layer between method docs and full agent automation.

- It turns method chunks into triggerable command units.
- It reduces invocation cost for GUI or chat-driven workflows.
- It improves consistency when applying the method repeatedly.

## Typical contents

- Command prompt files for specific CaTDD phases
- Parameterized command templates
- Examples of invocation patterns

## Upstream / Downstream

- Upstream input: `methodPrompts` (method definitions)
- Downstream consumers:
	- `utCodeAgentCLI` (agent pipelines calling commands)
	- Developers using assistant GUI/chat mode

## Maintenance rule

When a method step becomes high-frequency and stable, extract it here as a slash command.
