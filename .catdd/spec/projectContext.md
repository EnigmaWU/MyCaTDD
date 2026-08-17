# MyCaTDD SpecFlow Project Context

Initialized by `/SPEC_initProjectContext` on 2026-05-29.

This file is the team-shared, always-loaded working memory for SpecCoding in this repository. Keep project-wide guardrails and broadly reused facts here; retrieve module detail, lifecycle state, and history from the canonical routes below.

## Project Facts

- Repository: `MyCaTDD`.
- Owner: `EnigmaWU`.
- Default branch: `main`.
- Purpose: productize CaTDD from method text into commandized, automated, and reusable CodeAgent workflows.
- CaTDD means Comment-alive Test-Driven Development, invented by EnigmaWU.
- Core slogan: `Comments is Verification Design. LLM Generates Code. Iterate Forward Together.`
- The repository is both the CaTDD source repository and, after self-install, a target project for exercising its own `SPEC_*` workflow.

## Layer Model

| Layer | Path | Responsibility |
| --- | --- | --- |
| Method source | `methodPrompts/` | Owns CaTDD semantics, category meanings, US/AC/TC skeleton rules, status discipline, and implementation templates. |
| Command flow | `slashCommands/` | Owns portable `UT_*` and `SPEC_*` command contracts, flow order, input/output handoff, and tool-neutral execution rules. |
| Native CLI design | `codeAgents/utCodeAgentCLI/` | Owns the future CaTDD-native CLI execution layer and its goal/input/target/behavior contract. It is currently documentation and design, not a runnable CLI. |
| Skill packaging | `agentSkills/` | Owns reusable CodeAgent skill packages that reference the canonical method and command assets. |

## Installed Project Surface

After self-install with `scripts/installCaTDD4Copilot.sh --target "$PWD" --init --clean-prompts`:

- `.catdd/methodPrompts/` contains installed CaTDD method source for target-project usage.
- `.catdd/slashCommands/` contains installed portable flow-command source.
- `.catdd/spec/` contains SpecCoding lifecycle artifacts.
- `.github/prompts/UT_*.prompt.md` and `.github/prompts/SPEC_*.prompt.md` are generated Copilot adapters and are gitignored in this source repo.
- `.github/instructions/catdd.instructions.md` is a tracked team-shared instruction that points Copilot agents at the installed `.catdd/` assets.

## Stable Conventions

- Preserve the documentation split: `README.md` explains WHAT/WHY; `README_UserGuide.md` explains HOW/WHO/WHEN/WHERE.
- Keep English and Chinese README mirrors aligned by heading structure.
- Do not redefine CaTDD method semantics in `slashCommands/`, `codeAgents/`, or native prompt wrappers; refer back to `methodPrompts/`.
- Treat native wrappers as thin, regenerable adapters over `.catdd/slashCommands/` or `slashCommands/`.
- Commit `.catdd/spec/projectContext.md`, shared lifecycle artifacts under `.catdd/spec/`, and stable project-root `README*` SPEC docs.
- Keep local SpecCoding work-state trace gitignored: `.catdd/spec/WorkingProcessLog.md`.
- `SPEC_*` commands may orchestrate `UT_*` commands, but must not replace P0/P1/P2 category rules.
- `SPEC_clearStoryIntent` is the early mutual-intent gate after `SPEC_openUserStory`; it records developer intent and CodeAgent intent before design begins. It does not replace the final `SPEC_reviewUserStory` readiness gate after detail design.

## SUT Unit Convention

The boundary treated as one **Unit** for CaTDD unit tests in this project:

- Default scope: `module-interface` — one cohesive public boundary surfaced by a module or submodule.
- Rationale: MyCaTDD is organized around self-contained layers (`methodPrompts/`, `slashCommands/`, `codeAgents/utCodeAgentCLI/`, `agentSkills/`); each module interface is large enough to define meaningful behavior and small enough to design tests against without leaking unrelated internals.
- Example SUT names:
  - `SUT: methodPrompts` for the CaTDD method layer.
  - `SUT: slashCommands` for the portable command flow layer.
  - `SUT: utCodeAgentCLI` for the future CLI module.
- A single file such as a `*.H` header, a single class, or a single slash command may become the unit when the module interface is too coarse; record the exception in the story-level verification design.
- Update this convention through `SPEC_updateProjectContext` if the project later decides on a different default granularity.

## Canonical Knowledge Routes

| Knowledge | Canonical source | Retrieval rule |
| --- | --- | --- |
| CaTDD semantics, category meanings, skeleton rules, and status discipline | [methodPrompts](../../methodPrompts/README.md) and `methodPrompts/` | Read before interpreting or changing the method; project context must not redefine it. |
| SpecFlow lifecycle, command ownership, and artifact policy | [Px-SpecFlow](../../slashCommands/flows/Px-SpecFlow.md) and `slashCommands/commands/` | Read for `SPEC_*` orchestration and `UT_*` handoff rules. |
| `utCodeAgentCLI` requirements and open product questions | [README_UserStory](../../codeAgents/utCodeAgentCLI/README_UserStory.md) | Read when planning or reviewing CLI behavior. |
| `utCodeAgentCLI` public argument and behavior contract | [README_UsageDesign](../../codeAgents/utCodeAgentCLI/README_UsageDesign.md) | Read before changing CLI inputs, aliases, diagnostics, or invocation behavior. |
| `utCodeAgentCLI` architecture, runtime decisions, and rationale | [README_ArchDesign](../../codeAgents/utCodeAgentCLI/README_ArchDesign.md) and [ADRs](../../codeAgents/utCodeAgentCLI/ADRs/) | Read for module boundaries, runtime placement, quality trade-offs, and supersession history. |
| `utCodeAgentCLI` implementation contracts | [README_DetailDesign](../../codeAgents/utCodeAgentCLI/README_DetailDesign.md) | Read before changing parser, planner, executor, adapter, trace, or diagnostic internals. |
| Verification strategy and traceability | [README_VerifyDesign.md](../../README_VerifyDesign.md) and module `README_VerifyDesign.md` files | Read the project or module scope relevant to the active story. |

## Validation Commands

Use these commands as the default validation surface for documentation and command packaging changes:

```bash
bash scripts/check_readme_mirror.sh
bash scripts/test_documentation_contract.sh
bash scripts/test_slashcommands_complete.sh
bash scripts/test_makeSlashCmd4Copilot.sh
bash scripts/test_installCaTDD4Copilot.sh
```

Use focused checks such as `git diff --check -- <files>` for edited Markdown or shell files before committing.

## SpecFlow Lifecycle State

- Lifecycle state is operational memory. Do not store directory snapshots, filenames, counts, or next-task recommendations in this file.
- Before reading or updating lifecycle state, inspect all live directories and use that output as the source of truth:

```bash
ls -lrt .catdd/spec/pendingNews .catdd/spec/analyzedNews .catdd/spec/todoUS .catdd/spec/doingUS .catdd/spec/suspendUS .catdd/spec/doneUS .catdd/spec/abortUS
```

- If a directory is absent, report the absence instead of inventing state. Use `/SPEC_whatsNextTask` to derive the next action from current artifacts.
- Completed and aborted work remains available from `doneUS/`, `abortUS/`, ADRs, review artifacts, and Git history when rationale or diagnosis is needed.

## Open Questions

- None at project scope. Module-specific questions live in their canonical requirement and design documents.
