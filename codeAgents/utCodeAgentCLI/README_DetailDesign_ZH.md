# utCodeAgentCLI 详细设计

本文将 architecture 转换为增量 `utCodeAgentCLI` implementation 可使用的 implementation-facing contracts、data schemas、state transitions 与 verification strategy。本文基于 [`slashCommands/templates/README_DetailDesignTemplate.md`](../../slashCommands/templates/README_DetailDesignTemplate.md)。

## Story Context

- Active story: [../../.catdd/spec/doingUS/20260607-utCodeAgentCLI-US-INVENTOR-01-UserStory.md](../../.catdd/spec/doingUS/20260607-utCodeAgentCLI-US-INVENTOR-01-UserStory.md)
- Active tasks: [../../.catdd/spec/doingUS/20260607-utCodeAgentCLI-US-INVENTOR-01-TASKs.md](../../.catdd/spec/doingUS/20260607-utCodeAgentCLI-US-INVENTOR-01-TASKs.md)
- Reviewed requirement: [USs/README_UserStory4INVENTOR-01.md](USs/README_UserStory4INVENTOR-01.md)
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

`utCodeAgentCLI` 正按增量方式实现为 local CLI，并根据运行时语言 ADR 使用 TypeScript on Node.js。US-USER-01 invocation-validation slice 已存在；其余 v1 detail design 包括：

- CLI argument parsing and validation。
- 从 CLI aliases 或 direct `UT_*` names 到 portable slash commands 的 behavior resolution。
- 通过 canonical file path 与 current source content fresh-resolve method prompts 和 slash commands。
- 解析 one TC、one TestFile 或 multiple TestFiles 的 test target。
- 通过 adapter interface 创建和执行 command plan。
- Interactive per-command control。
- Structured diagnostics 与 machine-readable trace writing。

## When

在为 `utCodeAgentCLI` 增加新的 `src/` modules、executable test slices 或 package metadata 之前使用本设计。

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
5. 为本次 invocation 创建一个 `InvocationAssetSession`。
6. 将 behavior 解析为 `ResolvedBehavior` 与 fresh、root-contained `ResolvedSlashCommand[]`。
7. 将 required method prompts 解析为 fresh、content-bearing `ResolvedMethodPrompt[]`，并记录有序 `prompt-read` events。
8. 构建 `CatddRunPlan`，再把 assets 转换为 generic `AgentRunPlan` 的 `AgentInputAsset[]`。
9. 在 `RuntimeAdapter.execute()` 前立即记录 `command-invocation` event。
10. 通过 `SlashCommandExecutor` 与 `RuntimeAdapter` 执行每个 command step。
11. 收集 file observations、command results、TC transitions、diagnostics 与 control decisions。
12. 在 success 或 execution failure 时写入 metadata-only trace projection，然后销毁 invocation asset session。

## Requirements

