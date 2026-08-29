# utCodeAgentCLI Detail Design

This document turns the architecture into implementation-facing contracts, data schemas, state transitions, and verification strategy for the incremental `utCodeAgentCLI` implementation. It is based on [`slashCommands/templates/README_DetailDesignTemplate.md`](../../slashCommands/templates/README_DetailDesignTemplate.md).

## Story Context

- Active story: [../../.catdd/spec/doingUS/20260607-utCodeAgentCLI-US-INVENTOR-01-UserStory.md](../../.catdd/spec/doingUS/20260607-utCodeAgentCLI-US-INVENTOR-01-UserStory.md)
- Active tasks: [../../.catdd/spec/doingUS/20260607-utCodeAgentCLI-US-INVENTOR-01-TASKs.md](../../.catdd/spec/doingUS/20260607-utCodeAgentCLI-US-INVENTOR-01-TASKs.md)
- Reviewed requirement: [USs/README_UserStory4INVENTOR-01.md](USs/README_UserStory4INVENTOR-01.md)
- Story: [../../.catdd/spec/doneUS/20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md](../../.catdd/spec/doneUS/20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md)
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

`utCodeAgentCLI` is being implemented incrementally as a local CLI in TypeScript on Node.js, as decided by the runtime-language ADR. The US-USER-01 invocation-validation slice exists; the remaining v1 detail design includes:

- CLI argument parsing and validation.
- Behavior resolution from CLI aliases or direct `UT_*` names to portable slash commands.
- Fresh method-prompt and slash-command resolution by canonical file path and current source content.
- Test target parsing for one TC, one TestFile, or multiple TestFiles.
- Command plan creation and execution through an adapter interface.
- Interactive per-command control.
- Structured diagnostics and machine-readable trace writing.

## When

Use this design before adding new `src/` modules, executable test slices, or package metadata for `utCodeAgentCLI`.

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
5. Create one `InvocationAssetSession` for this invocation.
6. Resolve behavior to `ResolvedBehavior` and fresh, root-contained `ResolvedSlashCommand[]`.
7. Resolve required method prompts into fresh, content-bearing `ResolvedMethodPrompt[]` and record ordered `prompt-read` events.
8. Build `CatddRunPlan`, then translate its assets into generic `AgentInputAsset[]` for `AgentRunPlan`.
9. Record a `command-invocation` event immediately before `RuntimeAdapter.execute()`.
10. Execute each command step through `SlashCommandExecutor` and `RuntimeAdapter`.
11. Collect file observations, command results, TC transitions, diagnostics, and control decisions.
12. Write metadata-only trace projections on success or execution failure, then dispose the invocation asset session.

## Requirements

| Requirement | Source | Notes |
| --- | --- | --- |
| Validate required arguments and exclusive pairs. | `US-USER-01`, `README_UsageDesign.md` | Parser owns syntax and shape; no command executes on validation failure. |
| Generate, review, select, and implement CaTDD test artifacts. | `US-USER-02` through `US-USER-10` | CLI resolves behaviors; slash commands own artifact content. |
| Delegate CaTDD semantics. | `US-INVENTOR-01` | Read current prompt/command content through a per-invocation asset session; pass it to the runtime through generic inputs; never use a persistent semantic cache or hardcoded fallback. |
| Produce machine-readable traces. | `US-INVENTOR-02` | Trace written for successful execution and execution failure. |
| Reveal resolved prompts and commands. | `US-INVENTOR-03` | Diagnostic flags render metadata-only projections of resolved paths and events; US-INVENTOR-01 owns internal structured capture. |
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
| DD-AC-04 | A behavior needs CaTDD semantics. | Prompt resolution runs. | Required method prompt paths and current content are resolved or execution stops. | `MethodPromptResolver` reads through `InvocationAssetSession` from configured method roots. |
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
| DD-AC-16 | An invocation needs method and command assets. | Its run plan is built. | Generic runtime inputs contain current resolved content with no CLI semantic fallback. | Translate content-bearing `CatddRunStep` assets into generic `AgentInputAsset` values. |
| DD-AC-17 | A run needs prompts before invoking a command. | An approved step is prepared and executed. | Monotonic `prompt-read` events precede its `command-invocation` event. | The executor owns `prepare(step) -> PreparedStep -> execute(prepared)` and records metadata-only evidence. |
| DD-AC-18 | Edge meaning, status structure, and execution order are needed. | Prompt resolution runs. | The three named canonical prompt files resolve independently. | Keep the required-asset registry declarative and path-only; read meaning from files. |
| DD-AC-19 | A prompt changes after one invocation. | A second invocation is prepared. | The second run input contains current source content. | Create and dispose one `InvocationAssetSession` per invocation; clear its map and prohibit cross-invocation reuse or persistence. |
| DD-AC-20 | Under the V1 stable-filesystem assumption, a prompt or command resolves outside its configured root. | The candidate path is canonicalized before any adapter preparation. | Resolution fails before content is read or invoked. | Compare canonical root and candidate paths with a segment-safe containment check; concurrent adversarial topology mutation is deferred. |
| DD-AC-21 | An asset/root is missing, empty, unreadable, or the wrong file kind. | Resolution or read runs. | A typed error is returned and no fallback content is supplied. | Map filesystem failures after the attempted operation; do not rely on an existence precheck. |
| DD-AC-22 | Internal resolved assets, run inputs, argv, and workspace context contain canonical paths or raw values; the configured workspace path may itself be a symlink. | Public asset projection, trace, delegation evidence, or CLI diagnostics are produced. | An asset under the canonical workspace root uses a normalized workspace-relative path; an asset outside it uses a root-labeled path. Public output never contains canonical paths or raw content. | `openAssetSession` canonicalizes all roots through the injected filesystem and retains immutable `CanonicalAssetRoots`; every projection compares canonical asset and workspace paths before building safe DTOs. INV-03 owns diagnostic rendering. |

