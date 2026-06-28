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
- [ ] **SPEC_designUnitTests** — Design P0 Functional skeletons (32 ACs across Typical/Edge/Misuse/Fault)
- [ ] **SPEC_implUnitTests** — Implement RED tests for all categories
- [ ] **SPEC_reviewProductCodes** — Review test quality and spec alignment
- [ ] **SPEC_commitWorks** — Commit completed work
- [ ] **SPEC_closeUserStory** — Close the story

## Selected Next Command

### `/SPEC_designUnitTests`

**Rationale:** The Planning Decision Rules (SPEC_makePlan §42-48) skip rules 1-4 (intent cleared, no requirement changes, no design work needed) and land on rule 5: "Implementation-oriented work with sufficient requirement and design readiness: route to `SPEC_designUnitTests`."

The existing test files (`UT_US-USER-01-*.ts`) use old AC references and cover only the original 5-AC structure. New skeletons or skeleton updates are needed to align with the 32-AC structure.

## Rejected Alternatives

| Candidate | Reason Rejected |
|---|---|
| `SPEC_updateUserStory` | No requirement surface changes needed — spec already committed |
| `SPEC_takeArchDesign` | Architecture already exists and is reviewed |
| `SPEC_takeDetailDesign` | Detail design already exists and is reviewed |
| `SPEC_clearStoryIntent` | Already executed — intent CLEARED |

## Blockers

~ None. All prerequisites satisfied. ~