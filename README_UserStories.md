# MyCaTDD User Stories

This file is the project-level ledger for SpecCoding user story lifecycle state (`TODO` / `DOING` / `SUSPENDED` / `DONE` / `ABORTED`) and CaTDD-AC traceability in `MyCaTDD`.

> **Historical note:** Earlier `utCodeAgentCLI` stories (now deprecated) tracked module-local ACs in [utCodeAgentCLI AC Status Dashboard](codeAgents/utCodeAgentCLI/README_UserStoryStatus.md) and closed archives under `.catdd/spec/doneUS/`. All new repository and `specCodeAgentCLI` stories register here per `CaTDD_methodPrompt-testStructure.md#project-wide-traceability-ids`.

## Story Identity Registry

| Story ID | StoryIdAlias | CreatedAt (UTC+08:00) | Authoritative Story / AC Source | Source IDs / Revision | Parent / Supersession |
| --- | --- | --- | --- | --- | --- |
| `US-specDeveloper-defineSpecCodeAgentCliUsageContract` | `US-261111.220010` | `2026-11-11T22:00:10+08:00` | `.catdd/spec/doingUS/20261111-design-specCodeAgentCLI-usage-contract-UserStory.md` | `.catdd/spec/analyzedNews/20261111-design-specCodeAgentCLI-usage-contract-Feature.md` | Supersedes deprecated `utCodeAgentCLI` CLI contract direction |
| `US-SPECFLOW-REPAIR-01` | legacy (pre-alias; created `2026-08-30`, exact time unrecorded) | `2026-08-30` (legacy date-only; alias allocation blocked per identity contract) | `.catdd/spec/abortUS/20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md` | `AC-01..AC-05` in aborted story | Aborted when `utCodeAgentCLI` was deprecated on `2026-11-11` |

## Legacy Identity Mappings

None for `specCodeAgentCLI`. Legacy `utCodeAgentCLI` story/AC identities remain preserved in `.catdd/spec/doneUS/`, `.catdd/spec/todoUS/`, `.catdd/spec/abortUS/`, and `codeAgents/utCodeAgentCLI/README_UserStoryStatus.md` without renumbering.

## Story Ledger

### TODO / DOING Stories

| Story ID | Title | State | Source | Trace Link |
| --- | --- | --- | --- | --- |
| `US-specDeveloper-defineSpecCodeAgentCliUsageContract` | Define unified `specCodeAgentCLI` CLI UsageDesign contract | `doing` | Analyzed feature (`BRAINSTORM`) | [.catdd/spec/doingUS/20261111-design-specCodeAgentCLI-usage-contract-UserStory.md](.catdd/spec/doingUS/20261111-design-specCodeAgentCLI-usage-contract-UserStory.md) |

### SUSPENDED Stories

| Story ID | Title | Suspended On | Resume Reference | Trace Link |
| --- | --- | --- | --- | --- |
| None | — | — | — | — |

### DONE Stories

| Story ID | Title | Closed On | Evidence | Trace Link |
| --- | --- | --- | --- | --- |
| Historical `utCodeAgentCLI` & `methodPrompts` / `slashCommands` stories | Closed prior to root ledger initialization | `2026-05-30` .. `2026-06-28` | Archived in `.catdd/spec/doneUS/` | [.catdd/spec/doneUS](.catdd/spec/doneUS) |

### ABORTED Stories

| Story ID | Title | Aborted On | Evidence / Successor | Trace Link |
| --- | --- | --- | --- | --- |
| `US-SPECFLOW-REPAIR-01` | Reconcile `utCodeAgentCLI` partial closure and lifecycle evidence | `2026-11-11` | `scope-gap` (`span_commit_ref = 2178251`): `utCodeAgentCLI` deprecated in favor of unified `specCodeAgentCLI` (`followup_intent = undecided`) | [.catdd/spec/abortUS/20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md](.catdd/spec/abortUS/20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md) |

## Active Story

