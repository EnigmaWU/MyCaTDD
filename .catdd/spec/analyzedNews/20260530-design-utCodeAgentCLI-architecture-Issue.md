# Issue: Design utCodeAgentCLI Architecture

Imported by `/SPEC_importIssue` on 2026-05-30.

## Source Trace

- Source type: developer request in Copilot chat.
- Raw source text: `do ArchDesign of utCodeAgentCLI based on UsageDesign/UserGuide/UserStory, and reference GitHub Copilot/SDK, OpenCode, LangChain/Graph,Google AgentSDK, ... , etc, then do our own architectural: prefer use TS, adapt to raw TS,CopilotSDK,OpenCode at least`
- Area: `codeAgents/utCodeAgentCLI/`
- Related flow: Px SpecFlow.

## Classification

- Type: architecture design / research input.
- Current lifecycle state: pending import, not yet analyzed.
- Expected next step: analyze into a todo User Story or architecture-design work item before creating architecture docs.

## Preserved Intent

The developer wants an architecture-design activity for `utCodeAgentCLI` that starts from the repository's current `utCodeAgentCLI` UsageDesign, UserGuide, and UserStory context, then compares or references agent-framework designs such as GitHub Copilot SDK, OpenCode, LangChain/LangGraph, Google Agent SDK, and similar systems.

The resulting architecture should be MyCaTDD's own architecture, not a direct copy of any referenced framework.

The request currently expresses a technology preference for TypeScript and at least these adaptation targets:

- raw TypeScript usage without a required external agent runtime;
- GitHub Copilot SDK or Copilot-native integration;
- OpenCode integration or compatibility.

## Known Context

- `codeAgents/utCodeAgentCLI/README_UserGuide.md` is the current startup guide for the future CLI layer.
- `codeAgents/utCodeAgentCLI/README_UsageDesign.md` defines the current argument model, including `--goal`, `--goalStory`/`--goalStoryFile`, `--input`/`--inputFile`, `--target`, and `--behave`.
- `.catdd/spec/todoUS/20260530-assemble-utCodeAgentCLI-user-stories-UserStory.md` is the current todo story for assembling User Stories for the CLI layer.
- The CLI is currently documented as a future design/implementation target, not a runnable binary.

## Missing Details To Preserve For Analysis

- Which external frameworks must be treated as hard requirements versus research references?
- What does “adapt to raw TS” mean in concrete runtime terms: library API, CLI entrypoint, or both?
- What depth of Copilot SDK integration is expected: prompt-wrapper compatibility, VS Code extension integration, GitHub Models usage, or another SDK surface?
- What level of OpenCode compatibility is expected: command adapter, provider abstraction, workflow compatibility, or shared agent runtime?
- Should LangChain/LangGraph and Google Agent SDK influence only architecture research, or should they become optional adapters?
- Should the architecture design wait until the `utCodeAgentCLI` User Story set is opened and refined?

## Next Recommended Command

`/SPEC_analyzeIssue`