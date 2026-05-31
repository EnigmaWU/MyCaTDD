# User Story: Design utCodeAgentCLI Architecture

Created by `/SPEC_analyzeIssue` on 2026-06-01.

## Source Trace

- Analyzed raw issue: [../analyzedNews/20260530-design-utCodeAgentCLI-architecture-Issue.md](../analyzedNews/20260530-design-utCodeAgentCLI-architecture-Issue.md)
- Raw source text: `do ArchDesign of utCodeAgentCLI based on UsageDesign/UserGuide/UserStory, and reference GitHub Copilot/SDK, OpenCode, LangChain/Graph,Google AgentSDK, ... , etc, then do our own architectural: prefer use TS, adapt to raw TS,CopilotSDK,OpenCode at least`
- Area: `codeAgents/utCodeAgentCLI/`

## Active Work Status

- Status: TODO.
- Active state: `.catdd/spec/todoUS/` todo story.

## Analysis Status

- Status: TODO.
- Priority: P1 — important (needed for v1.0).
- Confidence: high.

## Observed Behavior

Currently, `utCodeAgentCLI` is a documented CLI contract (`README_UsageDesign.md`, `README_UserGuide.md`, `README_UserStory.md`), but lacks a concrete modular architecture. We need to introduce a generic, CaTDD-independent "AgentSDK" (an LLM Agent runtime platform with its own programming interface, supporting auth/audit/auto/hooks/control) and design how `utCodeAgentCLI` leverages both this general SDK and the CaTDD-specific `methodPrompts` and `slashCommands` to execute SpecFlow tasks.

## Expected Behavior

A comprehensive, modular architecture design document is available under `codeAgents/utCodeAgentCLI/` (both `README_ArchDesign.md` in English and `README_ArchDesign_ZH.md` in Chinese) that defines:
1. Comparative analysis of existing agent SDKs and frameworks.
2. Component modular layout showing the clean separation: a general-purpose, CaTDD-independent "AgentSDK" (LLM Agent engine) and the CaTDD-native `utCodeAgentCLI` built on top of it, which fully leverages `methodPrompts` and `slashCommands`.
3. Adaptability mechanisms of AgentSDK to run standalone (raw TS runtime), target existing SDKs (e.g., GitHub Copilot SDK, OpenCode), or adapt to existing CLIs.
4. Forward-looking architectural considerations in AgentSDK for authentication (auth), auditing (audit), pluggable automation (auto) for enterprise usage, lifecycle extension hooks (hooks), and execution/session control (control).
5. Extension contracts, interface definitions, and data flow.

## User Story

As a MyCaTDD architect/developer,
I want to design a modular and adaptable architecture introducing a generic "AgentSDK" (with its own programming interface, independent of CaTDD) and show how the CaTDD-specific `utCodeAgentCLI` builds on top of it by leveraging `methodPrompts` and `slashCommands`,
So that we have a clean separation of concerns where the underlying LLM Agent engine seamlessly adapts to raw runtimes, existing SDKs, and existing CLIs while providing robust auth/audit/auto/hooks/control, allowing `utCodeAgentCLI` to focus purely on executing CaTDD workflows.

## Independent Test Intent

A reviewer can inspect `codeAgents/utCodeAgentCLI/README_ArchDesign.md` and `README_ArchDesign_ZH.md` and verify that they cover comparative agent research, component layout, AgentSDK programming interface and adaptation strategies, as well as concrete design considerations for auth, auditing, pluggable automation modules, lifecycle hooks, and session control, ensuring both documents have matching heading structures and perfectly mirrored content.

## Acceptance Scenarios

### AC-1: Comparative Framework Analysis
- **Given** we have research references for modern agent architectures,
- **When** the architecture design is drafted,
- **Then** it includes a detailed comparative analysis section analyzing GitHub Copilot SDK, OpenCode, LangChain/LangGraph, and Google Agent SDK, highlighting how they handle goal parsing, command routing, and state execution.

### AC-2: Define Core Component Boundaries and CaTDD Separation
- **Given** the requirement to separate general LLM agent mechanisms from TDD method semantics,
- **When** the architecture design is drafted,
- **Then** it defines clear boundaries: `utCodeAgentCLI` sits at the application layer fully leveraging CaTDD `methodPrompts` and `slashCommands`, while delegating general agent execution, auth, audit, auto, hooks, and control to the underlying `AgentSDK`,
- **And** the `AgentSDK` itself remains completely independent of and has no knowledge of CaTDD concepts.

