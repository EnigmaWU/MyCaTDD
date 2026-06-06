# utCodeAgentCLI Detail Design

This document turns the architecture into implementation-facing contracts, data schemas, state transitions, and verification strategy for the future `utCodeAgentCLI` implementation. It is based on [`slashCommands/templates/README_DetailDesignTemplate.md`](../../slashCommands/templates/README_DetailDesignTemplate.md).

## Story Context

- Story: [../../.catdd/spec/doingUS/20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md](../../.catdd/spec/doingUS/20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md)
- Architecture: [README_ArchDesign.md](README_ArchDesign.md)
- Usage contract: [README_UsageDesign.md](README_UsageDesign.md)
- Requirements index: [README_UserStory.md](README_UserStory.md)
- ASR source: [ASRs/ASR_AgenticReliabilityContracts.md](ASRs/ASR_AgenticReliabilityContracts.md)
- ADR source: [ADRs/ADR_AgenticReliabilityPolicy.md](ADRs/ADR_AgenticReliabilityPolicy.md)
- Method source of truth: [../../methodPrompts/](../../methodPrompts/)
- Portable command source of truth: [../../slashCommands/](../../slashCommands/)

The detail design keeps the architecture decisions intact: `AgentSDK` is generic and CaTDD-independent; `utCodeAgentCLI` parses user intent, resolves CaTDD behaviors to delegated assets, invokes a runtime adapter, and records traces. Per the runtime-language ADR, V1 is implemented in TypeScript on Node.js, with Go pre-selected for V2 production distribution.

## Who

| Role | Detail-design concern |
| --- | --- |
| USER | Receives predictable CLI validation, behavior execution, test-file state transitions, and readable output. |
| INVENTOR | Gets runtime proof that method prompts and slash commands were resolved from source files, not hardcoded in CLI logic. |
| DEVELOPER | Gets concrete TypeScript contracts for parser, planner, executor, adapter, trace, diagnostics, and control modules. |

## What

`utCodeAgentCLI` will be implemented as a local CLI first, in TypeScript on Node.js as decided by the runtime-language ADR. The v1 detail design includes:

- CLI argument parsing and validation.
- Behavior resolution from CLI aliases or direct `UT_*` names to portable slash commands.
- Method prompt resolution by file path.
- Test target parsing for one TC, one TestFile, or multiple TestFiles.
- Command plan creation and execution through an adapter interface.
- Interactive per-command control.
- Structured diagnostics and machine-readable trace writing.

## When

Use this design before writing `src/`, executable tests, or package metadata for `utCodeAgentCLI`.

Update it when CLI flags, behavior aliases, trace schema, adapter capabilities, state transitions, or command-resolution rules change.

## Where

The first implementation should stay module-scoped:

```text
codeAgents/utCodeAgentCLI/
  src/
    cli/
    catdd/
    executor/
    agentsdk/
    adapters/
    trace/
    diagnostics/
    config/
  tests/
  traces/
```

`AgentSDK` starts inside `src/agentsdk/` so contracts can stabilize beside the CLI. A later package split is allowed only after adapter and trace APIs are proven by tests.

### V2 Go Portability Boundary

V1 ships in TypeScript on Node.js, but the runtime-language ADR pre-selects Go for V2 production distribution. To keep that future migration contained, V1 detail design must hold a clean portability boundary:

- Keep the `AgentSDK` runtime/adapter contracts language-neutral in shape (no Node-only types leaking across the `RuntimeAdapter`, `TracePort`, `ControlPort`, or `HookPort` boundaries).
- Keep CaTDD semantics delegated to `methodPrompts/` and `slashCommands/` files, not embedded in TS code, so a Go rewrite reuses the same portable assets.
- Keep the trace schema (`traceVersion`-stamped JSON/YAML) implementation-independent so V2 Go output stays compatible.
- Treat Node-specific concerns (process spawning, fs access, module loading) as adapter-local so only adapters, not core orchestration, need rewriting for Go.

## Why

The main detailed-design risk is accidental semantic duplication. This design prevents that by limiting CLI-owned logic to parsing, validation, planning, orchestration, control, diagnostics, and trace persistence. Category meaning, skeleton wording, status discipline, and portable command behavior remain delegated to `methodPrompts/` and `slashCommands/`.

