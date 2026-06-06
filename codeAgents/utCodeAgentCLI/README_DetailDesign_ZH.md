# utCodeAgentCLI 详细设计

本文将 architecture 转换为未来 `utCodeAgentCLI` implementation 可使用的 implementation-facing contracts、data schemas、state transitions 与 verification strategy。本文基于 [`slashCommands/templates/README_DetailDesignTemplate.md`](../../slashCommands/templates/README_DetailDesignTemplate.md)。

## Story Context

- Story: [../../.catdd/spec/doneUS/20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md](../../.catdd/spec/doneUS/20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md)
- Architecture: [README_ArchDesign_ZH.md](README_ArchDesign_ZH.md)
- Usage contract: [README_UsageDesign_ZH.md](README_UsageDesign_ZH.md)
- Requirements index: [README_UserStory_ZH.md](README_UserStory_ZH.md)
- ASR source: [ASRs/ASR_AgenticReliabilityContracts.md](ASRs/ASR_AgenticReliabilityContracts.md)
- ADR source: [ADRs/ADR_AgenticReliabilityPolicy.md](ADRs/ADR_AgenticReliabilityPolicy.md)
- Method source of truth: [../../methodPrompts/](../../methodPrompts/)
- Portable command source of truth: [../../slashCommands/](../../slashCommands/)

本 detail design 保持 architecture 决策不变：`AgentSDK` 是 generic 且 CaTDD-independent；`utCodeAgentCLI` 解析 user intent，将 CaTDD behaviors 解析到 delegated assets，调用 runtime adapter，并记录 traces。根据运行时语言 ADR，V1 使用 TypeScript on Node.js 实现，V2 生产分发预选 Go。

## Who

| Role | Detail-design concern |
| --- | --- |
| USER | 获得可预测的 CLI validation、behavior execution、test-file state transitions 与可读输出。 |
| INVENTOR | 获得 runtime proof，证明 method prompts 与 slash commands 是从 source files 解析出来，而不是硬编码在 CLI logic 中。 |
| DEVELOPER | 获得 parser、planner、executor、adapter、trace、diagnostics 与 control modules 的具体 TypeScript contracts。 |

## What

`utCodeAgentCLI` 将首先实现为 local CLI，根据运行时语言 ADR 使用 TypeScript on Node.js。v1 detail design 包括：

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

### V2 Go Portability Boundary

V1 使用 TypeScript on Node.js 发布，但运行时语言 ADR 为 V2 生产分发预选 Go。为使该迁移成本受控，V1 detail design 必须保持清晰的可移植边界：