### AC-3: Introduce AgentSDK and Runtime Adaptations
- **Given** the requirement to establish a reusable programmatic interface for general LLM agent operations,
- **When** the architecture design is drafted,
- **Then** it introduces a dedicated "AgentSDK" layer (as a generic, CaTDD-independent LLM Agent library) with its own programming interface,
- **And** it specifies how AgentSDK adapts to raw runtimes, existing SDKs (e.g., GitHub Copilot SDK, OpenCode), and existing CLIs,
- **And** it incorporates forward-looking designs for authentication (auth), auditing (audit), pluggable automation (auto - enabling custom enterprise automation modules), lifecycle extension hooks (hooks), and session/process control (control).

### AC-4: Preserving Metadata and Traceability
- **Given** the requirement for machine-readable execution traces (US-INVENTOR-02),
- **When** the architecture design is drafted,
- **Then** it details how trace data flows from the command line through the Core and adapters, and how execution traces are structured and saved.

### AC-5: Multilingual Documentation Parity
- **Given** the MyCaTDD convention for documentation,
- **When** the architecture design is finalized,
- **Then** it produces `codeAgents/utCodeAgentCLI/README_ArchDesign.md` in English and `codeAgents/utCodeAgentCLI/README_ArchDesign_ZH.md` in Chinese, with matching heading structures and perfectly mirrored content.

## Scope

In scope:
- Architecture research and comparative analysis of external agent SDKs.
- Designing the generic, CaTDD-independent "AgentSDK" layer, its programming interface (auth, audit, auto, hooks, control), and its adaptations to raw runtimes, existing SDKs, and existing CLIs.
- Designing how the CaTDD-native `utCodeAgentCLI` integrates with `AgentSDK` and delegates core verification/slash flows to `methodPrompts` and `slashCommands`.
- Specifying architectural strategies within AgentSDK for authentication (auth), auditing (audit), pluggable enterprise automation (auto), lifecycle extension hooks (hooks), and session control (control).
- Creating `codeAgents/utCodeAgentCLI/README_ArchDesign.md` and `README_ArchDesign_ZH.md`.

Out of scope:
- Implementing the CLI binary or the concrete adapter classes (e.g., writing the actual TypeScript code for execution).
- Designing lower-level class implementations or unit tests (which belongs to `SPEC_takeDetailDesign` and `SPEC_designUnitTests`).

## Risks

- **Integration Drift**: Evolving SDK specifications of Copilot SDK or OpenCode may mismatch our adapter abstraction.
- **Runtime Overhead**: Adapter/delegation layers might add call latency or complexity compared to raw scripts.

## Assumptions

- TypeScript (TS) is the target language for the `utCodeAgentCLI` implementation.
- The raw TS runtime will be a standard Node.js environment without external agent runtimes.

## Acceptance Questions

- What are the core methods of the `AgentSDK` programming interface that need to be exposed to external runtimes or applications?
- How does `utCodeAgentCLI` cleanly map its CaTDD `methodPrompts` and `slashCommands` pipelines onto the generic LLM agent execution pipeline provided by `AgentSDK`?
- For the "auth" consideration within AgentSDK, should we support token-based authentication, SSH/HTTPS keys, or runtime context inheritance?
- What are the security, compliance, and enterprise data requirements for the "audit" (logging, history, non-repudiation) model in AgentSDK?
- How should the pluggable "auto" module interface be defined to allow custom enterprise automation workflows to be seamlessly plugged in?
- What lifecycle events should trigger execution hooks (e.g., `pre-goal`, `post-command`, `on-verification-failure`), and how should custom hook handlers be registered in AgentSDK?
- How granular should the session/process "control" be (e.g., pausing execution to ask user for confirmation, aborting flows, or checkpoint/restore)?
- Which external frameworks must be treated as hard requirements versus research references?
- What does “adapt to raw TS” mean in concrete runtime terms: library API, CLI entrypoint, or both?
- What depth of Copilot SDK integration is expected: prompt-wrapper compatibility, VS Code extension integration, GitHub Models usage, or another SDK surface?
- What level of OpenCode compatibility is expected: command adapter, provider abstraction, workflow compatibility, or shared agent runtime?
- Should LangChain/LangGraph and Google Agent SDK influence only architecture research, or should they become optional adapters?
- Should the architecture design wait until the `utCodeAgentCLI` User Story set is opened and refined?

## Next Recommended Action

Open this User Story via `/SPEC_openUserStory` to move it from `.catdd/spec/todoUS/` to `.catdd/spec/doingUS/` and begin drafting the architecture design.
