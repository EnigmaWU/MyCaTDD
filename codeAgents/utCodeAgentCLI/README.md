# utCodeAgentCLI

`utCodeAgentCLI` represents the CaTDD-native CLI code-agent execution layer.

This README is the WHAT / WHY entry point for the CLI agent layer. For user intent and acceptance criteria, read [README_UserStory.md](README_UserStory.md). For HOW, WHO, WHEN, and WHERE to design or use this layer, read [README_UserGuide.md](README_UserGuide.md) or [README_UserGuide_ZH.md](README_UserGuide_ZH.md).

## What

`utCodeAgentCLI` is the intelligent execution layer in the CaTDD 4-layer model.

It is the repository's CaTDD-native agent concept:

- Developers define goals.
- The agent plans work from CaTDD method constraints.
- The agent can invoke standardized steps from `slashCommands`.
- The agent collects traces, reflects on outcomes, and feeds reusable patterns back into the method and command layers.
- The agent preserves CaTDD comment skeletons, US/AC/TC traceability, category classification, and RED/GREEN status discipline.

Implementation is now incremental rather than documentation-only:

- `SrcTS/cli/main.ts` is a runnable Node.js entry point for the `US-USER-01` invocation-validation slice.
- `SrcTS/cli/invocationValidator.ts` validates required arguments, exclusive pairs, supported behaviors, target shape, log levels, config shape, and referenced file paths.
- The four CaTDD P0 functional test files under `tests/` verify all 32 `US-USER-01` acceptance criteria.
- Planning, method-prompt and slash-command resolution, runtime adapters, command execution, trace persistence, and reflection remain design targets rather than implemented runtime capabilities.

The module therefore has a runnable validation slice, but it does not yet ship a distributable `utCodeAgentCLI` binary or an end-to-end agent execution loop.

## Why

`utCodeAgentCLI` exists to close the loop from reusable CaTDD knowledge to opinionated CaTDD-native execution.

It keeps a clean execution boundary:

- `methodPrompts` owns method semantics.
- `slashCommands` owns portable command steps and flows.
- `agentSkills` packages CaTDD for common CodeAgents such as GitHub Copilot; it is not an upstream dependency of this CLI layer.
- `utCodeAgentCLI` owns CLI validation today and will progressively own goal-driven planning, execution, trace collection, and reflection.

This avoids making generic CodeAgent adapters carry CaTDD-specific orchestration logic while still preserving a future path for first-class CaTDD automation.

## CaTDD-native contract

The CLI implementation must be based on the upstream layers:

- `methodPrompts` provides the language-agnostic CaTDD method contract.
- `slashCommands` provides code-agent-agnostic reusable prompt commands.
- `utCodeAgentCLI` adds planning, execution policy, trace handling, and reflection loops.

It may target many programming languages, but it must preserve CaTDD's comment-alive verification design.

## Typical contents

- Standalone user-story docs (`README_UserStory.md`, `README_UserStory_ZH.md`)
- Standalone user guides (`README_UserGuide.md`, `README_UserGuide_ZH.md`)
- Architecture design docs (`README_ArchDesign.md` and its ZH mirror) plus durable ADRs
- TypeScript implementation slices under `src/`
- CaTDD unit tests and fixtures under `tests/`
- Planned CLI task entry prompts, goal templates, and execution checklists
- Planned trace collection and reflection-loop assets

## Upstream / Downstream

- Upstream inputs:
  - `methodPrompts` for methodological constraints.
  - `slashCommands` for reusable execution units.
- Separate generic CodeAgent packaging:
  - `agentSkills` helps common CodeAgents use CaTDD, but `utCodeAgentCLI` should not depend on it.
- Downstream outputs:
  - Executed tasks.
  - Execution traces.
  - Reflection notes.
  - Feedback for improving `slashCommands` and `methodPrompts`.

## Documentation boundary

Keep the documentation split clear:

| File | Owns |
| --- | --- |
| `README.md` / `README_ZH.md` | WHAT this layer is and WHY it exists. |
| `README_UserStory.md` / `README_UserStory_ZH.md` | WHO needs this layer, WHAT user value it should provide, and BDD acceptance criteria before design and test work. |
| `README_UserStoryStatus.md` | Current acceptance-criteria lifecycle status across all CLI stories. |
| `README_UbiLang.md` | Shared domain vocabulary (roles, states, category/tier terms, behavior naming) used across story/design/implementation docs. |
| `README_ArchDesign.md` / `README_ArchDesign_ZH.md` and `ADRs/` | Sole module design authority: boundaries, runtime adapters, AgentSDK separation, trace/audit/control policy, architecture-significant implementation constraints, trade-offs, and durable decisions. |
| `README_UserGuide.md` / `README_UserGuide_ZH.md` | HOW to design or use this layer today, WHO uses it, WHEN to work in it, WHERE future assets live, and a copy-exec `Usage Example`. |
| `src/` / `tests/` | Incremental product implementation and executable CaTDD verification. |

Operational CLI commands belong in the standalone user guides as each runnable slice becomes available.

## Maintenance rule

When recurring planning, execution, trace, or reflection patterns emerge, formalize them here.

When those patterns stabilize as reusable prompt steps, feed improvements back to `slashCommands` and `methodPrompts`.