```text
US-specDeveloper-defineSpecCodeAgentCliUsageContract (US-261111.220010):
  As a SpecFlow developer and CLI operator,
  I want a unified bash-style CLI usage contract for specCodeAgentCLI across autonomousMode and manualMode,
  So that I can drive Px-SpecFlow headlessly from a --goal to terminal completion or ONE-MORE-THING halt, or step through explicit commands interactively without depending on deprecated utCodeAgentCLI.
```

## CaTDD-AC Ledger

| AC ID | Story | From | Given | When | Then | Counter | Status | Verification Trace |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `US-261111.220010-AC-Typical-01` | `US-specDeveloper-defineSpecCodeAgentCliUsageContract` | `EX-01`, `RULE-01`, `RULE-02` | Valid metaspec workspace and `implementation-oriented` story | `specCodeAgentCLI --goal "<xyz>"` runs in default `autonomousMode` | `MUST` plan via `SPEC_makePlan`, auto-advance deterministic Part 2.b `SPEC_*`/`TEST_*` steps, and exit at terminal `END` (`0`/`6`/`7`) without `utCodeAgentCLI` | Non-implementation story `MUST` halt (`10`) rather than auto-advance | `reviewed` | UsageDesign `USAGE-SC-001`, `USAGE-SC-002`; executable TCs deferred to implementation story |
| `US-261111.220010-AC-Typical-02` | `US-specDeveloper-defineSpecCodeAgentCliUsageContract` | `EX-02`, `RULE-01`, `RULE-03` | Valid metaspec workspace in `manualMode` | `specCodeAgentCLI --mode manualMode [--command <SLASH_CMD>]` runs | `MUST` run at most one explicit `Px-SpecFlow` step (default `SPEC_whatsNextTask`) and emit next-command choices for the user | `MUST NOT` auto-chain subsequent lifecycle steps in `manualMode` | `reviewed` | UsageDesign `USAGE-SC-003`, `USAGE-SC-004`; executable TCs deferred to implementation story |
| `US-261111.220010-AC-Typical-03` | `US-specDeveloper-defineSpecCodeAgentCliUsageContract` | `EX-03`, `RULE-04`, `RULE-05` | Valid invocation with `--json` / `--output` and `--config-file` | CLI emits execution report and loads runtime settings | `MUST` emit deterministic schema-versioned JSON, load LLM/backend settings from config file only, and redact secrets (`K-SEC-02`) | `MUST NOT` expose cleartext tokens or accept `--model`/`--backend` CLI flags | `reviewed` | UsageDesign `USAGE-SC-005`; executable TCs deferred to implementation story |
| `US-261111.220010-AC-Edge-01` | `US-specDeveloper-defineSpecCodeAgentCliUsageContract` | `EX-04`, `CEX-01`, `RULE-02`, `RULE-06` | `autonomousMode` hits non-implementation orientation, `ONE-MORE-THING`, or VibeCoding need | CLI evaluates orientation or step gate | `MUST` halt immediately, record mode handoff to `manualMode`, emit `status: manual_required`, and exit `10` | `implementation-oriented` story with clear evidence continues without halting | `reviewed` | UsageDesign `USAGE-SC-006`, `USAGE-SC-007`; executable TCs deferred to implementation story |
| `US-261111.220010-AC-Edge-02` | `US-specDeveloper-defineSpecCodeAgentCliUsageContract` | `EX-05`, `RULE-07` | Supported workspace (`.catdd/metaspec`, `.agents/metaspec`, or `.catdd/spec`) with `--dry-run` | CLI resolves workspace and previews plan | `MUST` resolve `metaspec_root` without mutating files or git state and exit `0` | Normal run without `--dry-run` writes lifecycle artifacts | `reviewed` | UsageDesign `USAGE-SC-008`; executable TCs deferred to implementation story |
| `US-261111.220010-AC-Misuse-01` | `US-specDeveloper-defineSpecCodeAgentCliUsageContract` | `CEX-02`, `RULE-02`, `RULE-04` | Caller omits `--goal` in `autonomousMode`, passes conflicting inputs, passes `--model`/`--backend`, or requests `SPEC_whatsWrong` in `autonomousMode` | CLI validates arguments | `MUST` fail fast with zero writes, print actionable diagnostic to `stderr`, and exit `2` | Valid `--mode manualMode` without `--goal` succeeds via `SPEC_whatsNextTask` | `reviewed` | UsageDesign `USAGE-SC-009`..`USAGE-SC-011`; executable TCs deferred to implementation story |
| `US-261111.220010-AC-Misuse-02` | `US-specDeveloper-defineSpecCodeAgentCliUsageContract` | `CEX-03`, `RULE-07` | Caller supplies unsupported `--metaspec-root` or path-traversal path (`K-SEC-01`) | CLI validates path boundaries | `MUST` reject before command dispatch, emit diagnostic on `stderr`, and exit `2` | Supported relative `metaspec_root` inside repo root is accepted | `reviewed` | UsageDesign `USAGE-SC-012`; executable TCs deferred to implementation story |
| `US-261111.220010-AC-Fault-01` | `US-specDeveloper-defineSpecCodeAgentCliUsageContract` | `CEX-04`, `RULE-07` | Multiple populated metaspec roots, missing/invalid `--config-file` or `--inputFile`, or missing `.catdd/` assets | CLI resolves workspace and dependencies | `MUST` stop without merging or guessing, cite remediation (`HARNESS_migrateMetaspec` / `HARNESS_diagnoseInstallation`), and exit `3` | Single valid workspace and readable config/assets proceed | `reviewed` | UsageDesign `USAGE-SC-013`, `USAGE-SC-014`; executable TCs deferred to implementation story |
| `US-261111.220010-AC-Fault-02` | `US-specDeveloper-defineSpecCodeAgentCliUsageContract` | `CEX-05`, `RULE-08` | Retry/rework budget exhausted (`maxStepRetry = 2`, `maxRunCorrectionLoop = 3`) or external dependency fails | Loop Guard triggers during execution | `MUST` stop bounded loop, preserve clean baseline, emit failure diagnostics, and exit `5` or `6` | Transient single failure recovering within budget proceeds | `reviewed` | UsageDesign `USAGE-SC-015`; executable TCs deferred to implementation story |