## How

Execution flow:

1. Parse argv into `RawCliArgs`.
2. Normalize paths and load config into `CliExecutionContext`.
3. Validate required arguments, mutually exclusive pairs, file paths, target shape, and behavior compatibility.
4. Build `CatddInvocation`.
5. Resolve behavior to `ResolvedBehavior` and `ResolvedSlashCommand[]`.
6. Resolve required method prompts into `ResolvedMethodPrompt[]`.
7. Build `CatddRunPlan` and generic `AgentRunPlan`.
8. Execute each command step through `SlashCommandExecutor` and `RuntimeAdapter`.
9. Collect file observations, command results, TC transitions, diagnostics, and control decisions.
10. Write a trace on success or execution failure.

## Requirements

| Requirement | Source | Notes |
| --- | --- | --- |
| Validate required arguments and exclusive pairs. | `US-USER-01`, `README_UsageDesign.md` | Parser owns syntax and shape; no command executes on validation failure. |
| Generate, review, select, and implement CaTDD test artifacts. | `US-USER-02` through `US-USER-10` | CLI resolves behaviors; slash commands own artifact content. |
| Delegate CaTDD semantics. | `US-INVENTOR-01` | No category meaning or status meaning is hardcoded in CLI. |
| Produce machine-readable traces. | `US-INVENTOR-02` | Trace written for successful execution and execution failure. |
| Reveal resolved prompts and commands. | `US-INVENTOR-03` | Diagnostic flags expose file paths and resolution reasons. |
| Produce actionable errors. | `US-DEV-01` | Errors name the argument/path/state and suggest corrections. |
| Support logging and interactive control. | `US-DEV-02`, `US-DEV-03` | `LogSink` and `ControlPort` are explicit dependencies. |
| Support replaceable runtimes. | `US-DEV-04` | Default adapter is the first chosen runtime/process based; Copilot/OpenCode adapters are later implementations. |
| Enforce ASR reliability and safety policy defaults at runtime. | `US-DEV-05`, `ASR-R1`..`ASR-R6`, `ADR_AgenticReliabilityPolicy` | Runtime policy must be deterministic for retry budget, fallback routing, failure taxonomy, escalation, and sensitive-path control. |

## Acceptance Criteria

| AC ID | Given | When | Then | Design Impact |
| --- | --- | --- | --- | --- |
| DD-AC-01 | Required CLI args are missing. | `CliParser` and `InvocationValidator` run. | Exit code is 1 and stderr names missing args. | `ValidationError` includes `argument`, `message`, and `suggestions`. |
| DD-AC-02 | `--goalStory` conflicts with `--goalStoryFile`, or `--input` conflicts with `--inputFile`. | Validation runs. | No plan is built and stderr names both args. | Exclusive-pair validation happens before file reads. |
| DD-AC-03 | `--behave` is an alias or direct `UT_*` command. | Behavior resolution runs. | A deterministic command sequence is returned or a suggestion error is raised. | `BehaviorRegistry` owns alias mapping only, not command behavior. |
| DD-AC-04 | A behavior needs CaTDD semantics. | Prompt resolution runs. | Required method prompt file paths are resolved or execution stops. | `MethodPromptResolver` reads file paths from configured method roots. |
| DD-AC-05 | A command modifies test files. | Execution completes or fails mid-step. | Trace records files, steps, TC transitions, and exit data. | `TraceEventCollector` observes before/after snapshots. |
| DD-AC-06 | Interactive mode is enabled. | A command step is about to run. | User can approve, skip, or abort. | `ControlPort` returns typed decisions consumed by executor. |
| DD-AC-07 | A custom runtime adapter is configured. | Command execution starts. | Executor invokes the adapter through the generic interface. | `RuntimeAdapter` receives command path, normalized invocation, and context. |
| DD-AC-08 | `reviewImplTestFile` targets one TestFile. | Behavior resolution runs. | The CLI builds a read-only sequence that invokes `UT_reviewImplTestCase` for each RED/GREEN TC and skips PLANNED TCs with a summary. | `BehaviorRegistry` treats `reviewImplTestFile` as a stable orchestration alias, not a new CaTDD method. |
| DD-AC-09 | EN/ZH detail design docs exist. | Mirror check runs. | Heading structure matches. | Keep sections synchronized when updating design. |
| DD-AC-10 | Transient retries exceed policy budget. | Executor applies policy decisions. | Retry stops deterministically and escalation metadata is emitted. | Add retry-budget state and escalation reason codes in execution result. |
| DD-AC-11 | `--behave` is unsupported. | Behavior resolution executes. | Diagnostics fallback returns supported values and argument-error exit. | Add fallback contract in resolver result type; forbid silent coercion. |
| DD-AC-12 | A permanent failure is detected. | Failure classification runs. | Retry is skipped and fail-fast route is chosen. | Add explicit `failureClass` in step result and classifier rules. |
| DD-AC-13 | A run fails after mutating step(s). | Compensation boundary handling runs. | Further mutating steps are blocked; trace records last consistent step boundary. | Add step snapshot records and compensation marker in trace schema. |
| DD-AC-14 | Non-interactive execution hits escalation trigger. | Control handling runs. | Forced abort with deterministic exit and escalation tag. | Add non-interactive escalation mode in `ControlPort` contract. |
| DD-AC-15 | Step targets a sensitive path without policy approval. | Safety policy check runs before execution and trace write. | Step is denied and secret-like values are redacted in diagnostics/trace. | Add sensitive-path gate and redaction classification before adapter execution. |

