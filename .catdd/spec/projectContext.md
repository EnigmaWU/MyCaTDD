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
- `.catdd/spec/` lifecycle currently has `pendingNews/`, `analyzedNews/`, `todoUS/`, and `doneUS/`; `doingUS/` is absent when no story is actively opened.
- Analyzed raw issues archived:
  - `.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md`
  - `.catdd/spec/analyzedNews/20260531-add-SPEC_takeArchDesign-command-Issue.md`
  - `.catdd/spec/analyzedNews/20260530-design-utCodeAgentCLI-architecture-Issue.md`
  - `.catdd/spec/analyzedNews/20260604-decide-utCodeAgentCLI-runtime-language-Issue.md`
  - `.catdd/spec/analyzedNews/20260602-add-SPEC_reviewDesignGates-commands-Feature.md`
  - `.catdd/spec/analyzedNews/20260606-treat-updates-as-issue-first-Issue.md`
  - `.catdd/spec/analyzedNews/20260608-rename-CaTDD-ImplTemplate-and-add-ts-template-Issue.md`
- Pending issues imported:
  - `.catdd/spec/pendingNews/20260531-add-SPEC_assembleRequirements-command-Issue.md`
  - `.catdd/spec/pendingNews/20260531-add-SPEC_updateRequirement-command-Issue.md`
  - `.catdd/spec/pendingNews/20260531-add-SPEC_verifyRequirement-command-Issue.md`
  - `.catdd/spec/pendingNews/20260531-add-UT_reviewImplTestFile-slash-command-Issue.md`
  - `.catdd/spec/pendingNews/20260531-create-installCaTDD-Skill4XYZ-installer-Issue.md`
  - `.catdd/spec/pendingNews/20260608-why-SPEC-designUnitTests-not-UT-doXYZ-in-P0-FuncTestFlow-Issue.md`
- Completed user stories:
  - `.catdd/spec/doneUS/20260530-assemble-utCodeAgentCLI-user-stories-UserStory.md`
  - `.catdd/spec/doneUS/20260531-add-SPEC_takeArchDesign-command-UserStory.md`
  - `.catdd/spec/doneUS/20260530-design-utCodeAgentCLI-architecture-UserStory.md`
  - `.catdd/spec/doneUS/20260602-add-SPEC_reviewDesignGates-commands-UserStory.md`
  - `.catdd/spec/doneUS/20260604-decide-utCodeAgentCLI-runtime-language-UserStory.md`
  - `.catdd/spec/doneUS/20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md`
  - `.catdd/spec/doneUS/20260607-utCodeAgentCLI-US-USER-01-UserStory.md`
  - `.catdd/spec/doneUS/20260607-utCodeAgentCLI-US-USER-01-TASKs.md`
  - `.catdd/spec/doneUS/20260608-methodPrompts-template-rename-and-typescript-design-and-impl-UserStory.md`
  - `.catdd/spec/doneUS/20260608-methodPrompts-template-rename-and-typescript-design-and-impl-TASKs.md`
- Todo user stories waiting:
  - `.catdd/spec/todoUS/20260607-utCodeAgentCLI-US-DEV-01-UserStory.md`
  - `.catdd/spec/todoUS/20260607-utCodeAgentCLI-US-DEV-05-UserStory.md`
  - `.catdd/spec/todoUS/20260607-utCodeAgentCLI-US-INVENTOR-01-UserStory.md`
  - `.catdd/spec/todoUS/20260607-utCodeAgentCLI-US-INVENTOR-02-UserStory.md`
  - `.catdd/spec/todoUS/20260607-utCodeAgentCLI-US-USER-02-UserStory.md`
  - `.catdd/spec/todoUS/20260607-utCodeAgentCLI-US-USER-03-UserStory.md`
  - `.catdd/spec/todoUS/20260607-utCodeAgentCLI-US-USER-04-UserStory.md`
  - `.catdd/spec/todoUS/20260607-utCodeAgentCLI-US-USER-05-UserStory.md`
  - `.catdd/spec/todoUS/20260607-utCodeAgentCLI-US-USER-09-UserStory.md`
  - `.catdd/spec/todoUS/20260607-utCodeAgentCLI-US-USER-10-UserStory.md`
- Active user stories opened: none.
- Shared module UserStory doc created: `codeAgents/utCodeAgentCLI/README_UserStory.md` and `codeAgents/utCodeAgentCLI/README_UserStory_ZH.md`.
- Shared module ArchDesign doc created: `codeAgents/utCodeAgentCLI/README_ArchDesign.md` and `codeAgents/utCodeAgentCLI/README_ArchDesign_ZH.md`; latest draft includes the runtime-language tradeoff review across TypeScript/Node.js, Python, and Go, Mermaid-renderable C4-style architecture views, Px-SpecFlow architecture-oriented surface coverage, and an ADR link for the runtime choice.
- Current `utCodeAgentCLI` ArchDesign has `/SPEC_reviewArchDesign` PASS recorded on 2026-06-03; the runtime-language ADR is now DECIDED: TypeScript/Node.js for V1 (PoC) and Go pre-selected for V2 (production distribution), Python evaluated and not selected. ADR status updated to Decided in `codeAgents/utCodeAgentCLI/ADRs/ADR_RuntimeLanguage.md`.
- Shared module DetailDesign doc created: `codeAgents/utCodeAgentCLI/README_DetailDesign.md` and `codeAgents/utCodeAgentCLI/README_DetailDesign_ZH.md`; latest draft includes TypeScript-facing parser, planner, executor, adapter, trace, diagnostics, state, error, and verification contracts; `/SPEC_reviewDetailDesign` PASS recorded on 2026-06-04.
- Current `utCodeAgentCLI` story/design readiness has `/SPEC_reviewUserStory` PASS recorded on 2026-06-04 and the story itself is archived in `doneUS/`.
- `US-USER-01` lifecycle was completed on 2026-06-08: `/SPEC_reviewProductCodes` PASS, `/SPEC_commitWorks` commit `3a98908`, CaTDD category correction commit `90268f7`, and closure through `/SPEC_closeUserStory`.

## Next Recommended Command

Run this next after context review:

- `/SPEC_analyzeIssue` to convert one pending issue in `.catdd/spec/pendingNews/` into a traceable todo user story and move its raw input into `.catdd/spec/analyzedNews/`.

## Assumptions To Confirm

- The current self-install is intentional for using MyCaTDD as its own target project.
- `.github/instructions/catdd.instructions.md` should be committed for this source repository, not treated only as local generated target-project state.
- Empty lifecycle directories do not need placeholder files unless the team wants them visible in Git before they contain artifacts.

## Open Questions

- Which user role should be treated as primary when prioritizing `utCodeAgentCLI` User Stories: developer, CodeAgent, maintainer, or tooling author?
- Should the self-installed `.github/instructions/catdd.instructions.md` become part of the repository's committed project instructions?
- Should the validation command list be expanded into a formal project-root `README_VerifyDesign.md` later?