| Requirement | Source | Notes |
| --- | --- | --- |
| Validate required arguments and exclusive pairs. | `US-USER-01`, `README_UsageDesign.md` | Parser 负责 syntax 与 shape；validation failure 时不执行 command。 |
| Generate, review, select, and implement CaTDD test artifacts. | `US-USER-02` through `US-USER-10` | CLI 解析 behaviors；slash commands 拥有 artifact content。 |
| Delegate CaTDD semantics. | `US-INVENTOR-01` | 通过 per-invocation asset session 读取 current prompt/command content，并通过 generic inputs 传给 runtime；禁止 persistent semantic cache 与 hardcoded fallback。 |
| Produce machine-readable traces. | `US-INVENTOR-02` | Successful execution 与 execution failure 都写 trace。 |
| Reveal resolved prompts and commands. | `US-INVENTOR-03` | Diagnostic flags 渲染 resolved paths 与 events 的 metadata-only projection；US-INVENTOR-01 负责 internal structured capture。 |
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
| DD-AC-04 | A behavior needs CaTDD semantics. | Prompt resolution runs. | Required method prompt paths 与 current content 被解析，否则 execution stops。 | `MethodPromptResolver` 通过 `InvocationAssetSession` 从 configured method roots 读取。 |
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
| DD-AC-16 | Invocation 需要 method 与 command assets。 | 构建 run plan。 | Generic runtime inputs 包含 current resolved content，且没有 CLI semantic fallback。 | 将 content-bearing `CatddRunStep` assets 转换为 generic `AgentInputAsset` values。 |
| DD-AC-17 | Run 必须先读取 prompts 再调用 command。 | Approved step 被 prepare 并 execute。 | 单调递增的 `prompt-read` events 位于其 `command-invocation` event 之前。 | Executor 负责 `prepare(step) -> PreparedStep -> execute(prepared)` 并记录 metadata-only evidence。 |
| DD-AC-18 | 需要 Edge meaning、status structure 与 execution order。 | Prompt resolution 运行。 | 三个已命名 canonical prompt files 独立解析。 | Required-asset registry 仅保存 declarative path；meaning 从文件读取。 |
| DD-AC-19 | Prompt 在一次 invocation 后发生变化。 | 准备第二次 invocation。 | 第二次 run input 包含 current source content。 | 每次 invocation 创建并销毁一个 `InvocationAssetSession`；清空其 map，并禁止 cross-invocation reuse 或 persistence。 |
| DD-AC-20 | 在 V1 stable-filesystem assumption 下，prompt 或 command 解析到 configured root 之外。 | 在 adapter preparation 前 canonicalize candidate path。 | 在读取或调用 content 前 resolution fails。 | 使用 segment-safe containment check 比较 canonical root 与 candidate path；defer concurrent adversarial topology mutation。 |
| DD-AC-21 | Asset/root 缺失、为空、不可读或 file kind 错误。 | Resolution 或 read 运行。 | 返回 typed error，且不提供 fallback content。 | 在 attempted operation 后映射 filesystem failures；不依赖 existence precheck。 |
| DD-AC-22 | Internal resolved assets、run inputs、argv 与 workspace context 包含 canonical paths 或 raw values；configured workspace path 本身可能是 symlink。 | 生成 public asset projection、trace、delegation evidence 或 CLI diagnostics。 | Canonical workspace root 下的 asset 使用 normalized workspace-relative path；workspace 外的 asset 使用 root-labeled path。Public output 不含 canonical paths 或 raw content。 | `openAssetSession` 通过 injected filesystem canonicalize 全部 roots，并保留 immutable `CanonicalAssetRoots`；每个 projection 在构建 safe DTO 前比较 canonical asset 与 workspace paths。INV-03 负责 diagnostic rendering。 |

## Interface Design

| Interface | Input | Output | Error Behavior |
| --- | --- | --- | --- |
| `parseArgv(argv)` | `string[]` | `RawCliArgs` | Throws `CliSyntaxError` for unknown flags or missing values. |
| `validateInvocation(raw, context)` | `RawCliArgs`, `CliExecutionContext` | `CatddInvocation` | Returns `ValidationError[]`; no command execution on any error. |
| `parseTarget(value)` | `string` | `TargetSelector` | Throws `TargetParseError` for empty, malformed, or mixed invalid selectors. |
| `resolveBehavior(invocation)` | `CatddInvocation` | `ResolvedBehavior` | Throws `BehaviorResolutionError` with valid values and nearest suggestion. |
| `openAssetSession(context)` | 含 normalized logical roots 且不假设已 canonicalize 的 `CliExecutionContext` | 保留 immutable `CanonicalAssetRoots` 的 `Promise<InvocationAssetSession>` | 通过 `AssetFileSystem` canonicalize workspace、method-prompt、slash-command 与 `commands/` roots；required root 缺失或不是 directory 时以 `AssetRootError` reject。 |
| `resolveMethodPrompts(plan, session, evidence)` | `CatddRunPlan`, `InvocationAssetSession`, `DelegationEvidenceCollector` | `ResolvedMethodPrompt[]` | 抛出 typed root、escape、kind、empty、unreadable 或 missing-asset errors，不使用 fallback。 |
| `resolveSlashCommands(behavior, session)` | `ResolvedBehavior`, `InvocationAssetSession` | `ResolvedSlashCommand[]` | 抛出等价 command-asset typed error，不使用 fallback。 |
| `planCatddRun(invocation)` | `CatddInvocation` | `CatddRunPlan` | Fails before execution if target shape and behavior are incompatible. |
| `buildAgentRunPlan(plan)` | `CatddRunPlan` | `AgentRunPlan` | Step 缺少唯一 instruction asset 时拒绝；不向 `AgentSDK` 输出 CaTDD type。 |
| `toPublicAssetPath(asset, roots)` | Internal resolved asset、session-owned `CanonicalAssetRoots` | `PublicAssetPath` | 只比较 canonical asset 与 workspace paths；拒绝 absolute、parent-traversing 或 empty public projection；workspace-external asset 使用 root-labeled path。 |
| `toTraceInvocation(raw, invocation, context)` | `RawCliArgs`, `CatddInvocation`, `CliExecutionContext` | `TraceInvocation` | 从 typed arguments 重建 redacted command；绝不存储 raw argv 或 inline goal/story/input values。 |
| `toTraceWorkspace(context)` | `CliExecutionContext` | `TraceWorkspace` | 使用 `<workspace>` 与 safe logical paths；绝不存储 absolute repository root 或 working directory。 |
| `assertSafeTrace(trace, sensitiveValues)` | `RunTrace`, invocation-local deny values | `void` | 任一 serialized string 含 canonical workspace/home prefix、raw inline value、raw asset content 或 unsafe path projection 时 fail closed。 |
| `RuntimeAdapter.prepare(step, context)` | `AgentRunStep`, `AgentRunContext` | `PreparedStep` | 必须 side-effect-free；返回 structured preparation failure。 |
| `recordCommandInvocation(prepared, evidence)` | `PreparedStep`, `DelegationEvidenceCollector` | `DelegationEvent` | 在 adapter execution 前立即记录 public logical path。 |
| `RuntimeAdapter.execute(prepared, control)` | `PreparedStep`, `ControlPort` | `StepResult` | Expected runtime failure 返回 structured failure，不抛出异常。 |
| `execute(plan, context)` | `CatddRunPlan`, `CliExecutionContext` | `ExecutionResult` | Writes failure trace for execution errors after planning succeeds. |
| `classifyFailure(error)` | `RuntimeError` | `FailureClass` (`TRANSIENT` or `PERMANENT`) | 当分类置信度不足时返回 `PERMANENT`，避免不安全重试。 |
| `evaluateStepPolicy(step, state)` | `AgentRunStep`, `PolicyState` | `PolicyDecision` | 当重试预算或敏感路径策略违规时拒绝执行。 |
| `TraceWriter.write(trace)` | `RunTrace` | `TraceWriteResult` | Redacts secrets and fails closed if trace cannot be safely written. |

