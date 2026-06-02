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
- `.catdd/spec/` has been initialized with `pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, and `doneUS/` directories.
- Analyzed raw issues archived:
  - `.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md`
  - `.catdd/spec/analyzedNews/20260531-add-SPEC_takeArchDesign-command-Issue.md`
  - `.catdd/spec/analyzedNews/20260530-design-utCodeAgentCLI-architecture-Issue.md`
  - `.catdd/spec/analyzedNews/20260602-add-SPEC_reviewDesignGates-commands-Feature.md`
- Pending feature requests imported:
  - None currently.
- Completed user stories:
  - `.catdd/spec/doneUS/20260530-assemble-utCodeAgentCLI-user-stories-UserStory.md`
  - `.catdd/spec/doneUS/20260531-add-SPEC_takeArchDesign-command-UserStory.md`
- Todo user stories waiting:
  - `.catdd/spec/todoUS/20260602-add-SPEC_reviewDesignGates-commands-UserStory.md`
- Active user stories opened:
  - `.catdd/spec/doingUS/20260530-design-utCodeAgentCLI-architecture-UserStory.md` for `utCodeAgentCLI` architecture design; architecture draft created.
- Shared module UserStory doc created: `codeAgents/utCodeAgentCLI/README_UserStory.md` and `codeAgents/utCodeAgentCLI/README_UserStory_ZH.md`.
- Shared module ArchDesign doc created: `codeAgents/utCodeAgentCLI/README_ArchDesign.md` and `codeAgents/utCodeAgentCLI/README_ArchDesign_ZH.md`; latest draft includes C4-style architecture views and Px-SpecFlow architecture-oriented surface coverage for usage, error, resource, performance, compatibility, diagnosis, verification, state, and embedded/media applicability.

## Next Recommended Command

Run one of these after context review:

- `/SPEC_openUserStory` on `.catdd/spec/todoUS/20260602-add-SPEC_reviewDesignGates-commands-UserStory.md` to open the user story for adding the review gates.
- `/SPEC_takeDetailDesign` on `.catdd/spec/doingUS/20260530-design-utCodeAgentCLI-architecture-UserStory.md` to convert the architecture into detailed TypeScript-facing contracts, data schemas, and verification design.
- `/SPEC_importIssue` when another work item starts from a bug, issue, defect, or corrective task.
- `/SPEC_importFeature` when another work item starts from a feature idea, enhancement, or design improvement.
- `/SPEC_updateProjectContext` when any project fact, convention, or guardrail in this file needs correction.

## Assumptions To Confirm

- The current self-install is intentional for using MyCaTDD as its own target project.
- `.github/instructions/catdd.instructions.md` should be committed for this source repository, not treated only as local generated target-project state.
- Empty lifecycle directories do not need placeholder files unless the team wants them visible in Git before they contain artifacts.

## Open Questions

- Which user role should be treated as primary when prioritizing `utCodeAgentCLI` User Stories: developer, CodeAgent, maintainer, or tooling author?
- Should the self-installed `.github/instructions/catdd.instructions.md` become part of the repository's committed project instructions?
- Should the validation command list be expanded into a formal project-root `README_VerifyDesign.md` later?