## Interface Design

| Interface | Input | Output | Error Behavior |
| --- | --- | --- | --- |
| `parseArgv(argv)` | `string[]` | `RawCliArgs` | Throws `CliSyntaxError` for unknown flags or missing values. |
| `validateInvocation(raw, context)` | `RawCliArgs`, `CliExecutionContext` | `CatddInvocation` | Returns `ValidationError[]`; no command execution on any error. |
| `parseTarget(value)` | `string` | `TargetSelector` | Throws `TargetParseError` for empty, malformed, or mixed invalid selectors. |
| `resolveBehavior(invocation)` | `CatddInvocation` | `ResolvedBehavior` | Throws `BehaviorResolutionError` with valid values and nearest suggestion. |
| `openAssetSession(context)` | `CliExecutionContext` with normalized logical roots that are not assumed canonical | `Promise<InvocationAssetSession>` retaining immutable `CanonicalAssetRoots` | Canonicalizes workspace, method-prompt, slash-command, and `commands/` roots through `AssetFileSystem`; rejects with `AssetRootError` when a required root is missing or not a directory. |
| `resolveMethodPrompts(plan, session, evidence)` | `CatddRunPlan`, `InvocationAssetSession`, `DelegationEvidenceCollector` | `ResolvedMethodPrompt[]` | Throws typed root, escape, kind, empty, unreadable, or missing-asset errors without fallback. |
| `resolveSlashCommands(behavior, session)` | `ResolvedBehavior`, `InvocationAssetSession` | `ResolvedSlashCommand[]` | Throws the equivalent typed command-asset error without fallback. |
| `planCatddRun(invocation)` | `CatddInvocation` | `CatddRunPlan` | Fails before execution if target shape and behavior are incompatible. |
| `buildAgentRunPlan(plan)` | `CatddRunPlan` | `AgentRunPlan` | Rejects a step without one instruction asset; emits no CaTDD type into `AgentSDK`. |
| `toPublicAssetPath(asset, roots)` | Internal resolved asset, session-owned `CanonicalAssetRoots` | `PublicAssetPath` | Compares canonical asset and workspace paths only; rejects absolute, parent-traversing, or empty public projections; workspace-external assets use a root-labeled path. |
| `toTraceInvocation(raw, invocation, context)` | `RawCliArgs`, `CatddInvocation`, `CliExecutionContext` | `TraceInvocation` | Reconstructs a redacted command from typed arguments; never stores raw argv or inline goal/story/input values. |
| `toTraceWorkspace(context)` | `CliExecutionContext` | `TraceWorkspace` | Uses `<workspace>` plus safe logical paths; never stores an absolute repository root or working directory. |
| `assertSafeTrace(trace, sensitiveValues)` | `RunTrace`, invocation-local deny values | `void` | Fails closed when any serialized string contains a canonical workspace/home prefix, raw inline value, raw asset content, or unsafe path projection. |
| `RuntimeAdapter.prepare(step, context)` | `AgentRunStep`, `AgentRunContext` | `PreparedStep` | Must be side-effect-free; returns structured preparation failure. |
| `recordCommandInvocation(prepared, evidence)` | `PreparedStep`, `DelegationEvidenceCollector` | `DelegationEvent` | Records a public logical path immediately before adapter execution. |
| `RuntimeAdapter.execute(prepared, control)` | `PreparedStep`, `ControlPort` | `StepResult` | Returns structured failure instead of throwing for expected runtime failures. |
| `execute(plan, context)` | `CatddRunPlan`, `CliExecutionContext` | `ExecutionResult` | Writes failure trace for execution errors after planning succeeds. |
| `classifyFailure(error)` | `RuntimeError` | `FailureClass` (`TRANSIENT` or `PERMANENT`) | Returns `PERMANENT` when classification confidence is low to avoid unsafe retries. |
| `evaluateStepPolicy(step, state)` | `AgentRunStep`, `PolicyState` | `PolicyDecision` | Denies execution when retry budget or sensitive-path policy is violated. |
| `TraceWriter.write(trace)` | `RunTrace` | `TraceWriteResult` | Redacts secrets and fails closed if trace cannot be safely written. |

## Module Layout

