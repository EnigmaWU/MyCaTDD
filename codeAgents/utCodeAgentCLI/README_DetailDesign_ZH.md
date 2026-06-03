# utCodeAgentCLI 详细设计

本文将已通过 review 的 architecture 转换为未来 `utCodeAgentCLI` implementation 可使用的 TypeScript-facing contracts、data schemas、state transitions 与 verification strategy。本文基于 [`slashCommands/templates/README_DetailDesignTemplate.md`](../../slashCommands/templates/README_DetailDesignTemplate.md)。

## Story Context

- Story: [../../.catdd/spec/doingUS/20260530-design-utCodeAgentCLI-architecture-UserStory.md](../../.catdd/spec/doingUS/20260530-design-utCodeAgentCLI-architecture-UserStory.md)
- Architecture: [README_ArchDesign_ZH.md](README_ArchDesign_ZH.md)
- Usage contract: [README_UsageDesign_ZH.md](README_UsageDesign_ZH.md)
- Requirements index: [README_UserStory_ZH.md](README_UserStory_ZH.md)
- Method source of truth: [../../methodPrompts/](../../methodPrompts/)
- Portable command source of truth: [../../slashCommands/](../../slashCommands/)

本 detail design 保持 architecture 决策不变：`AgentSDK` 是 generic 且 CaTDD-independent；`utCodeAgentCLI` 解析 user intent，将 CaTDD behaviors 解析到 delegated assets，调用 runtime adapter，并记录 traces。

## Who

| Role | Detail-design concern |
| --- | --- |
| USER | 获得可预测的 CLI validation、behavior execution、test-file state transitions 与可读输出。 |
| INVENTOR | 获得 runtime proof，证明 method prompts 与 slash commands 是从 source files 解析出来，而不是硬编码在 CLI logic 中。 |
| DEVELOPER | 获得 parser、planner、executor、adapter、trace、diagnostics 与 control modules 的具体 TypeScript contracts。 |

## What

`utCodeAgentCLI` 将首先实现为 local TypeScript/Node.js CLI。v1 detail design 包括：

- CLI argument parsing and validation。
- 从 CLI aliases 或 direct `UT_*` names 到 portable slash commands 的 behavior resolution。
- 通过 file path 解析 method prompt。
- 解析 one TC、one TestFile 或 multiple TestFiles 的 test target。
- 通过 adapter interface 创建和执行 command plan。
- Interactive per-command control。
- Structured diagnostics 与 machine-readable trace writing。

## When

在为 `utCodeAgentCLI` 编写 `src/`、executable tests 或 package metadata 之前使用本设计。

当 CLI flags、behavior aliases、trace schema、adapter capabilities、state transitions 或 command-resolution rules 变化时更新本文件。

## Where

第一版 implementation 应保持 module-scoped：

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

`AgentSDK` 先位于 `src/agentsdk/`，便于 contracts 在 CLI 旁边稳定下来。只有当 adapter 与 trace APIs 经过 tests 证明后，才允许后续拆分为独立 package。

## Why

主要 detail-design 风险是意外复制 method semantics。本设计通过限制 CLI-owned logic 为 parsing、validation、planning、orchestration、control、diagnostics 与 trace persistence 来避免这一点。Category meaning、skeleton wording、status discipline 与 portable command behavior 继续委托给 `methodPrompts/` 与 `slashCommands/`。

## How

Execution flow：

1. 将 argv 解析成 `RawCliArgs`。
2. 规范化 paths，并将 config 加载为 `CliExecutionContext`。
3. 验证 required arguments、mutually exclusive pairs、file paths、target shape 与 behavior compatibility。
4. 构建 `CatddInvocation`。
5. 将 behavior 解析为 `ResolvedBehavior` 与 `ResolvedSlashCommand[]`。
6. 将 required method prompts 解析为 `ResolvedMethodPrompt[]`。
7. 构建 `CatddRunPlan` 与 generic `AgentRunPlan`。
8. 通过 `SlashCommandExecutor` 与 `RuntimeAdapter` 执行每个 command step。
9. 收集 file observations、command results、TC transitions、diagnostics 与 control decisions。
10. 在 success 或 execution failure 时写入 trace。

