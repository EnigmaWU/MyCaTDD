# specCodeAgentCLI Lite CLI Usage Design

This document defines the public bash-style CLI usage contract for `specCodeAgentCLI`, instantiated from [README_UsageDesignLiteCliTemplate](../../slashCommands/templates/README_UsageDesignLiteCliTemplate.md).

- **Active Story:** `US-specDeveloper-defineSpecCodeAgentCliUsageContract` (`US-261111.220010`)
- **Story Artifact:** [.catdd/spec/doingUS/20261111-design-specCodeAgentCLI-usage-contract-UserStory](../../.catdd/spec/doingUS/20261111-design-specCodeAgentCLI-usage-contract-UserStory.md)
- **Project Story Ledger:** [README_UserStories](../../README_UserStories.md)
- **Implementation Status:** Design contract only (`specCodeAgentCLI` does not yet ship a runnable binary). Deprecated `utCodeAgentCLI` is retained as historical reference only; `specCodeAgentCLI` is the single unified CaTDD-native CLI runner with zero dependency on `utCodeAgentCLI`.

## Who

- **Primary user:** Software developer or SpecFlow operator driving feature/issue delivery from shell terminals, scripts, or CI pipelines.
- **Secondary user:** Repository maintainer, reviewer, or release automation job inspecting lifecycle status, gate verdicts, and installation health.
- **Assistant consumer:** Parent CodeAgent, cron runner, or CI orchestrator invoking `specCodeAgentCLI` non-interactively and branching on deterministic exit codes and JSON reports.

## What

`specCodeAgentCLI` is the unified bash-style CaTDD-native CLI that executes `Px-SpecFlow` directly over `methodPrompts/` and `slashCommands/` (`SPEC_*`, orchestrated `TEST_*`, `Px-StatusKits`, and `Px-HarnessKits`) across two explicit execution modes:

- **`autonomousMode` (default):** Accepts `--goal "<xyz>"`, runs `SPEC_makePlan`, and drives `implementation-oriented` story work forward to terminal `END` (`SPEC_closeUserStory`, `SPEC_abortUserStory`, or `SPEC_suspendUserStory`) — or halts immediately (`exit 10`) on `ONE-MORE-THING` ambiguity or non-implementation orientation boundaries.
- **`manualMode` (`--mode manualMode`):** Executes at most one explicit `Px-SpecFlow` command per invocation (defaulting to `SPEC_whatsNextTask` when `--command` is omitted) and prints the current gate/state plus selectable next commands so the user chooses what runs next.

The interface is optimized for:

- Copy-paste shell use from the project root.
- Scripted automation in CI, git hooks, or multi-agent pipelines.
- Stable `stdout` / `stderr` separation and deterministic exit-code contracts (`0..10`).
- Non-interactive execution by default (no hidden TUI prompts; `ONE-MORE-THING` halts cleanly with structured output).
- Strict separation between workflow CLI flags and LLM/backend runtime configuration (`--config-file` only).

## When

Use `specCodeAgentCLI` when:

- Driving an `implementation-oriented` user story autonomously from `--goal "<xyz>"` through test design, RED/GREEN implementation, reviews, planned commits, and story closure (`autonomousMode`).
- Stepping through `Px-SpecFlow` one command at a time (`SPEC_importFeature`, `SPEC_analyzeFeature`, `SPEC_openUserStory`, `SPEC_makePlan`, `SPEC_takeArchDesign`, `SPEC_takeDetailDesign`, `SPEC_designTests`, `TEST_implTestCase`, `SPEC_showMeStatus`, `HARNESS_verifyInstallation`, etc.) while keeping human choice between steps (`--mode manualMode`).
- Querying SpecCoding, Unit-Test, or Harness status in CI or shell scripts via `--mode manualMode --command SPEC_showMeStatus --json`.
- Previewing workspace resolution, planned command sequences, and commit boundaries safely via `--dry-run`.

Do not use `specCodeAgentCLI` when:

- Expecting `autonomousMode` to invent requirements, approve architecture trade-offs, or guess answers to `ONE-MORE-THING` questions (those boundaries intentionally halt with exit `10` and hand control back to `manualMode`).
- Running an interactive `VibeCoding` excursion (`SPEC_whatsWrong`), which requires live human conversational steering in an interactive chat session and is never valid in `autonomousMode`.
- Passing ad hoc LLM provider or model flags on the command line (all LLM/backend/model tier settings belong exclusively in `--config-file`).

## Where

- **Command entry point:** `specCodeAgentCLI` (installed on `PATH` or invoked via project wrapper script once implemented).
- **Working directory requirement:** Target repository root (or any subdirectory inside a repository whose root contains `.catdd/` or a supported `metaspec_root`).
- **Reads from:**
  - CLI options and workflow environment variables (`SPECCLI_*`), plus optional `stdin` when `--stdin` is passed.
  - Installed CaTDD method and command sources (`.catdd/methodPrompts/` and `.catdd/slashCommands/`, including any local `*Evolved.md` overlays; falls back to source-repo `methodPrompts/` and `slashCommands/` when running inside `MyCaTDD`).
  - Resolved `metaspec_root` per [MetaspecWorkspaceResolution](../../.catdd/slashCommands/MetaspecWorkspaceResolution.md): `.catdd/metaspec` (canonical default), `.agents/metaspec` (agent-owned), or `.catdd/spec` (legacy compatibility).
  - Runtime configuration file (default: `.catdd/specCodeAgentCLI/config.yaml`) for LLM backend, model tiers, `ApiKEY` env-var references, and Loop Guard bounds.
- **Writes to:**
  - `stdout`: concise human execution summary by default, or deterministic JSON report when `--json` is passed.
  - `stderr`: structured progress logs, `--diagMethodPrompts` / `--diagSlashCommands` traces, warnings, and validation/halt diagnostics.
  - Resolved `<metaspec_root>/` lanes (`pendingNews/`, `analyzedNews/`, `todoUS/`, `doingUS/`, `suspendUS/`, `abortUS/`, `doneUS/`, `projectContext.md`, gitignored `WorkingProcessLog.md`), project-root `README*` SPEC docs, test files, product source files, and optional `--output <path>` JSON report (zero writes when `--dry-run` is active).
- **Related overview:** [specCodeAgentCLI README](README.md)
- **Container overview:** [codeAgents README](../README.md)
- **Governing flow:** [Px-SpecFlow](../../slashCommands/flows/Px-SpecFlow.md)
- **Project story ledger:** [README_UserStories](../../README_UserStories.md)
- **Verification routing:** [README_VerifyDesign](../../README_VerifyDesign.md)

## Why

