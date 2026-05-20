# agentSkill

This directory contains authored skill sources and generated packages that make CaTDD reusable in agent workflows.

## Role in the 4-layer model

`agentSkill` is the capability packaging layer.

- It wraps method knowledge into triggerable skills.
- It defines skill scope, constraints, inputs, and outputs.
- It provides references that keep execution aligned with CaTDD.

## Typical contents

- Authored skill source folders (for example, `comment-alive-test-driven-development/`)
- `SKILL.md` files (machine-readable skill definitions)
- Skill-local `README.md` files (human-readable usage)
- Generated packages under `dist/` containing copied `references/` assets and `slashCommands/`

## Upstream / Downstream

- Upstream input: `methodPrompts` (canonical method definition)
- Downstream consumers:
  - `utCodeAgentCLI` (agent execution)
  - Assistant/chat workflows that call specific skills

## Maintenance rule

When updating a skill's behavior, edit the authored source and ensure consistency with `methodPrompts`. Generated packages under `dist/` are build output and should not be committed.

## Packaging command

Run the packaging script from repository root:

```bash
bash agentSkill/makeSkill.sh
```

This creates a self-contained generated package at `agentSkill/dist/comment-alive-test-driven-development/`. The generated package copies `methodPrompts` references and `slashCommands` so the authored source tree does not expose duplicate linked paths during normal repository work.

## Usage Example

Generate the default package from the repository root:

```bash
bash agentSkill/makeSkill.sh
```

Generate into a temporary output directory for validation:

```bash
bash agentSkill/makeSkill.sh --output /tmp/catdd-agent-skills
```

Expected result: the output directory contains `comment-alive-test-driven-development/SKILL.md`, copied `references/`, and copied `slashCommands/`, with no symlinks.
