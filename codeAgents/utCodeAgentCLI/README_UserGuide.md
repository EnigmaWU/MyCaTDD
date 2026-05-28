# utCodeAgentCLI User Guide

Primary startup guide for developers and CodeAgents using or designing the future CaTDD-native CLI execution layer.

Start here first. This guide gives the shortest practical path from user intent to a clear `utCodeAgentCLI` invocation plan. Use [README.md](README.md) for WHAT/WHY background, and use [README_UsageDesign.md](README_UsageDesign.md) as the detailed argument contract after this guide tells you what to look up.

## Start Here

Use this guide as the first document when you want to use, simulate, review, or design a `utCodeAgentCLI` workflow.

1. Say what you want the CLI to accomplish; that becomes `--goal`.
2. Provide the User Story with `--goalStory` or `--goalStoryFile` when the run designs new US/AC/TC skeletons.
3. Choose the source material with exactly one of `--input` or `--inputFile` when the behavior needs source context.
4. Choose `--target` as test-space scope only: one TestCase in one TestFile, one TestFile, or some TestFiles.
5. Choose `--behave` from the behavior table below.
6. Open [README_UsageDesign.md](README_UsageDesign.md) only when you need exact syntax, selector forms, or error rules.

## Who

Use this guide if you are one of these readers:

- A developer trying to decide which `utCodeAgentCLI` arguments to use.
- A CodeAgent preparing an invocation plan for a CaTDD test workflow.
- A maintainer designing the future CaTDD-native CLI agent.
- A developer capturing recurring planning, execution, trace, or reflection patterns.
- A tooling author deciding what belongs in `utCodeAgentCLI` instead of `methodPrompts` or `slashCommands`, and how this differs from `agentSkill` packaging.

## What

`codeAgents/utCodeAgentCLI/` is currently the startup and design home for the future CLI execution layer.

It does not yet contain a runnable CLI implementation. Today, use this guide to form clear invocation plans and to document stable execution patterns that should eventually become first-class CLI behavior.

The current invocation contract lives in [README_UsageDesign.md](README_UsageDesign.md). Treat that file as the source of truth for exact CLI arguments, valid `--target` forms, `--behave` selector forms, and error handling; treat this UserGuide as the first reading path.

Future CLI behavior should combine:

- Method constraints from `methodPrompts/`.
- Portable command steps from `slashCommands/`.
- Goal-driven planning, execution, trace collection, and reflection owned by `codeAgents/utCodeAgentCLI/`.

`agentSkill/` is a separate packaging path for common CodeAgents such as GitHub Copilot to use CaTDD. `utCodeAgentCLI` should not depend on it.

## When

Use this guide when:

- You are deciding how to express a task as `--goal`, `--input`/`--inputFile`, `--target`, and `--behave`.
- You need to pick between `designFuncTestsSkeleton`, `designAllSkeleton`, direct `UT_*` commands, and implementation behaviors.
- You need a quick path before reading the full UsageDesign reference.

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
  README_UsageDesign.md
  README_UsageDesign_ZH.md
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

1. Start from the user intent and write it as `--goal`.
2. Identify the source context and choose exactly one of `--input` or `--inputFile` when the behavior needs material outside the target test artifact.
3. Choose `--target` as test-space scope only: one TestCase in one TestFile, one TestFile, or some TestFiles.
4. Choose `--behave` from a stable alias or a compatible portable `UT_*` slash command.
5. Check [README_UsageDesign.md](README_UsageDesign.md) for required arguments, invalid combinations, and current selector forms.
6. If the desired behavior is a single reusable command, update `slashCommands/` first; keep this directory focused on CLI orchestration.
7. If the desired behavior sequences commands, records trace data, or decides when to stop or ask, document the missing CLI responsibility here.
8. Keep product or method uncertainty explicit as open questions.
9. Update tests when a documented contract becomes enforceable.

## Instruction Path

Use this path when a user starts with a CaTDD need and wants a `utCodeAgentCLI` plan:

1. Stay in this UserGuide to choose the practical path and likely `--behave`.
2. Open [README_UsageDesign.md](README_UsageDesign.md) to confirm exact argument syntax, required fields, and invalid combinations.
3. Open `slashCommands/README_UserGuide.md` only when you need to inspect the portable command contract behind a `UT_*` behavior.
4. Open `methodPrompts/README_UserGuide.md` only when you need method meaning; do not redefine category semantics here.
5. Open [README.md](README.md) only when you need layer-level WHAT/WHY background.
6. Write or update the smallest CLI-layer note needed to explain orchestration, trace, reflection, or policy.

## Behavior Selection Guide

| User wants to | Prefer `--behave` | Typical `--target` | Notes |
| --- | --- | --- | --- |
| Design one P0 functional category | `designTypicalSkeleton`, `designEdgeSkeleton`, `designMisuseSkeleton`, or `designFaultSkeleton` | one TestFile | Stable aliases for explicit P0 commands. |
| Design all P0 functional categories | `designFuncTestsSkeleton` or `UT_designFuncTestsSkeleton` | one TestFile or some TestFiles | Covers Typical, Edge, Misuse, and Fault only. |
| Design all P0/P1/P2 categories | `designAllSkeleton` | one TestFile or some TestFiles | Covers functional, design, and quality skeleton categories. |
| Review functional skeletons | `UT_reviewFuncTestsSkeleton` | one TestFile or some TestFiles | Direct portable slash command. |
| Pick the next TC to implement | `UT_tellMeNextImplTest` | one TestFile | Direct portable slash command. |
| Implement one TC | `implTestCase` or `UT_implTestCase` | one TestCase in one TestFile | Adds executable test code for the selected TC. |
| Implement a whole TestFile | `implTestFile` | one TestFile | CLI repeats the single-TC implementation step. |

Use direct `UT_*` command names when the caller wants a specific portable command. Use stable aliases when the caller wants CLI-friendly behavior names that may expand into one or more portable commands.

## Usage Example

Run these commands from the repository root to create a temporary invocation plan without changing the source tree:

```bash
WORK_DIR="$(mktemp -d)"
cat > "$WORK_DIR/utCodeAgentCLI-invocation-plan.md" <<'EOF'
# utCodeAgentCLI Invocation Plan

Goal: design the full P0 Functional skeleton set for the auth interface.

Inputs:
- --goal "design P0 functional skeletons for the auth interface"
- --inputFile src/auth/AuthService.h
- --target tests/auth_api_test.cpp
- --behave designFuncTestsSkeleton

Expected output:
- Typical, Edge, Misuse, and Fault skeletons are planned for the target TestFile.
- No executable implementation test code is planned.
- Any missing source or story context is listed as an open question.
EOF

test -s "$WORK_DIR/utCodeAgentCLI-invocation-plan.md"
echo "$WORK_DIR"
```

Expected result:

- The `test` command exits successfully.
- The printed temporary path contains an invocation plan with `--goal`, `--inputFile`, `--target`, and `--behave`.
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
- `--target` remains test-space scope, not source input.
- `--behave` names compatible UT slash-command behavior or a stable CLI alias.
- Documentation contract and README mirror checks pass.

## Next Step

For method meaning, read `methodPrompts/README_UserGuide.md`.

For command-flow execution, read `slashCommands/README_UserGuide.md`.

For generic CodeAgent skill packaging, read `agentSkill/README_UserGuide.md`; do not use it as a CLI dependency.

For this layer, capture only the future CLI orchestration responsibilities that the other layers should not own.
