# User Story: Complete remaining US-INVENTOR-01 delegation behavior

> **Story ID:** US-INVENTOR-01-FOLLOWUP-01 | **State:** todo | **Priority:** P0
> **Requirement Owner:** `codeAgents/utCodeAgentCLI/USs/README_UserStory4INVENTOR-01.md`
> **Source Repair:** `.catdd/spec/doingUS/20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md`
> **Related Partial Closure:** `.catdd/spec/doneUS/20260607-utCodeAgentCLI-US-INVENTOR-01-UserStory.md`
> **Created:** 2026-08-30

## Story Statement

**As an** INVENTOR,
**I want** the unfinished US-INVENTOR-01 delegation criteria completed through their normal CaTDD lifecycle,
**So that** the remaining method-prompt and slash-command delegation behavior is implemented without treating the accepted AC-01 slice as full-story completion.

## Ownership Boundary

- This continuation is the lifecycle owner for existing US-INVENTOR-01 AC-02 through AC-16.
- Canonical acceptance wording, category, and status remain in `codeAgents/utCodeAgentCLI/USs/README_UserStory4INVENTOR-01.md`; this artifact does not duplicate or renumber those ACs.
- Existing TC-DELEGATE-002 through TC-DELEGATE-016 remain their verification seeds.
- AC-01 and TC-DELEGATE-001 remain outside this continuation as accepted partial-closure evidence.
- The separate US-UTCLI-REPAIR-01 story owns the canonical asset-session contract correction and does not own AC-02 through AC-16.

## Existing Acceptance Scope

| Category | Existing AC IDs | Existing TC IDs | Current Status |
| --- | --- | --- | --- |
| Typical | AC-02 through AC-04 | TC-DELEGATE-002 through TC-DELEGATE-004 | TODO / PLANNED |
| Edge | AC-07 through AC-08 | TC-DELEGATE-007 through TC-DELEGATE-008 | TODO / PLANNED |
| Misuse | AC-11 through AC-12 | TC-DELEGATE-011 through TC-DELEGATE-012 | TODO / PLANNED |
| Fault | AC-05, AC-06, AC-09, AC-10, AC-13 through AC-16 | TC-DELEGATE-005, TC-DELEGATE-006, TC-DELEGATE-009, TC-DELEGATE-010, TC-DELEGATE-013 through TC-DELEGATE-016 | TODO / PLANNED |

## Independent Test Intent

A reviewer can trace every unfinished canonical AC to exactly one existing PLANNED TC and verify that none is represented as completed by the AC-01 partial closure.

## Scope

**In scope:**

- Existing US-INVENTOR-01 AC-02 through AC-16.
- Existing TC-DELEGATE-002 through TC-DELEGATE-016.
- Normal requirement, design, test, product, review, commit, and close gates for that unfinished scope.

**Non-goals:**

- Reopen or reimplement accepted AC-01.
- Change existing AC/TC identity, wording, or category during this ownership assignment.
- Absorb US-UTCLI-REPAIR-01 canonical asset-session repair.
- Modify historical partial-closure evidence.

## Readiness

- Status: TODO.
- Ownership is explicit; implementation readiness must be assessed after opening and planning.
- Next recommended command: `/SPEC_openUserStory` after the active US-SPECFLOW-REPAIR-01 story leaves `doingUS/`.
