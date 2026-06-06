# TASKs: Harden utCodeAgentCLI Agentic Reliability Contracts

Created by `/SPEC_makePlan` on 2026-06-06.
Updated by `/SPEC_makePlan` on 2026-06-07.

## Active Story

- Story: [20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md](20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md)
- Source issue: [../analyzedNews/20260606-treat-updates-as-issue-first-Issue.md](../analyzedNews/20260606-treat-updates-as-issue-first-Issue.md)
- Area: `codeAgents/utCodeAgentCLI/`

## Task Checklist

- [x] Confirm the story intent is clear enough to proceed without `SPEC_clearStoryIntent`.
- [x] Confirm the current architecture already covers adjacent runtime, control, and trace concepts but still lacks the six explicit reliability contracts.
- [x] Revise `codeAgents/utCodeAgentCLI/README_ArchDesign.md` with explicit contracts for retry limits, router fallback, failure taxonomy, rollback boundary, escalation policy, and shell safety.
- [x] Review the updated architecture against the skill-derived agentic-pattern guardrails.
- [x] Update detail design only if architecture review reveals required downstream contract changes.
- [x] Run story readiness review after architecture and any required detail updates pass review.
- [ ] If story readiness passes after design updates, close as design-oriented-only work (`SPEC_commitWorks` -> `SPEC_closeUserStory`) unless new implementation scope is explicitly added.

## Readiness Snapshot

| Prerequisite | Status | Rationale |
| --- | --- | --- |
| Intent clearing | Satisfied enough to plan | The story is specific, source-traceable, and already anchored to concrete findings from `design-agents-using-patterns`. |
| Architecture evidence | Present but incomplete | `README_ArchDesign.md` already defines adapters, control, and trace concepts, but it does not explicitly define retry limits, fallback, failure classes, rollback, escalation thresholds, or shell safety policy. |
| Detail design | Not next | These gaps are architecture-level contracts first; detail design should only update after the architecture contract is clarified and reviewed. |
| Story readiness review | Not next | Review should happen after architecture updates and any required detail follow-up exist. |
| Unit-test design | Not next | This is a design-contract hardening story, not a test-skeleton design step yet. |

## Candidate Next Steps

| Candidate command | Fit | Decision |
| --- | --- | --- |
| `SPEC_clearStoryIntent` | Useful only if the story scope or discovered findings are ambiguous. | Skip for now; the intent is explicit enough. |
| `SPEC_takeArchDesign` | Applies to initial architecture drafting when no story-specific architecture evidence exists yet. | Defer; this story revises an existing architecture document. |
| `SPEC_updateArchDesign` | Best match because the missing items are follow-up architecture contract gaps discovered against existing `README_ArchDesign.md`. | Select. |
| `SPEC_takeDetailDesign` | Too early because detail design should follow an approved architecture contract. | Defer. |
| `SPEC_reviewUserStory` | Premature because the required architecture updates do not exist yet. | Defer. |
| `SPEC_designUnitTests` | Out of sequence for a documentation and architecture contract story. | Defer. |

## Selected Next Step

- Next command: `/SPEC_updateArchDesign`.
- Primary target: revise `codeAgents/utCodeAgentCLI/README_ArchDesign.md` to make the six reliability and safety contracts explicit.
- Expected follow-up after revision: `/SPEC_reviewArchDesign`.
- Story orientation after design: design-oriented only by default; move to implementation-oriented flow only if the story scope is explicitly expanded.
- Expected documentation impact: architecture updates should stay traceable to [20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md](20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md) and may trigger targeted `README_DetailDesign.md` updates only if architecture review requires them.

## Rationale

The discovered gaps are not implementation details; they define architecture-level safety and control boundaries for loop behavior, routing, failure handling, and runtime execution policy. `README_ArchDesign.md` already owns adapter boundaries, control concepts, and trace policy, so this story is a follow-up architecture revision rather than an initial architecture draft. The smallest correct next step is to update architecture through `SPEC_updateArchDesign` and review it before touching detail design.

## Open Questions

- Should the shell-safety requirement be expressed as a hard sandbox requirement for v1, or as an approval-gated policy with sandboxing as a stronger deployment mode?
- Should rollback be documented as strict state snapshot/restore, or as narrower compensation boundaries for multi-step command execution?
