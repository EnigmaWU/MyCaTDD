# TASKs: Define Unified specCodeAgentCLI CLI UsageDesign Contract

Paired with [20261111-design-specCodeAgentCLI-usage-contract-UserStory](20261111-design-specCodeAgentCLI-usage-contract-UserStory.md).

---

## Active Story

- **ID:** `US-specDeveloper-defineSpecCodeAgentCliUsageContract`
- **StoryIdAlias:** `US-261111.220010`
- **CreatedAt:** `2026-11-11T22:00:10+08:00`
- **State:** `doing / OPEN`
- **Priority:** `P0 Functional` / `Typical`
- **Branch:** `feat/specCodeAgentCLI-requirements-and-usage-design`
- **Execution Mode:** `manualMode`
- **Source:** `.catdd/spec/analyzedNews/20261111-design-specCodeAgentCLI-usage-contract-Feature.md`
- **Project Story Ledger:** `README_UserStories.md`

---

## Current Readiness

| Prerequisite | Status | Evidence or gap |
| --- | --- | --- |
| Lifecycle state | Satisfied | Active story in `.catdd/spec/doingUS/` on branch `feat/specCodeAgentCLI-requirements-and-usage-design`; obsolete `US-SPECFLOW-REPAIR-01` cleanly moved to `.catdd/spec/abortUS/`. |
| Intent alignment | Satisfied | `Mutual Intent Contract` recorded as `CLEARED` from 2 interactive `BRAINSTORM` rounds. |
| Requirement surfaces | Reviewed PASS | `README_UserStories.md` registered with `US-261111.220010` and 9 `CaTDD-AC` rows (`SPEC_reviewUserStory = PASS`). |
| Architecture design | Deferred (approved) | High-level `README_ArchDesign.md` explicitly deferred in `Story Completion Conditions`; layer boundary documented in `codeAgents/specCodeAgentCLI/README.md` and `projectContext.md`. |
| UsageDesign surface | Reviewed PASS | `codeAgents/specCodeAgentCLI/README_UsageDesign.md` instantiated from `README_UsageDesignLiteCliTemplate.md` and verified against all 9 CaTDD-ACs and repository contract scripts. |
| Test skeletons & product code | Deferred (approved) | Executable CLI parser/runner implementation and TypeScript test files belong to follow-up implementation stories; repository contract check added to `scripts/test_codeAgents_structure.sh`. |

---

## Work Orientation

- **Current Orientation:** `design-oriented` (design-only UsageDesign contract story; closes after UsageDesign review, contract script validation, and developer-approved `SPEC_commitStoryWorks`)
- **Autonomous Boundary Status:** `manualMode required until requirements and designs are locked`
- **Summary:** This story establishes the authoritative English CLI usage contract (`codeAgents/specCodeAgentCLI/README_UsageDesign.md`) and project story ledger (`README_UserStories.md`) first, deferring the Chinese mirror, module architecture/detail design, and runnable CLI implementation to subsequent stories.

---

## EPIC Specification Sufficiency

