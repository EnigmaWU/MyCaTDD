# methodPrompts

This directory contains method-level prompt assets for CaTDD.

## Role in the 4-layer model

`methodPrompts` is the source-of-truth methodology layer.

- It defines how to design and execute CaTDD workflows.
- It is human-readable and LLM-friendly.
- It should be stable, explicit, and reusable across tools.

## Typical contents

- Method specification (`CaTDD_DesignPrompt.md`)
- User guide (`CaTDD_UserGuide.md`)
- Presentation summary (`CaTDD-UserGuide-PPT*.md`)
- Implementation template (`CaTDD_ImplTemplate.cxx`)

## Upstream / Downstream

- Upstream input: real project experience and lessons learned.
- Downstream consumers:
	- `slashCommands` (commandized method steps)
	- `utCodeAgentCLI` (agent execution constraints)
	- `agentSkill` (packaged reusable capability)

## Maintenance rule

When method intent changes, update this directory first, then propagate to the other 3 layers.