- 保持 `AgentSDK` runtime/adapter contracts 在形状上语言中立（不让 Node-only 类型泄漏过 `RuntimeAdapter`、`TracePort`、`ControlPort` 或 `HookPort` 边界）。
- 保持 CaTDD semantics 委托给 `methodPrompts/` 与 `slashCommands/` 文件，而非嵌入 TS 代码，使 Go 重写能复用同一批 portable assets。
- 保持 trace schema（带 `traceVersion` 的 JSON/YAML）与实现无关，使 V2 Go 输出保持兼容。
- 将 Node 特定关注（process spawning、fs access、module loading）限定在 adapter 局部，使只有 adapters（而非核心编排）需要为 Go 重写。

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
| Support replaceable runtimes. | `US-DEV-04` | Default adapter 是最终选定 runtime/process based；Copilot/OpenCode adapters 属于后续 implementation。 |
| Enforce ASR reliability and safety policy defaults at runtime. | `US-DEV-05`, `ASR-R1`..`ASR-R6`, `ADR_AgenticReliabilityPolicy` | 运行时策略必须在重试预算、fallback 路由、失败分类、升级行为和敏感路径控制上保持确定性。 |

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
| DD-AC-10 | 瞬时重试超出策略预算。 | Executor 应用策略决策。 | 重试确定性停止，并输出升级元数据。 | 在执行结果中增加重试预算状态与升级原因码。 |
| DD-AC-11 | `--behave` 不受支持。 | Behavior resolution 执行。 | Diagnostics fallback 返回支持值并以参数错误退出。 | 在 resolver 结果类型中加入 fallback 契约，禁止静默容错。 |
| DD-AC-12 | 检测到永久失败。 | Failure classification 执行。 | 跳过重试并走快速失败路径。 | 在 step result 中增加 `failureClass` 与分类规则。 |
| DD-AC-13 | 运行在已有修改步骤后失败。 | Compensation boundary handling 执行。 | 阻断后续会修改状态的步骤；trace 记录最后一致步骤边界。 | 在 trace schema 中增加 step snapshot 与补偿标记。 |
| DD-AC-14 | 非交互执行命中升级触发条件。 | Control handling 执行。 | 强制中止并返回确定性退出码与升级标记。 | 在 `ControlPort` 契约中增加非交互升级模式。 |
| DD-AC-15 | 步骤在无策略批准时访问敏感路径。 | 执行前策略检查运行。 | 在 adapter 执行前拒绝步骤，且 diagnostics/trace 对 secret-like 内容脱敏。 | 在 adapter 执行前增加敏感路径 gate 与 redaction 分类。 |

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
| `classifyFailure(error)` | `RuntimeError` | `FailureClass` (`TRANSIENT` or `PERMANENT`) | 当分类置信度不足时返回 `PERMANENT`，避免不安全重试。 |
| `evaluateStepPolicy(step, state)` | `AgentRunStep`, `PolicyState` | `PolicyDecision` | 当重试预算或敏感路径策略违规时拒绝执行。 |
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
| `PolicyState` | `executor/` | 在 run 开始时创建并按 step 更新。 | 跟踪重试计数、修正循环、升级标记与敏感路径拒绝次数。 |
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
| Retry budget exhausted | 该步骤不再重试；输出升级原因并持久化 trace。 |
| Failure classified as PERMANENT | 跳过重试路径并快速失败，同时输出分类细节。 |
| Non-interactive escalation condition met | 强制中止，确定性非零退出，并写入 `ESCALATED_NON_INTERACTIVE` trace tag。 |
| Sensitive path access without policy approval | 在 adapter 执行前拒绝步骤；diagnostics 标识被拒绝路径类别但不泄露 secrets。 |
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
| 7 | Reliability policy layer (`classifyFailure`, `evaluateStepPolicy`, sensitive-path gate). | Unit tests for ASR-R1..R6 behavior and deterministic non-interactive escalation. |
| 8 | End-to-end dry-run fixture. | CLI-level test from valid invocation to planned command sequence and trace. |

## Verification Strategy

- Unit-test parser and selector behavior without invoking external agents。
- Unit-test behavior resolution against fixture command roots。
- Unit-test missing prompt/command failures with temporary directories。
- Snapshot-test diagnostic output for actionable error wording。
- Validate `RunTrace` with a JSON schema parser。
- Use fixture test files to verify observed TC transition extraction。
- Add adapter contract tests using an in-memory fake adapter before adding Copilot/OpenCode adapters。
- Add policy tests for retry budget exhaustion, failure classification, unknown-behavior fallback, sensitive-path denial, and escalation behavior in interactive and non-interactive modes。

## Assumptions

- First implementation language is ADR 最终选定的运行时。
- First runtime is local raw process execution，使用最终选定的 runtime adapter。
- Copilot/MCP and OpenCode are adapter targets after the raw runtime contract is stable。
- LangGraph and Google ADK remain reference architectures until a later story asks for optional adapters。
- Default trace output is module-local under `codeAgents/utCodeAgentCLI/traces/`。

## Open Questions

- Which package manager and test runner should the chosen implementation use?
- Should installed-target traces later default to `.catdd/traces/` instead of the module-local trace directory?
- Should prompt-wrapper execution or MCP tool execution be the first Copilot adapter surface?
- Should OpenCode support start as a command adapter or provider abstraction?
- Should `.npmrc`, `.netrc`, `*.p12`, `*.jks`, and other repo-local credential-bearing patterns be included in the default sensitive-path deny list for v1?

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

运行 `/SPEC_reviewUserStory`，先基于已更新的 architecture 与 detail design 进行 story readiness 评审，再进入任何 coding 或 test-generation 命令。