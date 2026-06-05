# Planning: Decide utCodeAgentCLI Runtime Language and ADR

Created by `/SPEC_takePlan` on 2026-06-04.

## Active Story

- Story: [20260604-decide-utCodeAgentCLI-runtime-language-UserStory.md](20260604-decide-utCodeAgentCLI-runtime-language-UserStory.md)
- Source issue: [../analyzedNews/20260604-decide-utCodeAgentCLI-runtime-language-Issue.md](../analyzedNews/20260604-decide-utCodeAgentCLI-runtime-language-Issue.md)
- Area: `codeAgents/utCodeAgentCLI/`

## Current Readiness

- Story is opened in `.catdd/spec/doingUS/`.
- Developer intent is clear enough to plan: decide TypeScript vs Python vs Go for `utCodeAgentCLI` and record a formal ADR.
- Existing architecture and detail design already assume TypeScript/Node.js, and that assumption is now captured as a standalone architecture decision.
- A formal ADR file now exists for this decision.

## Prerequisite Assessment

| Prerequisite | Status | Rationale |
| --- | --- | --- |
| Intent clearing | Satisfied enough to plan | The developer explicitly asked for a language architecture decision with ADR. |
| Architecture evidence | Present but incomplete | `README_ArchDesign.md` and `README_DetailDesign.md` contain TypeScript assumptions and adapter boundaries, but no TypeScript/Python/Go decision record. |
| Detail design | Not next | A language decision constrains detail design; updating details before the ADR would preserve an implicit assumption. |
| Story readiness review | Not next | Review should happen after the architecture decision and ADR are drafted. |
| Unit-test design | Not next | This is a design/ADR story, not a test skeleton story yet. |

## Candidate Next Steps

| Candidate command | Fit | Decision |
| --- | --- | --- |
| `SPEC_clearStoryIntent` | Useful only if developer intent is ambiguous. | Skip for now; intent is explicit enough. |
| `SPEC_takeArchDesign` | Best match for architecture-significant runtime-language choice and ADR creation/update. | Select. |
| `SPEC_reviewArchDesign` | Best match after the architecture draft exists and needs review against the active story. | Select next. |
| `SPEC_takeDetailDesign` | Too low-level before the primary runtime decision is recorded. | Defer. |
| `SPEC_reviewUserStory` | Premature because no decision artifact exists yet. | Defer. |
| `SPEC_designUnitTests` | Out of sequence for an ADR decision. | Defer. |

## Selected Next Step

- Next command: `/SPEC_reviewArchDesign`.
- Primary target: review the updated architecture decision artifact for `utCodeAgentCLI` runtime language.
- Expected review scope: TypeScript vs Python vs Go decision, primary v1 language, adapter consequences, non-goals, risks, and rationale.
- Expected documentation impact: confirm `codeAgents/utCodeAgentCLI/README_ArchDesign.md`, `codeAgents/utCodeAgentCLI/README_ArchDesign_ZH.md`, and `codeAgents/utCodeAgentCLI/ADRs/ADR_RuntimeLanguage.md` are ready for the story review gate.

## Rationale

The language choice affects runtime packaging, adapter boundaries, ecosystem fit, test runner/tooling decisions, and future implementation structure. It belongs at architecture level before detail-design updates or test skeleton design. The existing docs already lean TypeScript, so the next action should either confirm that assumption with ADR evidence or revise it through a documented alternative.

## Open Questions

- Should Python and Go remain non-goal alternatives after the decision, or be preserved as future adapter/runtime options?