## Lifecycle Links

- Pending inbox: `.catdd/spec/pendingNews/`
- Analyzed archive: `.catdd/spec/analyzedNews/20261111-design-specCodeAgentCLI-usage-contract-Feature.md`
- Todo queue: `.catdd/spec/todoUS/`
- Active story: `.catdd/spec/doingUS/20261111-design-specCodeAgentCLI-usage-contract-UserStory.md`
- Active tasks: `.catdd/spec/doingUS/20261111-design-specCodeAgentCLI-usage-contract-UserStory-Tasks.md`
- Aborted archive: `.catdd/spec/abortUS/20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md`
- Done archive: `.catdd/spec/doneUS/`

## Sync Rules

- Keep each opened story in `TODO / DOING` until closure is complete.
- Move a story to `SUSPENDED` only when a durable resume reference (such as a git branch or worktree) exists.
- Move a story to `DONE` only when closure evidence exists (review + commit + verification).
- Preserve registered `Story ID`, `StoryIdAlias`, and `CreatedAt` across lifecycle moves.
- Do not leave story ID state mismatches between this ledger and `.catdd/spec/*US/` artifacts.

## Traceability Notes

- Active CLI usage design: [specCodeAgentCLI UsageDesign](codeAgents/specCodeAgentCLI/README_UsageDesign.md)
- Active CLI overview: [specCodeAgentCLI README](codeAgents/specCodeAgentCLI/README.md)
- Project ubiquitous language: [README_UbiLang](README_UbiLang.md)
- Verification routing index: [README_VerifyDesign](README_VerifyDesign.md)
- Project user guide: [README_UserGuide](README_UserGuide.md)

## Usage Example

Run from the project root to inspect registered story identities and active CaTDD-AC statuses:

```bash
grep -E '^\| `US-' README_UserStories.md
```

Expected result: registered `Story ID`, `StoryIdAlias`, lifecycle state, and `US-261111.220010-AC-*` rows are printed cleanly.

## Maintenance Rule

Keep this file as the mandatory project-level ledger for `TODO` / `DOING` / `DONE` / `ABORTED` and CaTDD-AC status. Keep active task checklists and trajectories in `.catdd/spec/doingUS/` until the story closes.