| EPIC Category | Dimension | Disposition (`satisfied / partial / gap / question / N/A`) | Evidence / Affected IDs | Owner / Next Action |
| --- | --- | --- | --- | --- |
| **Expressive (E)** | `E1 Unambiguous` | `satisfied` | Quantified exit codes (`0..10`), explicit `--mode` / `--goal` / `--command` rules, AST scan clean (`US-261111.220010-AC-*`) | `none` |
| **Expressive (E)** | `E2 Singular` | `satisfied` | 9 atomic P0 CaTDD-ACs (`Typical` 1..3, `Edge` 1..2, `Misuse` 1..2, `Fault` 1..2) | `none` |
| **Expressive (E)** | `E3 Verifiable` | `satisfied` | Observable `stdout` / `stderr` / JSON / exit-code oracles in `README_UsageDesign.md` + `scripts/test_codeAgents_structure.sh` | `none` |
| **Precise (P)** | `P1 Dependency Control` | `satisfied` | Zero `utCodeAgentCLI` dependency; config-only provider settings; `MetaspecWorkspaceResolution` + Loop Guard ($B \le 3$) | `none` |
| **Precise (P)** | `P2 Complete` | `satisfied` | Full P0 (`Typical`, `Edge`, `Misuse`, `Fault`) scenario coverage + `K-SEC-01..04` security/secret redaction | `none` |
| **Interpretable (I)** | `I1 Conforming` | `satisfied` | Conforms to `SpecTodoUserStoryTemplate.md`, `README_UserStoriesTemplate.md`, and `README_UsageDesignLiteCliTemplate.md` | `none` |
| **Interpretable (I)** | `I2 Consistent` | `satisfied` | Aligned with `Px-SpecFlow.md`, `README_UbiLang.md`, `projectContext.md`, and `README_UserStories.md` | `none` |
| **Interpretable (I)** | `I3 Comprehensible` | `satisfied` | 5W1H, OOPSI model, Mermaid flow, copy-exec bash examples, and CaTDD verification handoff included | `none` |
| **Compartmentalized (C)** | `C1 Scope Discipline` | `satisfied` | Strictly scoped to English `README_UsageDesign.md` + ledger; ZH mirror, ArchDesign, and runtime code explicitly deferred | `none` |
| **Compartmentalized (C)** | `C2 Implementation Planning` | `satisfied` | Design-only closure path, CaTDD verification handoff table for future implementation story, and verified `step` + `pre_close` commit plan | `SPEC_closeUserStory` |

### Cross-Artifact Semantic-Delta Matrix (`EPIC I2.3 / Transformation Preservation`)

| Source Obligation (`US/AC/ASR`) | Story / Guide | ArchDesign / UbiLang | UsageDesign (`README_UsageDesign.md`) | Test Design Handoff | Repo Contract Script | Gate Status |
| --- | --- | --- | --- | --- | --- | --- |
| `US-261111.220010-AC-Typical-01` | Defined (`MUST`; `EX-01`, `RULE-01..02`) | `KEPT` (`autonomousMode` in `README_UbiLang`) | `DETAILED` (`USAGE-SC-001`, `USAGE-SC-002`, Exit `0`/`6`/`7`) | `REASSIGNED` (`test_spec_cli_invocation_funcValidTypical.ts` in impl story) | `KEPT` (`test_codeAgents_structure.sh`) | `PASS` |
| `US-261111.220010-AC-Typical-02` | Defined (`MUST`; `EX-02`, `RULE-01`, `RULE-03`) | `KEPT` (`manualMode` in `README_UbiLang`) | `DETAILED` (`USAGE-SC-003`, `USAGE-SC-004`, `--command` & default `SPEC_whatsNextTask`) | `REASSIGNED` (`test_spec_cli_invocation_funcValidTypical.ts` in impl story) | `KEPT` (`test_codeAgents_structure.sh`) | `PASS` |
| `US-261111.220010-AC-Typical-03` | Defined (`MUST`; `EX-03`, `RULE-04..05`) | `KEPT` (`K-SEC-02` in `projectContext`) | `DETAILED` (`USAGE-SC-005`, JSON schema v1, config-only LLM settings) | `REASSIGNED` (`test_spec_cli_invocation_funcValidTypical.ts` in impl story) | `KEPT` (`test_codeAgents_structure.sh`) | `PASS` |
| `US-261111.220010-AC-Edge-01` | Defined (`MUST`; `EX-04`, `CEX-01`, `RULE-02`, `RULE-06`) | `KEPT` (`ONE-MORE-THING` & orientation boundary) | `DETAILED` (`USAGE-SC-006`, `USAGE-SC-007`, `manual_required` Exit `10`) | `REASSIGNED` (`test_spec_cli_invocation_funcValidEdge.ts` in impl story) | `KEPT` (`test_codeAgents_structure.sh`) | `PASS` |
| `US-261111.220010-AC-Edge-02` | Defined (`MUST`; `EX-05`, `RULE-07`) | `KEPT` (`MetaspecWorkspaceResolution`) | `DETAILED` (`USAGE-SC-008`, `--dry-run` + `--metaspec-root`) | `REASSIGNED` (`test_spec_cli_invocation_funcValidEdge.ts` in impl story) | `KEPT` | `PASS` |
| `US-261111.220010-AC-Misuse-01` | Defined (`MUST`; `CEX-02`, `RULE-02`, `RULE-04`) | `KEPT` | `DETAILED` (`USAGE-SC-009`..`011`, Exit `2` fail-fast) | `REASSIGNED` (`test_spec_cli_invocation_funcInvalidMisuse.ts` in impl story) | `KEPT` | `PASS` |
| `US-261111.220010-AC-Misuse-02` | Defined (`MUST`; `CEX-03`, `RULE-07`) | `KEPT` (`K-SEC-01` in `projectContext`) | `DETAILED` (`USAGE-SC-012`, path escape / invalid root Exit `2`) | `REASSIGNED` (`test_spec_cli_invocation_funcInvalidMisuse.ts` in impl story) | `KEPT` | `PASS` |
| `US-261111.220010-AC-Fault-01` | Defined (`MUST`; `CEX-04`, `RULE-07`) | `KEPT` (`HARNESS_migrateMetaspec`) | `DETAILED` (`USAGE-SC-013`..`014`, workspace drift / missing file Exit `3`) | `REASSIGNED` (`test_spec_cli_invocation_funcInvalidFault.ts` in impl story) | `KEPT` | `PASS` |
| `US-261111.220010-AC-Fault-02` | Defined (`MUST`; `CEX-05`, `RULE-08`) | `KEPT` (`Closed-Loop Regeneration Budget (B)`) | `DETAILED` (`USAGE-SC-015`, Loop Guard $B \le 3$, Exit `5`/`6`) | `REASSIGNED` (`test_spec_cli_invocation_funcInvalidFault.ts` in impl story) | `KEPT` | `PASS` |