| Module | Files | Responsibility |
| --- | --- | --- |
| `src/cli/` | `args.ts`, `targetSelector.ts`, `main.ts` | Parse argv, target selectors, and process entrypoint. |
| `src/config/` | `config.ts`, `paths.ts`, `assetFileSystem.ts` | Load config, resolve roots, define the injectable filesystem port, and normalize workspace paths. |
| `src/catdd/` | `invocation.ts`, `behaviorRegistry.ts`, `invocationAssetSession.ts`, `methodPromptResolver.ts`, `slashCommandResolver.ts`, `planner.ts`, `agentRunPlanBuilder.ts` | Own CaTDD orchestration metadata, invocation-local asset reads, and translation to generic run inputs without owning CaTDD semantics. |
| `src/executor/` | `slashCommandExecutor.ts`, `delegationEvidence.ts`, `commandResultNormalizer.ts` | Record ordered delegation events, execute resolved command steps, and normalize adapter output. |
| `src/agentsdk/` | `runtime.ts`, `ports.ts`, `runPlan.ts`, `events.ts` | Generic agent runtime contracts, ports, and event model. |
| `src/adapters/` | `rawTsRuntimeAdapter.ts`, `cliProcessAdapter.ts` | First raw TypeScript/process runtime adapters. |
| `src/trace/` | `traceSchema.ts`, `traceProjection.ts`, `traceSafety.ts`, `traceEventCollector.ts`, `traceWriter.ts`, `redaction.ts` | Define serialization-only DTOs, project safe values, validate the complete trace, capture transitions, redact, and persist. |
| `src/diagnostics/` | `errors.ts`, `diagnosticReporter.ts`, `logSink.ts`, `suggestions.ts` | Actionable errors, log levels, diagnostic flags, typo suggestions. |
| `tests/support/` | `fakeAssetFileSystem.ts`, `fakeRuntimeAdapter.ts` | Deterministically inject missing, permission, mutation, symlink, and runtime-capture scenarios. |

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
  canonicalPath: WorkspacePath;
  content: string;
  flow: "P0" | "P1" | "P2" | "SPEC" | "unknown";
  order: number;
}

export interface ResolvedMethodPrompt {
  name: string;
  path: WorkspacePath;
  canonicalPath: WorkspacePath;
  content: string;
  reason: string;
  order: number;
}
```

```ts
export interface CatddRunStep {
  id: string;
  slashCommand: ResolvedSlashCommand;
  target: TargetSelector;
  invocation: CatddInvocation;
  methodPrompts: ResolvedMethodPrompt[];
}

export type PublicAssetPath = string & { readonly __kind: "PublicAssetPath" };
export type PublicTargetSelector = string & { readonly __kind: "PublicTargetSelector" };
export type PublicTraceText = string & { readonly __kind: "PublicTraceText" };
export type TraceId = string & { readonly __kind: "TraceId" };
export type IsoTimestamp = string & { readonly __kind: "IsoTimestamp" };

export interface AgentInputAsset {
  name: string;
  path: PublicAssetPath;
  content: string;
  role: "instruction" | "context";
}

export interface AgentRunPlan {
  goal: string;
  steps: AgentRunStep[];
  requiredTools: ToolRef[];
  tracePolicy: TracePolicy;
}

export interface AgentRunStep {
  id: string;
  goal: string;
  instruction: AgentInputAsset;
  context: AgentInputAsset[];
  metadata: Record<string, string>;
}

export interface PreparedStep {
  stepId: string;
  input: AgentRunStep;
}

export interface RuntimeAdapter {
  prepare(step: AgentRunStep, context: AgentRunContext): Promise<PreparedStep>;
  execute(prepared: PreparedStep, control: ControlPort): Promise<StepResult>;
}
```

```ts
export interface DelegationEvent {
  sequence: number;
  kind: "prompt-read" | "command-invocation";
  assetName: PublicTraceText;
  path: PublicAssetPath;
}

export interface DelegationEvidenceSnapshot {
  events: readonly DelegationEvent[];
}

export interface DelegationEvidenceCollector {
  record(kind: DelegationEvent["kind"], assetName: PublicTraceText, path: PublicAssetPath): DelegationEvent;
  snapshot(): DelegationEvidenceSnapshot;
}

export interface AssetReadRequest {
  kind: "method-prompt" | "slash-command";
  name: string;
  relativePath: WorkspacePath;
}

export interface ResolvedAssetContent {
  path: WorkspacePath;
  canonicalPath: WorkspacePath;
  content: string;
}

export interface InvocationAssetSession {
  read(request: AssetReadRequest): Promise<ResolvedAssetContent>;
  dispose(): void;
}

export interface AssetFileSystem {
  realpath(path: WorkspacePath): Promise<WorkspacePath>;
  stat(path: WorkspacePath): Promise<{ isFile: boolean; isDirectory: boolean }>;
  readFile(path: WorkspacePath): Promise<Uint8Array>;
}

export interface CliExecutionContext {
  workspaceRoot: WorkspacePath; // Normalized logical path; may be a symlink.
  methodPromptsRoot: WorkspacePath;
  slashCommandsRoot: WorkspacePath;
  assetFileSystem: AssetFileSystem;
}