## Module Layout

| Module | Files | Responsibility |
| --- | --- | --- |
| `src/cli/` | `args.ts`, `targetSelector.ts`, `main.ts` | Parse argv, target selectors, and process entrypoint. |
| `src/config/` | `config.ts`, `paths.ts`, `assetFileSystem.ts` | Load config、resolve roots、定义 injectable filesystem port，并 normalize workspace paths。 |
| `src/catdd/` | `invocation.ts`, `behaviorRegistry.ts`, `invocationAssetSession.ts`, `methodPromptResolver.ts`, `slashCommandResolver.ts`, `planner.ts`, `agentRunPlanBuilder.ts` | Own CaTDD orchestration metadata、invocation-local asset reads 与 generic run-input translation，不拥有 CaTDD semantics。 |
| `src/executor/` | `slashCommandExecutor.ts`, `delegationEvidence.ts`, `commandResultNormalizer.ts` | 记录 ordered delegation events、执行 resolved command steps，并 normalize adapter output。 |
| `src/agentsdk/` | `runtime.ts`, `ports.ts`, `runPlan.ts`, `events.ts` | Generic agent runtime contracts, ports, and event model. |
| `src/adapters/` | `rawTsRuntimeAdapter.ts`, `cliProcessAdapter.ts` | First raw TypeScript/process runtime adapters. |
| `src/trace/` | `traceSchema.ts`, `traceProjection.ts`, `traceSafety.ts`, `traceEventCollector.ts`, `traceWriter.ts`, `redaction.ts` | 定义 serialization-only DTOs、project safe values、验证完整 trace、捕获 transitions、redact 并 persist。 |
| `src/diagnostics/` | `errors.ts`, `diagnosticReporter.ts`, `logSink.ts`, `suggestions.ts` | Actionable errors, log levels, diagnostic flags, typo suggestions. |
| `tests/support/` | `fakeAssetFileSystem.ts`, `fakeRuntimeAdapter.ts` | 确定性注入 missing、permission、mutation、symlink 与 runtime-capture scenarios。 |

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

`InvocationAssetSession` 在 invocation validation 后创建，并在 trace/output finalization 后销毁。`CliExecutionContext` 提供 normalized logical roots，但不承诺 `workspaceRoot` 或 asset root 已 canonicalize。`openAssetSession` 负责通过 injected `AssetFileSystem` canonicalize workspace、method-prompt、slash-command 与 `commands/` roots，验证其 directory roles，并以 immutable `CanonicalAssetRoots` 保留。Session 还拥有以 canonical asset path 为 key 的 invocation-local map。第一次请求 asset 时执行 canonicalize 与 read；同一 invocation 中的后续请求可以复用该 captured content。禁止 module-level、static、process-wide 或 cross-invocation semantic cache。

第二次 CLI invocation 一定创建新 session，因此能观察 source changes。Session 仅向 CaTDD application 与 run-plan builder 返回 content-bearing resolved assets。`AgentSDK`、traces、logs 与 diagnostics 接收 generic inputs 或 metadata projections，不接收代码内嵌的 CaTDD semantic definition。