## Requirements

| Requirement | Source | Notes |
| --- | --- | --- |
| Validate required arguments and exclusive pairs. | `US-USER-01`, `README_UsageDesign.md` | Parser 负责 syntax 与 shape；validation failure 时不执行 command。 |
| Generate, review, select, and implement CaTDD test artifacts. | `US-USER-02` through `US-USER-10` | CLI 解析 behaviors；slash commands 拥有 artifact content。 |
| Delegate CaTDD semantics. | `US-INVENTOR-01` | CLI 中不硬编码 category meaning 或 status meaning。 |
| Produce machine-readable traces. | `US-INVENTOR-02` | Successful execution 与 execution failure 都写 trace。 |
| Reveal resolved prompts and commands. | `US-INVENTOR-03` | Diagnostic flags 暴露 file paths 与 resolution reasons。 |
| Produce actionable errors. | `US-DEV-01` | Errors 命名 argument/path/state 并给出 corrections。 |
| Support logging and interactive control. | `US-DEV-02`, `US-DEV-03` | `LogSink` 与 `ControlPort` 是明确 dependencies。 |
| Support replaceable runtimes. | `US-DEV-04` | Default adapter 是 raw TypeScript/process based；Copilot/OpenCode adapters 属于后续 implementation。 |

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
| DD-AC-08 | `reviewImplTestFile` targets one TestFile. | Behavior resolution runs. | CLI 构建 read-only sequence，对每个 RED/GREEN TC 调用 `UT_reviewImplTestCase`，并跳过 PLANNED TCs，最后输出 summary。 | `BehaviorRegistry` 将 `reviewImplTestFile` 视为 stable orchestration alias，而不是新的 CaTDD method。 |
| DD-AC-09 | EN/ZH detail design docs exist. | Mirror check runs. | Heading structure matches. | Keep sections synchronized when updating design. |

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

Default trace output 是 `codeAgents/utCodeAgentCLI/traces/`，以保持 module locality。Config file 可以覆盖它；未来 installed-target usage 可以选择 `.catdd/traces/`。

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
| `RunTrace` | `trace/` | Created during execution and written at exit. | Secrets and raw sensitive content are redacted. |

## State Machine

CaTDD file-state transitions 继续委托并被观察：

```text
EMPTY -> DESIGNED -> PARTIAL -> FULLY_RED -> ALL_GREEN
```

CLI run-state transitions 是 generic：

```text
created -> validated -> planned -> running -> completed
                              \-> waiting_for_approval
                              \-> failed
                              \-> aborted
                              \-> skipped
```

CLI 只能通过 delegated slash-command execution 写入 `PLANNED -> RED`。它绝不写入 `RED -> GREEN`。

## Embedded and Digital Media Detail Points

`utCodeAgentCLI` v1 不适用。当前没有 interrupt、driver、buffer、media timing、sample format、power 或 A/V synchronization boundary。对应的本地等价 concern 是 process lifecycle、timeout、cancellation、trace file growth、redaction 与 adapter output capture；这些已经由 execution、trace 与 control design 覆盖。

## Error and Edge Handling