---

## Trajectory

| # | Date | Command / Gate | Verdict / Evidence / Commit | Plan Delta -> Next Command |
| --- | --- | --- | --- | --- |
| 1 | `2026-11-11` | `SPEC_abortUserStory` + `SPEC_updateProjectContext` | Aborted obsolete `US-SPECFLOW-REPAIR-01` to `.catdd/spec/abortUS/`; marked `utCodeAgentCLI` deprecated in `projectContext.md` (`117` lines); commit held per developer instruction (`No git commits yet`) | Cleared active lane for `specCodeAgentCLI` intake -> `SPEC_importFeature` |
| 2 | `2026-11-11` | `SPEC_importFeature` + `SPEC_analyzeFeature` (`BRAINSTORM`) | Archived `.catdd/spec/analyzedNews/20261111-design-specCodeAgentCLI-usage-contract-Feature.md` with 7-turn `## Chat History`; registered `US-261111.220010` in `README_UserStories.md`; pre-story commit deferred (`No git commits yet`) | Story `Gate = READY` -> `SPEC_openUserStory` |
| 3 | `2026-11-11` | `SPEC_openUserStory` + `SPEC_makePlan` | Opened story in `.catdd/spec/doingUS/` on `feat/specCodeAgentCLI-requirements-and-usage-design`; `Mutual Intent Contract = CLEARED`; orientation `design-oriented` (UsageDesign-only slice) | Initialized checklist and commit plan -> `SPEC_reviewUserStory` |
| 4 | `2026-11-11` | `SPEC_reviewUserStory` + `SPEC_updateMadePlan` | `review_verdict = PASS`; verified `US-261111.220010` identity, 9 `From/Given/When/Then/Counter` CaTDD-ACs, normative `MUST`/`MUST NOT` modals, and `README_UserStories.md` sync | Checked `[x]` requirement review; transferred to UsageDesign authoring -> `SPEC_takeDetailDesign` |
| 5 | `2026-11-11` | `SPEC_takeDetailDesign` + `SPEC_reviewDetailDesign` + `SPEC_updateMadePlan` | `review_verdict = PASS`; authored `codeAgents/specCodeAgentCLI/README_UsageDesign.md` from `README_UsageDesignLiteCliTemplate.md`, updated `scripts/test_codeAgents_structure.sh`, and verified all repository validation scripts pass; commit held per developer choice | Ready for developer review & commit approval -> `SPEC_commitStoryWorks` (`pre_close`) |
| 6 | `2026-11-13` | `SPEC_commitStepWorks` | Committed step `SPEC_takeDetailDesign` (`step_commit_ref = 5862e55`; 4 step-scoped files: `codeAgents/specCodeAgentCLI/README_UsageDesign.md`, `codeAgents/specCodeAgentCLI/README.md`, `codeAgents/README.md`, `scripts/test_codeAgents_structure.sh`); metaspec/ledger files kept unstaged for story-span commits | Recorded `step_commit_ref = 5862e55`; no remaining planned step commits -> `SPEC_commitStoryWorks` (`span_end` + `pre_close`) |
| 7 | `2026-11-13` | `SPEC_commitStoryWorks` (`span_end` + `pre_close`) | Committed `US-SPECFLOW-REPAIR-01` `span_end` (`span_commit_ref = 2178251`) and `US-261111.220010` `pre_close` story-span artifacts (`projectContext.md`, `README_UserStories.md`, `analyzedNews/`, `doingUS/`; referencing `step_commit_refs = 5862e55`) | Checked `[x]` `SPEC_commitStoryWorks` (`pre_close`) -> `SPEC_closeUserStory` |