## Interface Design

| Interface | Input | Output | Error Behavior |
| --- | --- | --- | --- |
| `parseArgv(argv)` | `string[]` | `RawCliArgs` | Throws `CliSyntaxError` for unknown flags or missing values. |
| `validateInvocation(raw, context)` | `RawCliArgs`, `CliExecutionContext` | `CatddInvocation` | Returns `ValidationError[]`; no command execution on any error. |
| `parseTarget(value)` | `string` | `TargetSelector` | Throws `TargetParseError` for empty, malformed, or mixed invalid selectors. |
| `resolveBehavior(invocation)` | `CatddInvocation` | `ResolvedBehavior` | Throws `BehaviorResolutionError` with valid values and nearest suggestion. |
| `resolveMethodPrompts(plan)` | `CatddRunPlan` | `ResolvedMethodPrompt[]` | Throws `AssetResolutionError` naming missing prompt paths. |
| `resolveSlashCommands(behavior)` | `ResolvedBehavior` | `ResolvedSlashCommand[]` | Throws `AssetResolutionError` naming missing command paths. |
| `planCatddRun(invocation)` | `CatddInvocation` | `CatddRunPlan` | Fails before execution if target shape and behavior are incompatible. |
| `execute(plan, context)` | `CatddRunPlan`, `CliExecutionContext` | `ExecutionResult` | Writes failure trace for execution errors after planning succeeds. |
| `classifyFailure(error)` | `RuntimeError` | `FailureClass` (`TRANSIENT` or `PERMANENT`) | Returns `PERMANENT` when classification confidence is low to avoid unsafe retries. |
| `evaluateStepPolicy(step, state)` | `AgentRunStep`, `PolicyState` | `PolicyDecision` | Denies execution when retry budget or sensitive-path policy is violated. |
| `RuntimeAdapter.execute(step, context, control)` | `AgentRunStep`, `AgentRunContext`, `ControlPort` | `StepResult` | Returns structured failure instead of throwing for expected runtime failures. |
| `TraceWriter.write(trace)` | `RunTrace` | `TraceWriteResult` | Redacts secrets and fails closed if trace cannot be safely written. |

## Module Layout

