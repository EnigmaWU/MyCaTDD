# TASKs: {{UserStoryTitle}}

This is the SpecCoding template for `.catdd/spec/doingUS/{{YYYYMMDD-StorySlug}}-UserStory-Tasks.md` (and its preserved copies in `suspendUS/`, `abortUS/`, and `doneUS/`). Create it initially via `SPEC_makePlan` after `SPEC_openUserStory` or `SPEC_clearStoryIntent`, and synchronize/refine it via `SPEC_updateMadePlan` after review gates (`SPEC_reviewUserStory`, `SPEC_reviewArchDesign`, `SPEC_reviewDetailDesign`, `SPEC_reviewImplTests`, `SPEC_reviewProductCodes`), rework loops, story resumption, or `plan_drift` checkpoints.

Paired with [{{YYYYMMDD-StorySlug-UserStory.md}}]({{YYYYMMDD-StorySlug-UserStory.md}}).

---

## Active Story

- **ID:** US-{{n}}
- **State:** {{doing / OPEN | suspended | aborted | done}}
- **Priority:** {{P0 Functional | P1 Design | P2 Quality | P3 Addons}} / {{Category}}
- **Branch:** `{{branch_name}}`
- **Execution Mode:** `{{manualMode | autonomousMode (held until implementation-oriented) | autonomousMode (active)}}`
- **Source:** `.catdd/spec/analyzedNews/{{YYYYMMDD-source}}.md` (or module `README_UserStory.md` + `README_UserGuide.md`)
- **Project Story Ledger:** `README_UserStories.md`

---

## Current Readiness

| Prerequisite | Status | Evidence or gap |
| --- | --- | --- |
| Lifecycle state | {{Satisfied / Blocked}} | {{doingUS placement, branch, suspendUS check}} |
| Intent alignment | {{Satisfied / Pending / Skipped}} | {{Mutual Intent Contract status or SPEC_clearStoryIntent note}} |
| Requirement surfaces | {{Satisfied / Pending / Reviewed PASS}} | {{README_UserStories.md + README_UserGuide.md + SPEC_reviewUserStory verdict}} |
| Architecture design | {{Satisfied / Skipped / Reviewed PASS / REVISE}} | {{README_ArchDesign.md + README_ArchVerifyDesign.md + SPEC_reviewArchDesign verdict}} |
| Detail design | {{Satisfied / Pending / Reviewed PASS / REVISE}} | {{README_DetailDesign.md + README_DetailVerifyDesign.md + SPEC_reviewDetailDesign verdict}} |
| Test skeletons | {{Pending / Reviewed PASS / REVISE}} | {{P0 Typical/Edge/Misuse/Fault + gated P1/P2 skeletons}} |
| Test & product implementation | {{Pending / RED verified / GREEN verified}} | {{SPEC_reviewImplTests + SPEC_reviewProductCodes verdicts}} |

---

## Work Orientation

- **Current Orientation:** `{{intent-clearing | requirement-oriented | design-oriented | implementation-oriented}}`
- **Autonomous Boundary Status:** {{manualMode required until requirements and designs are locked | implementation-oriented unlocked for autonomousMode}}
- **Summary:** {{1-2 sentences explaining why this orientation applies now and what transition comes next}}

---

## EPIC Specification Sufficiency