`dispose()` 清空 session map。复制到 `CatddRunPlan`、`AgentRunPlan` 或 `PreparedStep` 的 content strings 在 executor 的 `finally` path 于 output finalization 后释放 references 前仍保持 run-local；本设计不声明 JavaScript secure erasure。Production code 不得持久化 content-bearing objects，test fakes 必须在 tests 之间重置 captures。Invariant 是 no cross-invocation reuse or persistence，而不是 session disposal 后绝无 in-memory copy。

### Root Containment and Read Algorithm

V1 在从 root canonicalization 到 asset read 的 filesystem topology 保持稳定时保证 static containment。CLI 在任何 external runtime adapter 被 prepare 或 execute 前完成全部 asset reads。在该区间并发恶意替换 directory 或 symlink topology 不属于 V1 threat boundary；atomic contained-read 作为 future hardening option 延后。Read 期间发生 missing/deleted 与 permission changes 时，attempted operation 仍 fail closed。

在 session open 时以及对每个 configured method-prompt 或 slash-command root：

1. 通过 `AssetFileSystem.realpath` 解析 `workspaceRoot`、method-prompt root、slash-command root 及其 `commands/` child；要求每个 role 都是 directory，并在 session lifetime 内保留 canonical values。
2. 将 registry-owned relative asset path join 到 configured root。Behavior aliases 只包含 file names 与 routing metadata，不包含 method 或 command content。
3. 使用 `realpath` 解析 candidate，使 static symlinks 与 `..` segments 无法隐藏最终位置。
4. 计算 `relative(rootCanonicalPath, candidateCanonicalPath)`。当结果等于 `..`、以 `..` 加 path separator 开头，或为 absolute path 时拒绝。
5. 计算 `relative(workspaceCanonicalPath, candidateCanonicalPath)` 以分类 public path。若 contained，则输出 normalized workspace-relative path；否则输出 configured-root label 加 canonical root-relative suffix。不得将 canonical candidate 与仅为 absolute/logical 的 workspace path 比较。
6. 要求 canonical candidate 是 regular file，再通过 `AssetFileSystem` 读取 bytes。Zero-byte file 以 `ASSET_EMPTY` 拒绝。
7. Decode current source content，只存入 invocation-local map，并返回 content-bearing resolved asset。
8. Method-prompt 成功读取后追加 metadata-only `prompt-read` event。`SlashCommandExecutor` 在调用 runtime adapter 前立即追加 `command-invocation`。

Attempted filesystem operation 是权威结果。Missing/deleted (`ENOENT`)、unreadable (`EACCES`/`EPERM`)、wrong-kind、empty、root-missing 与 root-escape failures 映射为 typed errors。Resolver 不得先检查 existence 再假设后续 read 必定成功，也不得替换为 built-in semantic content。

| Error code | Trigger |
| --- | --- |
| `ASSET_ROOT_MISSING` | Configured method-prompt 或 slash-command root 缺失或不是 directory。 |
| `ASSET_COMMANDS_DIR_MISSING` | Configured slash-command root 中没有 `commands/` directory。 |
| `ASSET_ESCAPE` | Canonical candidate 位于 canonical configured root 之外。 |
| `ASSET_WRONG_KIND` | Candidate 存在但不是 regular file。 |
| `ASSET_EMPTY` | Candidate 是 zero-byte file。 |
| `ASSET_MISSING` | Candidate 在 canonicalize、open 或 read 时消失或不存在。 |
| `ASSET_UNREADABLE` | Open/read 返回 `EACCES`、`EPERM` 或等价 permission failure。 |

### Evidence and Runtime Capture

`CatddRunStep` 保留在 CaTDD application layer。`src/catdd/agentRunPlanBuilder.ts` 将 slash command 转换为一个 generic `instruction` asset，并将 method prompts 转换为有序 generic `context` assets。每个 input 获得一个 `PublicAssetPath`；internal canonical paths 保留在 asset session 中。这既保持 `AgentSDK` 不含 CaTDD types，也允许 in-memory fake adapter 捕获其收到的 safe logical path 与 current content。

`PublicAssetPath` 由一个使用 session-owned `CanonicalAssetRoots` 的 projection function 产生。Canonical path 位于 `workspaceCanonicalPath` 内的 assets 使用 normalized workspace-relative paths，即使 configured workspace path 是 symlink。由 canonical workspace 外的 canonical configured root 提供的 assets 使用 `<methodPromptsRoot>/<relativePath>` 或 `<slashCommandsRoot>/<relativePath>` labels。Projection 拒绝 absolute output、empty output 与任何 `..` segment。`AgentRunStep.metadata` 由 non-sensitive scalar labels 的 allowlist 构建，不得包含 serialized invocations、canonical paths 或 asset content。