| Module | Files | Responsibility |
| --- | --- | --- |
| `src/cli/` | `args.ts`, `targetSelector.ts`, `main.ts` | Parse argv, target selectors, and process entrypoint. |
| `src/config/` | `config.ts`, `paths.ts` | Load config, resolve method/command roots, normalize workspace paths. |
| `src/catdd/` | `invocation.ts`, `behaviorRegistry.ts`, `methodPromptResolver.ts`, `slashCommandResolver.ts`, `planner.ts` | Own CaTDD orchestration metadata without owning CaTDD semantics. |
| `src/executor/` | `slashCommandExecutor.ts`, `commandResultNormalizer.ts` | Execute resolved command steps and normalize adapter output. |
| `src/agentsdk/` | `runtime.ts`, `ports.ts`, `runPlan.ts`, `events.ts` | Generic agent runtime contracts, ports, and event model. |
| `src/adapters/` | `rawTsRuntimeAdapter.ts`, `cliProcessAdapter.ts` | First raw TypeScript/process runtime adapters. |
| `src/trace/` | `traceSchema.ts`, `traceEventCollector.ts`, `traceWriter.ts`, `redaction.ts` | Trace schema, observations, transition capture, redaction, persistence. |
| `src/diagnostics/` | `errors.ts`, `diagnosticReporter.ts`, `logSink.ts`, `suggestions.ts` | Actionable errors, log levels, diagnostic flags, typo suggestions. |

## Core Type Contracts

```ts
export interface RawCliArgs {
  goal?: string;
  goalStory?: string;
  goalStoryFile?: string;
  input?: string;
  inputFile?: string;
  target?: string;
  behave?: string;
  reference: string[];
  extraPrompt: string[];
  configFile?: string;
  logLevel: LogLevel;
  interactiveSlashCommands: boolean;
  diagMethodPrompts: boolean;
  diagSlashCommands: boolean;
}

export interface CatddInvocation {
  goal: string;
  story?: StorySource;
  input?: InputSource;
  target: TargetSelector;
  behaviorName: string;
  references: WorkspacePath[];
  extraPrompts: WorkspacePath[];
  diagnostics: DiagnosticOptions;
}

export type TargetSelector =
  | { kind: "test-case"; file: WorkspacePath; tcId: string }
  | { kind: "test-file"; file: WorkspacePath }
  | { kind: "test-files"; files: WorkspacePath[] };
```

```ts
export interface ResolvedBehavior {
  requested: string;
  canonicalName: string;
  mode: "design" | "review" | "implement" | "select" | "combined";
  commandNames: string[];
  requiredTargetKinds: TargetSelector["kind"][];
  writesFiles: boolean;
}

export interface ResolvedSlashCommand {
  name: string;
  path: WorkspacePath;
  flow: "P0" | "P1" | "P2" | "SPEC" | "unknown";
  order: number;
}

export interface ResolvedMethodPrompt {
  name: string;
  path: WorkspacePath;
  reason: string;
}
```

```ts
export interface AgentRunPlan {
  goal: string;
  steps: AgentRunStep[];
  requiredTools: ToolRef[];
  tracePolicy: TracePolicy;
}

export interface AgentRunStep {
  id: string;
  slashCommand: ResolvedSlashCommand;
  target: TargetSelector;
  invocation: CatddInvocation;
  methodPrompts: ResolvedMethodPrompt[];
}

export interface RuntimeAdapter {
  prepare(plan: AgentRunPlan, context: AgentRunContext): Promise<PreparedRun>;
  execute(step: AgentRunStep, context: AgentRunContext, control: ControlPort): Promise<StepResult>;
}
```

## Data Schemas

### Config Schema

```yaml
methodPromptsRoot: methodPrompts
slashCommandsRoot: slashCommands
traceDir: codeAgents/utCodeAgentCLI/traces
defaultRuntime: raw-ts
logLevel: info
adapters:
  raw-ts:
    type: raw-ts
  process:
    type: cli-process
```

Default trace output is `codeAgents/utCodeAgentCLI/traces/` for module locality. A config file may override it, and future installed-target usage may choose `.catdd/traces/`.

### Trace Schema

```ts
export interface RunTrace {
  traceVersion: "1.0";
  traceId: string;
  startedAt: string;
  finishedAt: string;
  invocation: TraceInvocation;
  workspace: TraceWorkspace;
  resolvedMethodPrompts: ResolvedMethodPrompt[];
  resolvedSlashCommands: ResolvedSlashCommand[];
  steps: TraceStep[];
  files: TraceFileEvent[];
  tcTransitions: TraceTcTransition[];
  diagnostics: TraceDiagnostic[];
  exit: TraceExit;
}
```

