# TASKs: utCodeAgentCLI USER US-USER-01 Parse and validate CLI arguments

Created by `/SPEC_makePlan` on 2026-06-28.
Paired with `.catdd/spec/doingUS/20260628-utCodeAgentCLI-US-USER-01-UserStory.md`.

## Active Story

- **ID:** US-USER-01
- **Title:** Parse and validate CLI arguments
- **Priority:** P0
- **Lifecycle Phase:** Open → Intent Cleared → Planning

## Requirement Source Trace

- Module: `codeAgents/utCodeAgentCLI/`
- Source spec: `README_UserStory4USER.md` — US-USER-01 (32 ACs, 4 categories)
- Paired UserGuide: `README_UserGuide.md`
- Formal argument contract: `README_UsageDesign.md`
- Master index: `README_UserStory.md`

## Mutual Intent Contract

- Status: **CLEARED** (by SPEC_clearStoryIntent on 2026-06-28)
- Developer intent: 32-AC structure across Typical(10), Edge(10), Misuse(9), Fault(3)
- CodeAgent intent: Respect spec boundaries, no new ACs, use UserGuide + UsageDesign

## Current Readiness

| Prerequisite | Status |
|---|---|
| User story spec updated (README_UserStory4USER.md) | ✅ Committed |
| UserGuide updated (README_UserGuide.md) | ✅ Already exists as usage source |
| UsageDesign contract (README_UsageDesign.md) | ✅ Already exists as formal contract |
| Mutual Intent Contract cleared | ✅ CLEARED |
| Architecture Design | ✅ Exists and reviewed (PASS) |
| Detail Design | ✅ Exists and reviewed (PASS) |

## Work Orientation

**Implementation-oriented.** No requirement updates or new design work needed. The spec is complete, intent is cleared, and existing architecture/detail design are sufficient. The story requires test skeleton design and RED test implementation.

## Task Checklist

- [x] **SPEC_importUserStory** — Import US-USER-01 as todoUS artifact
- [x] **SPEC_openUserStory** — Move to doingUS/
- [x] **SPEC_clearStoryIntent** — Establish Mutual Intent Contract (CLEARED)
- [x] **SPEC_designUnitTests** — Typical skeletons redesigned (10 ACs, TC-ARG-001..TC-ARG-010)
- [x] **SPEC_designUnitTests** — Edge skeletons redesigned (from non-required to 10 ACs, TC-ARG-011..TC-ARG-020)
- [x] **SPEC_designUnitTests** — Misuse skeletons redesigned (9 ACs: AC-21~AC-28, AC-32; TC-ARG-021..TC-ARG-026 GREEN, TC-ARG-027..TC-ARG-031 PLANNED)
- [x] **SPEC_designUnitTests** — Fault skeletons redesigned (3 ACs: AC-29~AC-31; TC-ARG-029..TC-ARG-033 GREEN, TC-ARG-034..TC-ARG-035 PLANNED)
- [x] **SPEC_designUnitTests** — Final review of all 4 category files (traceability verified, SUT declared, provenance recorded)
- [x] **SPEC_implUnitTests** u2014 All 4 categories implemented: Typical 6G+4R, Edge 3G+7R, Misuse 7G+4R, Fault 5G+2R = 21 GREEN + 17 RED
- [ ] **SPEC_reviewProductCodes** — Review test quality and spec alignment
- [ ] **SPEC_commitWorks** — Commit completed work
- [ ] **SPEC_closeUserStory** — Close the story

## Selected Next Command

### `/SPEC_implUnitTests`

**Rationale:** All 4 P0 Functional category skeletons are now redesigned and reviewed:
- Typical (10 ACs): TC-ARG-001..TC-ARG-010 — ready for RED implementation
- Edge (10 ACs): TC-ARG-011..TC-ARG-020 — ready for RED implementation
- Misuse (9 ACs): TC-ARG-021..TC-ARG-026 (GREEN), TC-ARG-027..TC-ARG-031 (PLANNED, need RED implementation)
- Fault (3 ACs): TC-ARG-029..TC-ARG-033 (GREEN), TC-ARG-034..TC-ARG-035 (PLANNED, need RED implementation)

The PLANNED skeletons (TC-ARG-027~TC-ARG-031 for Misuse, TC-ARG-034~TC-ARG-035 for Fault) need RED test implementation. Existing GREEN tests must remain passing. Source-command provenance is recorded via UT_designFuncTestsSkeleton route.

## Rejected Alternatives

| Candidate | Reason Rejected |
|---|---|
| `SPEC_updateUserStory` | No requirement surface changes needed — spec already committed |
| `SPEC_takeArchDesign` | Architecture already exists and is reviewed |
| `SPEC_takeDetailDesign` | Detail design already exists and is reviewed |
| `SPEC_clearStoryIntent` | Already executed — intent CLEARED |

## Blockers

~ None. All prerequisites satisfied. ~