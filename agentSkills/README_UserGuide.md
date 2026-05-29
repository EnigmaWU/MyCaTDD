# agentSkills User Guide

Practical guide for developers and CodeAgents packaging CaTDD and SpecCoding as reusable agent skills.

For WHAT this layer is and WHY it exists, read [README.md](README.md). This guide focuses on HOW to package skills, WHO uses them, WHEN to generate packages, and WHERE the outputs live.

## Who

Use this guide if you are one of these readers:

- A maintainer who edits authored CaTDD or SpecCoding skill source.
- A developer who wants a self-contained skill package for another agent environment.
- A CodeAgent that needs packaged CaTDD references and command flows.
- A tooling author validating that generated packages contain no source-tree symlinks.

## What

`agentSkills/` turns authored CaTDD and SpecCoding skill source into self-contained generated packages.

The generated package includes:

- Skill metadata and behavior from authored `SKILL.md` files.
- Human-readable skill-local README content.
- Method references copied from `methodPrompts/`.
- Portable command flows copied from `slashCommands/`.
- No symlinks and no dependency on source-tree-only paths.

## When

Generate or validate an agent skill package when:

- You changed authored skill behavior.
- You changed `methodPrompts` references used by the skill.
- You changed `slashCommands` content that should ship with the skill.
- You want to distribute CaTDD or user-story-centered SpecCoding as a reusable CodeAgent capability.
- You need to confirm the generated package is self-contained before publishing or copying it.

Do not edit generated `agentSkills/dist/` content as the source of truth. Regenerate it from authored sources.

## Where

Authored skill source lives under:

```text
agentSkills/
  README.md
  README_ZH.md
  README_UserGuide.md
  README_UserGuide_ZH.md
  makeSkill.sh
  comment-alive-test-driven-development/
    SKILL.md
    README.md
  user-story-centered-spec-coding/
    SKILL.md
    README.md
```

Default generated output lives under:

```text
agentSkills/dist/comment-alive-test-driven-development/
  SKILL.md
  README.md
  references/
  slashCommands/
agentSkills/dist/user-story-centered-spec-coding/
  SKILL.md
  README.md
  references/
  slashCommands/
```

Temporary validation output can be written anywhere with `--output`.

## Why

The skill package gives CodeAgents compact, reusable CaTDD and SpecCoding capabilities without making the authored source tree expose duplicate linked paths or partial references.

This keeps daily repository editing clean while still producing distributable artifacts that contain the method guide, method prompt, implementation template, and slash command flows needed for agent execution.

## How

Follow this workflow when packaging a skill.

1. Edit authored skill source under the relevant `agentSkills/<skill-name>/` directory.
2. Keep referenced method assets in `methodPrompts/` and command assets in `slashCommands/`.
3. Run `bash agentSkills/makeSkill.sh` or `bash agentSkills/makeSkill.sh <skill-name>` from the repository root.
4. Inspect the generated package under `agentSkills/dist/` or a temporary output path.
5. Run `bash scripts/test_makeSkill.sh` to confirm required files and no symlinks.
6. Commit authored source, packaging script changes, and tests. Do not commit ignored generated output.

## Usage Example

Run these commands from the repository root to generate the default CaTDD package into a temporary output directory and verify key files:

```bash
OUT_ROOT="$(mktemp -d)"
bash agentSkills/makeSkill.sh --output "$OUT_ROOT"
test -f "$OUT_ROOT/comment-alive-test-driven-development/SKILL.md"
test -f "$OUT_ROOT/comment-alive-test-driven-development/references/README_UserGuide.md"
test -f "$OUT_ROOT/comment-alive-test-driven-development/slashCommands/README_UserGuide.md"
find "$OUT_ROOT/comment-alive-test-driven-development" -type l | wc -l
echo "$OUT_ROOT"
```

Generate the user-story-centered SpecCoding package:

```bash
OUT_ROOT="$(mktemp -d)"
bash agentSkills/makeSkill.sh user-story-centered-spec-coding --output "$OUT_ROOT"
test -f "$OUT_ROOT/user-story-centered-spec-coding/SKILL.md"
test -f "$OUT_ROOT/user-story-centered-spec-coding/slashCommands/flows/Px-SpecFlow.md"
test -f "$OUT_ROOT/user-story-centered-spec-coding/slashCommands/commands/Px-SpecFlow/SPEC_openUserStory.md"
find "$OUT_ROOT/user-story-centered-spec-coding" -type l | wc -l
echo "$OUT_ROOT"
```

Expected result:

- The `test` commands exit successfully.
- The symlink count prints `0`.
- The printed temporary path contains a self-contained skill package for the selected skill.

## Supported Skills

| Skill | Package command | Purpose |
| --- | --- | --- |
| `comment-alive-test-driven-development` | `bash agentSkills/makeSkill.sh` | Package CaTDD as the reusable verification and testing methodology skill. |
| `user-story-centered-spec-coding` | `bash agentSkills/makeSkill.sh user-story-centered-spec-coding` | Package the user-story-centered SpecCoding lifecycle skill. |

## Packaging Output

Each generated package contains:

| Path | Purpose |
| --- | --- |
| `SKILL.md` | Machine-readable skill behavior and trigger instructions. |
| `README.md` | Human-readable skill-local usage documentation. |
| `references/README_UserGuide.md` | Standalone CaTDD method user guide copied from `methodPrompts/`. |
| `references/README_UserGuide_ZH.md` | Chinese standalone CaTDD method user guide copied from `methodPrompts/`. |
| `references/CaTDD_methodPrompt.md` | Canonical CaTDD method contract copied from `methodPrompts/`. |
| `references/CaTDD_ImplTemplate.cxx` | Complete CaTDD test-file template copied from `methodPrompts/`. |
| `slashCommands/` | Portable command flows and user guides copied from `slashCommands/`. |

## Source vs Dist

Treat these paths differently:

| Path | Treat as |
| --- | --- |
| `agentSkills/comment-alive-test-driven-development/` | Authored source. Edit and commit. |
| `agentSkills/user-story-centered-spec-coding/` | Authored source. Edit and commit. |
| `agentSkills/makeSkill.sh` | Packaging logic. Edit and commit when packaging rules change. |
| `agentSkills/dist/` | Generated output. Rebuild locally and keep ignored in this source repository. |

## Quality Checklist

Before calling an agent skill packaging change complete, verify:

- The generated package contains no symlinks.
- Packaged references come from `methodPrompts/`, not stale presentation or duplicated files.
- Packaged `slashCommands/` includes portable command sources and user guides.
- Authored source does not expose linked `references/` or `slashCommands/` paths.
- `bash scripts/test_makeSkill.sh` passes.
- README mirrors and documentation contract tests pass.

## Next Step

For method meaning, read `methodPrompts/README_UserGuide.md`.

For command-flow execution, read `slashCommands/README_UserGuide.md`.

For packaging, run `bash scripts/test_makeSkill.sh` before committing changes to this layer.