export interface CanonicalAssetRoots {
  workspace: WorkspacePath;
  methodPrompts: WorkspacePath;
  slashCommands: WorkspacePath;
  slashCommandsDir: WorkspacePath;
}
```

## US-INVENTOR-01 Delegation Design

### Invocation Asset Session

`InvocationAssetSession` is created after invocation validation and disposed after trace/output finalization. `CliExecutionContext` supplies normalized logical roots but does not promise that `workspaceRoot` or an asset root is already canonical. `openAssetSession` owns canonicalizing the workspace, method-prompt, slash-command, and `commands/` roots through the injected `AssetFileSystem`, validates their directory roles, and retains them as immutable `CanonicalAssetRoots`. The session also owns an invocation-local map keyed by canonical asset path. The first request for an asset canonicalizes and reads it; later requests in the same invocation may reuse that captured content. No module-level, static, process-wide, or cross-invocation semantic cache is allowed.

A second CLI invocation always creates a new session and therefore observes source changes. The session returns content-bearing resolved assets only to the CaTDD application and run-plan builder. `AgentSDK`, traces, logs, and diagnostics receive generic inputs or metadata projections, never a CaTDD semantic definition embedded in code.

`dispose()` clears the session map. Content strings copied into `CatddRunPlan`, `AgentRunPlan`, or `PreparedStep` remain run-local until the executor's `finally` path drops those references after output finalization; JavaScript secure erasure is not claimed. Production code must not persist content-bearing objects, and test fakes must reset captures between tests. The invariant is no cross-invocation reuse or persistence, not that no in-memory copy can exist after session disposal.

### Root Containment and Read Algorithm

V1 guarantees static containment while filesystem topology is stable from root canonicalization through asset read. The CLI completes every asset read before any external runtime adapter is prepared or executed. Concurrent adversarial replacement of directory or symlink topology during that interval is outside the V1 threat boundary; atomic contained-read is deferred as a future hardening option. Missing/deleted and permission changes during a read still fail closed through the attempted operation.

At session open and for each configured method-prompt or slash-command root:

1. Resolve `workspaceRoot`, the method-prompt root, the slash-command root, and its `commands/` child through `AssetFileSystem.realpath`; require each role to be a directory and retain the canonical values for the session lifetime.
2. Join a registry-owned relative asset path to the configured root. Behavior aliases contain file names and routing metadata only; they contain no method or command content.
3. Resolve the candidate with `realpath` so static symlinks and `..` segments cannot hide the final location.
4. Compute `relative(rootCanonicalPath, candidateCanonicalPath)`. Reject when the result is `..`, begins with `..` plus a path separator, or is absolute.
5. Classify public paths by computing `relative(workspaceCanonicalPath, candidateCanonicalPath)`. If contained, emit that normalized workspace-relative path; otherwise emit the configured-root label plus the canonical root-relative suffix. Never compare a canonical candidate with a merely absolute/logical workspace path.
6. Require the canonical candidate to be a regular file, then read bytes through `AssetFileSystem`. Reject a zero-byte file as `ASSET_EMPTY`.
7. Decode current source content, store it only in the invocation-local map, and return the content-bearing resolved asset.
8. For a successful method-prompt read, append a metadata-only `prompt-read` event. `SlashCommandExecutor` appends `command-invocation` immediately before calling the runtime adapter.

The attempted filesystem operation is authoritative. Missing/deleted (`ENOENT`), unreadable (`EACCES`/`EPERM`), wrong-kind, empty, root-missing, and root-escape failures map to typed errors. The resolver must not check existence and then assume a later read will succeed, and it must never substitute built-in semantic content.

| Error code | Trigger |
| --- | --- |
| `ASSET_ROOT_MISSING` | Configured method-prompt or slash-command root is absent or not a directory. |
| `ASSET_COMMANDS_DIR_MISSING` | The configured slash-command root has no `commands/` directory. |
| `ASSET_ESCAPE` | Canonical candidate is outside its canonical configured root. |
| `ASSET_WRONG_KIND` | Candidate exists but is not a regular file. |
| `ASSET_EMPTY` | Candidate is a zero-byte file. |
| `ASSET_MISSING` | Candidate disappears or is absent when canonicalized, opened, or read. |
| `ASSET_UNREADABLE` | Open/read returns `EACCES`, `EPERM`, or an equivalent permission failure. |

### Evidence and Runtime Capture

`CatddRunStep` remains in the CaTDD application layer. `src/catdd/agentRunPlanBuilder.ts` translates its slash command to one generic `instruction` asset and its method prompts to ordered generic `context` assets. Each input receives a `PublicAssetPath`; internal canonical paths stay in the asset session. This keeps `AgentSDK` free of CaTDD types while allowing an in-memory fake adapter to capture the safe logical path and current content it received.

`PublicAssetPath` is produced by one projection function using the session-owned `CanonicalAssetRoots`. Assets whose canonical paths are inside `workspaceCanonicalPath` use normalized workspace-relative paths even when the configured workspace path is a symlink. Assets supplied by a canonical configured root outside the canonical workspace use `<methodPromptsRoot>/<relativePath>` or `<slashCommandsRoot>/<relativePath>` labels. The projection rejects absolute output, empty output, and any `..` segment. `AgentRunStep.metadata` is allowlist-built from non-sensitive scalar labels and must not contain serialized invocations, canonical paths, or asset content.

`DelegationEvidenceCollector` assigns monotonically increasing sequence numbers. Prompt-read events are appended only after successful reads; command-invocation is appended immediately before adapter execution. For a step, every required prompt-read sequence must be lower than its command-invocation sequence. Events contain names and paths but no content.

An invocation-local cache hit does not create another `prompt-read` event because no physical read occurred. A skipped step creates no `command-invocation`; an adapter failure after the event records an attempted invocation and preserves the failure result separately.

US-INVENTOR-01 tests inspect the generic run plan, fake adapter capture, and evidence snapshot. US-INVENTOR-03 separately decides whether and how metadata is rendered to stderr under `--diagMethodPrompts` or `--diagSlashCommands`. Raw asset content is excluded from diagnostics and persisted traces.

The detail-level adapter contract refines the architecture's conceptual `PreparedRun` sketch without changing the adapter boundary. `SlashCommandExecutor` owns plan iteration. For each approved step it calls side-effect-free `prepare(step, context)`, records `command-invocation`, and calls `execute(prepared, control)`. A skipped step is neither prepared nor invoked. `StepResult` is accumulated into the run-level `AgentRunResult`/`ExecutionResult`.

### Requirement Traceability

| Story AC | Detailed-design mechanism |
| --- | --- |
| AC-01 | Edge prompt becomes a current-content context asset captured by the fake runtime; a logical workspace alias that canonicalizes elsewhere still produces `methodPrompts/CaTDD_methodPrompt4Cat-Edge.md`. |
| AC-02 | `UT_designFuncTestsSkeleton.md` becomes the instruction asset and produces `command-invocation`. |
| AC-03..AC-04 | Generic run inputs prove source delegation; sequenced evidence proves prompt-before-command order. |
| AC-05..AC-06 | Zero-byte prompt/command reads fail with `ASSET_EMPTY` and no fallback. |
| AC-07 | The declarative registry names Edge, test-structure, and workflow prompt paths independently. |
| AC-08 | A new `InvocationAssetSession` captures a sentinel added between invocations. |
| AC-09..AC-10 | Injected deletion between canonicalization and read maps to a missing-asset error. |
| AC-11..AC-12 | Canonical containment rejects prompt and command symlink/path escape before read. |
| AC-13..AC-16 | Root-missing, permission, missing commands directory, and wrong-kind paths map to typed errors. |

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
  traceId: TraceId;
  startedAt: IsoTimestamp;
  finishedAt: IsoTimestamp;
  invocation: TraceInvocation;
  workspace: TraceWorkspace;
  resolvedMethodPrompts: TraceResolvedAssetRef[];
  resolvedSlashCommands: TraceResolvedAssetRef[];
  delegationEvents: DelegationEvent[];
  steps: TraceStep[];
  files: TraceFileEvent[];
  tcTransitions: TraceTcTransition[];
  diagnostics: TraceDiagnostic[];
  exit: TraceExit;
}
```