---

## Task Checklist

### Phase 1: Intake, Opening, and Intent

- [x] **SPEC_abortUserStory** (`US-SPECFLOW-REPAIR-01`) — Moved deprecated `utCodeAgentCLI` story and tasks from `doingUS/` to `abortUS/` and updated `projectContext.md`.
- [x] **SPEC_importFeature** & **SPEC_analyzeFeature** (`BRAINSTORM`) — Archived analyzed feature with `## Chat History` and registered `US-261111.220010` in `README_UserStories.md`.
- [x] **SPEC_openUserStory** — Opened story in `.catdd/spec/doingUS/` on branch `feat/specCodeAgentCLI-requirements-and-usage-design`.
- [x] **SPEC_clearStoryIntent** — `CLEARED` `Mutual Intent Contract` recorded from interactive `BRAINSTORM` decisions.
- [x] **SPEC_makePlan** — Created initial `*-UserStory-Tasks.md`, classified `design-oriented` UsageDesign slice, and locked commit plan.

### Phase 2: Requirements & UsageDesign Gates

- [x] **SPEC_updateUserStory** — Created and synchronized project-root `README_UserStories.md` with `US-261111.220010` and 9 P0 CaTDD-ACs.
- [x] **SPEC_reviewUserStory** — `PASS`: verified identity registry, `From/Given/When/Then/Counter` evidence, `MUST`/`MUST NOT` modals, and `Story Completion Conditions`.
- [x] **SPEC_takeArchDesign** / **SPEC_reviewArchDesign** — Skipped / deferred by approved story scope (`README_ArchDesign.md` scheduled for follow-up architecture story; layer boundary recorded in `codeAgents/specCodeAgentCLI/README.md`).
- [x] **SPEC_takeDetailDesign** (UsageDesign surface) — Authored `codeAgents/specCodeAgentCLI/README_UsageDesign.md` from `README_UsageDesignLiteCliTemplate.md` and extended `scripts/test_codeAgents_structure.sh`.
- [x] **SPEC_reviewDetailDesign** (UsageDesign surface) — `PASS`: verified 5W1H, OOPSI model, `autonomousMode` vs `manualMode` CLI contract, config-only provider rule, stdout/stderr/JSON/exit-code determinism, `K-SEC-01..04` compliance, CaTDD verification handoff, and repository validation scripts (`README_DetailDesign.md` and `README_DetailVerifyDesign.md` explicitly deferred in `Approved Deferrals`).
- [x] **SPEC_updateMadePlan** — Synchronized `[x]` design review evidence and `## Trajectory` rows 1–5.

