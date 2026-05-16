# agentSkill

This directory contains packaged skills that make CaTDD reusable in agent workflows.

## Role in the 4-layer model

`agentSkill` is the capability packaging layer.

- It wraps method knowledge into triggerable skills.
- It defines skill scope, constraints, inputs, and outputs.
- It provides references that keep execution aligned with CaTDD.

## Typical contents

- Skill package folders (for example, `comment-alive-test-driven-development/`)
- `SKILL.md` files (machine-readable skill definitions)
- Skill-local `README.md` files (human-readable usage)
- `references/` assets (guides, prompts, templates, PPT)

## Upstream / Downstream

- Upstream input: `methodPrompts` (canonical method definition)
- Downstream consumers:
	- `utCodeAgentCLI` (agent execution)
	- Assistant/chat workflows that call specific skills

## Maintenance rule

When updating a skill's behavior, ensure consistency with `methodPrompts` and refresh the skill-local references.

## Packaging command

Run the packaging script from repository root:

```bash
bash agentSkill/makeSkill.sh
```

This updates skill-level symlinks to `methodPrompts` and `slashCommands` for `comment-alive-test-driven-development`.