```ts
export type TraceArgument =
  | { name: PublicTraceText; kind: "flag"; value: true }
  | { name: PublicTraceText; kind: "scalar"; value: PublicTraceText }
  | { name: PublicTraceText; kind: "path"; value: PublicAssetPath }
  | { name: PublicTraceText; kind: "target"; value: PublicTargetSelector }
  | { name: PublicTraceText; kind: "inline"; value: "[REDACTED]" }
  | { name: PublicTraceText; kind: "unserializable"; value: "[unserializable]" };

export interface TraceInvocation {
  behavior: PublicTraceText;
  target: PublicTargetSelector;
  arguments: TraceArgument[];
  redactedCommand: PublicTraceText;
}

export interface TraceWorkspace {
  repositoryRoot: "<workspace>";
  workingDirectory: PublicAssetPath;
  configFile?: PublicAssetPath;
}

// RunTrace is created only after invocation validation succeeds.
// US-INVENTOR-02 AC-09 requires no trace for argument-validation failure.

export interface TraceResolvedAssetRef {
  kind: "method-prompt" | "slash-command";
  name: PublicTraceText;
  path: PublicAssetPath;
  order: number;
  reason?: PublicTraceText;
}
```

`TraceInvocation.redactedCommand` is reconstructed from `TraceArgument[]`; raw argv is never retained. `--goal`, `--goalStory`, and `--input` become the literal `[REDACTED]`. Path-bearing arguments use `PublicAssetPath`; `--target` uses a `PublicTargetSelector` built by projecting every target file while preserving only validated comma and `::TC-ID` structure. Allowlisted values such as behavior and log level become bounded, control-character-free `PublicTraceText`.

`TraceWorkspace.repositoryRoot` is the fixed `<workspace>` token. Its working directory is `.` when it is the workspace root, otherwise a safe workspace-relative path; an external working directory is represented by `<externalWorkingDirectory>` without preserving its basename. Config paths use the same workspace-relative/root-labeled path policy.

`TraceResolvedAssetRef` is an explicit metadata projection. Internal `canonicalPath` and `content` from `ResolvedMethodPrompt`, `ResolvedSlashCommand`, and `AgentInputAsset` must never be copied into traces, diagnostics, logs, or error messages. `DelegationEvent.path` uses the same `PublicAssetPath` projection.