<!-- Stage 2 artifact-set sufficiency ledger (arXiv:2610.07534 EPIC framework).
     Judges the active story, guide, architecture/detail design, verification design, and task plan
     as one semantic artifact set rather than isolated documents.
     Seeded by SPEC_makePlan (inheriting Stage 1 story readiness from todoUS/*-UserStory.md or evaluating
     imported stories directly), progressively updated by SPEC_updateMadePlan after each SPEC_review* gate
     (SPEC_reviewUserStory, SPEC_reviewArchDesign, SPEC_reviewDetailDesign, SPEC_reviewImplTests,
     SPEC_reviewProductCodes), and verified at SPEC_closeUserStory so no unresolved blocking gap or
     question remains. Do not collapse into a single numeric score; record disposition, evidence, and owner. -->

| EPIC Category | Dimension | Disposition (`satisfied / partial / gap / question / N/A`) | Evidence / Affected IDs | Owner / Next Action |
| --- | --- | --- | --- | --- |
| **Expressive (E)** | `E1 Unambiguous` | `{{satisfied / partial / gap / question}}` | {{quantified bounds, AST smell scan, Mutual Intent Contract, or open Q IDs}} | `{{SPEC_clearStoryIntent / SPEC_updateUserStory / none}}` |
| **Expressive (E)** | `E2 Singular` | `{{satisfied / partial / gap / question}}` | {{atomic scenarios, singular arch/detail facts, isolated risk/edge entries}} | `{{SPEC_updateUserStory / SPEC_updateDetailDesign / none}}` |
| **Expressive (E)** | `E3 Verifiable` | `{{satisfied / partial / gap / question}}` | {{observable ACs, `discovery_ledger` TPs, `TestEvidenceChain`, completion criteria}} | `{{SPEC_reviewDetailDesign / SPEC_designTests / none}}` |
| **Precise (P)** | `P1 Dependency Control` | `{{satisfied / partial / gap / question / N/A}}` | {{declared assumptions, boundary constraints, dependency failure modes (`Fault`)}} | `{{SPEC_takeArchDesign / SPEC_takeDetailDesign / none}}` |
| **Precise (P)** | `P2 Complete` | `{{satisfied / partial / gap / question}}` | {{Typical + Edge + Misuse + Fault coverage, quality/resource/security constraints}} | `{{SPEC_reviewUserStory / SPEC_reviewDetailDesign / none}}` |
| **Interpretable (I)** | `I1 Conforming` | `{{satisfied / partial / gap}}` | {{standard templates, stable `US/AC/TP/TC` IDs}} | `{{SPEC_updateUserStory / SPEC_designTests / none}}` |
| **Interpretable (I)** | `I2 Consistent` | `{{satisfied / partial / gap / question}}` | {{ubiquitous language, `README_UserStories.md` ledger sync, cross-artifact alignment}} | `{{SPEC_reviewUserStory / SPEC_reviewDetailDesign / SPEC_reviewProductCodes}}` |
| **Interpretable (I)** | `I3 Comprehensible` | `{{satisfied / partial / gap / N/A}}` | {{structured sections, cross-doc links, worked/usage examples, companion test READMEs}} | `{{SPEC_reviewDetailDesign / SPEC_reviewImplTests / none}}` |
| **Compartmentalized (C)** | `C1 Scope Discipline` | `{{satisfied / partial / gap / question}}` | {{explicit `In scope` / `Non-goals`, product `WHAT/WHY` separated from design `HOW`}} | `{{SPEC_clearStoryIntent / SPEC_reviewUserStory / none}}` |
| **Compartmentalized (C)** | `C2 Implementation Planning` | `{{satisfied / partial / gap}}` | {{work orientation, ordered `US/AC/TC` slices, `[P]` parallel markers, commit plan}} | `{{SPEC_makePlan / SPEC_updateMadePlan}}` |

### Cross-Artifact Semantic-Delta Matrix (`EPIC I2.3 / Transformation Preservation`)

<!-- Tracks each material obligation across the 4 review stages:
     1. SPEC_reviewArchDesign: Story / Guide -> ArchDesign / UbiLang / ArchVerifyDesign
     2. SPEC_reviewDetailDesign: ArchDesign -> DetailDesign / StateDesign -> DetailVerifyDesign (discovery_ledger)
     3. SPEC_designTests + TEST_review*TestsSkeleton: DetailVerifyDesign (TP) -> US/AC/TC Skeleton (@[Expect])
     4. SPEC_reviewImplTests: US/AC/TC Skeleton (@[Expect]) -> Implemented Test Body (SETUP/BEHAVIOR/VERIFY) & Companion README
     Classify each transition as KEPT, DETAILED (with rationale), REASSIGNED (with owner), EXCLUDED (with approval), VIOLATED (blocks gate -> REVISE), or UNKNOWN (blocks gate -> ASK / BLOCKED). -->

| Source Obligation (`US/AC/ASR`) | Story / Guide | ArchDesign / UbiLang | DetailDesign / VerifyDesign (`TP`) | Test Design Skeleton (`US/AC/TC`) | ImplTest Body (`SETUP/BEHAVIOR/VERIFY`) | Gate Status |
| --- | --- | --- | --- | --- | --- | --- |
| `{{AC-01 / ASR-01}}` | Defined (`MUST`) | `{{KEPT / DETAILED / N/A}}` | `{{KEPT / DETAILED (TP-01..n)}}` | `{{KEPT (TC-001)}}` | `{{KEPT (RED / GREEN)}}` | `{{PASS / REVISE / ASK}}` |
| `{{AC-02}}` | Defined (`MUST`) | `{{KEPT / REASSIGNED / EXCLUDED}}` | `{{DETAILED / VIOLATED / UNKNOWN}}` | `{{pending / TC-002}}` | `{{pending}}` | `{{PASS / REVISE / ASK}}` |

---

## Trajectory

<!-- Append-only chronological execution trace of the story across the SpecFlow lifecycle.
     Initialized by SPEC_makePlan (Row 1) and appended by SPEC_updateMadePlan after every
     review gate (SPEC_reviewUserStory, SPEC_reviewArchDesign, SPEC_reviewDetailDesign,
     SPEC_reviewImplTests, SPEC_reviewProductCodes), rework cycle (Attempt k of max_rework_attempts),
     phase transition, VibeCoding excursion (SPEC_whatsWrong), suspend/resume, or commit checkpoint.
     Never delete or overwrite prior rows; preserve history so Loop Guard budgets and gate evidence stay auditable. -->

| # | Date | Command / Gate | Verdict / Evidence / Commit | Plan Delta -> Next Command |
| --- | --- | --- | --- | --- |
| 1 | {{YYYY-MM-DD}} | `SPEC_openUserStory` + `SPEC_makePlan` | Story opened on `{{branch_name}}`; initial orientation `{{orientation}}` | Initialized task checklist and commit plan -> `{{next_command}}` |
| 2 | {{YYYY-MM-DD}} | `{{SPEC_reviewUserStory / SPEC_reviewArchDesign / SPEC_reviewDetailDesign / SPEC_reviewImplTests / SPEC_reviewProductCodes}}` + `SPEC_updateMadePlan` | `review_verdict = {{PASS / REVISE (finding IDs, attempt k/3)}}`; evidence: `{{artifact or test output}}`; commit: `{{commit_ref or none}}` | Checked `[x]` `{{completed step}}`; {{expanded slices / added rework task}} -> `{{next_command}}` |

---

## Task Checklist

<!-- Use [x] only when backed by a Trajectory row citing a PASS verdict, commit_ref, or explicit Skipped rationale.
     Use [ ] for pending work. When SPEC_updateMadePlan transitions into design-oriented or implementation-oriented
     phases, expand coarse placeholders into concrete README* SPEC surfaces or ordered US/AC/TC slices (P0 first, [P] for parallel). -->

### Phase 1: Intake, Opening, and Intent

- [x] **SPEC_openUserStory** — Moved story to `.catdd/spec/doingUS/` on branch `{{branch_name}}`.
- [ ] **SPEC_clearStoryIntent** — {{Record CLEARED Mutual Intent Contract, or mark `[x] Skipped (intent already aligned)`}}.
- [x] **SPEC_makePlan** — Created initial `*-UserStory-Tasks.md`, classified orientation, and locked commit plan.

### Phase 2: Requirements & Design Gates

- [ ] **SPEC_updateUserStory** — {{Synchronize `README_UserStories.md` and `README_UserGuide.md`, or mark `[x] Skipped (no requirement surface change)`}}.
- [ ] **SPEC_reviewUserStory** — {{Gate requirement clarity, measurability, and ledger consistency (`PASS` / `REVISE`)}}.
- [ ] **SPEC_updateMadePlan** — {{Sync requirement gate `[x]` and expand architecture/detail design tasks}}.
- [ ] **SPEC_takeArchDesign** / **SPEC_updateArchDesign** — {{Update `README_ArchDesign.md` and `README_ArchVerifyDesign.md`, or mark `[x] Skipped (no arch boundary change)`}}.
- [ ] **SPEC_reviewArchDesign** — {{Gate architecture boundaries and quality scenarios (`PASS` / `REVISE`)}}.
- [ ] **SPEC_takeDetailDesign** / **SPEC_updateDetailDesign** — {{Update `README_DetailDesign.md`, `README_DetailVerifyDesign.md`, and domain SPEC docs}}.
- [ ] **SPEC_reviewDetailDesign** — {{Gate API/state completeness, `discovery_ledger`, and AC testability (`PASS` / `REVISE`)}}.
- [ ] **SPEC_updateMadePlan** — {{Transition orientation to `implementation-oriented` and expand Part 2.b into US/AC/TC slices}}.

### Phase 3: Test-First Implementation & Review Slices (Part 2.b)

- [ ] **SPEC_designTests** — Design P0 Functional (`Typical`, `Edge`, `Misuse`, `Fault`) skeletons first, plus gated P1/P2 skeletons (`TEST_review*Skeleton = PASS`).
- [ ] **SPEC_updateMadePlan** — Expand concrete TC implementation slices (`TC-001..TC-n`, `[P]` parallel markers) and step-commit checkpoints.
- [ ] **SPEC_implTests** — Implement selected TC slices (`{{TC IDs}}`) and verify semantic `🔴 RED`.
- [ ] **SPEC_reviewImplTests** (pre-code) — Gate implemented RED tests and companion test READMEs (`PASS` / `REVISE` -> `SPEC_updateMadePlan`).
- [ ] **SPEC_implProductCodes** — Implement minimal product code to turn target TCs `🟢 GREEN`.
- [ ] **SPEC_refactTests** *(optional)* — Clean up GREEN unit tests without changing behavior.
- [ ] **SPEC_reviewProductCodes** — Gate correctness, `README*` SPEC traceability, minimality, and quality risk (`PASS` / `REVISE` -> `SPEC_updateMadePlan`).
- [ ] **SPEC_reviewImplTests** (post-code) — Re-verify implemented tests and companion README status after product-code review (`PASS` / `REVISE` -> `SPEC_updateMadePlan`).

### Phase 4: Commit, Closure, and Merge

- [ ] **SPEC_commitStoryWorks** (`pre_close`) — Commit the verified story span (`commit_ref = {{sha}}`).
- [ ] **SPEC_closeUserStory** — Verify truthful checklist/Trajectory (`no plan_drift`), move story and tasks to `.catdd/spec/doneUS/`, and sync `README_UserStories.md`.
- [ ] **SPEC_commitStoryWorks** (`post_close`) — Commit close-generated lifecycle/meta changes when `close_commit_required = yes`.
- [ ] **SPEC_mergeWorks** — Merge dedicated branch when integration is required, or mark `[x] Auto-skipped`.

---

## Commit Plan

- **Pre-Story Commit (`pre_story_commit`):** `{{yes | no}}` (`{{commit_ref or N/A}}`)
- **Single Story Squash (`single_story_commit`):** `{{yes | no}}`
- **Story-Span Closing Command:** `SPEC_commitStoryWorks` (`pre_close`, then `post_close` if close changes files; `span_end` on partial close, abort, or suspend)

| Step Boundary | Policy (`commit_step`) | Gate Condition | Recorded `commit_ref` / Status |
| --- | --- | --- | --- |
| `SPEC_designTests` | `{{yes / optional / no}}` | `TEST_review*Skeleton = PASS` | `{{pending / skipped / sha}}` |
| `SPEC_implTests` | `{{yes / optional / no}}` | Pre-code `SPEC_reviewImplTests = PASS` (valid RED) | `{{pending / skipped / sha}}` |
| `SPEC_implProductCodes` | `{{yes / optional / no}}` | `SPEC_reviewProductCodes = PASS` + post-code `SPEC_reviewImplTests = PASS` (GREEN) | `{{pending / skipped / sha}}` |
| `SPEC_refactTests` | `{{yes / optional / no}}` | Post-refactor `SPEC_reviewImplTests = PASS` (GREEN) | `{{pending / skipped / sha}}` |

---

## Candidate Next Steps

| Candidate | Decision | Rationale |
| --- | --- | --- |
| `{{SPEC_command_A}}` | Selected | {{Prerequisites satisfied; earliest surviving rank}} |
| `{{SPEC_command_B}}` | Rejected | {{Missing prerequisite or downstream of selected step}} |

## Rejected Next Steps

| Candidate | Reason rejected now |
| --- | --- |
| `{{SPEC_command_B}}` | {{Concrete missing gate or artifact evidence}} |

## Selected Next Command

### `/{{selected_SPEC_command}}`

{{1-2 sentences stating why this command is next and what inputs it should read.}}

## Blockers and Open Questions

- {{List any blocking `ONE-MORE-THING` questions, or state `No blocker prevents /{{selected_SPEC_command}}.`}}

---

## Usage Example

```text
# 1. Create initial task artifact after opening a story
/SPEC_makePlan
doing_user_story: .catdd/spec/doingUS/20260904-payment-retry-UserStory.md
tasks_file: .catdd/spec/doingUS/20260904-payment-retry-UserStory-Tasks.md
projectContext_file: .catdd/spec/projectContext.md

# 2. Synchronize [x]/[ ] status, append Trajectory row, and refine slices after any review gate
/SPEC_updateMadePlan
doing_user_story: .catdd/spec/doingUS/20260904-payment-retry-UserStory.md
tasks_file: .catdd/spec/doingUS/20260904-payment-retry-UserStory-Tasks.md
trigger_reason: review_gate_completed
review_evidence: SPEC_reviewImplTests PASS (TC-001, TC-002 valid RED)
```
