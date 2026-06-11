# MyCaTDD SpecFlow Project Context

Initialized by `/SPEC_initProjectContext` on 2026-05-29.

This file is the team-shared SpecCoding context for this repository. Keep stable project facts, constraints, conventions, and open questions here so future `SPEC_*` commands can continue from explicit state instead of chat memory.

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
- `.github/instructions/catdd.instructions.md` points Copilot agents at the installed `.catdd/` assets.

## Stable Conventions

- Preserve the documentation split: `README.md` explains WHAT/WHY; `README_UserGuide.md` explains HOW/WHO/WHEN/WHERE.
- Keep English and Chinese README mirrors aligned by heading structure.
- Do not redefine CaTDD method semantics in `slashCommands/`, `codeAgents/`, or native prompt wrappers; refer back to `methodPrompts/`.
- Treat native wrappers as thin, regenerable adapters over `.catdd/slashCommands/` or `slashCommands/`.
- Commit shared SpecCoding artifacts such as `.catdd/spec/projectContext.md`, pending imported work, analyzed raw input archives, todo user stories, active doing user stories, done user stories, and stable project-root `README*` SPEC docs.
- Keep local SpecCoding work-state trace gitignored: `.catdd/spec/WorkingProcessLog.md`.
- `SPEC_*` commands may orchestrate `UT_*` commands, but must not replace P0/P1/P2 category rules.
- `SPEC_clearStoryIntent` is the early mutual-intent gate after `SPEC_openUserStory`; it records developer intent and CodeAgent intent before design begins. It does not replace the final `SPEC_reviewUserStory` readiness gate after detail design.

## Current Design Decisions

- P0 Functional categories are Typical, Edge, Misuse, and Fault.
- P1 Design categories are State, Capability, and Concurrency.
- P2 Quality categories are Performance, Robust, Compatibility, and Configuration.
- `designAllSkeleton` means all P0/P1/P2 categories.
- `designFuncTestsSkeleton` means the P0 Functional set only: Typical, Edge, Misuse, and Fault.
- In `utCodeAgentCLI`, `--target` is test-space scope only: one TestCase in one TestFile, one TestFile, or some TestFiles.
- In `utCodeAgentCLI`, `--input` or `--inputFile` carries source/context such as interface, protocol, schema, draft, or production source.
- In `utCodeAgentCLI`, `--behave` names a compatible UT slash-command behavior or a stable CLI alias.
- Stable CLI aliases include `reviewFuncTestsSkeleton` and `tellMeNextImplTest`, resolving to `UT_reviewFuncTestsSkeleton` and `UT_tellMeNextImplTest` respectively.

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

- `SPEC_*` Copilot prompt wrappers have been installed into `.github/prompts/`.
- Do not maintain duplicated file lists for `pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, `doneUS/`, or `abortUS/` in this file. They drift too easily.
- Before updating lifecycle state, run a live directory inventory and use that output as the source of truth:

```bash
ls -lrt .catdd/spec/pendingNews .catdd/spec/analyzedNews .catdd/spec/todoUS .catdd/spec/doingUS .catdd/spec/doneUS .catdd/spec/abortUS
```

- If a lifecycle directory is absent, record that absence instead of inventing an empty state. Current check on 2026-06-11 found `.catdd/spec/abortUS/` absent.
- Current lifecycle summary from the latest filesystem check: `pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, and `doneUS/` exist; `doingUS/` is empty; no active story is opened.
- Use `/SPEC_whatsNextTask` or the live `ls -lrt` inventory to choose the next lifecycle file, rather than reading a stale filename list from this project context.
- Shared module UserStory doc created: `codeAgents/utCodeAgentCLI/README_UserStory.md` and `codeAgents/utCodeAgentCLI/README_UserStory_ZH.md`.
- Shared module ArchDesign doc created: `codeAgents/utCodeAgentCLI/README_ArchDesign.md` and `codeAgents/utCodeAgentCLI/README_ArchDesign_ZH.md`; latest draft includes the runtime-language tradeoff review across TypeScript/Node.js, Python, and Go, Mermaid-renderable C4-style architecture views, Px-SpecFlow architecture-oriented surface coverage, and an ADR link for the runtime choice.
- Current `utCodeAgentCLI` ArchDesign has `/SPEC_reviewArchDesign` PASS recorded on 2026-06-03; the runtime-language ADR is now DECIDED: TypeScript/Node.js for V1 (PoC) and Go pre-selected for V2 (production distribution), Python evaluated and not selected. ADR status updated to Decided in `codeAgents/utCodeAgentCLI/ADRs/ADR_RuntimeLanguage.md`.
- Shared module DetailDesign doc created: `codeAgents/utCodeAgentCLI/README_DetailDesign.md` and `codeAgents/utCodeAgentCLI/README_DetailDesign_ZH.md`; latest draft includes TypeScript-facing parser, planner, executor, adapter, trace, diagnostics, state, error, and verification contracts; `/SPEC_reviewDetailDesign` PASS recorded on 2026-06-04.
- Current `utCodeAgentCLI` story/design readiness has `/SPEC_reviewUserStory` PASS recorded on 2026-06-04 and the story itself is archived in `doneUS/`.
- `US-USER-01` lifecycle was completed on 2026-06-08: `/SPEC_reviewProductCodes` PASS, `/SPEC_commitWorks` commit `3a98908`, CaTDD category correction commit `90268f7`, and closure through `/SPEC_closeUserStory`.
- `SPEC_designUnitTests` to `UT_designFuncTestsSkeleton` alignment lifecycle was completed on 2026-06-11: category-specific `UT_US-USER-01-*.ts` UnitTesting split, `/SPEC_reviewProductCodes` PASS, `/SPEC_commitWorks` commit `8714e7f`, and closure through `/SPEC_closeUserStory`.

## Next Recommended Command

Run this next after context review:

- `/SPEC_analyzeIssue` for pending imported work, starting with `.catdd/spec/pendingNews/20260611-add-emoji-to-designAndImplTemplate-key-states-Issue.md` if that is the next priority.

## Assumptions To Confirm

- The current self-install is intentional for using MyCaTDD as its own target project.
- `.github/instructions/catdd.instructions.md` should be committed for this source repository, not treated only as local generated target-project state.
- Empty lifecycle directories do not need placeholder files unless the team wants them visible in Git before they contain artifacts.

## Open Questions

- Which user role should be treated as primary when prioritizing `utCodeAgentCLI` User Stories: developer, CodeAgent, maintainer, or tooling author?
- Should the self-installed `.github/instructions/catdd.instructions.md` become part of the repository's committed project instructions?
- Should the validation command list be expanded into a formal project-root `README_VerifyDesign.md` later?