```ts
export interface TraceDiagnostic {
  code: PublicTraceText;
  severity: "info" | "warning" | "error";
  message: PublicTraceText;
  path?: PublicAssetPath;
}

export interface TraceStep {
  id: PublicTraceText;
  commandName: PublicTraceText;
  commandPath: PublicAssetPath;
  status: "planned" | "running" | "completed" | "failed" | "skipped" | "aborted";
  durationMs: number;
  adapter: PublicTraceText;
  approvalDecision?: "approve" | "skip" | "abort";
  diagnostic?: TraceDiagnostic;
}

export interface TraceFileEvent {
  path: PublicAssetPath;
  action: "read" | "write" | "skip";
}

export interface TraceTcTransition {
  tcId: PublicTraceText;
  category?: PublicTraceText;
  file: PublicAssetPath;
  beforeStatus?: "PLANNED" | "RED" | "GREEN";
  afterStatus?: "PLANNED" | "RED" | "GREEN";
  commandName: PublicTraceText;
}

export interface TraceExit {
  code: number;
  outcome: "completed" | "failed" | "aborted";
  durationMs: number;
  failureStepId?: PublicTraceText;
}
```

Every path-bearing trace field uses `PublicAssetPath` or `PublicTargetSelector`; every user-derived free-text field uses `PublicTraceText`; generated identity/time fields use validated `TraceId` or `IsoTimestamp`. During projection, a known field whose runtime value cannot be represented by its trace DTO becomes the literal `[unserializable]` and adds a `TRACE_VALUE_UNSERIALIZABLE` diagnostic, satisfying US-INVENTOR-02 AC-16. Unknown runtime fields are not copied into the DTO.

`traceSafety.ts` recursively visits the complete serialization DTO immediately before `JSON.stringify`/YAML encoding. It rejects canonical workspace/home prefixes, known raw inline values, loaded asset-content sentinels, control characters, absolute/path-traversal values in path fields, malformed generated IDs/timestamps, and any object outside the trace DTO allowlist. A failed safety assertion produces no trace file; this is distinct from the projection-time `[unserializable]` fallback.

## Behavior Design

```text
1. Parse argv and environment.
2. Load config and derive workspace roots.
3. Validate required fields and exclusive argument pairs.
4. Validate file paths for --inputFile, --goalStoryFile, --reference, --extra-prompt, and --config-file.
5. Parse --target into a typed selector.
6. Resolve --behave through BehaviorRegistry.
7. Check target selector compatibility with resolved behavior.
8. Open one invocation asset session and canonicalize configured roots.
9. Resolve and read portable slash commands and required method prompts into invocation-local content-bearing assets.
10. Record successful prompt reads and build generic runtime input assets with ordered steps.
11. For each step, request ControlPort decision when interactive mode is enabled.
12. Prepare the approved generic step through RuntimeAdapter; preparation is side-effect-free.
13. Record command invocation, then execute the prepared step through RuntimeAdapter.
14. Normalize results and collect evidence plus before/after file observations.
15. Project `TraceInvocation`, `TraceWorkspace`, and every nested trace DTO from typed runtime state without retaining raw argv.
16. Recursively assert the complete trace is safe, then serialize/write it and emit separately projected process output.
17. In a `finally` path, clear the asset session and drop production references to content-bearing plans, inputs, and prepared steps.
```

## State and Data

| State/Data | Owner | Lifecycle | Invariant |
| --- | --- | --- | --- |
| `RawCliArgs` | `cli/` | Created from argv, discarded after validation. | May contain invalid or missing values. |
| `CatddInvocation` | `catdd/` | Created after validation, used by planner/executor/trace. | Required fields are present and normalized. |
| `TargetSelector` | `cli/` + `catdd/` | Created from `--target`, used by behavior validation. | Exactly one selector kind is present. |
| `ResolvedBehavior` | `catdd/` | Created during behavior resolution. | Contains command names but no CaTDD category definitions. |
| `InvocationAssetSession` | `catdd/` | Created once per validated invocation and disposed at exit. | Its map is cleared; no cached content is reused or persisted across invocations. |
| `ResolvedMethodPrompt` / `ResolvedSlashCommand` | `catdd/` | Created by fresh session reads and used to build the run plan. | Canonical path is root-contained; content is internal and non-empty. |
| `DelegationEvidenceSnapshot` | `executor/` | Appended during reads and execution, then projected to trace/diagnostics. | Sequence is monotonic; events contain no source content. |
| `CatddRunPlan` | `catdd/` | Created before execution. | All required assets are content-bearing, root-contained, and ordered. |
| `AgentRunPlan` / `PreparedStep` | `agentsdk/` + adapter | Created from `CatddRunPlan` and released after run finalization. | Contains generic input assets, no CaTDD-specific types, and is never persisted. |
| `StepResult` | `executor/` + adapter | Created per command step. | Expected failures are structured, not hidden in logs. |
| `PolicyState` | `executor/` | Created at run start and updated per step. | Tracks retry counts, correction loops, escalation flags, and denied-sensitive-path attempts. |
| `RunTrace` | `trace/` | Created from serialization-only projections and written at exit. | Every path/text field is safe-typed; recursive validation fails closed before encoding. |

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
| Configured method/slash root missing or not a directory | Exit code 1; typed root error names the root role and safe path. |
| `slashCommands/commands/` missing | Exit code 1; typed command-root error; no behavior fallback. |
| Prompt or command canonical path escapes its configured root | Exit code 1 before read/invocation; stderr reports configured-root escape. |
| Filesystem topology changes adversarially during containment/read | Outside the V1 atomicity guarantee; no external adapter runs until all reads finish. Track atomic contained-read as future hardening. |
| Prompt or command path is a directory | Exit code 1; wrong-kind error identifies that a regular file was required. |
| Prompt or command is zero bytes | Exit code 1 with `ASSET_EMPTY`; no built-in semantic content is substituted. |
| Asset is deleted or becomes unreadable before read | Exit code 1 from the attempted read; map `ENOENT`, `EACCES`, or `EPERM` without an existence-precheck assumption. |
| Interactive skip | Step is skipped; trace records skipped command and reason. |
| Interactive abort | No further steps run; exit code 1; trace records abort point. |
| `reviewImplTestFile` finds no RED/GREEN TCs | Exit code 0; stdout reports that no implemented TCs were found and no file is modified. |
| Adapter execution failure after planning | Failure trace is written with completed steps and active failure point. |
| Trace projection or recursive safety validation fails | Fail closed; do not encode or persist any trace content. |
| Known runtime field is not representable in its trace DTO | Replace that value with `[unserializable]`, add `TRACE_VALUE_UNSERIALIZABLE`, and continue with final safety validation. |

