# Feature: Define unified specCodeAgentCLI CLI UsageDesign contract

Imported by `/SPEC_importFeature` and analyzed by `/SPEC_analyzeFeature` on 2026-11-11.

## Metadata

- `status`: `analyzed`
- `input_type`: `feature`
- `imported_by`: `SPEC_importFeature`
- `imported_on`: `2026-11-11`
- `analyzed_by`: `SPEC_analyzeFeature`
- `analyzed_on`: `2026-11-11`
- `analysis_mode`: `BRAINSTORM`
- `execution_mode`: `manualMode`
- `generated_todo_story`: `.catdd/spec/doingUS/20261111-design-specCodeAgentCLI-usage-contract-UserStory.md` (moved from `.catdd/spec/todoUS/20261111-design-specCodeAgentCLI-usage-contract-UserStory.md` via `SPEC_openUserStory`)
- `project_story_ledger`: `README_UserStories.md`
- `story_id`: `US-specDeveloper-defineSpecCodeAgentCliUsageContract`
- `story_id_alias`: `US-261111.220010`

## Source Trace

- Source type: interactive developer requests in VS Code session on 2026-11-11.
- Raw developer requests preserved verbatim:
  - `"did you see README of specCodeAgentCLI ?"`
  - `"I want usageDesign of specCodeAgentCLI first, do you know how to going on ?"`
  - `"utCodeAgentCLI is deprecated now"`
  - CLI shape specification: `"autonomousMode vs manualMode, when autonomous just follow accept '--goal xyz' arg and makePlan and moving END or ONE-MORE-THING as Agent it SHOULD be, when manual just follow Px-SpecFlow exactly and let user chose what's next"`
- Area: `codeAgents/specCodeAgentCLI/`
- Related flow: `Px-SpecFlow`

## Preserved User Value and Intent

The developer wants to establish `codeAgents/specCodeAgentCLI/README_UsageDesign.md` first as the unified bash-style CLI usage contract for CaTDD SpecCoding orchestration, replacing the now-deprecated `utCodeAgentCLI` layer with zero dependency on `utCodeAgentCLI`.

Key product and design constraints established by the developer:

1. **Single unified CLI**: `specCodeAgentCLI` directly orchestrates `Px-SpecFlow` (`SPEC_*`, orchestrated `TEST_*`, and `Px-StatusKits` / `Px-HarnessKits` checks) from `methodPrompts/` and `slashCommands/`, with no dependency on `utCodeAgentCLI`.
2. **Mode-centered CLI contract (`autonomousMode` vs `manualMode`)**:
   - In `autonomousMode` (default flow-driver mode): accepts `--goal "<xyz>"`, runs `SPEC_makePlan`, and drives `implementation-oriented` work forward to terminal `END` (`closeUserStory`, `abortUserStory`, or `suspendUserStory`) or halts immediately on `ONE-MORE-THING` / non-implementation orientation boundaries (`manual_required`).
   - In `manualMode`: follows `Px-SpecFlow` step-by-step via `--mode manualMode [--command <SLASH_CMD>]`, executing one explicit command (defaulting to `SPEC_whatsNextTask` when `--command` is omitted) and presenting next-step options so the user chooses what runs next.
3. **Config-only LLM/backend settings**: CLI flags remain strictly workflow-focused; LLM/model/provider runtime settings belong in `--config-file` only.
4. **Initial deliverable scope**: Deliver English `codeAgents/specCodeAgentCLI/README_UsageDesign.md` and project-root `README_UserStories.md` first on branch `feat/specCodeAgentCLI-requirements-and-usage-design` without running `git commit` yet; defer `README_UsageDesign_ZH.md`, `README_ArchDesign.md`, `README_DetailDesign.md`, and executable code/tests to follow-up stories.

## Chat History (`chatHistory`)

| Turn # | Speaker / Prompt | Question or Proposal | Developer Answer / Decision | Impact on Story / Scope |
| --- | --- | --- | --- | --- |
| 1 | Developer | Asked whether `codeAgents/specCodeAgentCLI/README.md` was inspected and requested `usageDesign` of `specCodeAgentCLI` first. | Confirmed starting point is `codeAgents/specCodeAgentCLI/`. | Scoped initial design target to `specCodeAgentCLI` UsageDesign contract. |
| 2 | Developer | Declared `"utCodeAgentCLI is deprecated now"`. | Deprecated `utCodeAgentCLI` across repository context. | Triggered `SPEC_abortUserStory` on active `US-SPECFLOW-REPAIR-01`, updated `projectContext.md` and `codeAgents/` READMEs, and removed `utCodeAgentCLI` sub-agent delegation from `specCodeAgentCLI`. |
| 3 | CodeAgent (`BRAINSTORM` Q1: Unified Scope) | Asked whether `specCodeAgentCLI` should be the single unified CLI (`SPEC_*` + orchestrated `TEST_*` + status/harness checks) or `SPEC_*` only. | Selected: `Single unified CLI (no utCodeAgentCLI dependency)`. | Established unified command ownership over `methodPrompts/` and `slashCommands/` in `RULE-01` and `AC-Typical-01..02`. |
| 4 | CodeAgent (`BRAINSTORM` Q2: CLI Shape) | Asked which CLI invocation shape to adopt. | Freeform answer: `"autonomousMode vs manualMode, when autonomous just follow accept '--goal xyz' arg and makePlan and moving END or ONE-MORE-THING as Agent it SHOULD be, when manual just follow Px-SpecFlow exactly and let user chose what's next"`. | Defined the dual-mode invocation model (`autonomousMode` goal-to-END/ONE-MORE-THING vs `manualMode` single-step choice) in `RULE-02`, `RULE-03`, `AC-Typical-01`, `AC-Typical-02`, and `AC-Edge-01`. |
| 5 | CodeAgent (`BRAINSTORM` Q3: Process & Deprecation) | Asked whether to draft directly or run full `Px-SpecFlow` lifecycle first. | Selected: `Run full Px-SpecFlow lifecycle first`. | Executed `SPEC_abortUserStory`, `SPEC_updateProjectContext`, `SPEC_importFeature`, `SPEC_analyzeFeature`, `SPEC_openUserStory`, and `SPEC_makePlan` before drafting UsageDesign. |
| 6 | CodeAgent (`BRAINSTORM` Q4: Backend / Model Flags) | Asked whether CLI/env should expose `--backend` / `--model` flags or keep provider config in config file only. | Selected: `Config-file only for LLM/backend settings`. | Excluded `--backend` / `--model` CLI flags (`RULE-04`, `AC-Typical-03`, `AC-Misuse-01`). |
| 7 | CodeAgent (`BRAINSTORM` Q5–Q8: Branch, Commits, Syntax, Mirror Scope) | Proposed `--mode <autonomousMode\|manualMode>`, `--goal`, and `--command <SLASH_CMD>`; asked about branch selection, git commit checkpoints, and EN vs EN+ZH scope. | Selected: `No git commits yet`, `Use feat/specCodeAgentCLI-requirements-and-usage-design`, `Approve proposed autonomous vs manual syntax`, and `English UsageDesign only first`. | Locked CLI syntax, switched to `feat/specCodeAgentCLI-requirements-and-usage-design`, held git commits for manual developer review, and deferred `README_UsageDesign_ZH.md` to a follow-up slice. |