`DelegationEvidenceCollector` 分配单调递增 sequence numbers。Prompt-read events 仅在读取成功后追加；command-invocation 在 adapter execution 之前立即追加。对一个 step，每个 required prompt-read sequence 都必须小于其 command-invocation sequence。Events 包含 names 与 paths，但不包含 content。

Invocation-local cache hit 不创建新的 `prompt-read` event，因为没有发生 physical read。Skipped step 不创建 `command-invocation`；event 之后发生 adapter failure 时，该 event 表示 attempted invocation，failure result 单独保留。

US-INVENTOR-01 tests 检查 generic run plan、fake adapter capture 与 evidence snapshot。US-INVENTOR-03 单独决定是否以及如何在 `--diagMethodPrompts` 或 `--diagSlashCommands` 下把 metadata 渲染到 stderr。Raw asset content 不进入 diagnostics 或持久化 traces。

Detail-level adapter contract 在不改变 adapter boundary 的前提下细化 architecture 的 conceptual `PreparedRun` sketch。`SlashCommandExecutor` 负责 plan iteration。对每个 approved step，它调用 side-effect-free `prepare(step, context)`、记录 `command-invocation`，再调用 `execute(prepared, control)`。Skipped step 既不 prepare 也不 invoke。`StepResult` 聚合到 run-level `AgentRunResult`/`ExecutionResult`。

### Requirement Traceability

| Story AC | Detailed-design mechanism |
| --- | --- |
| AC-01 | Edge prompt 成为由 fake runtime 捕获的 current-content context asset；canonicalize 到其他位置的 logical workspace alias 仍生成 `methodPrompts/CaTDD_methodPrompt4Cat-Edge.md`。 |
| AC-02 | `UT_designFuncTestsSkeleton.md` 成为 instruction asset，并产生 `command-invocation`。 |
| AC-03..AC-04 | Generic run inputs 证明 source delegation；sequenced evidence 证明 prompt-before-command order。 |
| AC-05..AC-06 | Zero-byte prompt/command reads 以 `ASSET_EMPTY` 失败，且没有 fallback。 |
| AC-07 | Declarative registry 独立命名 Edge、test-structure 与 workflow prompt paths。 |
| AC-08 | 新 `InvocationAssetSession` 捕获 invocations 之间加入的 sentinel。 |
| AC-09..AC-10 | 在 canonicalization 与 read 之间注入 deletion，映射为 missing-asset error。 |
| AC-11..AC-12 | Canonical containment 在 read 前拒绝 prompt 与 command symlink/path escape。 |
| AC-13..AC-16 | Root-missing、permission、missing commands directory 与 wrong-kind paths 映射为 typed errors。 |

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

`TraceInvocation.redactedCommand` 从 `TraceArgument[]` 重建；raw argv 绝不保留。`--goal`、`--goalStory` 与 `--input` 转换为 literal `[REDACTED]`。Path-bearing arguments 使用 `PublicAssetPath`；`--target` 使用 `PublicTargetSelector`，它投影每个 target file，同时只保留已验证的 comma 与 `::TC-ID` structure。Behavior 与 log level 等 allowlisted values 转换为 bounded、control-character-free `PublicTraceText`。

`TraceWorkspace.repositoryRoot` 使用固定 `<workspace>` token。当 working directory 等于 workspace root 时使用 `.`，否则使用 safe workspace-relative path；external working directory 表示为 `<externalWorkingDirectory>`，不保留 basename。Config paths 使用相同 workspace-relative/root-labeled path policy。

`TraceResolvedAssetRef` 是明确的 metadata projection。来自 `ResolvedMethodPrompt`、`ResolvedSlashCommand` 与 `AgentInputAsset` 的 internal `canonicalPath` 和 `content` 绝不能复制到 traces、diagnostics、logs 或 error messages。`DelegationEvent.path` 使用相同 `PublicAssetPath` projection。

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

每个 path-bearing trace field 使用 `PublicAssetPath` 或 `PublicTargetSelector`；每个 user-derived free-text field 使用 `PublicTraceText`；generated identity/time fields 使用 validated `TraceId` 或 `IsoTimestamp`。Projection 时，已知 field 的 runtime value 如果不能由其 trace DTO 表示，则转换为 literal `[unserializable]` 并添加 `TRACE_VALUE_UNSERIALIZABLE` diagnostic，以满足 US-INVENTOR-02 AC-16。Unknown runtime fields 不复制到 DTO。

