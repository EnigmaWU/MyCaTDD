# MyCaTDD SpecFlow Project Context

Initialized by `/SPEC_initProjectContext` on 2026-05-29.

This file is the team-shared, always-loaded working memory for SpecCoding in this repository. Keep project-wide guardrails and broadly reused facts here; retrieve module detail, lifecycle state, and history from the canonical routes below.

## Project Facts

- Repository: `MyCaTDD`.
- Owner: `EnigmaWU`.
- Default branch: `main`.
- Purpose: productize CaTDD from method text into commandized, automated, and reusable CodeAgent workflows.
- CaTDD means Comment-alive Test-Driven Development, invented by EnigmaWU.
- `SPEC = youWantR + iWhyD + aiHowC` and the distinction between `SPEC` and `metaspec` are defined canonically in [README_UbiLang](../../README_UbiLang.md); do not redefine them here.
- Core slogan: `Comments is Verification Design. LLM Generates Code. Iterate Forward Together.`
- The repository is both the CaTDD source repository and, after self-install, a target project for exercising its own `SPEC_*` workflow.

## Layer Model

| Layer | Path | Responsibility |
| --- | --- | --- |
| Method source | `methodPrompts/` | Owns CaTDD semantics, category meanings, US/AC/TC skeleton rules, status discipline, and implementation templates. |
| Command flow | `slashCommands/` | Owns portable `TEST_*`, `SPEC_*`, and `HARNESS_*` command contracts, flow order, input/output handoff, and tool-neutral execution rules. |
| Native CLI execution | `codeAgents/specCodeAgentCLI/` | Owns the active unified CaTDD-native CLI orchestration layer over `Px-SpecFlow`, `methodPrompts/`, and `slashCommands/` (`autonomousMode` by default inside the `implementation-oriented` boundary; `manualMode` step-by-step control otherwise). Legacy `codeAgents/utCodeAgentCLI/` is **deprecated** and retained only as historical/regression reference. |
| Skill packaging | `agentSkills/` | Owns reusable CodeAgent skill packages that reference the canonical method and command assets. |

## Agent Instruction Surfaces

| Surface | Scope | Provenance & Region Ownership | Operating Conventions Owned |
| --- | --- | --- | --- |
| `AGENTS.md` | Repository root | `catdd-created` (`CaTDD Codex instructions` managed region only; no hand-written region outside markers) | Projects `.catdd/` sources, metaspec workspace resolution, explicit SpecFlow intake, and `ONE-MORE-THING` ask-if-unsure behavior for Codex/agent sessions. |

## Installed Project Surface

After self-install with `scripts/installCaTDD.sh --targetDir "$PWD" --targetCodeAgent Copilot --init --clean-prompts`:

- `.catdd/methodPrompts/` contains installed CaTDD method source for target-project usage.
- `.catdd/slashCommands/` contains installed portable flow-command source.
- `.catdd/spec/` contains SpecCoding lifecycle artifacts.
- `.github/prompts/TEST_*.prompt.md`, `.github/prompts/SPEC_*.prompt.md`, and `.github/prompts/HARNESS_*.prompt.md` are generated Copilot adapters and are gitignored in this source repo.
- `.github/instructions/catdd.instructions.md` is a tracked team-shared instruction that points Copilot agents at the installed `.catdd/` assets.

## Stable Conventions

- Preserve the documentation split: `README.md` explains WHAT/WHY; `README_UserGuide.md` explains HOW/WHO/WHEN/WHERE.
- Keep English and Chinese README mirrors aligned by heading structure.
- Do not redefine CaTDD method semantics in `slashCommands/`, `codeAgents/`, or native prompt wrappers; refer back to `methodPrompts/`.
- Treat native wrappers as thin, regenerable adapters over `.catdd/slashCommands/` or `slashCommands/`.
- Commit `.catdd/spec/projectContext.md`, shared lifecycle artifacts under `.catdd/spec/`, and stable project-root `README*` SPEC docs.
- Keep local SpecCoding work-state trace gitignored: `.catdd/spec/WorkingProcessLog.md`.
- `SPEC_*` commands may orchestrate `TEST_*` commands, but must not replace P0/P1/P2 category rules.
- `SPEC_clearStoryIntent` is the early mutual-intent gate after `SPEC_openUserStory`; it records developer intent and CodeAgent intent before design begins. It does not replace the final `SPEC_reviewUserStory` readiness gate after detail design.
- `specCodeAgentCLI` is the single active CLI layer under `codeAgents/` and has no dependency on `utCodeAgentCLI`; LLM/backend provider settings live in its config file rather than CLI flags.
- `utCodeAgentCLI` is deprecated (historical context at [projectContext-utCodeAgentCLI](projectContext-utCodeAgentCLI.md)); keep its existing files intact only for repository mirror/contract regression tests.

## Constitutional Invariants (K)

Non-negotiable security, safety, and governance guardrails governing all CodeAgent generation, specification authoring, and verification design in this repository:

- `K-SEC-01 (Proactive CWE Exclusion)`: Code generation and test design must proactively eliminate high-risk weakness classes (injection CWE-89/78, path traversal CWE-22, insecure deserialization CWE-502) through safe APIs, parameterized interfaces, and bounded parsers by construction.
- `K-SEC-02 (Credential & Secret Isolation)`: Sensitive credentials, ApiKEYs, tokens, passphrases, and private keys must never be output in cleartext in logs, exceptions, traces, test assertions, comments, or terminal output; masking and redaction are mandatory.
- `K-SEC-03 (Least Privilege & Mutative Tool Sandboxing)`: Operations that mutate state (modifying filesystem, altering databases, executing external scripts, force pushing git) require explicit human approval or sandboxing; read-only inspection operations may proceed autonomously.
- `K-SEC-04 (Deterministic Verification Oracles)`: Security verification must prove concrete protection properties via observable oracles (access denied, exception raised, status 401/403, sanitized output, redacting secrets); vacuous truthiness assertions or mock-asserting-mock are strictly forbidden.

## SUT Unit Convention

The boundary treated as one **Unit** for CaTDD unit tests in this project:

- Default scope: `module-interface` — one cohesive public boundary surfaced by a module or submodule.
- Rationale: MyCaTDD is organized around self-contained layers (`methodPrompts/`, `slashCommands/`, `codeAgents/specCodeAgentCLI/`, `agentSkills/`); each module interface is large enough to define meaningful behavior and small enough to design tests against without leaking unrelated internals.
- Example SUT names:
  - `SUT: methodPrompts` for the CaTDD method layer.
  - `SUT: slashCommands` for the portable command flow layer.
  - `SUT: specCodeAgentCLI` for the unified CaTDD-native CLI module.
- A single file such as a `*.H` header, a single class, or a single slash command may become the unit when the module interface is too coarse; record the exception in the story-level verification design.
- Update this convention through `SPEC_updateProjectContext` if the project later decides on a different default granularity.

## Canonical Knowledge Routes

| Knowledge | Canonical source | Retrieval rule |
| --- | --- | --- |
| CaTDD semantics, category meanings, skeleton rules, and status discipline | [methodPrompts](../../methodPrompts/README.md) and `methodPrompts/` | Read before interpreting or changing the method; project context must not redefine it. |
| SpecFlow lifecycle, command ownership, and artifact policy | [Px-SpecFlow](../../slashCommands/flows/Px-SpecFlow.md) and `slashCommands/commands/` | Read for `SPEC_*` orchestration and `TEST_*` handoff rules. |
| `specCodeAgentCLI` overview, execution-mode boundary, and CLI usage contract | [specCodeAgentCLI README](../../codeAgents/specCodeAgentCLI/README.md) and `codeAgents/specCodeAgentCLI/README_UsageDesign.md` | Read before changing unified CLI inputs, modes, output contracts, exit codes, or lifecycle orchestration. |
| Deprecated `utCodeAgentCLI` historical artifacts and policy | [projectContext-utCodeAgentCLI](projectContext-utCodeAgentCLI.md) and [utCodeAgentCLI README](../../codeAgents/utCodeAgentCLI/README.md) | Historical reference only; do not add new features or active stories to `utCodeAgentCLI`. |
| Verification design and traceability | [README_VerifyDesign](../../README_VerifyDesign.md) routing index; `README_ArchVerifyDesign.md` for `SysTesting`/`UserTesting` and `README_DetailVerifyDesign.md` for `UnitTesting` once instantiated; module `README_*VerifyDesign.md` files | Read the project or module scope relevant to the active story. Live status belongs in `README_VerifyStatusTraces.md` when present, otherwise in story TASKs or test-file comments. |

## Validation Commands

Use these commands as the default validation surface for documentation and command packaging changes:

```bash
bash scripts/check_readme_mirror.sh
bash scripts/test_documentation_contract.sh
bash scripts/test_slashcommands_complete.sh
bash scripts/test_installCaTDD.sh
```

Use focused checks such as `git diff --check -- <files>` for edited Markdown or shell files before committing.

## SpecFlow Lifecycle State

metaspec_root: .catdd/spec

- Lifecycle state is operational memory. Do not store directory snapshots, filenames, counts, or next-task recommendations in this file.
- Before reading or updating lifecycle state, inspect all live directories and use that output as the source of truth:

```bash
ls -lrt .catdd/spec/pendingNews .catdd/spec/analyzedNews .catdd/spec/todoUS .catdd/spec/doingUS .catdd/spec/suspendUS .catdd/spec/doneUS .catdd/spec/abortUS
```

- If a directory is absent, report the absence instead of inventing state. Use `/SPEC_whatsNextTask` to derive the next action from current artifacts.
- Completed and aborted work remains available from `doneUS/`, `abortUS/`, ADRs, review artifacts, and Git history when rationale or diagnosis is needed.

## Open Questions

- None at project scope. Module-specific questions live in their canonical requirement and design documents.
