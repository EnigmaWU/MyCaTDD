# utCodeAgentCLI User Guide

Practical guide for developers and CodeAgents designing the future CaTDD-native CLI execution layer.

For WHAT this layer is and WHY it exists, read [README.md](README.md). This guide focuses on HOW to use the layer today, WHO uses it, WHEN to work here, and WHERE future assets should live.

## Who

Use this guide if you are one of these readers:

- A maintainer designing the future CaTDD-native CLI agent.
- A developer capturing recurring planning, execution, trace, or reflection patterns.
- A CodeAgent helping turn stable workflows into future CLI behavior.
- A tooling author deciding what belongs in `utCodeAgentCLI` instead of `methodPrompts` or `slashCommands`, and how this differs from `agentSkill` packaging.

## What

`codeAgents/utCodeAgentCLI/` is currently a design home for the future CLI execution layer.

It does not yet contain a runnable CLI implementation. Today, use this directory to document stable execution patterns that should eventually become first-class CLI behavior.

Future CLI behavior should combine:

- Method constraints from `methodPrompts/`.
- Portable command steps from `slashCommands/`.
- Goal-driven planning, execution, trace collection, and reflection owned by `codeAgents/utCodeAgentCLI/`.

`agentSkill/` is a separate packaging path for common CodeAgents such as GitHub Copilot to use CaTDD. `utCodeAgentCLI` should not depend on it.

## When

Work in `codeAgents/utCodeAgentCLI/` when:

- A workflow is more than a prompt command and needs goal-driven orchestration.
- A repeated pattern spans planning, execution, verification, and reflection.
- You need to preserve execution traces for method improvement.
- A future CLI feature should coordinate multiple `slashCommands` steps.
- A behavior should become CaTDD-native automation rather than a generic CodeAgent adapter.

Use `slashCommands/` when the behavior is a stable single command or flow step. Use `agentSkill/` only when the behavior is generic CodeAgent packaging, outside the CLI dependency path.

## Where

Current directory layout:

```text
codeAgents/utCodeAgentCLI/
  README.md
  README_ZH.md
  README_UserGuide.md
  README_UserGuide_ZH.md
```

Recommended future layout:

```text
codeAgents/utCodeAgentCLI/
  prompts/
  goals/
  checklists/
  traces/
  reflections/
  src/
  tests/
```

Do not add generated runtime output to this directory as source. Keep repeatable design assets, templates, and implementation files here; keep local run logs or temporary execution output outside committed source unless they become deliberate examples.

## Why

The CLI layer should become the place where CaTDD stops being only method text or prompt commands and becomes a native execution loop.

Documenting the layer before implementation keeps the future CLI honest: it should orchestrate existing CaTDD assets instead of redefining the method or bypassing the command-flow contracts.

## How

Follow this workflow when shaping `codeAgents/utCodeAgentCLI/` today.

1. Start from a repeated CaTDD work pattern.
2. Identify which parts are already covered by `methodPrompts/` or `slashCommands/`.
3. Write only the missing CLI orchestration responsibility here.
4. Capture expected inputs, outputs, trace data, and reflection behavior.
5. Keep product or method uncertainty explicit as questions.
6. Once the pattern is stable, decide whether it belongs as a CLI feature or a slash command.
7. Update tests when a documented contract becomes enforceable.

## Usage Example

Run these commands from the repository root to create a temporary CLI design note without changing the source tree:

```bash
WORK_DIR="$(mktemp -d)"
cat > "$WORK_DIR/utCodeAgentCLI-first-loop.md" <<'EOF'
# utCodeAgentCLI Design Note

Goal: Capture a future CLI loop that plans one CaTDD test task, executes one command step, records trace evidence, and reflects on whether the method or command layer needs improvement.

Inputs:
- methodPrompts/README_UserGuide.md
- slashCommands/README_UserGuide.md

Expected output:
- A proposed CLI responsibility that does not redefine CaTDD method semantics.
- A list of trace fields to preserve.
- Open questions before implementation.
EOF

test -s "$WORK_DIR/utCodeAgentCLI-first-loop.md"
echo "$WORK_DIR"
```

Expected result:

- The `test` command exits successfully.
- The printed temporary path contains a design note for one future CLI loop.
- No repository files are changed.

## Future CLI Responsibility Map

| Responsibility | Belongs here when |
| --- | --- |
| Goal intake | The CLI needs structured task goals before choosing method or command steps. |
| Planning | The CLI must select and sequence multiple CaTDD steps. |
| Execution policy | The CLI must decide when to run, stop, ask, or continue. |
| Trace collection | The CLI must preserve evidence for review and improvement. |
| Reflection | The CLI must identify reusable patterns or method gaps after execution. |
| Feedback routing | The CLI must decide whether an improvement belongs in `methodPrompts` or `slashCommands`. |

## Boundary Checklist

Before adding a future CLI artifact, check:

- Is this more than a single portable command? If not, use `slashCommands/`.
- Is this only method meaning? If yes, use `methodPrompts/`.
- Is this only package metadata or generic CodeAgent skill behavior? If yes, keep it in `agentSkill/`, outside the CLI dependency path.
- Does it preserve US/AC/TC traceability and CaTDD status discipline?
- Does it record what evidence the CLI should collect?
- Does it leave unclear product or method intent as explicit questions?

## Quality Checklist

Before calling a CLI-layer design change complete, verify:

- README/UserGuide documentation split is preserved.
- No runnable CLI behavior is claimed before implementation exists.
- Future paths are clearly marked as future or recommended layout.
- The design references upstream layers instead of duplicating them.
- Documentation contract and README mirror checks pass.

## Next Step

For method meaning, read `methodPrompts/README_UserGuide.md`.

For command-flow execution, read `slashCommands/README_UserGuide.md`.

For generic CodeAgent skill packaging, read `agentSkill/README_UserGuide.md`; do not use it as a CLI dependency.

For this layer, capture only the future CLI orchestration responsibilities that the other layers should not own.