## Implementation Plan

| Step | Deliverable | Verification |
| --- | --- | --- |
| 1 | Package scaffold and TypeScript config. | Compile empty project and run placeholder test. |
| 2 | `cli/` parser and target selector. | Unit tests for required args, exclusive pairs, and target forms. |
| 3 | `catdd/` behavior registry, invocation asset session, and asset resolvers. | Unit tests for fresh reads, three named prompts, empty/missing/wrong-kind assets, root escape, and no fallback. |
| 4 | Generic `AgentInputAsset` translation, safe public-path projection, prepared-step adapter, delegation evidence, and in-memory fake adapter. | Type tests proving no CaTDD types in SDK; capture/order tests; assertions that public output has no canonical path or raw content. |
| 5 | `executor/` plan execution with `ControlPort`. | Tests for approve, skip, abort, and structured step failures. |
| 6 | Complete trace DTOs, projection, recursive safety validation, collector, and writer. | JSON schema plus whole-serialization leakage tests for success and failure traces. |
| 7 | Reliability policy layer (`classifyFailure`, `evaluateStepPolicy`, sensitive-path gate). | Unit tests for ASR-R1..R6 behavior and deterministic non-interactive escalation. |
| 8 | End-to-end dry-run fixture. | CLI-level test from valid invocation to planned command sequence and trace. |

## Verification Strategy

- Unit-test parser and selector behavior without invoking external agents.
- Unit-test behavior resolution against fixture command roots.
- Unit-test each invocation with a new `InvocationAssetSession`; mutate a sentinel between sessions to prove fresh reads.
- Unit-test missing, empty, permission, wrong-kind, and post-canonicalization deletion failures with `FakeAssetFileSystem`.
- Unit-test prompt and command symlink/path escape against canonical configured roots before any content read.
- Retarget TC-DELEGATE-001 with a logical workspace alias whose `realpath` differs from its configured path; before product correction it must turn RED when the internal Edge prompt is root-labeled instead of workspace-relative.
- State the V1 stable-topology assumption in the tests; do not claim concurrent adversarial symlink-swap resistance.
- Capture the generic run step with `FakeRuntimeAdapter` and assert current instruction/context content plus event order.
- Contract-test `prepare(step) -> PreparedStep -> execute(prepared) -> StepResult`, including skip and adapter-failure evidence.
- Type-test that `AgentRunStep` imports no CaTDD-specific resolved type.
- Snapshot-test metadata-only diagnostic output for actionable error wording; raw source content, canonical paths, absolute workspace/home prefixes, and `..` segments must be absent.
- Verify session disposal clears invocation-local entries, a new session rereads assets, production content-bearing objects are not serialized, and fake captures reset between tests.
- Validate `RunTrace` with a JSON schema parser and reject unknown/non-DTO fields.
- Inject a known non-serializable runtime value and verify projection emits `[unserializable]` plus `TRACE_VALUE_UNSERIALIZABLE` before the final safety gate.
- Serialize traces containing sentinel values in raw argv, inline goal/story/input, asset content, absolute workspace/home paths, external roots, target lists, TC selectors, diagnostics, file events, and failures; assert only redacted or public projections survive.
- Force `assertSafeTrace` failure and verify no partial trace file is created.
- Use fixture test files to verify observed TC transition extraction.
- Add adapter contract tests using an in-memory fake adapter before adding Copilot/OpenCode adapters.
- Add policy tests for retry budget exhaustion, failure classification, unknown-behavior fallback, sensitive-path denial, and escalation behavior in interactive and non-interactive modes.

## Assumptions