```ts
export interface TraceTcTransition {
  tcId: string;
  category?: string;
  file: WorkspacePath;
  beforeStatus?: "PLANNED" | "RED" | "GREEN";
  afterStatus?: "PLANNED" | "RED" | "GREEN";
  commandName: string;
}
```

## Behavior Design

```text
1. Parse argv and environment.
2. Load config and derive workspace roots.
3. Validate required fields and exclusive argument pairs.
4. Validate file paths for --inputFile, --goalStoryFile, --reference, --extra-prompt, and --config-file.
5. Parse --target into a typed selector.
6. Resolve --behave through BehaviorRegistry.
7. Check target selector compatibility with resolved behavior.
8. Resolve portable slash commands and required method prompts.
9. Build a run plan with ordered steps.
10. For each step, request ControlPort decision when interactive mode is enabled.
11. Execute approved steps through RuntimeAdapter.
12. Normalize results and collect before/after file observations.
13. Write stdout/stderr, trace, diagnostics, and process exit code.
```

## State and Data

| State/Data | Owner | Lifecycle | Invariant |
| --- | --- | --- | --- |
| `RawCliArgs` | `cli/` | Created from argv, discarded after validation. | May contain invalid or missing values. |
| `CatddInvocation` | `catdd/` | Created after validation, used by planner/executor/trace. | Required fields are present and normalized. |
| `TargetSelector` | `cli/` + `catdd/` | Created from `--target`, used by behavior validation. | Exactly one selector kind is present. |
| `ResolvedBehavior` | `catdd/` | Created during behavior resolution. | Contains command names but no CaTDD category definitions. |
| `CatddRunPlan` | `catdd/` | Created before execution. | All command paths and prompt paths are resolvable. |
| `AgentRunPlan` | `agentsdk/` | Created from `CatddRunPlan`. | Contains generic execution steps only. |
| `StepResult` | `executor/` + adapter | Created per command step. | Expected failures are structured, not hidden in logs. |
| `PolicyState` | `executor/` | Created at run start and updated per step. | Tracks retry counts, correction loops, escalation flags, and denied-sensitive-path attempts. |
| `RunTrace` | `trace/` | Created during execution and written at exit. | Secrets and raw sensitive content are redacted. |

## State Machine

CaTDD file-state transitions remain delegated and observed:

```text
EMPTY -> DESIGNED -> PARTIAL -> FULLY_RED -> ALL_GREEN
```

CLI run-state transitions are generic:

```text
created -> validated -> planned -> running -> completed
                              \-> waiting_for_approval
                              \-> failed
                              \-> aborted
                              \-> skipped
```

The CLI may write `PLANNED -> RED` only through delegated slash-command execution. It never writes `RED -> GREEN`.

## Embedded and Digital Media Detail Points

Not applicable for `utCodeAgentCLI` v1. There is no interrupt, driver, buffer, media timing, sample format, power, or A/V synchronization boundary. The local equivalents are process lifecycle, timeout, cancellation, trace file growth, redaction, and adapter output capture; those are covered by execution, trace, and control design.

## Error and Edge Handling

| Condition | Expected behavior |
| --- | --- |
| Missing `--goal`, `--target`, or `--behave` | Exit code 1; stderr names missing arguments and explains purpose. |
| Conflicting exclusive args | Exit code 1; stderr names both arguments and states the conflict. |
| Missing file path | Exit code 1; stderr includes argument name and resolved path. |
| Unknown behavior | Exit code 1; stderr lists valid aliases/direct command names and nearest suggestion. |
| Retry budget exhausted | No further retries for that step; escalation reason is emitted and trace is persisted. |
| Failure classified as PERMANENT | Skip retry path and fail fast with classification details in diagnostics. |
| Non-interactive escalation condition met | Forced abort with deterministic non-zero exit and `ESCALATED_NON_INTERACTIVE` trace tag. |
| Sensitive path access without policy approval | Step denied before adapter execution; diagnostics identify denied path class without leaking secrets. |
| Target/behavior mismatch | Exit code 1; stderr explains required target shape and suggests valid combinations. |
| Missing method prompt or slash command | Exit code 1; stderr names missing asset path; no fallback semantic copy is used. |
| Interactive skip | Step is skipped; trace records skipped command and reason. |
| Interactive abort | No further steps run; exit code 1; trace records abort point. |
| `reviewImplTestFile` finds no RED/GREEN TCs | Exit code 0; stdout reports that no implemented TCs were found and no file is modified. |
| Adapter execution failure after planning | Failure trace is written with completed steps and active failure point. |
| Trace redaction failure | Fail closed; do not persist unsafe trace content. |