| Condition | Expected behavior |
| --- | --- |
| Missing `--goal`, `--target`, or `--behave` | Exit code 1；stderr 命名 missing arguments 并解释 purpose。 |
| Conflicting exclusive args | Exit code 1；stderr 命名两个 arguments 并说明 conflict。 |
| Missing file path | Exit code 1；stderr 包含 argument name 与 resolved path。 |
| Unknown behavior | Exit code 1；stderr 列出 valid aliases/direct command names 与 nearest suggestion。 |
| Target/behavior mismatch | Exit code 1；stderr 解释 required target shape 并建议 valid combinations。 |
| Missing method prompt or slash command | Exit code 1；stderr 命名 missing asset path；不使用 fallback semantic copy。 |
| Interactive skip | Step 被 skipped；trace 记录 skipped command 与 reason。 |
| Interactive abort | 不再执行后续 steps；exit code 1；trace 记录 abort point。 |
| `reviewImplTestFile` 找不到 RED/GREEN TCs | Exit code 0；stdout 报告未找到 implemented TCs；不修改文件。 |
| Adapter execution failure after planning | 写入 failure trace，包含 completed steps 与 active failure point。 |
| Trace redaction failure | Fail closed；不持久化 unsafe trace content。 |

## Implementation Plan

| Step | Deliverable | Verification |
| --- | --- | --- |
| 1 | Package scaffold and TypeScript config. | Compile empty project and run placeholder test. |
| 2 | `cli/` parser and target selector. | Unit tests for required args, exclusive pairs, and target forms. |
| 3 | `catdd/` behavior and asset resolvers. | Unit tests for aliases, direct `UT_*` names, missing assets, and suggestions. |
| 4 | `agentsdk/` generic interfaces and raw adapter. | Type tests or unit tests proving no CaTDD category definitions in SDK. |
| 5 | `executor/` plan execution with `ControlPort`. | Tests for approve, skip, abort, and structured step failures. |
| 6 | `trace/` schema, collector, and writer. | JSON schema tests for success and execution failure traces. |
| 7 | End-to-end dry-run fixture. | CLI-level test from valid invocation to planned command sequence and trace. |

## Verification Strategy

- Unit-test parser and selector behavior without invoking external agents。
- Unit-test behavior resolution against fixture command roots。
- Unit-test missing prompt/command failures with temporary directories。
- Snapshot-test diagnostic output for actionable error wording。
- Validate `RunTrace` with a JSON schema parser。
- Use fixture test files to verify observed TC transition extraction。
- Add adapter contract tests using an in-memory fake adapter before adding Copilot/OpenCode adapters。

## Assumptions

- First implementation language is TypeScript on Node.js。
- First runtime is local raw TypeScript/process execution。
- Copilot/MCP and OpenCode are adapter targets after the raw runtime contract is stable。
- LangGraph and Google ADK remain reference architectures until a later story asks for optional adapters。
- Default trace output is module-local under `codeAgents/utCodeAgentCLI/traces/`。

## Open Questions

- Which package manager and test runner should the first TypeScript implementation use?
- Should installed-target traces later default to `.catdd/traces/` instead of the module-local trace directory?
- Should prompt-wrapper execution or MCP tool execution be the first Copilot adapter surface?
- Should OpenCode support start as a command adapter or provider abstraction?

## Usage Example

从 repository root 运行以下命令，验证 detail-design 文档对具有匹配 heading structure：

```bash
awk '/^#{1,6} /{print length($1), $1}' codeAgents/utCodeAgentCLI/README_DetailDesign.md > /tmp/ut-detail-en.headings
awk '/^#{1,6} /{print length($1), $1}' codeAgents/utCodeAgentCLI/README_DetailDesign_ZH.md > /tmp/ut-detail-zh.headings
diff -u /tmp/ut-detail-en.headings /tmp/ut-detail-zh.headings
```

Expected result：`diff` 不输出内容，并以 code 0 退出。

## Review Checklist

- Every acceptance criterion has a design impact or explicit non-impact。
- Interfaces and state changes are clear enough to drive tests。
- `AgentSDK` contracts contain no CaTDD category or status definitions。
- Behavior aliases resolve to slash commands; they do not duplicate command logic。
- Trace schema covers success and execution failure。
- Error messages can name argument, path, state, and suggestion。
- EN/ZH heading structure matches。

## Next Step

运行 `/SPEC_designUnitTests`，为已批准的 story、architecture 与 detail design 设计 CaTDD unit-test skeletons。