`traceSafety.ts` 在 `JSON.stringify`/YAML encoding 前立即递归访问完整 serialization DTO。它拒绝 canonical workspace/home prefixes、known raw inline values、loaded asset-content sentinels、control characters、path fields 中的 absolute/path-traversal values、malformed generated IDs/timestamps，以及 trace DTO allowlist 之外的 object。Safety assertion 失败时不创建 trace file；这与 projection-time `[unserializable]` fallback 不同。

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
12. 通过 RuntimeAdapter prepare approved generic step；preparation 必须 side-effect-free。
13. 记录 command invocation，再通过 RuntimeAdapter execute prepared step。
14. Normalize results，并 collect evidence 与 before/after file observations。
15. 从 typed runtime state 投影 `TraceInvocation`、`TraceWorkspace` 与每个 nested trace DTO，且不保留 raw argv。
16. 递归 assert 完整 trace safe，再 serialize/write，并输出单独投影的 process output。
17. 在 `finally` path 中清空 asset session，并释放 production content-bearing plans、inputs 与 prepared steps 的 references。
```

## State and Data

| State/Data | Owner | Lifecycle | Invariant |
| --- | --- | --- | --- |
| `RawCliArgs` | `cli/` | Created from argv, discarded after validation. | May contain invalid or missing values. |
| `CatddInvocation` | `catdd/` | Created after validation, used by planner/executor/trace. | Required fields are present and normalized. |
| `TargetSelector` | `cli/` + `catdd/` | Created from `--target`, used by behavior validation. | Exactly one selector kind is present. |
| `ResolvedBehavior` | `catdd/` | Created during behavior resolution. | Contains command names but no CaTDD category definitions. |
| `InvocationAssetSession` | `catdd/` | 每个 validated invocation 创建一次并在 exit 时销毁。 | 清空其 map；cached content 不得跨 invocation reuse 或 persist。 |
| `ResolvedMethodPrompt` / `ResolvedSlashCommand` | `catdd/` | 由 fresh session reads 创建并用于构建 run plan。 | Canonical path 被 root-contained；content 是 internal 且 non-empty。 |
| `DelegationEvidenceSnapshot` | `executor/` | 在 reads/execution 中追加，再投影到 trace/diagnostics。 | Sequence 单调递增；events 不含 source content。 |
| `CatddRunPlan` | `catdd/` | Created before execution. | 所有 required assets 都 content-bearing、root-contained 且 ordered。 |
| `AgentRunPlan` / `PreparedStep` | `agentsdk/` + adapter | 从 `CatddRunPlan` 创建，并在 run finalization 后释放。 | 只含 generic input assets、不含 CaTDD-specific types，且不得 persist。 |
| `StepResult` | `executor/` + adapter | Created per command step. | Expected failures are structured, not hidden in logs. |
| `PolicyState` | `executor/` | 在 run 开始时创建并按 step 更新。 | 跟踪重试计数、修正循环、升级标记与敏感路径拒绝次数。 |
| `RunTrace` | `trace/` | 从 serialization-only projections 创建，并在 exit 时写入。 | 每个 path/text field 都 safe-typed；encoding 前 recursive validation fail closed。 |

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
| Configured method/slash root missing or not a directory | Exit code 1；typed root error 命名 root role 与 safe path。 |
| `slashCommands/commands/` missing | Exit code 1；typed command-root error；不使用 behavior fallback。 |
| Prompt or command canonical path escapes its configured root | 在 read/invocation 前 exit code 1；stderr 报告 configured-root escape。 |
| Filesystem topology changes adversarially during containment/read | 不属于 V1 atomicity guarantee；全部 reads 完成前不运行 external adapter。将 atomic contained-read 记录为 future hardening。 |
| Prompt or command path is a directory | Exit code 1；wrong-kind error 说明需要 regular file。 |
| Prompt or command is zero bytes | Exit code 1 并报告 `ASSET_EMPTY`；不替换为 built-in semantic content。 |
| Asset is deleted or becomes unreadable before read | Attempted read 返回 exit code 1；映射 `ENOENT`、`EACCES` 或 `EPERM`，不假设 existence precheck 后仍可读。 |
| Interactive skip | Step 被 skipped；trace 记录 skipped command 与 reason。 |
| Interactive abort | 不再执行后续 steps；exit code 1；trace 记录 abort point。 |
| `reviewImplTestFile` 找不到 RED/GREEN TCs | Exit code 0；stdout 报告未找到 implemented TCs；不修改文件。 |
| Adapter execution failure after planning | 写入 failure trace，包含 completed steps 与 active failure point。 |
| Trace projection or recursive safety validation fails | Fail closed；不 encode 或 persist 任何 trace content。 |
| Known runtime field 无法由其 trace DTO 表示 | 将该 value 替换为 `[unserializable]`，添加 `TRACE_VALUE_UNSERIALIZABLE`，再继续 final safety validation。 |

## Implementation Plan

| Step | Deliverable | Verification |
| --- | --- | --- |
| 1 | Package scaffold and TypeScript config. | Compile empty project and run placeholder test. |
| 2 | `cli/` parser and target selector. | Unit tests for required args, exclusive pairs, and target forms. |
| 3 | `catdd/` behavior registry、invocation asset session 与 asset resolvers。 | Unit tests 覆盖 fresh reads、三个 named prompts、empty/missing/wrong-kind assets、root escape 与 no fallback。 |
| 4 | Generic `AgentInputAsset` translation、safe public-path projection、prepared-step adapter、delegation evidence 与 in-memory fake adapter。 | Type tests 证明 SDK 不含 CaTDD types；capture/order tests；断言 public output 不含 canonical path 或 raw content。 |
| 5 | `executor/` plan execution with `ControlPort`. | Tests for approve, skip, abort, and structured step failures. |
| 6 | Complete trace DTOs、projection、recursive safety validation、collector 与 writer。 | JSON schema 加 whole-serialization leakage tests，覆盖 success 与 failure traces。 |
| 7 | Reliability policy layer (`classifyFailure`, `evaluateStepPolicy`, sensitive-path gate). | Unit tests for ASR-R1..R6 behavior and deterministic non-interactive escalation. |
| 8 | End-to-end dry-run fixture. | CLI-level test from valid invocation to planned command sequence and trace. |

## Verification Strategy

- Unit-test parser and selector behavior without invoking external agents。
- Unit-test behavior resolution against fixture command roots。
- 每次 invocation 使用新的 `InvocationAssetSession`；在 sessions 之间修改 sentinel 以证明 fresh reads。
- 使用 `FakeAssetFileSystem` unit-test missing、empty、permission、wrong-kind 与 post-canonicalization deletion failures。
- 在读取 content 前 unit-test prompt/command symlink/path 对 canonical configured roots 的 escape。
- 将 TC-DELEGATE-001 retarget 到 logical workspace alias，其 `realpath` 与 configured path 不同；在 product correction 前，当 internal Edge prompt 被错误标为 root-labeled 而非 workspace-relative 时，测试必须转为 RED。
- 在 tests 中声明 V1 stable-topology assumption；不得声称可抵抗 concurrent adversarial symlink swap。
- 使用 `FakeRuntimeAdapter` 捕获 generic run step，并断言 current instruction/context content 与 event order。
- Contract-test `prepare(step) -> PreparedStep -> execute(prepared) -> StepResult`，包括 skip 与 adapter-failure evidence。
- Type-test `AgentRunStep` 不 import CaTDD-specific resolved type。
- Snapshot-test metadata-only diagnostic output 的 actionable error wording；raw source content、canonical paths、absolute workspace/home prefixes 与 `..` segments 必须不存在。
- 验证 session disposal 清空 invocation-local entries、新 session 重新读取 assets、production content-bearing objects 不被 serialize，且 fake captures 在 tests 之间 reset。
- 使用 JSON schema parser 验证 `RunTrace`，并拒绝 unknown/non-DTO fields。
- 注入 known non-serializable runtime value，并验证 projection 在 final safety gate 前输出 `[unserializable]` 与 `TRACE_VALUE_UNSERIALIZABLE`。
- Serialize 含 raw argv、inline goal/story/input、asset content、absolute workspace/home paths、external roots、target lists、TC selectors、diagnostics、file events 与 failures 的 sentinel traces；断言只有 redacted 或 public projections 保留。
- 强制 `assertSafeTrace` 失败，并验证不会创建 partial trace file。
- Use fixture test files to verify observed TC transition extraction。
- Add adapter contract tests using an in-memory fake adapter before adding Copilot/OpenCode adapters。
- Add policy tests for retry budget exhaustion, failure classification, unknown-behavior fallback, sensitive-path denial, and escalation behavior in interactive and non-interactive modes。

## Assumptions

- First implementation language is ADR 最终选定的运行时。
- First runtime is local raw process execution，使用最终选定的 runtime adapter。
- Copilot/MCP and OpenCode are adapter targets after the raw runtime contract is stable。
- LangGraph and Google ADK remain reference architectures until a later story asks for optional adapters。
- Default trace output is module-local under `codeAgents/utCodeAgentCLI/traces/`。
- Asset content 是 UTF-8 Markdown/text，并保持在 invocation/run input internal boundary 内。
- V1 假设从 root canonicalization 到 asset read 期间没有 concurrent adversarial directory 或 symlink topology mutation；external adapter preparation 前完成全部 reads。
- Atomic contained-read 是 future hardening option，不是 V1 guarantee。
- Raw argv 仅为 invocation-local input；traces 只保留 reconstructed redacted command 与 typed argument projections。
- `CliExecutionContext` roots 是 normalized logical paths 且可能为 symlinks；只有 `InvocationAssetSession` 负责 canonicalize 并保留用于 containment 与 public projection 的 roots。

## Detail-Design Update Feedback

- [x] 每次 invocation 增加一个 fresh asset session，并禁止 persistent semantic cache。
- [x] 将 current prompt/command content 传给 generic run step，且不让 CaTDD types 泄漏到 `AgentSDK`。
- [x] 为 in-memory fake runtime 捕获单调递增的 prompt-read 与 command-invocation evidence。
- [x] Canonicalize roots 与 candidates，拒绝 segment-safe root escape，并定义 typed asset errors。
- [x] 通过 metadata projection 保证 source content 不进入 traces、diagnostics、logs 或 error messages。
- [x] 为 permission、mutation、symlink 与 capture tests 定义 deterministic fake filesystem/runtime boundaries。
- [x] 将全部 16 条 US-INVENTOR-01 AC 映射到 implementation-facing mechanisms。
- [x] 使用 `/SPEC_reviewDetailDesign` 评审第一次 revision；结果：REVISE。
- [x] 从 public schemas 移除 canonical paths，并定义 safe workspace-relative/root-labeled projection。
- [x] 将 `RuntimeAdapter` 标准化为 prepared-step lifecycle，并分配 `AgentRunPlanBuilder` ownership。
- [x] 记录 V1 stable-filesystem threat boundary，并 defer atomic contained-read hardening。
- [x] 用 bounded no-reuse/no-persistence content lifetime 替换错误的 erasure 声明。
- [x] 使用 `/SPEC_reviewDetailDesign` re-review DD-REV-01 through DD-REV-04；这些 findings PASS，但 DD-REV-05 需要 revision。
- [x] 定义 redacted `TraceInvocation`、safe `TraceWorkspace` 与 safe nested trace DTOs。
- [x] 在不保留 raw argv 或 inline source/story values 的情况下重建 command evidence。
- [x] 增加 recursive whole-trace safety validation 与 fail-closed no-file behavior。
- [x] 为每个 path/value-bearing trace surface 增加 whole-serialization leakage fixtures。
- [x] 使用 `/SPEC_reviewDetailDesign` re-review DD-REV-05；结果：PASS。
- [x] 通过把 workspace 与 asset-root canonicalization 分配给 `openAssetSession` 并使用 injected filesystem，解决 PROD-REV-01。
- [x] 保留 TC-DELEGATE-001 identity，并定义 symlinked-workspace fake topology，使其在 product correction 前必须失败。
- [ ] 使用 `/SPEC_reviewDetailDesign` re-review PROD-REV-01 detail-design correction。

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

Expected result：`diff` 不输出内容，每个 contract marker 都能找到，并以 code 0 退出。

## Review Checklist

- Every acceptance criterion has a design impact or explicit non-impact。
- Interfaces and state changes are clear enough to drive tests。
- `AgentSDK` contracts contain no CaTDD category or status definitions。
- 每次 invocation 拥有 fresh asset session；不存在 persistent semantic cache。
- Canonical containment 在读取 asset content 前拒绝 configured-root escape。
- V1 static-containment scope 与 deferred atomic hardening 已明确。
- Generic runtime inputs 携带 current content，而 evidence、diagnostics 与 traces 保持 metadata-only。
- Public evidence paths 是 workspace-relative 或 root-labeled，绝不是 canonical/absolute。
- Public path classification 将 canonical asset paths 与 session-owned canonical workspace root 比较；logical/symlinked workspace paths 不得用于 trust classification。
- Runtime adapters 消费 `PreparedStep`；executor 负责 plan iteration。
- Content-bearing session/plan objects 保持 run-local、被清空或释放，且不 persist。
- Raw argv 被 typed redacted arguments 与 reconstructed command 替代。
- 每个 nested trace path/text field 都 safe-typed，并在 encoding 前递归验证完整 DTO。
- 每个 step 的 prompt-read events 位于 command-invocation 之前。
- Behavior aliases resolve to slash commands; they do not duplicate command logic。
- Trace schema covers success and execution failure。
- Error messages can name argument, path, state, and suggestion。
- EN/ZH heading structure matches。

## Next Step

运行 `/SPEC_reviewDetailDesign`，在修改 tests 或 product code 前评审 PROD-REV-01 ownership 与 test-first correction design。