## Implementation Plan

| Step | Deliverable | Verification |
| --- | --- | --- |
| 1 | Package scaffold and TypeScript config. | Compile empty project and run placeholder test. |
| 2 | `cli/` parser and target selector. | Unit tests for required args, exclusive pairs, and target forms. |
| 3 | `catdd/` behavior and asset resolvers. | Unit tests for aliases, direct `UT_*` names, missing assets, and suggestions. |
| 4 | `agentsdk/` generic interfaces and raw adapter. | Type tests or unit tests proving no CaTDD category definitions in SDK. |
| 5 | `executor/` plan execution with `ControlPort`. | Tests for approve, skip, abort, and structured step failures. |
| 6 | `trace/` schema, collector, and writer. | JSON schema tests for success and execution failure traces. |
| 7 | Reliability policy layer (`classifyFailure`, `evaluateStepPolicy`, sensitive-path gate). | Unit tests for ASR-R1..R6 behavior and deterministic non-interactive escalation. |
| 8 | End-to-end dry-run fixture. | CLI-level test from valid invocation to planned command sequence and trace. |

## Verification Strategy

- Unit-test parser and selector behavior without invoking external agents.
- Unit-test behavior resolution against fixture command roots.
- Unit-test missing prompt/command failures with temporary directories.
- Snapshot-test diagnostic output for actionable error wording.
- Validate `RunTrace` with a JSON schema parser.
- Use fixture test files to verify observed TC transition extraction.
- Add adapter contract tests using an in-memory fake adapter before adding Copilot/OpenCode adapters.
- Add policy tests for retry budget exhaustion, failure classification, unknown-behavior fallback, sensitive-path denial, and escalation behavior in interactive and non-interactive modes.

## Assumptions

- First implementation language is the runtime selected by the ADR.
- First runtime is local raw process execution using the chosen runtime adapter.
- Copilot/MCP and OpenCode are adapter targets after the raw runtime contract is stable.
- LangGraph and Google ADK remain reference architectures until a later story asks for optional adapters.
- Default trace output is module-local under `codeAgents/utCodeAgentCLI/traces/`.

## Open Questions

- Which package manager and test runner should the chosen implementation use?
- Should installed-target traces later default to `.catdd/traces/` instead of the module-local trace directory?
- Should prompt-wrapper execution or MCP tool execution be the first Copilot adapter surface?
- Should OpenCode support start as a command adapter or provider abstraction?
- Should `.npmrc`, `.netrc`, `*.p12`, `*.jks`, and other repo-local credential-bearing patterns be included in the default sensitive-path deny list for v1?

## Usage Example

Run from the repository root to verify the detail-design document pair has matching heading structure:

```bash
awk '/^#{1,6} /{print length($1), $1}' codeAgents/utCodeAgentCLI/README_DetailDesign.md > /tmp/ut-detail-en.headings
awk '/^#{1,6} /{print length($1), $1}' codeAgents/utCodeAgentCLI/README_DetailDesign_ZH.md > /tmp/ut-detail-zh.headings
diff -u /tmp/ut-detail-en.headings /tmp/ut-detail-zh.headings
```

Expected result: `diff` prints no output and exits with code 0.

## Review Checklist

- Every acceptance criterion has a design impact or explicit non-impact.
- Interfaces and state changes are clear enough to drive tests.
- `AgentSDK` contracts contain no CaTDD category or status definitions.
- Behavior aliases resolve to slash commands; they do not duplicate command logic.
- Trace schema covers success and execution failure.
- Error messages can name argument, path, state, and suggestion.
- EN/ZH heading structure matches.

## Next Step

Run `/SPEC_reviewUserStory` to review story readiness against the updated architecture and detail design before any coding or test-generation command.