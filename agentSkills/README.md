# agentSkills

`agentSkills` contains authored skill sources and generated packages that make CaTDD and SpecCoding capabilities reusable in agent workflows.

This README is the WHAT / WHY entry point for the capability packaging layer. For HOW, WHO, WHEN, and WHERE to package or consume CaTDD and SpecCoding skills, read [README_UserGuide.md](README_UserGuide.md) or [README_UserGuide_ZH.md](README_UserGuide_ZH.md).

## What

`agentSkills` is the reusable capability packaging layer in the CaTDD 4-layer model.

It defines how CaTDD method knowledge and SpecCoding workflow knowledge are wrapped into CodeAgent-friendly skills:

- Authored skill source directories.
- Machine-readable `SKILL.md` definitions.
- Human-readable skill-local README files.
- Packaged references copied from `methodPrompts`.
- Packaged `slashCommands` command flows for execution and SpecCoding lifecycle support.
- Generated distributable packages under ignored `dist/` output.

The authored source is the durable asset. Generated packages are build output.

## Why

`agentSkills` exists so CaTDD and SpecCoding can be reused by agents without making every agent rediscover the method, command flows, lifecycle rules, constraints, and references from scratch.

It keeps a clean packaging boundary:

- `methodPrompts` owns the canonical CaTDD method definition.
- `slashCommands` owns portable command flow execution.
- `agentSkills` packages those assets as a reusable capability with scope, constraints, inputs, outputs, and validation expectations.
- Generated `dist/` packages are self-contained so they can be copied or published without exposing source-tree symlinks or duplicate authored paths.

## Supported skills

| Skill | Owns |
| --- | --- |
| `comment-alive-test-driven-development` | CaTDD as a reusable verification and testing methodology. |
| `user-story-centered-spec-coding` | User-story-centered SpecCoding lifecycle orchestration, using CaTDD as the default UnitTesting method. |

## Packaging contract

Skill packages should be generated from source, not manually edited in `dist/`.

- Edit authored skill source under the relevant `agentSkills/<skill-name>/` directory.
- Keep references aligned with `methodPrompts` and `slashCommands`.
- Use `agentSkills/makeSkill.sh` to generate a self-contained package.
- Keep generated `agentSkills/dist/` output ignored in this source repository.

## Typical contents

- Standalone user guides (`README_UserGuide.md`, `README_UserGuide_ZH.md`)
- Packaging script (`makeSkill.sh`)
- Authored skill source folders such as `comment-alive-test-driven-development/` and `user-story-centered-spec-coding/`
- `SKILL.md` files for machine-readable skill behavior
- Skill-local `README.md` files for human-readable skill usage
- Generated packages under `dist/` containing copied `references/` assets and copied `slashCommands/`

## Upstream / Downstream

- Upstream inputs:
  - `methodPrompts` for canonical method definition.
  - `slashCommands` for portable execution flows.
- Downstream consumers:
  - CodeAgent skill systems that load packaged skills.
  - `utCodeAgentCLI` when it needs reusable skill behavior.
  - Developers or maintainers distributing CaTDD as an agent capability.

## Documentation boundary

Keep the documentation split clear:

| File | Owns |
| --- | --- |
| `README.md` / `README_ZH.md` | WHAT this layer contains and WHY it exists. |
| `README_UserGuide.md` / `README_UserGuide_ZH.md` | HOW to generate packages, WHO uses them, WHEN to package, WHERE output lives, and a copy-exec `Usage Example`. |

Operational packaging commands and validation commands belong in the standalone user guides, not in this README.

## Maintenance rule

When updating a skill's behavior, edit the authored source and ensure consistency with `methodPrompts` and `slashCommands`.

When packaging rules change, update the user guide and tests so the generated package remains self-contained and reproducible.