- **Outcome:** One coherent, scriptable CaTDD-native CLI drives both autonomous implementation loops and manual step-by-step SpecCoding without splitting orchestration across `specCodeAgentCLI` and the deprecated `utCodeAgentCLI`.
- **Risk reduced:** Eliminates silent requirement guessing in headless runs, prevents cross-tool drift between `SPEC_*` and `TEST_*` steps, avoids leaking provider/model flags into build scripts, and gives shell callers distinct exit codes for completion (`0`), gate rework (`4`), abort (`6`), suspend (`7`), and human-decision halts (`10`).
- **Success signal:** Any caller can express autonomous goal execution (`specCodeAgentCLI --goal "..."`) or manual step execution (`specCodeAgentCLI --mode manualMode --command ...`) with predictable `stdout`, `stderr`, exit codes, and full `US -> CaTDD-AC -> TP -> TC` traceability.

## Usage Outcome Model

| Layer | Design answer |
| --- | --- |
| **Outcome** | Traceable SpecCoding progression from goal or explicit command to either a verified lifecycle checkpoint (`END` / single step) or a safe, structured `ONE-MORE-THING` human handoff. |
| **Outputs** | Updated `<metaspec_root>/` and project artifacts (unless read-only or `--dry-run`), planned git commits (when applicable), human summary or schema-versioned JSON on `stdout`, diagnostics on `stderr`, and exit code `0..10`. |
| **Process** | Validate CLI options and path boundaries -> load `--config-file` -> resolve single `metaspec_root` and `.catdd/` assets -> dispatch `autonomousMode` (`SPEC_makePlan` -> orientation gate -> bounded Part 2.b loop -> terminal commit/close or `manual_required` halt) or `manualMode` (execute single `--command` -> report gate verdict and next-step choices). |
| **Scenarios** | Autonomous implementation-to-close (`0`), autonomous orientation/`ONE-MORE-THING` halt (`10`), manual next-task inspection (`0`), manual single-command execution (`0`/`4`), dry-run preview (`0`), JSON output with secret redaction (`0`), caller flag/path misuse (`2`), workspace/config fault (`3`), and Loop Guard exhaustion (`5`/`6`). |
| **Inputs** | `--mode`, `--goal`, `--command`, `--target`, `--input` / `--inputFile` / `--stdin`, `--analysis-mode`, `--metaspec-root`, `--reference`, `--extra-prompt`, `--config-file`, `--output`, `--json`, `--dry-run`, `--log-level`, `--diagMethodPrompts`, `--diagSlashCommands`, and `SPECCLI_*` env vars. |

## Execution Mode Model: autonomousMode vs manualMode

| Dimension | `autonomousMode` (Default) | `manualMode` (`--mode manualMode`) |
| --- | --- | --- |
| **Primary invocation** | `specCodeAgentCLI --goal "<xyz>" [OPTIONS]` | `specCodeAgentCLI --mode manualMode [--command <SLASH_CMD>] [OPTIONS]` |
| **Required arguments** | `--goal "<xyz>"` is **mandatory** | `--goal` is optional; `--command` defaults to `SPEC_whatsNextTask` |
| **Planning & progression** | Runs `SPEC_makePlan` / `SPEC_updateMadePlan` and auto-chains safe Part 2.b commands (`SPEC_designTests` -> `SPEC_implTests` -> `SPEC_reviewImplTests` -> `SPEC_implProductCodes` -> `SPEC_reviewProductCodes` -> `SPEC_reviewImplTests` -> `SPEC_commitStoryWorks` -> `SPEC_closeUserStory`) | Executes **at most one** portable `SPEC_*`, `TEST_*`, or `HARNESS_*` command, then stops and prints candidate next commands so the user chooses what runs next |
| **Orientation boundary** | **Strictly `implementation-oriented` only**; `intent-clearing`, `requirement-oriented`, or `design-oriented` stories immediately halt (`exit 10`), record `manualMode` in `*-UserStory-Tasks.md`, and hand control to the developer | Supports **all** orientations (`intent-clearing`, `requirement-oriented`, `design-oriented`, and `implementation-oriented`) plus pre-story intake/analysis |
| **`ONE-MORE-THING` rule** | Immediately halts, preserves evidence, outputs `status: manual_required: ONE-MORE-THING: <question>`, and exits `10` | Stops after the single step and surfaces the `ASK` / `ONE-MORE-THING` question and options (`exit 10`) |
| **Commit behavior** | Automatically runs `SPEC_commitStepWorks` at planned `commit_step = yes` boundaries and `SPEC_commitStoryWorks` at `pre_close` / `post_close` / `span_end` | Never auto-commits unless the caller explicitly invokes a `SPEC_commit*` command |
| **VibeCoding (`SPEC_whatsWrong`)** | Forbidden (`--command SPEC_whatsWrong` rejected with `exit 2`; unnameable runtime stalls halt with `exit 10`) | Allowed as an explicit command to freeze SpecFlow state and open a `manualMode` VibeCoding investigation record |

## CLI Synopsis

```text
# Autonomous mode (default): require --goal, plan, and drive to END or ONE-MORE-THING halt
specCodeAgentCLI --goal <STRING> [OPTIONS]

# Manual mode: run one explicit Px-SpecFlow step (default: SPEC_whatsNextTask) and let user choose next
specCodeAgentCLI --mode manualMode [--command <SLASH_CMD>] [OPTIONS]

Workflow options:
  --mode <MODE>               Execution mode: autonomousMode | manualMode (default: autonomousMode)
  --goal <STRING>             Natural language goal for the run (required in autonomousMode; optional in manualMode)
  --command <SLASH_CMD>       Portable command to run in manualMode (SPEC_*, TEST_*, HARNESS_*; default: SPEC_whatsNextTask),
                              or optional entry command in autonomousMode (SPEC_openUserStory | SPEC_resumeUserStory)
  --target <SELECTOR>         Story ID, StoryIdAlias (US-YYMMDD.HHMMSS), relative artifact path, or test selector (file::TC-ID)
  --input <STRING>            Inline source/context text (mutually exclusive with --inputFile and --stdin)
  --inputFile <FILE>          Path to source/issue/feature/story input file (mutually exclusive with --input and --stdin)
  --stdin                     Read raw source/context text from standard input (mutually exclusive with --input and --inputFile)
  --analysis-mode <MODE>      Local mode for SPEC_analyzeIssue / SPEC_analyzeFeature in manualMode: BRAINSTORM | AUTONOMOUS
  --metaspec-root <DIR>       Explicit workspace check: .catdd/metaspec | .agents/metaspec | .catdd/spec
  --reference <FILES>         Comma-separated relative or in-repo file paths for additional read-only context
  --extra-prompt <FILES>      Comma-separated file paths appended as supplementary prompt constraints

Output, config, and diagnostic options:
  --config-file <FILE>        Runtime & LLM config YAML (default: .catdd/specCodeAgentCLI/config.yaml)
  --json                      Format stdout as deterministic machine-readable JSON (schema v1)
  --output <FILE>             Write deterministic JSON execution report to FILE (in addition to stdout summary/JSON)
  --dry-run                   Resolve workspace and preview planned command/commit sequence without writing files or commits
  --log-level <LEVEL>         stderr log verbosity: debug | info | warn | error (default: info)
  --diagMethodPrompts         Emit DIAG lines on stderr listing resolved methodPrompts files and overlays
  --diagSlashCommands         Emit DIAG lines on stderr listing resolved slashCommands files and *Evolved.md overlays
  --help, -h                  Print CLI usage synopsis to stdout and exit 0
  --version, -V               Print specCodeAgentCLI version to stdout and exit 0
```