### Phase 3: Test-First Implementation & Review Slices (Part 2.b)

- [x] **Deferred by design-only story scope** — Executable TypeScript CLI parser/runner implementation and CaTDD test files (`test_spec_cli_invocation_*.ts`) are handed off via `README_UsageDesign.md` (`## CaTDD Verification Handoff`) to the follow-up implementation story.

### Phase 4: Commit, Closure, and Merge

- [x] **SPEC_commitStoryWorks** (`span_end` for `US-SPECFLOW-REPAIR-01` = `2178251`; `pre_close` for `US-261111.220010`) — Committed remaining story-span lifecycle, ledger, and project-context artifacts.
- [ ] **SPEC_closeUserStory** — Move story and tasks to `.catdd/spec/doneUS/` and update `README_UserStories.md` to `DONE` after `pre_close` commit.
- [ ] **SPEC_commitStoryWorks** (`post_close`) — Commit close-generated lifecycle/ledger updates.
- [ ] **SPEC_mergeWorks** — Merge `feat/specCodeAgentCLI-requirements-and-usage-design` into `main` when ready.

---

## Commit Plan

- **Pre-Story Commit (`pre_story_commit`):** `no` (developer selected `No git commits yet` during intake; pre-story artifacts captured in `pre_close` story-span commit)
- **Single Story Squash (`single_story_commit`):** `no` (preserved step commit `5862e55` alongside `SPEC_commitStoryWorks` checkpoints)
- **Story-Span Closing Command:** `SPEC_commitStoryWorks` (`span_end = 2178251` for aborted `US-SPECFLOW-REPAIR-01`; `pre_close` committed; `post_close` pending after `SPEC_closeUserStory`)

| Step Boundary | Policy (`commit_step`) | Gate Condition | Recorded `commit_ref` / Status |
| --- | --- | --- | --- |
| `SPEC_reviewUserStory` | `no` | Requirement & ledger gate `PASS` | `skipped (changed no file)` |
| `SPEC_takeDetailDesign` + `SPEC_reviewDetailDesign` (UsageDesign) | `optional` | UsageDesign review `PASS` + `scripts/test_*.sh` `PASS` | `5862e55` (`SPEC_commitStepWorks` on `2026-11-13`) |

---

## Candidate Next Steps

| Candidate | Decision | Rationale |
| --- | --- | --- |
| `SPEC_closeUserStory` | Selected | All in-scope UsageDesign and ledger gates are `PASS`, step commit `5862e55` is recorded, and `pre_close` commit provides `commit_ref`. |
| `SPEC_designTests` | Rejected | This story is a `design-oriented only` UsageDesign slice; executable code/tests are deferred to follow-up stories after ArchDesign/DetailDesign. |

## Rejected Next Steps

| Candidate | Reason rejected now |
| --- | --- |
| `SPEC_designTests` | Approved `Story Completion Conditions` scope this story to English `README_UsageDesign.md` + `README_UserStories.md` first. |

## Selected Next Command

### `/SPEC_closeUserStory`

Close `US-specDeveloper-defineSpecCodeAgentCliUsageContract` (`US-261111.220010`) using the `pre_close` `commit_ref` and green repository contract verification summary, then finalize close-generated changes via `/SPEC_commitStoryWorks` (`post_close`).

## Blockers and Open Questions

- No blocker prevents `/SPEC_closeUserStory`
- No specification or design blocker remains. Git commits are intentionally paused per developer preference (`No git commits yet`).
