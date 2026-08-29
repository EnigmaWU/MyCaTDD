# User Story: utCodeAgentCLI INVENTOR US-INVENTOR-01 Delegate all CaTDD semantics to methodPrompts

Created by `/SPEC_importUserStory` on 2026-06-07.
Imported from `codeAgents/utCodeAgentCLI/README_UserStory4INVENTOR.md` slice `US-INVENTOR-01`.

## Source Trace

- Source role index: [../../../codeAgents/utCodeAgentCLI/README_UserStory4INVENTOR.md](../../../codeAgents/utCodeAgentCLI/README_UserStory4INVENTOR.md)
- Updated canonical story: [../../../codeAgents/utCodeAgentCLI/USs/README_UserStory4INVENTOR-01.md](../../../codeAgents/utCodeAgentCLI/USs/README_UserStory4INVENTOR-01.md)
- Updated paired usage context: [../../../codeAgents/utCodeAgentCLI/README_UserGuide.md](../../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Authoritative module dashboard: [../../../codeAgents/utCodeAgentCLI/README_UserStoryStatus.md](../../../codeAgents/utCodeAgentCLI/README_UserStoryStatus.md)
- Master requirements index: [../../../codeAgents/utCodeAgentCLI/README_UserStory.md](../../../codeAgents/utCodeAgentCLI/README_UserStory.md)
- Role area: `codeAgents/utCodeAgentCLI/`
- Import granularity: `US-by-US`
- Imported slice: `US-INVENTOR-01 [P0]`

## Active Work Status

- Status: DONE.
- Active state: `.catdd/spec/doneUS/` completed story archive.
- Opened by `/SPEC_openUserStory` on 2026-08-26.
- Planned by `/SPEC_makePlan` on 2026-08-26.
- Intent cleared by `/SPEC_clearStoryIntent` on 2026-08-26.
- Replanned by `/SPEC_makePlan` on 2026-08-26.
- Requirements updated by `/SPEC_updateUserStory` on 2026-08-26.
- Requirements reviewed by `/SPEC_reviewUserStory` on 2026-08-28: REVISE.
- Requirement corrections applied by `/SPEC_updateUserStory` on 2026-08-28.
- Project context updated by `/SPEC_updateProjectContext` on 2026-08-28.
- Requirements re-reviewed by `/SPEC_reviewUserStory` on 2026-08-28: PASS.
- Detail design updated by `/SPEC_updateDetailDesign` on 2026-08-28.
- Detail design reviewed by `/SPEC_reviewDetailDesign` on 2026-08-28: REVISE.
- Detail-design corrections applied by `/SPEC_updateDetailDesign` on 2026-08-28.
- Detail design re-reviewed by `/SPEC_reviewDetailDesign` on 2026-08-28: REVISE.
- DD-REV-05 corrected by `/SPEC_updateDetailDesign` on 2026-08-28.
- DD-REV-05 re-reviewed by `/SPEC_reviewDetailDesign` on 2026-08-28: PASS.
- P0 Functional skeletons designed by `/SPEC_designUnitTests` on 2026-08-28.
- P0 Functional skeletons reviewed by `/UT_reviewFuncTestsSkeleton` on 2026-08-28: REVISE.
- FUNC-REV-01 corrected by `/SPEC_updateUserStory` and `/SPEC_designUnitTests` on 2026-08-28.
- Corrected P0 skeletons reviewed by `/UT_reviewFuncTestsSkeleton` on 2026-08-28: PASS.
- Corrected canonical category assignment reviewed by `/SPEC_reviewUserStory` on 2026-08-28: PASS.
- Next implementation TC selected by `/UT_tellMeNextImplTest` on 2026-08-28: TC-DELEGATE-001.
- TC-DELEGATE-001 implemented RED by `/SPEC_implUnitTests` and reviewed with `/UT_reviewImplTestCase` mechanics on 2026-08-28: PASS.
- TC-DELEGATE-001 reviewed by `/SPEC_reviewImplUnitTests` on 2026-08-28: FIX IMPLEMENTATION (IMPL-REV-01 and IMPL-REV-02).
- IMPL-REV-01 and IMPL-REV-02 corrected by `/SPEC_implUnitTests` on 2026-08-28; focused RED and TC-level correction review PASS.
- Corrected TC-DELEGATE-001 re-reviewed by `/SPEC_reviewImplUnitTests` on 2026-08-28: PASS.
- Minimum TC-DELEGATE-001 product slice implemented by `/SPEC_implProductCodes` on 2026-08-28: GREEN on correction attempt 1.
- Product slice reviewed by `/SPEC_reviewProductCodes` on 2026-08-28: UPDATE DESIGN with PROD-REV-01.
- PROD-REV-01 detail design updated by `/SPEC_updateDetailDesign` on 2026-08-29: canonical-root ownership and test-first correction defined.
- Closed by `/SPEC_closeUserStory` on 2026-08-29.
- Commit reference: `fe43e6e` (`refactor: add project diagnosis harness and close accepted story lane`).
- Branch: `feat/utcodeagentcli-us-inventor-01`.
- Branch integration: deferred; next lifecycle step after close is `/SPEC_mergeWorks` if the story branch still requires merge/integration.
- Priority: P0 - critical.
- Confidence: high.
- Next recommended command: `/SPEC_mergeWorks` for branch integration, or `/HARNESS_evolveHarness` with `evolution_mode=auto` when no merge step is required.

## Story

As an INVENTOR,
I want the CLI to own zero CaTDD method knowledge,
so that I can evolve categories, discipline rules, and prompt contracts without touching or re-releasing the CLI.

## Independent Test Intent

A reviewer can inspect CLI resolution behavior and verify that category meaning and command behavior are delegated to methodPrompts and slashCommands rather than hardcoded in the CLI.

## Mutual Intent Contract

- **Review result:** CLEARED
- **Developer intent:** Keep the CLI free of CaTDD method knowledge while proving at runtime which canonical prompt and command assets it consumed.
- **CodeAgent intent:** Design and implement only the resolver and delegation behavior required by the 16 acceptance criteria, with no semantic fallback or unrelated runtime-adapter work.

### In Scope

- Resolve and read required `methodPrompts/` and `slashCommands/` assets fresh during every CLI invocation.
- Permit invocation-local reuse only after the current invocation has resolved and read the source; do not persist semantic content across invocations.
- Prove delegation through structured run-plan or fake-runtime capture of resolved paths, current source content, and ordered prompt-read and command-invocation events.
- Fail explicitly for missing, empty, unreadable, configured-root-escaping, or wrong-kind assets without substituting hardcoded CaTDD meaning.
- Treat `codeAgents/utCodeAgentCLI/README_UserStoryStatus.md` as the authoritative lifecycle-status dashboard for this module.

### Out of Scope

- Method/CLI version negotiation or version-drift detection; route that concern to a future compatibility story.
- Flag-controlled CLI diagnostic rendering and public source-content or content-hash output; diagnostic behavior belongs to US-INVENTOR-03.
- New CaTDD category definitions, changed method semantics, runtime-adapter policy, or persistent semantic caching.
- Creating a project-root `README_UserStories.md` as part of this story.

### Success Signal

- All 16 US-INVENTOR-01 ACs have traceable P0 Typical, Edge, Misuse, and Fault tests.
- A method-prompt change is observed by the next CLI invocation without a CLI code change or stale cached content.
- Structured run-plan or fake-runtime capture identifies resolved asset paths, receives current source content, and preserves prompt-read and command-invocation order.
- Missing or invalid assets fail with no hardcoded semantic fallback.
- Existing US-USER-01 CLI validation tests remain GREEN.

### Contract Assumptions

- Canonical asset roots remain `methodPrompts/` and `slashCommands/` unless configuration explicitly supplies equivalent roots.
- Invocation-local reuse does not violate AC-08 because each new invocation resolves and reads current source content.
- Version compatibility will receive separate requirements before any version metadata or negotiation behavior is implemented.

### Open Questions

- None block replanning or downstream requirement synchronization.

## Acceptance Criteria

### P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
| --- | --- | --- | --- | --- |
| Typical | ValidFunc | AC-01 ~ AC-04 | 4 | ✅ Delegation works |
| Edge | ValidFunc | AC-07 ~ AC-08 | 2 | ✅ Delegation boundary |
| Misuse | InvalidFunc | AC-11 ~ AC-12 | 2 | ❌ Rejected caller/configured topology |
| Fault | InvalidFunc | AC-05 ~ AC-06, AC-09 ~ AC-10, AC-13 ~ AC-16 | 8 | ❌ Dependency failures |

---

### Typical (ValidFunc) — Delegation works

#### AC-01 [Func/Typical]: Category resolved from methodPrompts at runtime
- **Given** CLI needs Edge category meaning
- **When** `--behave designEdgeSkeleton` is prepared for a fake runtime
- **Then** captured run input contains the path and current source content of `CaTDD_methodPrompt4Cat-Edge.md`

#### AC-02 [Func/Typical]: Behavior delegates to slashCommands
- **Given** CLI resolves `--behave designFuncTestsSkeleton`
- **When** the prepared step executes through a fake runtime
- **Then** structured capture records the resolved `UT_designFuncTestsSkeleton.md` path and its `command-invocation` event

#### AC-03 [Func/Typical]: Run input comes from delegated assets
- **Given** an invocation requires CaTDD method and command content
- **When** its run plan is captured before execution
- **Then** captured content comes from the resolved assets, with no inline semantic fallback supplied by CLI code

#### AC-04 [Func/Typical]: Structured events preserve delegation order
- **Given** a run requires method prompts and a slash command
- **When** the run executes through a fake runtime
- **Then** structured capture records each resolved path and all `prompt-read` events before the `command-invocation` event

### Edge (ValidFunc) — Delegation boundary

#### AC-07 [Func/Edge]: Multiple prompts resolve independently
- **Given** CLI needs Edge category meaning, test status structure, and default execution order
- **When** method-prompt resolution runs
- **Then** structured capture records independent `prompt-read` events for `CaTDD_methodPrompt4Cat-Edge.md`, `CaTDD_methodPrompt-testStructure.md`, and `CaTDD_methodPrompt-workflow.md`

#### AC-08 [Func/Edge]: Updated prompt picked up without CLI change
- **Given** `CaTDD_methodPrompt4Cat-Edge.md` is updated with a sentinel after one invocation completes
- **When** the next invocation is prepared for a fake runtime
- **Then** captured run input contains the sentinel from current source content rather than content retained by a persistent cross-invocation cache

### Misuse (InvalidFunc) — Delegation contract

#### AC-11 [Func/Misuse]: Symlink escapes methodPrompts/ directory
- **Given** caller/configuration selects a prompt candidate that is a symlink outside the configured `methodPrompts/` root
- **When** CLI resolves
- **Then** exit 1, stderr reports symlink escape

#### AC-12 [Func/Misuse]: SlashCommand escapes configured root
- **Given** caller/configuration selects a slash-command symlink or path outside the configured `slashCommands/` root
- **When** CLI canonicalizes the resolved command path
- **Then** exit 1, stderr reports a configured-root escape, and no command content is read or invoked

### Fault (InvalidFunc) — Missing dependencies

#### AC-05 [Func/Fault]: Empty methodPrompt dependency
- **Given** a valid invocation requires a methodPrompt dependency that is empty (0 bytes)
- **When** CLI resolves that category
- **Then** exit 1, stderr reports empty file, no hardcoded fallback

#### AC-06 [Func/Fault]: Empty slashCommand dependency
- **Given** a valid invocation resolves a slashCommand dependency that is empty
- **When** CLI invokes that command
- **Then** exit 1, stderr reports empty command, no inline logic substituted

#### AC-09 [Func/Fault]: Prompt deleted at runtime — CLI fails
- **Given** a valid invocation selects a required prompt dependency that is deleted before read
- **When** CLI needs that category
- **Then** exit 1, stderr reports missing file

#### AC-10 [Func/Fault]: slashCommand deleted at runtime — CLI fails
- **Given** a valid invocation resolves a slashCommand dependency that is deleted before read
- **When** CLI attempts to read
- **Then** exit 1, stderr reports missing command, no fallback

#### AC-13 [Func/Fault]: `methodPrompts/` directory missing
- **Given** directory does not exist
- **When** CLI resolves any category
- **Then** exit 1, stderr: methodPrompts/ not found

#### AC-14 [Func/Fault]: Prompt file unreadable
- **Given** file exists but no read permission
- **When** CLI reads
- **Then** exit 1, stderr: permission error

#### AC-15 [Func/Fault]: `slashCommands/commands/` directory missing
- **Given** directory does not exist
- **When** CLI resolves behavior
- **Then** exit 1, stderr: directory not found

#### AC-16 [Func/Fault]: slashCommand path is a directory
- **Given** resolved path is a directory, not file
- **When** CLI reads
- **Then** exit 1, stderr: path is a directory, expected command file

## Scope

In scope:

- Delegation of CaTDD semantics.
- Hardcoded-method avoidance.
- Traceable artifact generation.

Out of scope:

- CLI behavior implementation details outside delegation rules.
- New category definitions.
- Runtime adapter policy.

## Risks

- Hardcoded semantics would make the CLI stale when CaTDD evolves.
- Duplicate logic across CLI and prompts would create drift.
- Unclear delegation boundaries would make maintenance harder.

## Assumptions

- `methodPrompts/` remains the source of truth for CaTDD meaning.
- Portable commands remain the source of truth for behavior execution.
- The CLI should be thin orchestration only.

## Resolved Acceptance Questions

- Cache policy: no persistent cross-invocation semantic cache; read canonical assets fresh for each invocation.
- Delegation proof: structured run-plan or fake-runtime capture of resolved paths, current source content, and ordered prompt-read and command-invocation events; CLI rendering belongs to US-INVENTOR-03.
- Version drift: deferred to a future compatibility story.
- Story ledger: the module-scoped `README_UserStoryStatus.md` is authoritative for `utCodeAgentCLI` lifecycle status.

## Requirement Update Checklist

- [x] Preserved `US-INVENTOR-01` and all 16 AC IDs.
- [x] Transitioned all 16 canonical ACs from PENDING to TODO.
- [x] Added fresh-per-invocation and ordered diagnostic-event requirements.
- [x] Recorded version-drift detection as future compatibility scope.
- [x] Synchronized the authoritative module dashboard.
- [x] Aligned the English and Chinese UserGuides with the updated usage expectation.
- [x] Reviewed requirement consistency with `/SPEC_reviewUserStory`; result: REVISE.
- [x] Removed USER-02 generated-artifact dependencies from AC-01, AC-03, and AC-08.
- [x] Kept structured resolver/runtime-capture evidence in US-INVENTOR-01 and CLI diagnostic flag behavior in US-INVENTOR-03.
- [x] Named the three canonical method-prompt assets required by AC-07.
- [x] Replaced AC-12 circular-reference behavior with slash-command configured-root escape rejection.
- [x] Updated stale project context to record the runnable US-USER-01 validation slice and unimplemented end-to-end boundary.
- [x] Reran `/SPEC_reviewUserStory` after all five corrections; result: PASS.

## Requirement Review

- **Review date:** 2026-08-28
- **Review result:** REVISE
- **Intent alignment:** PASS
- **US/AC identity and status traceability:** PASS
- **Usage-guide mirror and requirement alignment:** PASS
- **Independent testability and dependency direction:** REVISE

### Requirement Review Findings

1. **REQ-REV-01 - Upstream dependency cycle:** AC-01 requires generated TCs, AC-03 requires a test-file-modifying invocation, and AC-08 requires generated output to reflect changed prompt content. Those observables belong to US-USER-02 even though US-INVENTOR-01 is its prerequisite. Rewrite these ACs around resolved content captured in a run plan or fake runtime adapter; keep generated-artifact assertions in US-USER-02.
2. **REQ-REV-02 - Diagnostic ownership overlap:** AC-01, AC-02, AC-04, and AC-07 currently make `--diagMethodPrompts` or `--diagSlashCommands` output part of US-INVENTOR-01. US-INVENTOR-03 explicitly owns CLI diagnostic flags and is the downstream runtime proof of US-INVENTOR-01. US-INVENTOR-01 should require structured resolution paths and ordered events available to resolver/runtime capture; US-INVENTOR-03 should own flag-controlled stderr rendering.
3. **REQ-REV-03 - Unnamed AC-07 dependencies:** "category + status + priority" does not identify three deterministic source files. Name the canonical assets as `CaTDD_methodPrompt4Cat-Edge.md`, `CaTDD_methodPrompt-testStructure.md`, and `CaTDD_methodPrompt-workflow.md`, or revise the intended set explicitly.
4. **REQ-REV-04 - Undefined AC-12 grammar:** No recursive slash-command include grammar exists, so an ordinary Markdown self-link cannot define a circular command dependency safely. Per developer decision, replace AC-12 with rejection when a resolved slash-command symlink or path escapes the configured `slashCommands/` root.
5. **REQ-REV-05 - Stale project context:** `.catdd/spec/projectContext.md` still says `utCodeAgentCLI` is documentation and design rather than runnable. The verified US-USER-01 invocation-validation entrypoint makes that statement stale. Update the project fact through `SPEC_updateProjectContext`; do not fold this context maintenance into requirement semantics.

### Accepted Project Exception

- The developer selected `codeAgents/utCodeAgentCLI/README_UserStoryStatus.md` as the authoritative module ledger instead of creating project-root `README_UserStories.md`.
- This review accepts that repository-local exception for US-INVENTOR-01 and verifies the module dashboard against the active story. The exception diverges from the generic Px-SpecFlow ledger convention and remains a process-level residual risk; it does not change CaTDD method semantics.

### Review Checks

- [x] All 16 AC IDs remain stable and are marked TODO in the canonical story and module dashboard.
- [x] Dashboard totals remain 256 overall: 208 PENDING, 16 TODO, and 32 DONE.
- [x] The Mutual Intent Contract has no unresolved product question.
- [x] EN/ZH UserGuide heading structure and delegation guidance match.
- [x] Missing, empty, unreadable, escape, and wrong-kind failure paths are represented.
- [x] Every AC is independently testable without requiring a downstream story.
- [x] Structured delegation evidence belongs to US-INVENTOR-01; flag-controlled CLI diagnostics belong to US-INVENTOR-03.
- [x] AC-07 and AC-12 fixtures are deterministic from requirement text.
- [x] Project context reflects the runnable validation slice accurately.

## Requirement Correction

- **Correction date:** 2026-08-28
- **Applied by:** `/SPEC_updateUserStory`
- **Resolved findings:** REQ-REV-01 through REQ-REV-04
- **Preserved traceability:** `US-INVENTOR-01`, AC-01 through AC-16, and all TODO status markers
- **Subsequent correction:** REQ-REV-05 completed through `/SPEC_updateProjectContext`
- **Pending:** requirement re-review

## Project Context Update

- **Update date:** 2026-08-28
- **Applied by:** `/SPEC_updateProjectContext`
- **Resolved finding:** REQ-REV-05
- **Classification:** REFERENCE update in the stable layer model
- **Change:** Replaced the documentation-only claim with the runnable US-USER-01 invocation-validation boundary and retained the module `README.md` as the canonical detail route.
- **Budget:** 100 of 200 lines; no compaction required.
- **Open questions:** None.

## Requirement Re-review

- **Review date:** 2026-08-28
- **Review result:** PASS - transfer to design-oriented work
- **Intent alignment:** PASS
- **Clarity and ambiguity scan:** PASS; no unbounded or subjective result wording remains.
- **Completeness:** PASS; all 16 ACs have one Given, one When, and one Then.
- **Traceability:** PASS; all 16 stable AC IDs remain TODO in the canonical story and authoritative module dashboard.
- **Independent testability:** PASS; resolver/run-plan capture no longer depends on US-USER-02 artifact generation.
- **Ownership:** PASS; US-INVENTOR-01 owns structured delegation evidence and US-INVENTOR-03 owns CLI diagnostic rendering.
- **Exception coverage:** PASS; missing, empty, unreadable, configured-root escape, and wrong-kind asset paths are explicit.
- **Usage guidance:** PASS; English and Chinese UserGuides preserve the corrected ownership boundary.
- **Project context:** PASS; the runnable validation slice and unimplemented end-to-end boundary are accurate.
- **Architecture impact:** None; module ownership, dependency direction, and runtime placement are unchanged.
- **Required design follow-up:** Update detail design with fresh-per-invocation content loading, structured fake-runtime capture, event ordering, and configured-root canonicalization contracts.

### Closed Findings

- REQ-REV-01: Closed by replacing generated-artifact assertions with resolver/run-plan capture.
- REQ-REV-02: Closed by separating INV-01 structured evidence from INV-03 diagnostic rendering.
- REQ-REV-03: Closed by naming all three canonical AC-07 prompt assets.
- REQ-REV-04: Closed by replacing undefined circular-reference behavior with configured-root escape rejection.
- REQ-REV-05: Closed by updating bounded project context from verified repository evidence.

### Requirement Re-review Residual Risks

- The accepted module-ledger exception differs from generic Px-SpecFlow's project-root ledger convention; the module dashboard is internally consistent but process portability remains reduced.
- Detail design must keep captured source content internal to the run boundary and prevent it from becoming public diagnostic output.
- Filesystem permission and symlink tests should use deterministic injected filesystem boundaries where host behavior differs.

## Detail-Design Update

- **Update date:** 2026-08-28
- **Applied by:** `/SPEC_updateDetailDesign`
- **English design:** [../../../codeAgents/utCodeAgentCLI/README_DetailDesign.md](../../../codeAgents/utCodeAgentCLI/README_DetailDesign.md)
- **Chinese mirror:** [../../../codeAgents/utCodeAgentCLI/README_DetailDesign_ZH.md](../../../codeAgents/utCodeAgentCLI/README_DetailDesign_ZH.md)
- **Architecture impact:** None; existing resolver, executor, adapter, and trace boundaries remain intact.

### Addressed Feedback

- [x] Added one fresh `InvocationAssetSession` per invocation with invocation-local reuse only.
- [x] Added content-bearing resolved assets and generic `AgentInputAsset` translation so `AgentSDK` remains CaTDD-independent.
- [x] Added monotonic `DelegationEvidenceCollector` ordering for prompt reads and command invocation.
- [x] Added canonical, segment-safe configured-root containment and typed asset error codes.
- [x] Added metadata-only `TraceResolvedAssetRef` projection so raw source content does not reach public output.
- [x] Added deterministic `FakeAssetFileSystem` and `FakeRuntimeAdapter` verification boundaries.
- [x] Mapped all 16 US-INVENTOR-01 ACs to detailed-design mechanisms.
- [x] Preserved matching EN/ZH heading and TypeScript contract structure.
- [x] Reviewed the updated design with `/SPEC_reviewDetailDesign`; result: REVISE.

### Detail-Design Update Risks

- Re-review must verify that generic `AgentRunStep` contains no CaTDD-specific type or semantic definition.
- Re-review must verify that public paths are workspace-relative or root-labeled and contain no canonical/absolute prefix.
- Implementation must preserve attempted-invocation evidence when an adapter fails after `command-invocation` is recorded.

## Detail-Design Review

- **Review date:** 2026-08-28
- **Review result:** REVISE
- **Boundary gate:** PASS; CaTDD application, generic `AgentSDK`, executor, adapter, and trace ownership remain separated.
- **API/state gate:** REVISE; adapter lifecycle and content-lifetime invariants are internally inconsistent.
- **Constraint gate:** REVISE; public path projection and the V1 root-race threat boundary are incomplete.
- **Quality continuity gate:** REVISE; QAS-1 adapter modifiability and QAS-2 diagnosability depend on the corrections below.
- **Testability gate:** PASS after correction; all 16 ACs have deterministic fixture strategies.
- **Mirror gate:** PASS; EN/ZH headings and TypeScript blocks match.

### Developer Decisions

- Persist or print only workspace-relative logical asset paths; keep canonical paths internal.
- For V1, guarantee static canonical containment and explicitly exclude concurrent adversarial symlink/path mutation during one asset read.
- Standardize the adapter on a prepared-step lifecycle: `prepare(step) -> PreparedStep -> execute(prepared) -> StepResult`.

### Detail-Design Review Findings

1. **DD-REV-01 - Public path disclosure:** `TraceResolvedAssetRef` persists `canonicalPath`, and `DelegationEvent.path` does not distinguish internal canonical paths from public logical paths. This conflicts with the architecture's trace-leakage risk and redaction boundary. Remove canonical paths from persisted/public schemas, define workspace-relative logical-path projection, and test that absolute workspace/home prefixes are absent.
2. **DD-REV-02 - Incoherent adapter lifecycle:** Detail design declares `prepare(plan) -> PreparedRun` but `execute(step) -> StepResult`; the prepared result is never consumed and the shape diverges from the architecture's placeholder without explaining the refinement. Define `PreparedStep`, make the runtime/executor loop own step iteration, map `AgentRunPlanBuilder` to an explicit module, and document the step-level refinement.
3. **DD-REV-03 - Undeclared root-race boundary:** The separate `realpath -> stat -> readFile` calls prove containment only while filesystem topology is stable. Document the V1 no-concurrent-adversarial-mutation assumption, ensure all asset reads finish before any external adapter executes, keep static symlink/deletion tests, and record atomic contained-read as future hardening rather than claiming race-safe containment.
4. **DD-REV-04 - False content-lifetime invariant:** `InvocationAssetSession` says no content survives into another invocation, but `AgentRunPlan`, adapter inputs, or a fake capture may retain copied strings after session disposal. Replace this with a no-cross-invocation-reuse invariant, require session-map clearing, bound production plan/input lifetime to run finalization, and prohibit persistence of content-bearing objects.

### Architecture Viewpoint Check

- Context/functional: PASS; canonical assets remain external inputs consumed by the CLI application.
- Functional/development: REVISE until `AgentRunPlanBuilder` has an explicit module/file owner.
- Information/security: REVISE until internal canonical paths and content are projected to safe public metadata.
- Concurrency/deployment: PASS with the selected V1 stable-filesystem assumption made explicit; atomic hostile-mutation resistance is deferred.
- Operational: PASS after safe path projection; trace redaction and fail-closed persistence remain the owning tactics.

### Tactics and ADR Check

- Modifiability tactic: generic input assets and prepared-step adapters preserve adapter isolation, subject to DD-REV-02.
- Testability tactic: injected filesystem and runtime ports provide control/observation points.
- Security tactic: root containment limits access, but safe public path projection is required by DD-REV-01.
- Diagnosability tactic: monotonic metadata-only events preserve failure evidence, subject to safe projection.
- ADR advice: no new ADR is required. The selected changes refine interfaces and explicitly bound V1 behavior without changing accepted module ownership, runtime language, or ASR policy defaults.

## Detail-Design Correction

- **Correction date:** 2026-08-28
- **Applied by:** `/SPEC_updateDetailDesign`
- **English design:** [../../../codeAgents/utCodeAgentCLI/README_DetailDesign.md](../../../codeAgents/utCodeAgentCLI/README_DetailDesign.md)
- **Chinese mirror:** [../../../codeAgents/utCodeAgentCLI/README_DetailDesign_ZH.md](../../../codeAgents/utCodeAgentCLI/README_DetailDesign_ZH.md)
- **Architecture impact:** None; the adapter remains generic and the detail-level step lifecycle refines the architecture's conceptual prepared-run sketch.

### Applied Corrections

- [x] DD-REV-01: Added `PublicAssetPath`, removed canonical paths from public trace/event schemas, and defined workspace-relative/root-labeled projection.
- [x] DD-REV-02: Added `PreparedStep`, standardized adapter preparation/execution, and assigned `AgentRunPlanBuilder` to `src/catdd/agentRunPlanBuilder.ts`.
- [x] DD-REV-03: Documented the V1 stable-filesystem threat boundary, required all reads before adapter preparation, and deferred atomic contained-read hardening.
- [x] DD-REV-04: Replaced false erasure wording with map clearing, bounded run-local references, no cross-invocation reuse, and no persistence.
- [x] Preserved EN/ZH heading and TypeScript block parity.
- [x] Re-reviewed corrected design with `/SPEC_reviewDetailDesign`; DD-REV-01 through DD-REV-04 are closed, but DD-REV-05 remains.

### Detail-Design Correction Risks

- Static V1 containment does not resist concurrent adversarial directory/symlink replacement during one read interval.
- JavaScript does not guarantee secure erasure of copied strings; the design limits references and prohibits persistence instead.
- Re-review must confirm public path projection and prepared-step lifecycle are complete enough for deterministic CaTDD skeletons.

## Detail-Design Re-review

- **Review date:** 2026-08-28
- **Review result:** REVISE
- **DD-REV-01 public asset paths:** PASS; public asset refs/events use `PublicAssetPath` and omit canonical paths.
- **DD-REV-02 adapter lifecycle:** PASS; `PreparedStep` is produced and consumed, executor owns iteration, and builder ownership is explicit.
- **DD-REV-03 V1 threat boundary:** PASS; stable topology is explicit and atomic contained-read is deferred.
- **DD-REV-04 content lifetime:** PASS; map clearing, bounded references, no reuse, and no persistence replace secure-erasure claims.
- **Boundary/viewpoint gate:** PASS; no CaTDD-specific type crosses into `AgentSDK`.
- **Testability gate:** REVISE; persisted invocation/workspace path projection remains undefined.

### DD-REV-05 Finding

1. **DD-REV-05 - Undefined trace invocation/workspace projection:** `RunTrace` references `TraceInvocation` and `TraceWorkspace`, but neither type is defined anywhere in the module design. The architecture expects the original command, normalized arguments, repository root, config file, and working directory, all of which may contain absolute paths or inline content. Define structured redacted invocation fields and safe workspace fields using `PublicAssetPath`; prohibit raw argv/command persistence; add tests proving absolute home/workspace prefixes, inline source/story values, canonical paths, and parent traversal are absent from the complete serialized trace.

### Architecture and Tactics Check

- Architecture boundary: unchanged; this completes the existing trace redaction detail rather than changing trace ownership.
- Security: REVISE until all path-bearing trace fields use safe projections and inline values are redacted.
- Diagnosability: preserve behavior, target, argument names, and safe logical paths so traces remain actionable without raw values.
- Modifiability/testability: explicit trace types make schema tests deterministic and keep redaction centralized.
- ADR advice: no new ADR is required because the existing redaction decision already governs this correction.

### Process Note

- `SPEC_reviewDetailDesign` says PASS routes to `SPEC_reviewUserStory`, while `SPEC_makePlan` says not to add that gate after detail review. This does not block DD-REV-05 correction; resolve the next-step conflict when the detail review passes rather than silently choosing now.
- Developer decision on 2026-08-28: follow `SPEC_makePlan` and Px-SpecFlow, proceeding directly to `SPEC_designUnitTests`; retain the command inconsistency as process debt rather than adding another story review gate.

## Trace Schema Correction

- **Correction date:** 2026-08-28
- **Applied by:** `/SPEC_updateDetailDesign`
- **Resolved finding:** DD-REV-05
- **English design:** [../../../codeAgents/utCodeAgentCLI/README_DetailDesign.md](../../../codeAgents/utCodeAgentCLI/README_DetailDesign.md)
- **Chinese mirror:** [../../../codeAgents/utCodeAgentCLI/README_DetailDesign_ZH.md](../../../codeAgents/utCodeAgentCLI/README_DetailDesign_ZH.md)

### Applied Correction

- [x] Defined redacted `TraceInvocation` with typed arguments and reconstructed command evidence; raw argv is not retained.
- [x] Defined safe `TraceWorkspace` using `<workspace>`, relative paths, and an opaque external-working-directory label.
- [x] Defined path/text-safe `TraceStep`, `TraceFileEvent`, `TraceDiagnostic`, `TraceTcTransition`, and `TraceExit` DTOs.
- [x] Added `TraceId`, `IsoTimestamp`, `PublicTraceText`, `PublicAssetPath`, and `PublicTargetSelector` validation boundaries.
- [x] Added recursive whole-trace validation before encoding and fail-closed no-file behavior.
- [x] Added sentinel leakage tests spanning invocation values, content, workspace, targets, steps, diagnostics, files, transitions, and failures.
- [x] Preserved INV-02 AC-09: argument-validation failure creates no trace, so validated trace behavior/target fields remain required.
- [x] Preserved INV-02 AC-16: known non-serializable runtime values project to `[unserializable]` before final safety validation.
- [x] Preserved exact EN/ZH TypeScript schema parity.
- [x] Re-reviewed DD-REV-05 with `/SPEC_reviewDetailDesign`; result: PASS.

### Trace Schema Correction Risks

- Redaction must remain centralized; future trace fields must join the DTO allowlist and whole-trace safety test matrix.
- Reconstructed command evidence is intentionally less replayable than raw argv and must be paired with typed redacted arguments.
- The post-PASS command inconsistency remains process debt; this story follows the developer-selected direct test-design route.

## Detail-Design Final Review

- **Review date:** 2026-08-28
- **Review result:** PASS
- **Boundary gate:** PASS; CaTDD-specific resolved types remain in the application layer and `AgentSDK` receives generic input assets.
- **API/state gate:** PASS; every referenced trace DTO is defined, prepared steps are consumed, and run-local content lifetime is explicit.
- **Constraint gate:** PASS; safe path/text projection, recursive trace validation, typed asset failures, and V1 static-containment scope are explicit.
- **Quality continuity gate:** PASS; generic adapters preserve QAS-1 modifiability, complete failure traces support QAS-2 diagnosability, and aborted/failed states preserve QAS-3 evidence.
- **Testability gate:** PASS; all 16 story ACs map to deterministic fake filesystem/runtime and whole-trace leakage tests.
- **INV-02 compatibility:** PASS; validation failures create no trace and known non-serializable values use `[unserializable]` before final validation.
- **Mirror gate:** PASS; EN/ZH heading structure and TypeScript schemas are identical.
- **ADR gate:** PASS; no new architecture decision is required.

### Closed Detail Findings

- DD-REV-01: Closed by safe `PublicAssetPath` projection and removal of canonical paths from public DTOs.
- DD-REV-02: Closed by the consumed `PreparedStep` lifecycle and explicit plan-builder ownership.
- DD-REV-03: Closed by the V1 stable-filesystem threat boundary and deferred atomic hardening.
- DD-REV-04: Closed by map clearing, bounded references, no reuse, and no persistence.
- DD-REV-05: Closed by complete safe trace DTOs, reconstructed redacted invocation data, and recursive fail-closed validation.

### Detail-Design Final Residual Risks

- Static V1 containment does not protect against concurrent adversarial filesystem-topology mutation during one read interval.
- JavaScript cannot guarantee secure erasure; implementation must clear/drop references and prohibit persistence.
- Future trace fields can reintroduce leakage unless they join the DTO allowlist and whole-trace fixture matrix.
- Px-SpecFlow command documents disagree on whether another story review follows detail PASS; the developer selected direct test design for this story.

## Unit-Test Skeleton Design

- **Design date:** 2026-08-28
- **Applied by:** `/SPEC_designUnitTests`
- **SUT:** `utCodeAgentCLI` CaTDD asset-delegation module interface
- **Route:** Full P0 Functional set through `UT_designFuncTestsSkeleton`
- **Template:** `methodPrompts/CaTDD_designAndImplTemplate.ts`
- **Verification design:** [../../../codeAgents/utCodeAgentCLI/README_VerifyDesign.md](../../../codeAgents/utCodeAgentCLI/README_VerifyDesign.md)

### Category Files

| Category | ACs | TCs | Test file | Status |
| --- | --- | --- | --- | --- |
| Typical | AC-01..AC-04 | TC-DELEGATE-001..004 | [test_catdd_asset_delegation_funcValidTypical.ts](../../../codeAgents/utCodeAgentCLI/tests/test_catdd_asset_delegation_funcValidTypical.ts) | PLANNED |
| Edge | AC-07..AC-08 | TC-DELEGATE-007..008 | [test_catdd_asset_delegation_funcValidEdge.ts](../../../codeAgents/utCodeAgentCLI/tests/test_catdd_asset_delegation_funcValidEdge.ts) | PLANNED |
| Misuse | AC-11..AC-12 | TC-DELEGATE-011..012 | [test_catdd_asset_delegation_funcInvalidMisuse.ts](../../../codeAgents/utCodeAgentCLI/tests/test_catdd_asset_delegation_funcInvalidMisuse.ts) | PLANNED |
| Fault | AC-05..06, AC-09..10, AC-13..16 | TC-DELEGATE-005..006,009..010,013..016 | [test_catdd_asset_delegation_funcInvalidFault.ts](../../../codeAgents/utCodeAgentCLI/tests/test_catdd_asset_delegation_funcInvalidFault.ts) | PLANNED |

### Design Checks

- [x] Every US has linked ACs and every AC has one linked TC.
- [x] All 16 TC IDs are unique and marked `@[Status:PLANNED]`.
- [x] Every file declares SUT, class/category, source SPEC/UT command, and TypeScript template.
- [x] No executable `test`, `it`, or `describe` body exists.
- [x] Every category file has an exact `_readme.md` companion with Purpose, Status, Covered, and Manual sections.
- [x] P1/P2 promotion is deferred because no additional source-backed AC is accepted.
- [x] Four parallel-ready implementation slices and validation checkpoints are recorded in verification design.
- [x] Reviewed category placement, completeness, and traceability with `/UT_reviewFuncTestsSkeleton`; result: REVISE.
- [x] Corrected FUNC-REV-01 without changing any AC or TC identity.
- [x] Re-reviewed the corrected skeleton set with `/UT_reviewFuncTestsSkeleton`; result: PASS.

### Unit-Test Skeleton Risks

- Shared `FakeAssetFileSystem` and `FakeRuntimeAdapter` contracts must be frozen before parallel test implementation.
- Misuse and Fault boundaries must remain aligned with the accepted story categories during review.
- Product code must not begin until executable tests are implemented and confirmed RED for the intended reason.

## Functional Skeleton Review

- **Review date:** 2026-08-28
- **Review result:** REVISE
- **Traceability:** PASS; all 16 ACs have one unique PLANNED TC.
- **Skeleton structure:** PASS; SUT, category, priority, provenance, template, and implementation tracking are present.
- **Design-only gate:** PASS; no executable `test`, `it`, or `describe` body exists.
- **Companion documentation:** PASS; every test file has an exact `_readme.md` companion.
- **Category gate:** REVISE; four dependency-failure scenarios conflict with canonical CaTDD category semantics.

### Coverage Summary

| Category file | Current TCs | Review |
| --- | --- | --- |
| Typical | TC-DELEGATE-001..004 / AC-01..04 | PASS |
| Edge | TC-DELEGATE-005..008 / AC-05..08 | REVISE: AC-05/06 are dependency failures, not valid Edge behavior. |
| Misuse | TC-DELEGATE-009..012 / AC-09..12 | REVISE: AC-09/10 are dependency failures with a valid caller, not caller misuse. |
| Fault | TC-DELEGATE-013..016 / AC-13..16 | INCOMPLETE: must also own AC-05/06 and AC-09/10. |

### Functional Skeleton Finding

1. **FUNC-REV-01 - Dependency failures routed to Edge/Misuse:** Zero-byte required assets (AC-05/06) and assets deleted before read (AC-09/10) are dependency/environment failures while the CLI caller remains valid. `CaTDD_methodPrompt4Cat-Edge.md` routes dependency failures to Fault, and `CaTDD_methodPrompt4Cat-Misuse.md` reserves Misuse for caller contract violations. Per developer decision, move all four ACs and stable TC IDs into Fault.

### Required Corrections

- [x] Updated the canonical story category table, status overview, section placement, and category labels without changing AC/TC IDs or total counts.
- [x] Moved TC-DELEGATE-005/006 and TC-DELEGATE-009/010 into `test_catdd_asset_delegation_funcInvalidFault.ts`.
- [x] Kept Edge with TC-DELEGATE-007/008 and Misuse with TC-DELEGATE-011/012.
- [x] Updated companion READMEs, verification coverage, traceability, and parallel handoff.
- [x] Preserved 16 unique PLANNED TCs and zero executable bodies.
- [x] Reran `/UT_reviewFuncTestsSkeleton`; result: PASS.

## Functional Skeleton Re-review

- **Review date:** 2026-08-28
- **Review result:** PASS
- **Typical:** PASS with AC-01..04 / TC-DELEGATE-001..004.
- **Edge:** PASS with AC-07..08 / TC-DELEGATE-007..008.
- **Misuse:** PASS with AC-11..12 / TC-DELEGATE-011..012.
- **Fault:** PASS with AC-05..06, AC-09..10, AC-13..16 / TC-DELEGATE-005..006,009..010,013..016.
- **Traceability:** PASS; 16 unique AC/TC pairs and 16 PLANNED markers remain.
- **Provenance and SUT:** PASS in all four category files.
- **Design-only status:** PASS; no executable test body exists.
- **Companion documentation:** PASS with corrected 4/2/2/8 counts.
- **P1/P2 decision:** Deferred; no additional source-backed AC requires promotion.

### Remaining Gate

- Review the PROD-REV-01 detail-design update. After PASS, retarget TC-DELEGATE-001 to the specified logical workspace alias, prove/review RED, correct product code, and rerun product and post-product test reviews.

## Requirement Category Re-review

- **Review date:** 2026-08-28
- **Review result:** PASS
- **Intent and scope:** PASS; story value, runtime delegation contract, and 16 stable AC IDs are unchanged.
- **BDD completeness:** PASS; every AC has one Given, one When, and one Then.
- **Category taxonomy:** PASS; Typical/Edge/Misuse/Fault use the canonical 4/2/2/8 distribution.
- **Causal boundary:** PASS; Fault ACs state valid invocation plus dependency failure, while Misuse ACs state caller/configuration-selected root escape.
- **Status ledger:** PASS; all 16 ACs remain TODO in the canonical story and authoritative module dashboard.
- **Design/test traceability:** PASS; each AC maps to one unique PLANNED TC in the corrected category file.
- **Verification guidance:** PASS after correcting three stale top-level file-range summaries during review.
- **Usage/design impact:** None; behavior and detailed mechanisms are unchanged.
- **Open questions:** None.

### Closed Finding

- FUNC-REV-01: Closed by canonical category correction, stable TC redistribution, functional skeleton PASS, and requirement re-review PASS.

## Next Implementation Test Selection

- **Selection date:** 2026-08-28
- **Selection command:** `/UT_tellMeNextImplTest`
- **Selected TC:** TC-DELEGATE-001 `verifyEdgePromptResolution_byValidInvocation_expectCurrentContentCapture`
- **Trace:** US-INVENTOR-01 / AC-01 / P0 Functional / ValidFunc / Typical
- **Current status:** RED; one focused test runs and fails at the expected missing implementation boundary.
- **Reason:** No INV-01 TC is RED or blocked; Typical is first in the canonical P0 order, and no documented risk override applies.
- **Dependency value:** Current Edge-prompt resolution and fake-runtime capture provide the smallest foundation for later provenance, ordering, and freshness TCs.
- **Observed RED cause:** `src/catdd/invocationAssetSession.ts` is not implemented.
- **Implementation scope:** One executable test plus minimal `FakeAssetFileSystem` and `FakeRuntimeAdapter` test support; no product code.
- **TC-level structural review:** PASS for two keypoints, four phases, cleanup, and CaTDD metadata.
- **Story-level review:** PASS after IMPL-REV-01 and IMPL-REV-02 correction.
- **Blocker:** Product approval remains blocked until the PROD-REV-01 design update passes `/SPEC_reviewDetailDesign` and its test-first correction sequence completes.

## Implemented Unit-Test Review

- **Review date:** 2026-08-28
- **Review command:** `/SPEC_reviewImplUnitTests`
- **Review result:** FIX IMPLEMENTATION
- **Finding IMPL-REV-01:** TC-DELEGATE-001 calls `InvocationAssetSession.read` and `buildAgentRunPlan` only after the test itself chooses `CaTDD_methodPrompt4Cat-Edge.md`; it never calls `resolveBehavior`, `planCatddRun`, or `resolveMethodPrompts`.
- **Impact:** A wrong or hardcoded `designEdgeSkeleton` prompt mapping could still pass, and the public-path assertion is self-fulfilling because the same literal is supplied as input and expected output.
- **Finding IMPL-REV-02:** Pylance reports redeclarations of `path`, `FakeAssetFileSystem`, and `FakeRuntimeAdapter` because the CommonJS-style TypeScript files have no module scope.
- **Preserved evidence:** RED cause is reproducible; P0 ordering, metadata, two key assertions, all four phases, cleanup, and the 1 RED / 15 PLANNED ledger are valid.
- **Companion README:** Reviewed and updated using `test-case-with-readme`.
- **Required correction:** Drive the approved resolver chain from a valid `designEdgeSkeleton` invocation, assert the context asset derived by the fake runtime, and isolate the test/support files as TypeScript modules.
- **Product-code gate:** BLOCKED until correction and re-review PASS.

### Correction Result

- **Correction command:** `/SPEC_implUnitTests`
- **IMPL-REV-01:** Corrected; `resolveBehavior`, `planCatddRun`, `resolveSlashCommands`, and `resolveMethodPrompts` now derive the run-plan assets.
- **IMPL-REV-02:** Corrected; type-only exports isolate all three TypeScript files and diagnostics are clean.
- **Verification:** One test executes and remains RED for missing `src/catdd/behaviorRegistry.ts`; no product code exists.
- **TC-level correction review:** PASS with two keypoints, four phases, cleanup, metadata, and one-TC scope preserved.
- **Story-level re-review:** PASS; no implementation or skeleton drift remains.
- **Product-code result:** GREEN for TC-DELEGATE-001 only.
- **Next gate:** `/SPEC_reviewProductCodes`.

## Product Implementation

- **Implementation date:** 2026-08-28
- **Command:** `/SPEC_implProductCodes`
- **Target:** US-INVENTOR-01 / AC-01 / TC-DELEGATE-001
- **Initial RED:** Missing `src/catdd/behaviorRegistry.ts`.
- **Changed product files:** `behaviorRegistry.ts`, `planner.ts`, `invocationAssetSession.ts`, `slashCommandResolver.ts`, `methodPromptResolver.ts`, and `agentRunPlanBuilder.ts` under `src/catdd/`.
- **Behavior:** Resolve `designEdgeSkeleton`, read current path-only-selected command/prompt assets through an invocation-local session, and translate them into generic runtime inputs.
- **Correction attempts:** 1 of 3.
- **Evaluation:** GREEN; focused TC passes, all product files are diagnostic-clean, and 38 existing CLI tests pass.
- **Scope guard:** No other PLANNED TC and no unrelated CLI behavior was implemented.
- **Product review:** UPDATE DESIGN with PROD-REV-01.
- **Next gate:** `/SPEC_updateDetailDesign`.

## Product-Code Review

- **Review date:** 2026-08-28
- **Command:** `/SPEC_reviewProductCodes`
- **Result:** UPDATE DESIGN
- **Passing evidence:** 39/39 executable tests, zero diagnostics, one GREEN / 15 PLANNED INV-01 status, and no embedded semantic content.
- **Finding PROD-REV-01:** `toPublicPath` compares canonical asset paths against non-canonical `path.resolve(context.workspaceRoot)`. A symlinked workspace therefore misclassifies an internal prompt as root-external.
- **Reproduction:** `/workspace-link -> /real/workspace` emits `<methodPromptsRoot>/CaTDD_methodPrompt4Cat-Edge.md`; the reviewed contract requires `methodPrompts/CaTDD_methodPrompt4Cat-Edge.md`.
- **Design ambiguity:** No `CliExecutionContext` contract assigns workspace-root canonicalization to context construction or the asset session.
- **Required action:** Update detail design to assign ownership and verification guidance before product/test correction.
- **Product approval:** BLOCKED.

## PROD-REV-01 Detail-Design Correction

- **Update date:** 2026-08-29
- **Command:** `/SPEC_updateDetailDesign`
- **Ownership decision:** `CliExecutionContext` supplies normalized logical roots that may be symlinks; `InvocationAssetSession` owns asynchronous canonicalization through the injected `AssetFileSystem`.
- **Session contract:** `openAssetSession` returns `Promise<InvocationAssetSession>` after validating and retaining immutable canonical workspace, method-prompt, slash-command, and `commands/` roots.
- **Projection invariant:** Compare canonical asset paths only with the session-owned canonical workspace root. Workspace-contained assets are workspace-relative; external configured-root assets are root-labeled.
- **Test-first correction:** Preserve TC-DELEGATE-001 and retarget its fake topology from `/workspace-link` to `/real/workspace`. The current product must become RED with the wrong root-labeled path before correction.
- **Scope:** No new story AC or TC. Existing PLANNED Fault/Misuse TCs retain typed-error and escape coverage.
- **Current evidence:** The original TC remains GREEN, while an isolated probe still reproduces PROD-REV-01; no test or product code changed in this design step.
- **Next gate:** `/SPEC_reviewDetailDesign`.

## Next Recommended Action

Run `/SPEC_reviewDetailDesign` to review the PROD-REV-01 ownership and test-first correction design.