- First implementation language is the runtime selected by the ADR.
- First runtime is local raw process execution using the chosen runtime adapter.
- Copilot/MCP and OpenCode are adapter targets after the raw runtime contract is stable.
- LangGraph and Google ADK remain reference architectures until a later story asks for optional adapters.
- Default trace output is module-local under `codeAgents/utCodeAgentCLI/traces/`.
- Asset content is UTF-8 Markdown/text and remains internal to the invocation/run input boundary.
- V1 assumes no concurrent adversarial directory or symlink topology mutation from root canonicalization through asset read; all reads complete before external adapter preparation.
- Atomic contained-read is a future hardening option, not a V1 guarantee.
- Raw argv is invocation-local input only; traces retain a reconstructed redacted command and typed argument projections.
- `CliExecutionContext` roots are normalized logical paths and may be symlinks; `InvocationAssetSession` alone owns canonicalizing and retaining roots for containment and public projection.

## Detail-Design Update Feedback

- [x] Add one fresh asset session per invocation and prohibit persistent semantic caching.
- [x] Pass current prompt/command content to a generic run step without leaking CaTDD types into `AgentSDK`.
- [x] Capture monotonic prompt-read and command-invocation evidence for an in-memory fake runtime.
- [x] Canonicalize roots and candidates, reject segment-safe root escape, and define typed asset errors.
- [x] Keep source content out of traces, diagnostics, logs, and error messages through metadata projection.
- [x] Define deterministic fake filesystem/runtime boundaries for permission, mutation, symlink, and capture tests.
- [x] Map all 16 US-INVENTOR-01 ACs to implementation-facing mechanisms.
- [x] Review the first revision with `/SPEC_reviewDetailDesign`; result: REVISE.
- [x] Remove canonical paths from public schemas and define safe workspace-relative/root-labeled projection.
- [x] Standardize `RuntimeAdapter` on a prepared-step lifecycle and assign `AgentRunPlanBuilder` ownership.
- [x] Document the V1 stable-filesystem threat boundary and defer atomic contained-read hardening.
- [x] Replace the false erasure claim with bounded no-reuse/no-persistence content lifetime.
- [x] Re-review DD-REV-01 through DD-REV-04 with `/SPEC_reviewDetailDesign`; those findings pass, but DD-REV-05 requires revision.
- [x] Define redacted `TraceInvocation`, safe `TraceWorkspace`, and safe nested trace DTOs.
- [x] Reconstruct command evidence without retaining raw argv or inline source/story values.
- [x] Add recursive whole-trace safety validation and fail-closed no-file behavior.
- [x] Add whole-serialization leakage fixtures for every path/value-bearing trace surface.
- [x] Re-review DD-REV-05 with `/SPEC_reviewDetailDesign`; result: PASS.
- [x] Resolve PROD-REV-01 by assigning workspace and asset-root canonicalization to `openAssetSession` through the injected filesystem.
- [x] Preserve TC-DELEGATE-001 identity and define a symlinked-workspace fake topology that must fail before product correction.
- [ ] Re-review the PROD-REV-01 detail-design correction with `/SPEC_reviewDetailDesign`.

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

for doc in codeAgents/utCodeAgentCLI/README_DetailDesign.md codeAgents/utCodeAgentCLI/README_DetailDesign_ZH.md; do
  grep -Fq 'InvocationAssetSession' "$doc"
  grep -Fq 'DelegationEvidenceCollector' "$doc"
  grep -Fq 'TraceResolvedAssetRef' "$doc"
  grep -Fq 'PublicAssetPath' "$doc"
  grep -Fq 'PreparedStep' "$doc"
  grep -Fq 'TraceInvocation' "$doc"
  grep -Fq 'TraceWorkspace' "$doc"
  grep -Fq 'CanonicalAssetRoots' "$doc"
done
```

Expected result: `diff` prints no output, every contract marker is found, and the block exits with code 0.

## Review Checklist

- Every acceptance criterion has a design impact or explicit non-impact.
- Interfaces and state changes are clear enough to drive tests.
- `AgentSDK` contracts contain no CaTDD category or status definitions.
- Each invocation owns a fresh asset session; no persistent semantic cache exists.
- Canonical containment rejects configured-root escape before asset content is read.
- V1 static-containment scope and deferred atomic hardening are explicit.
- Generic runtime inputs carry current content while evidence, diagnostics, and traces remain metadata-only.
- Public evidence paths are workspace-relative or root-labeled and never canonical/absolute.
- Public path classification compares canonical asset paths with the session-owned canonical workspace root; logical/symlinked workspace paths are never used for trust classification.
- Runtime adapters consume `PreparedStep`; executor owns plan iteration.
- Content-bearing session/plan objects are run-local, cleared or released, and never persisted.
- Raw argv is replaced by typed redacted arguments and a reconstructed command.
- Every nested trace path/text field is safe-typed and the complete DTO is recursively validated before encoding.
- Prompt-read events precede command-invocation for every step.
- Behavior aliases resolve to slash commands; they do not duplicate command logic.
- Trace schema covers success and execution failure.
- Error messages can name argument, path, state, and suggestion.
- EN/ZH heading structure matches.

## Next Step

Run `/SPEC_reviewDetailDesign` to review the PROD-REV-01 ownership and test-first correction design before changing tests or product code.