> **Config-Only LLM/Provider Rule:** `specCodeAgentCLI` intentionally exposes **no** `--model`, `--backend`, `--provider`, `--temperature`, or `--api-key` CLI flags. Passing any provider/model flag on the command line fails fast with exit code `2`; configure LLM providers and `Px-SpecFlow` model tiers exclusively in `--config-file`.

## Shell Contract

| Surface | Contract |
| --- | --- |
| **Invocation style** | Single bash-friendly command driven by `--mode` (`autonomousMode` default vs `manualMode`), composable in shell scripts, pipelines, and CI jobs. |
| **Interactivity** | Strictly non-interactive on TTY and non-TTY alike. Never blocks waiting for `read` input; human decisions surface via exit code `10` (`manual_required`) and structured output. |
| **`stdout`** | Human-readable execution summary by default; when `--json` is passed, `stdout` contains **only** valid UTF-8 JSON (`schema_version: "1.0"`). On option/file errors (`exit 2`/`3`) without `--json`, `stdout` is empty. |
| **`stderr`** | Structured log lines (`[specCodeAgentCLI][<LEVEL>] ...`), optional `[DIAG]` asset-resolution traces, and actionable error/remediation messages. Never pollutes JSON `stdout`. |
| **`stdin`** | Ignored by default (safe inside `while read` loops and background jobs); read until EOF only when `--stdin` is explicitly passed. |
| **Exit code** | `0` completed/passed; distinct non-zero codes `1..7`, `10`, and `130` defined in [Exit Codes](#exit-codes). |
| **Idempotency** | `--dry-run`, `SPEC_showMeStatus`, `TEST_showMeStatus`, `HARNESS_showMeStatus`, `SPEC_whatsNextTask`, and `HARNESS_verifyInstallation` are read-only and idempotent. Mutating steps preserve lane normalization (never duplicating a Story ID across lanes) and restore clean state on Loop Guard exhaustion. |
| **Filesystem writes** | Scoped to the resolved `metaspec_root`, in-scope repository files (`README*`, `src/`, `tests/`), and optional `--output <FILE>`. Zero persistent writes when `--dry-run` is set. |
| **Network use** | Outbound requests occur only through the LLM/provider adapter configured in `--config-file`; pure validation, `--help`, `--version`, and static status checks require no network. |
| **Secrets (`K-SEC-02`)** | Secrets and `ApiKEY` values are never accepted on CLI flags and never printed to `stdout`, `stderr`, `--output`, or `WorkingProcessLog.md`. `--config-file` references secret environment variable names (for example `api_key_env: OPENAI_API_KEY`), and output redaction masks token patterns automatically. |

## Argument Dictionary

| Name | Kind | Type/format | Values/range | Required | Default | Repeatable | Depends on/conflicts with | Validation failure |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `--mode` | option | enum | `autonomousMode` \| `manualMode` | no | `autonomousMode` | no | Overrides `SPECCLI_MODE` | Unknown mode -> `stderr` message + exit `2` |
| `--goal` | option | string | Non-empty UTF-8 text | yes in `autonomousMode`; no in `manualMode` | none | no | Required when effective mode is `autonomousMode` | Missing/blank in `autonomousMode` -> `stderr` + exit `2` |
| `--command` | option | command ID | Portable `SPEC_*`, `TEST_*`, or `HARNESS_*` name | no | `SPEC_whatsNextTask` in `manualMode`; flow-derived in `autonomousMode` | no | In `autonomousMode`, only entry commands (`SPEC_openUserStory`, `SPEC_resumeUserStory`) or omitted are valid; `SPEC_whatsWrong` conflicts with `autonomousMode` | Unknown command or mode conflict -> `stderr` + exit `2` |
| `--target` | option | selector | `StoryID`, `StoryIdAlias` (`US-YYMMDD.HHMMSS`), repo-relative path, or `file::TC-ID` | no | active story in `doingUS/` (when unique) | no | Must stay within repository root (`K-SEC-01`) | Path escape or ambiguous multi-story target -> `stderr` + exit `2` |
| `--input` | option | string | Non-empty inline text | no | none | no | Conflicts with `--inputFile` and `--stdin` | Exclusive conflict or blank value -> `stderr` + exit `2` |
| `--inputFile` | option | path | Existing readable file inside repo (or explicit safe path) | no | none | no | Conflicts with `--input` and `--stdin` | Conflict/escape -> exit `2`; missing/unreadable -> exit `3` |
| `--stdin` | flag | boolean | present/absent | no | `false` | no | Conflicts with `--input` and `--inputFile` | Conflict or empty `stdin` stream -> `stderr` + exit `2` |
| `--analysis-mode` | option | enum | `BRAINSTORM` \| `AUTONOMOUS` | no | `BRAINSTORM` | no | Valid only with `--mode manualMode` and `SPEC_analyzeIssue` / `SPEC_analyzeFeature` | Used outside analysis commands or in `autonomousMode` -> exit `2` |
| `--metaspec-root` | option | enum path | `.catdd/metaspec` \| `.agents/metaspec` \| `.catdd/spec` | no | Resolved via `projectContext.md` | no | Overrides `SPECCLI_METASPEC_ROOT`; must match `projectContext.md` if present | Unsupported path -> exit `2`; workspace drift -> exit `3` |
| `--reference` | option | path list | Comma-separated readable file paths | no | none | no | Paths must resolve inside repository root | Path escape -> exit `2`; missing file -> exit `3` |
| `--extra-prompt` | option | path list | Comma-separated readable file paths | no | none | no | Paths must resolve inside repository root | Path escape -> exit `2`; missing file -> exit `3` |
| `--config-file` | option | path | Readable YAML file | no | `.catdd/specCodeAgentCLI/config.yaml` | no | Overrides `SPECCLI_CONFIG_FILE` | Path escape -> exit `2`; missing/invalid YAML -> exit `3` |
| `--json` | flag | boolean | present/absent | no | `false` | no | Formats `stdout` as JSON schema v1 | n/a |
| `--output` | option | path | Writable file path (parent directory must exist) | no | none | no | Writes JSON schema v1 report to path | Unwritable/missing parent dir -> `stderr` + exit `3` |
| `--dry-run` | flag | boolean | present/absent | no | `false` | no | Suppresses all filesystem and git mutations | n/a |
| `--log-level` | option | enum | `debug` \| `info` \| `warn` \| `error` | no | `info` | no | Overrides `SPECCLI_LOG_LEVEL` | Unknown level -> `stderr` + exit `2` |
| `--diagMethodPrompts` | flag | boolean | present/absent | no | `false` | no | Emits `[DIAG][methodPrompts]` lines to `stderr` | n/a |
| `--diagSlashCommands` | flag | boolean | present/absent | no | `false` | no | Emits `[DIAG][slashCommands]` lines to `stderr` | n/a |
| `--help`, `-h` | flag | boolean | present/absent | no | `false` | no | Short-circuits execution; prints help on `stdout` | Exits `0` |
| `--version`, `-V` | flag | boolean | present/absent | no | `false` | no | Short-circuits execution; prints version on `stdout` | Exits `0` |
| `SPECCLI_MODE` | env var | enum | `autonomousMode` \| `manualMode` | no | unset | n/a | Overridden by `--mode` | Invalid value -> `stderr` + exit `2` |
| `SPECCLI_METASPEC_ROOT` | env var | enum path | `.catdd/metaspec` \| `.agents/metaspec` \| `.catdd/spec` | no | unset | n/a | Overridden by `--metaspec-root` | Invalid value -> `stderr` + exit `2` |
| `SPECCLI_CONFIG_FILE` | env var | path | Readable YAML file | no | unset | n/a | Overridden by `--config-file` | Missing/invalid YAML -> `stderr` + exit `3` |
| `SPECCLI_LOG_LEVEL` | env var | enum | `debug` \| `info` \| `warn` \| `error` | no | unset | n/a | Overridden by `--log-level` | Invalid value -> `stderr` + exit `2` |
| `stdin` | stream | UTF-8 text | Non-empty when `--stdin` is set | only with `--stdin` | ignored | n/a | Requires `--stdin`; conflicts with `--input` / `--inputFile` | Empty stream when `--stdin` set -> `stderr` + exit `2` |

## Config File Contract (LLM and Runtime Settings Only in Config)

All LLM provider, model-tier routing, credential env-var binding, and Loop Guard settings reside in `.catdd/specCodeAgentCLI/config.yaml` (or the file selected by `--config-file` / `SPECCLI_CONFIG_FILE`):

```yaml
schema_version: "1.0"

runtime:
  provider: "openai-compatible"          # adapter identifier owned by config, never a CLI flag
  endpoint: "https://api.example.com/v1"
  api_key_env: "SPECCLI_PROVIDER_APIKEY" # env var holding the ApiKEY; never store raw secrets in YAML

model_tiers:                             # aligned with Px-SpecFlow Model Tier Guidance
  sota_reasoning: "gpt-5.5-xhigh"        # SPEC_takeArchDesign, SPEC_reviewArchDesign
  high_performance: "gpt-5.4"            # analysis, makePlan, detail design, reviews, test design
  flash_speed: "gpt-5.4-mini"            # deterministic moves, commits, bounded impl slices

loop_guard:                              # aligned with SGRM Closed-Loop Regeneration Budget (B <= 3)
  max_step_retry: 2
  max_run_correction_loop: 3

git:
  allow_auto_commit_in_autonomous: true  # governs SPEC_commitStepWorks / SPEC_commitStoryWorks in autonomousMode
```

## Precedence Rules

When multiple sources can supply a workflow setting, `specCodeAgentCLI` resolves them in strict order:

1. **Explicit CLI option** (`--mode`, `--metaspec-root`, `--config-file`, `--log-level`).
2. **Workflow environment variable** (`SPECCLI_MODE`, `SPECCLI_METASPEC_ROOT`, `SPECCLI_CONFIG_FILE`, `SPECCLI_LOG_LEVEL`).
3. **Repository declaration / config file** (`metaspec_root` in `<metaspec_root>/projectContext.md`; runtime settings in `.catdd/specCodeAgentCLI/config.yaml`).
4. **Built-in default** (`--mode autonomousMode`, `--command SPEC_whatsNextTask` in `manualMode`, `--log-level info`, canonical `.catdd/metaspec` on fresh bootstrap).

Conflict and override invariants:

- Two mutually exclusive CLI flags (`--input` + `--inputFile`, `--input` + `--stdin`, `--inputFile` + `--stdin`) or any forbidden provider/model CLI flag (`--model`, `--backend`, `--api-key`) fail fast with exit `2` before reading or mutating lifecycle state.
- If `--metaspec-root` (or `SPECCLI_METASPEC_ROOT`) disagrees with the `metaspec_root` declared in `projectContext.md`, execution stops with configuration drift (`exit 3`) per `MetaspecWorkspaceResolution.md`.
- Local `<Name>Evolved.md` overlays beside canonical `.catdd/slashCommands/` artifacts take precedence automatically per CaTDD overlay rules and are surfaced when `--diagSlashCommands` is enabled.

## Command Resolution and Mode Compatibility Matrix

| Command / Flow Family | `autonomousMode` (`--goal "<xyz>"`) | `manualMode` (`--mode manualMode`) | Notes |
| --- | --- | --- | --- |
| `SPEC_whatsNextTask` | Used internally when inspecting state | **Default** when `--command` is omitted (`exit 0`) | Read-only recommendation |
| `SPEC_showMeStatus`, `TEST_showMeStatus`, `HARNESS_showMeStatus` | Not an autonomous entry; use `manualMode` | `--command <STATUS_CMD>` (`exit 0`) | Read-only StatusKits reports |
| `SPEC_initProjectContext`, `SPEC_updateProjectContext`, `SPEC_import*`, `SPEC_analyze*`, `SPEC_commitPreStoryWorks` | Rejected or halted (`exit 2` / `exit 10`): pre-story span is `manualMode`-only | `--command <SPEC_CMD>` (`--analysis-mode AUTONOMOUS` supported on `SPEC_analyze*`) | Pre-story intake and analysis |
| `SPEC_openUserStory`, `SPEC_resumeUserStory` | Valid entry before `SPEC_makePlan` when paired with `--goal` and `--target` | `--command SPEC_openUserStory --target <story>` | Transitions story into `doingUS/` |
| `SPEC_clearStoryIntent`, `SPEC_updateUserStory`, `SPEC_reviewUserStory`, `SPEC_take*Design`, `SPEC_update*Design`, `SPEC_review*Design` | Halts at `SPEC_makePlan` orientation boundary (`exit 10`, `manual_required`) | `--command <SPEC_CMD>` (`exit 0` on `PASS`, `exit 4` on `REVISE`/`BLOCKED`, `exit 10` on `ASK`) | Human intent & design governance |
| Part 2.b loop: `SPEC_designTests`, `SPEC_implTests`, `SPEC_reviewImplTests`, `SPEC_implProductCodes`, `SPEC_refactTests`, `SPEC_reviewProductCodes`, `SPEC_updateMadePlan` | **Auto-sequenced** to terminal state (orchestrating `TEST_*` contracts directly; zero `utCodeAgentCLI` dependency) | Each command invocable individually via `--command <SPEC_CMD>` | Core implementation-oriented loop |
| Direct `TEST_*` commands (`TEST_designFuncTestsSkeleton`, `TEST_implTestCase`, `TEST_reviewImplTestCase`, `TEST_tellMeNextImplTest`, etc.) | Orchestrated internally by `SPEC_designTests` / `SPEC_implTests` / `SPEC_refactTests` | Directly invocable via `--command <TEST_CMD> --target <file[::TC]>` | Replaces deprecated `utCodeAgentCLI` |
| `SPEC_commitStepWorks`, `SPEC_commitStoryWorks`, `SPEC_commitWorks`, `SPEC_closeUserStory`, `SPEC_abortUserStory`, `SPEC_suspendUserStory`, `SPEC_partialCloseUserStory`, `SPEC_mergeWorks` | Planned step/story commits and terminal transitions run automatically (`exit 0` close, `6` abort, `7` suspend) | Invocable individually via `--command <SPEC_CMD>` | Lifecycle commit & closure gates |
| `SPEC_whatsWrong` (VibeCoding switch) | **Forbidden** (`exit 2` if requested; `exit 10` if unnameable stall occurs) | `--command SPEC_whatsWrong` freezes SpecFlow lanes and records excursion | Requires human intent source |
| `HARNESS_verifyInstallation`, `HARNESS_diagnoseInstallation`, `HARNESS_diagnoseProject`, `HARNESS_migrateMetaspec`, `HARNESS_evolveHarness`, `HARNESS_newTaskSession`, `HARNESS_patchCaTDDSource` | Not part of autonomous story loop | Invocable via `--command <HARNESS_CMD>` (`--dry-run` default on `HARNESS_migrateMetaspec`) | Operational HarnessKits tools |

## Behavior Scenarios

| Scenario ID | Given | When | Then | `stdout` | `stderr` | Exit | Writes | Trace |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `USAGE-SC-001` | Valid `.catdd/metaspec`, config file, and active `implementation-oriented` story in `doingUS/` | `specCodeAgentCLI --goal "implement P0 tests and code for active retry story"` | Runs `SPEC_makePlan`/`SPEC_updateMadePlan`, auto-advances Part 2.b `SPEC_*` + `TEST_*` steps, commits planned spans, and closes story to `doneUS/` | Human completion summary (`terminal_state: closed`, `commit_ref`, `learning_command`) | `[INFO]` step progress logs | `0` | `doingUS -> doneUS`, `README_UserStories.md`, `src/`, `tests/`, git commits | `US-261111.220010-AC-Typical-01` |
| `USAGE-SC-002` | Valid workspace and queued `implementation-oriented` story `US-261111.220010` in `todoUS/` | `specCodeAgentCLI --command SPEC_openUserStory --target US-261111.220010 --goal "deliver P0 slice to closure"` | Opens story, runs `SPEC_makePlan`, verifies `implementation-oriented`, and drives Part 2.b to `SPEC_closeUserStory` | Human completion summary | `[INFO]` open + loop logs | `0` | `todoUS -> doneUS`, code, tests, commits | `US-261111.220010-AC-Typical-01` |
| `USAGE-SC-003` | Valid workspace in `manualMode` with `--command` omitted | `specCodeAgentCLI --mode manualMode` | Executes `SPEC_whatsNextTask` only and prints active gate plus selectable next commands | Human next-task summary & candidate commands | `[INFO]` workspace resolved | `0` | none | `US-261111.220010-AC-Typical-02` |
| `USAGE-SC-004` | Valid workspace with test skeleton file `tests/test_retry_funcValidTypical.ts` | `specCodeAgentCLI --mode manualMode --command TEST_implTestCase --target tests/test_retry_funcValidTypical.ts::US-261111.220010-TC-01 --inputFile src/retry.ts` | Executes single `TEST_implTestCase` step (valid RED), stops without chaining `SPEC_implProductCodes`, and prints next-step options | Step summary (`status: RED`, `next_command: TEST_reviewImplTestCase`) | `[INFO]` single-step log | `0` | Target test file & companion README only | `US-261111.220010-AC-Typical-02` |
| `USAGE-SC-005` | Valid config containing `api_key_env: SPECCLI_PROVIDER_APIKEY` and `--json --output /tmp/run.json` | `specCodeAgentCLI --mode manualMode --command SPEC_showMeStatus --json --output /tmp/run.json` | Emits schema-v1 JSON to `stdout` and `/tmp/run.json`, loads provider settings from config only, and redacts any secret pattern | Valid JSON (`schema_version: "1.0"`) | `[INFO]` redacted diagnostics | `0` | `/tmp/run.json` only | `US-261111.220010-AC-Typical-03` |
| `USAGE-SC-006` | Active story in `doingUS/` is classified by `SPEC_makePlan` as `design-oriented` | `specCodeAgentCLI --goal "finish design and code"` | Halts at orientation boundary, records `execution_mode: manualMode` in `*-UserStory-Tasks.md`, and reports `manual_required` | Structured halt summary (`status: manual_required`, `reason: orientation_boundary`) | `[WARN]` non-implementation orientation halt | `10` | `*-UserStory-Tasks.md` mode handoff only | `US-261111.220010-AC-Edge-01` |
| `USAGE-SC-007` | Active `implementation-oriented` run encounters ambiguous source threshold (`ONE-MORE-THING`) | `specCodeAgentCLI --goal "implement timeout policy"` | Halts immediately without guessing, preserves clean baseline, and outputs `ONE-MORE-THING` question | `status: manual_required: ONE-MORE-THING: <question>` | `[WARN]` halted on `ONE-MORE-THING` | `10` | `*-UserStory-Tasks.md` trajectory/mode record | `US-261111.220010-AC-Edge-01` |
| `USAGE-SC-008` | Legacy `.catdd/spec` workspace (such as `MyCaTDD`) invoked with `--dry-run` | `specCodeAgentCLI --goal "implement active story" --metaspec-root .catdd/spec --dry-run` | Resolves `.catdd/spec`, previews planned `SPEC_*`/`TEST_*` commands and commit spans, performs zero writes | Dry-run execution plan summary | `[INFO]` dry-run mode active | `0` | none | `US-261111.220010-AC-Edge-02` |
| `USAGE-SC-009` | Caller invokes default `autonomousMode` without `--goal` | `specCodeAgentCLI` | Fails fast before reading/mutating story lanes | empty | `[ERROR] --goal is required in autonomousMode` + synopsis hint | `2` | none | `US-261111.220010-AC-Misuse-01` |
| `USAGE-SC-010` | Caller passes both `--input` and `--inputFile` (or passes `--model gpt-5`) | `specCodeAgentCLI --mode manualMode --command SPEC_importIssue --input "bug" --inputFile bug.md` | Rejects conflicting/forbidden CLI options before dispatch | empty | `[ERROR] mutually exclusive options: --input, --inputFile` (or forbidden `--model` hint pointing to `--config-file`) | `2` | none | `US-261111.220010-AC-Misuse-01` |
| `USAGE-SC-011` | Caller requests `SPEC_whatsWrong` in `autonomousMode` | `specCodeAgentCLI --goal "debug" --command SPEC_whatsWrong` | Rejects VibeCoding command in headless `autonomousMode` | empty | `[ERROR] SPEC_whatsWrong requires --mode manualMode` | `2` | none | `US-261111.220010-AC-Misuse-01` |
| `USAGE-SC-012` | Caller supplies `--metaspec-root ../escape` or `--target ../../etc/passwd` | `specCodeAgentCLI --mode manualMode --metaspec-root ../escape` | Rejects unsupported root / path traversal (`K-SEC-01`) | empty | `[ERROR] invalid --metaspec-root '../escape': must be .catdd/metaspec, .agents/metaspec, or .catdd/spec` | `2` | none | `US-261111.220010-AC-Misuse-02` |
| `USAGE-SC-013` | Both `.catdd/metaspec` and `.catdd/spec` contain lifecycle files | `specCodeAgentCLI --mode manualMode --command SPEC_openUserStory --target US-01` | Stops without merging roots and recommends `HARNESS_migrateMetaspec` | empty | `[ERROR] multiple populated metaspec workspaces detected (.catdd/metaspec, .catdd/spec); run HARNESS_migrateMetaspec` | `3` | none | `US-261111.220010-AC-Fault-01` |
| `USAGE-SC-014` | `--config-file` or `--inputFile` is missing or invalid YAML, or `.catdd/slashCommands/` is missing | `specCodeAgentCLI --goal "run story" --config-file missing.yaml` | Stops before execution and reports exact unreadable/invalid path | empty | `[ERROR] unreadable config file: missing.yaml` (or `HARNESS_diagnoseInstallation` hint) | `3` | none | `US-261111.220010-AC-Fault-01` |
| `USAGE-SC-015` | `SPEC_implProductCodes` fails verification across `maxRunCorrectionLoop = 3` ($B = 3$) | `specCodeAgentCLI --goal "implement active story"` | Stops retry loop, restores last verified clean baseline, emits failure diagnostic, aborts/escalates story | Failure summary (`terminal_state: aborted`, `attempt_count: 3`) | `[ERROR] Loop Guard budget exhausted (B=3); clean baseline restored` | `6` | `doingUS -> abortUS` + `span_end` commit (clean code baseline) | `US-261111.220010-AC-Fault-02` |

## Output Contracts

### Human Output

- **`autonomousMode` terminal completion (`exit 0`):**

```text
status: completed
execution_mode: autonomousMode
effective_mode: autonomousMode
metaspec_root: .catdd/metaspec
story_id: US-paymentAdmin-capMerchantRetries (US-261111.093015)
executed_commands: SPEC_makePlan -> SPEC_designTests -> SPEC_implTests -> SPEC_reviewImplTests -> SPEC_implProductCodes -> SPEC_reviewProductCodes -> SPEC_reviewImplTests -> SPEC_commitStoryWorks(pre_close) -> SPEC_closeUserStory -> SPEC_commitStoryWorks(post_close)
terminal_state: doneUS (.catdd/metaspec/doneUS/20261111-cap-merchant-retries-UserStory.md)
commit_refs: 4a19c02, 7f31b8e, 9d04e11
next_command: no_command
success_learning_checkpoint: recommended
learning_command: /HARNESS_evolveHarness (evolution_mode=auto)
```

- **`autonomousMode` `ONE-MORE-THING` or orientation halt (`exit 10`):**

```text
status: manual_required
halt_reason: ONE-MORE-THING
execution_mode: autonomousMode
effective_mode: manualMode
metaspec_root: .catdd/metaspec
story_id: US-paymentAdmin-capMerchantRetries (US-261111.093015)
stopped_at_command: SPEC_designTests
question: "Rule BR-03 caps per-merchant retries at the system maximum, but no system maximum is defined in README_DetailDesign.md. Should the cap be 3, 5, or configurable?"
next_command: SPEC_updateDetailDesign
resume_hint: specCodeAgentCLI --mode manualMode --command SPEC_updateDetailDesign --target US-261111.093015
```

- **`manualMode` single-step execution with next-command choices (`exit 0`):**

```text
status: step_completed
execution_mode: manualMode
effective_mode: manualMode
metaspec_root: .catdd/metaspec
executed_command: SPEC_whatsNextTask
story_id: US-specDeveloper-defineSpecCodeAgentCliUsageContract (US-261111.220010)
review_verdict: PASS
next_command: SPEC_commitStoryWorks
candidate_next_commands:
  1. SPEC_commitStoryWorks   (recommended: commit reviewed pre_close story span)
  2. SPEC_showMeStatus       (inspect full metaspec lane inventory)
  3. HARNESS_evolveHarness   (optional post-success learning with evolution_mode=auto)
```

Human output rules:

- Use deterministic `key: value` lines so humans can scan quickly and lightweight `awk`/`grep` scripts remain reliable, while `--json` serves full structured automation.
- Keep progress logs and `[DIAG]` traces exclusively on `stderr`.
- Never require ANSI escape-code stripping when `stdout` is redirected to a non-TTY pipe or file.

### Machine Output (`--json` and `--output <FILE>`)

```json
{
  "schema_version": "1.0",
  "status": "completed",
  "exit_code": 0,
  "execution_mode": "autonomousMode",
  "effective_mode": "autonomousMode",
  "dry_run": false,
  "metaspec_root": ".catdd/metaspec",
  "story": {
    "story_id": "US-paymentAdmin-capMerchantRetries",
    "story_id_alias": "US-261111.093015",
    "orientation": "implementation-oriented",
    "lane": "doneUS",
    "artifact_path": ".catdd/metaspec/doneUS/20261111-cap-merchant-retries-UserStory.md"
  },
  "executed_commands": [
    "SPEC_makePlan",
    "SPEC_designTests",
    "SPEC_implTests",
    "SPEC_reviewImplTests",
    "SPEC_implProductCodes",
    "SPEC_reviewProductCodes",
    "SPEC_reviewImplTests",
    "SPEC_commitStoryWorks",
    "SPEC_closeUserStory"
  ],
  "review_verdict": "PASS",
  "halt": null,
  "commit_refs": ["4a19c02", "7f31b8e", "9d04e11"],
  "next_command": "no_command",
  "candidate_next_commands": [],
  "success_learning_checkpoint": "recommended",
  "learning_command": "HARNESS_evolveHarness"
}
```

When `status` is `"manual_required"` (`exit 10`), `"halt"` is populated as:

```json
{
  "halt_reason": "ONE-MORE-THING",
  "stopped_at_command": "SPEC_designTests",
  "question": "Rule BR-03 caps per-merchant retries at the system maximum, but no system maximum is defined.",
  "options": ["3", "5", "configurable in YAML"]
}
```

Machine output rules:

- `schema_version` is mandatory and starts at `"1.0"`.
- All artifact paths in JSON are repository-relative (`/`-separated) unless `--output` echoes its own caller-supplied destination in `stderr` logs.
- Redact secret values (`ApiKEY`, bearer tokens, private keys) to `"[REDACTED]"` before serialization (`K-SEC-02`).

## Exit Codes

| Code | Symbolic Name | Meaning | Recoverable | Typical `stderr` / Action |
| --- | --- | --- | --- | --- |
| `0` | `OK` | Autonomous story reached `SPEC_closeUserStory`, manual single command succeeded/`PASS`, or `--dry-run` / `--help` / `--version` completed | n/a | Informational step logs on `stderr` |
| `1` | `INTERNAL_ERROR` | Unexpected internal unhandled error inside `specCodeAgentCLI` | maybe | Bug/stack summary (secrets redacted) |
| `2` | `CLI_MISUSE` | Invalid CLI flag, missing `--goal` in `autonomousMode`, conflicting input flags, forbidden `--model`/`--backend` flag, `SPEC_whatsWrong` in `autonomousMode`, or path escape (`K-SEC-01`) | yes | Actionable validation error + usage hint |
| `3` | `WORKSPACE_OR_CONFIG_FAULT` | Missing/unreadable `--inputFile`/`--config-file`, invalid YAML config, missing `.catdd/` assets, or multi-workspace metaspec drift | yes | Failing path + `HARNESS_migrateMetaspec` or `HARNESS_diagnoseInstallation` hint |
| `4` | `GATE_NOT_PASSED` | In `manualMode`, an executed review/verification command returned `REVISE` or `BLOCKED` (or a test step produced `BROKEN_TEST`) | yes | Gate findings + `rework_route` command |
| `5` | `EXTERNAL_DEPENDENCY_FAULT` | Unrecoverable LLM provider failure, test-runner crash, or `git` execution failure | maybe | Redacted provider/tool error details |
| `6` | `STORY_ABORTED` | Story terminated via `SPEC_abortUserStory` (including Loop Guard budget $B \le 3$ exhaustion with unrecoverable assumption/design failure) | yes | Abort summary + `abortUS/` path (`next_command: SPEC_analyzeAbortedUserStory`) |
| `7` | `STORY_SUSPENDED` | Story paused cleanly via `SPEC_suspendUserStory` with durable git branch/worktree resume reference | yes | Suspend summary + `suspendUS/` path (`next_command: SPEC_resumeUserStory`) |
| `10` | `MANUAL_REQUIRED` | Halted safely at `SPEC_makePlan` orientation boundary (`intent-clearing` / `requirement-oriented` / `design-oriented`), `ONE-MORE-THING` ambiguity, `ASK` verdict, or VibeCoding escalation | yes | Exact `ONE-MORE-THING` question or orientation notice + `manualMode` resume command |
| `130` | `INTERRUPTED` | Interrupted by `SIGINT` / `SIGTERM` | yes | Clean temp-file removal and uncommitted partial-edit rollback notice |

## Error and Edge Handling

Validation and execution errors evaluate in strict fail-fast precedence so callers always get the same exit code when multiple problems exist:

1. **Short-circuit flags (`--help`, `--version`)** -> print to `stdout` and exit `0`.
2. **CLI syntax, unknown/forbidden flags (`--model`, `--backend`), exclusive flag conflicts (`--input` / `--inputFile` / `--stdin`), mode conflicts (missing `--goal` in `autonomousMode`, `SPEC_whatsWrong` in `autonomousMode`), and path-traversal checks (`K-SEC-01`)** -> write diagnostic to `stderr`, leave `stdout` empty (or JSON error envelope when `--json`), perform zero writes, and exit `2`.
3. **Filesystem, config, and metaspec workspace resolution (`--config-file`, `--inputFile`, `--reference`, `--extra-prompt`, `.catdd/` installation surface, `MetaspecWorkspaceResolution` multi-root drift)** -> write exact path and remediation command to `stderr`, perform zero writes, and exit `3`.
4. **Orientation boundary and `ONE-MORE-THING` checks during execution** -> record mode transition to `manualMode` when an active tasks file exists, emit `status: manual_required` (`stdout`), log warning (`stderr`), and exit `10`.
5. **Gate `REVISE` / `BLOCKED` (in `manualMode`) vs Loop Guard exhaustion (in `autonomousMode`)** -> in `manualMode`, return `exit 4` with `rework_route`; in `autonomousMode`, retry/route within `maxStepRetry = 2` and `maxRunCorrectionLoop = 3` ($B \le 3$), then restore the clean baseline and exit `6` (`SPEC_abortUserStory`), `10` (`ASK`), or `5` (external dependency crash).
6. **Empty `stdin` with `--stdin`** -> rejected as caller misuse (`exit 2`); without `--stdin`, `stdin` is never read so background/cron jobs never hang.
7. **Non-TTY execution** -> identical behavior to TTY execution; ANSI colors on `stderr` are disabled automatically when `NO_COLOR` is set or `stderr` is not a TTY.
8. **Interrupted execution (`SIGINT` / `SIGTERM`)** -> remove temporary staging files, avoid leaving half-written metaspec files (atomic temp-file + rename writes), leave git index clean, and exit `130`.
9. **Permission denied or unwritable `--output`** -> report path and OS error code without echoing file contents or secrets, and exit `3`.

## Bash Integration Examples

```bash
# 1. Autonomous mode (default): drive an implementation-oriented story from goal to closure (exit 0) or ONE-MORE-THING halt (exit 10)
specCodeAgentCLI \
  --goal "implement P0 functional tests and retry cap enforcement for active story"

# 2. Shell script branching cleanly on autonomous exit codes (0 = closed, 10 = needs human answer, 6 = aborted, 7 = suspended)
set +e
specCodeAgentCLI \
  --goal "implement P0 functional tests and minimal product code for US-261111.093015" \
  --target US-261111.093015 \
  --json --output "$TMPDIR/spec-run.json"
rc=$?
set -e
case "$rc" in
  0)  printf 'Story closed cleanly.\n' ;;
  10) printf 'Human decision required — inspect %s and continue in manualMode.\n' "$TMPDIR/spec-run.json" ;;
  6)  printf 'Story aborted safely to abortUS/.\n' ;;
  7)  printf 'Story suspended safely to suspendUS/.\n' ;;
  *)  printf 'Execution failed with exit code %d.\n' "$rc" >&2; exit "$rc" ;;
esac

# 3. Manual mode: ask Px-SpecFlow what should run next (defaults to SPEC_whatsNextTask)
specCodeAgentCLI --mode manualMode

# 4. Manual mode: import a raw issue from stdin, analyze in AUTONOMOUS analysis_mode, open, and plan step by step
printf '%s\n' 'Merchant retry count has no per-tenant upper bound' \
  | specCodeAgentCLI --mode manualMode --command SPEC_importIssue --stdin

specCodeAgentCLI --mode manualMode \
  --command SPEC_analyzeIssue \
  --analysis-mode AUTONOMOUS \
  --target .catdd/metaspec/pendingNews/20261111-merchant-retry-cap-Issue.md

# 5. Manual mode: invoke a portable TEST_* command directly (replaces deprecated utCodeAgentCLI)
specCodeAgentCLI --mode manualMode \
  --command TEST_designFuncTestsSkeleton \
  --target tests/test_merchant_retry_funcValidTypical.ts \
  --inputFile src/payment/RetryPolicy.ts \
  --diagMethodPrompts --diagSlashCommands

# 6. Dry-run preview on a legacy .catdd/spec workspace with custom config file
SPECCLI_CONFIG_FILE=".catdd/specCodeAgentCLI/config.yaml" \
specCodeAgentCLI \
  --goal "verify planned Part 2.b steps before running" \
  --metaspec-root .catdd/spec \
  --dry-run
```

## CaTDD Verification Handoff

When the follow-up `specCodeAgentCLI` implementation story enters `SPEC_takeDetailDesign` (`README_DetailVerifyDesign.md`) and `SPEC_designTests`, map these usage scenarios into CaTDD test files as follows:

| Usage scenario | Feature token | Category token | Suggested test file | Test points / Story AC trace |
| --- | --- | --- | --- | --- |
| Autonomous goal-to-END execution (`USAGE-SC-001`, `USAGE-SC-002`) | `spec_cli_invocation` | `funcValidTypical` | `test_spec_cli_invocation_funcValidTypical.ts` | `US-261111.220010-AC-Typical-01` (autonomous `SPEC_makePlan` -> Part 2.b -> terminal `0`/`6`/`7`, zero `utCodeAgentCLI` dependency) |
| Manual single-step & next-choice output (`USAGE-SC-003`, `USAGE-SC-004`) | `spec_cli_invocation` | `funcValidTypical` | `test_spec_cli_invocation_funcValidTypical.ts` | `US-261111.220010-AC-Typical-02` (default `SPEC_whatsNextTask`, explicit `SPEC_*`/`TEST_*`/`HARNESS_*` single step, candidate list) |
| JSON report, config-only LLM settings & secret redaction (`USAGE-SC-005`) | `spec_cli_invocation` | `funcValidTypical` | `test_spec_cli_invocation_funcValidTypical.ts` | `US-261111.220010-AC-Typical-03` (`schema_version: "1.0"`, `--output`, `ApiKEY` masking `K-SEC-02`) |
| Orientation boundary & `ONE-MORE-THING` halt (`USAGE-SC-006`, `USAGE-SC-007`) | `spec_cli_invocation` | `funcValidEdge` | `test_spec_cli_invocation_funcValidEdge.ts` | `US-261111.220010-AC-Edge-01` (`manual_required`, mode switch recorded in tasks file, exit `10`) |
| `--dry-run` across `.catdd/metaspec`, `.agents/metaspec`, and `.catdd/spec` (`USAGE-SC-008`) | `spec_cli_invocation` | `funcValidEdge` | `test_spec_cli_invocation_funcValidEdge.ts` | `US-261111.220010-AC-Edge-02` (zero filesystem/git writes, exit `0`) |
| Missing `--goal`, flag conflicts, forbidden `--model`/`--backend`, `SPEC_whatsWrong` in autonomous (`USAGE-SC-009..011`) | `spec_cli_invocation` | `funcInvalidMisuse` | `test_spec_cli_invocation_funcInvalidMisuse.ts` | `US-261111.220010-AC-Misuse-01` (fail-fast exit `2`, zero writes) |
| Unsupported `--metaspec-root` & path traversal (`USAGE-SC-012`) | `spec_cli_invocation` | `funcInvalidMisuse` | `test_spec_cli_invocation_funcInvalidMisuse.ts` | `US-261111.220010-AC-Misuse-02` (`K-SEC-01` boundary check, exit `2`) |
| Multi-workspace drift, missing/invalid YAML config, unreadable `.catdd/` assets (`USAGE-SC-013`, `USAGE-SC-014`) | `spec_cli_invocation` | `funcInvalidFault` | `test_spec_cli_invocation_funcInvalidFault.ts` | `US-261111.220010-AC-Fault-01` (remediation hint, exit `3`) |
| Loop Guard exhaustion ($B \le 3$) & external runtime failure (`USAGE-SC-015`) | `spec_cli_invocation` | `funcInvalidFault` | `test_spec_cli_invocation_funcInvalidFault.ts` | `US-261111.220010-AC-Fault-02` (clean baseline rollback, structured diagnostic, exit `5` / `6`) |
| Multi-process concurrent workspace locking | `spec_cli_invocation` | `designConcurrency` | `test_spec_cli_invocation_designConcurrency.ts` | `@[NoTestPoints]: Deferred to P1 ArchDesign/StateDesign story deciding metaspec lockfile semantics across parallel sessions.` |
| Startup & static validation latency budget | `spec_cli_invocation` | `qualityPerformance` | `test_spec_cli_invocation_qualityPerformance.ts` | `@[NoTestPoints]: Deferred to P2 PerfDesign story once runtime implementation language is selected.` |

## Open Questions

- Should parallel `specCodeAgentCLI` runs in the same repository acquire an advisory lockfile under `<metaspec_root>/.lock` when running mutating commands, while allowing concurrent read-only status commands? (To be decided in `SPEC_takeArchDesign`.)
- Should `--stdin` enforce a maximum byte limit (for example `1 MiB`) before forwarding raw issue/feature text to intake commands? (To be decided in `SPEC_takeDetailDesign`.)
- When should `README_UsageDesign_ZH.md` be authored and registered in `scripts/check_readme_mirror.sh`? (Explicitly deferred from `US-261111.220010` per developer scope selection.)

## Usage Example

Run from the repository root to inspect this UsageDesign contract in a temporary file without modifying tracked repository files:

```bash
TMP_DOC="$(mktemp -d)/README_UsageDesign.md"
cp codeAgents/specCodeAgentCLI/README_UsageDesign.md "$TMP_DOC"
printf '%s\n' "$TMP_DOC"
grep -E '^## |--mode|--goal|--command|--metaspec-root|--config-file|MANUAL_REQUIRED' "$TMP_DOC"
```

Expected result: the temporary file path is printed, followed by all top-level section headings, core workflow options (`--mode`, `--goal`, `--command`, `--metaspec-root`, `--config-file`), and the `MANUAL_REQUIRED` (`10`) exit-code row.

## Review Checklist

- 5W1H context is complete for developers, operators, CI scripts, and parent CodeAgents.
- `utCodeAgentCLI` deprecation is explicit and `specCodeAgentCLI` has zero dependency on `utCodeAgentCLI`.
- `autonomousMode` (`--goal` -> `SPEC_makePlan` -> `END` or `ONE-MORE-THING` halt) vs `manualMode` (single `Px-SpecFlow` step + next-step choices) is unambiguous.
- LLM/backend/model settings live strictly in `--config-file`; CLI provider/model flags are rejected with exit `2`.
- Every CLI option, flag, env var, `stdin` rule, and config field defines type, values, default, precedence, and failure exit code.
- `stdout`, `stderr`, JSON schema `v1`, secret redaction (`K-SEC-02`), exit codes (`0..10`, `130`), and idempotency are explicit.
- All 15 behavior scenarios (`USAGE-SC-001..015`) trace to `US-261111.220010-AC-*` and map to P0 CaTDD category files in `CaTDD Verification Handoff`.
- No runnable CLI binary is claimed before implementation exists.
