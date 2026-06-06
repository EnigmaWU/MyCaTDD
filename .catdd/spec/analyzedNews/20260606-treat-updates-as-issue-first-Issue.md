# Issue: treat updates as issue first

Imported via SPEC_importIssue on 2026-06-06.

## Source

first treat these updates as issue first

Session context used for import:

- Recent updates in `Px-SpecFlow` command set and lifecycle governance were being discussed.
- The developer explicitly requested an issue-first intake policy for such updates.

Discovery source for concrete updates:

- Skill used: `design-agents-using-patterns`.
- Skill file: `.github/skills/design-agents-using-patterns/SKILL.md`.
- Reviewed target: `codeAgents/utCodeAgentCLI/README_ArchDesign.md`.
- Pattern checklist reference: `.github/skills/design-agents-using-patterns/details/pattern-checklists.md`.

## Classification

- Type: workflow/process request.
- Area: `Px-SpecFlow` command usage and intake sequence.
- Severity: P2 — flow discipline and traceability.

## Observed Behavior

Update requests can be interpreted directly as design/refactor work without first being captured as an issue artifact.

From the `design-agents-using-patterns` review of `utCodeAgentCLI` architecture, several concrete updates were discovered but not yet imported as pending issue inputs.

## Expected Behavior

When updates are introduced, the workflow should import them as an issue artifact first, then continue through normal SpecFlow analysis and story steps.

Expected intake path:

1. `SPEC_importIssue` captures raw request into `.catdd/spec/pendingNews/*-Issue.md`.
2. `SPEC_analyzeIssue` converts it into `.catdd/spec/todoUS/*-UserStory.md` and archives raw input to `.catdd/spec/analyzedNews/`.
3. `SPEC_openUserStory` starts active execution only after analysis.

Discovered updates to import (raw issue scope, not analyzed yet):

1. Add hard retry/iteration limits for agent loops and command retries (for example, `maxRetries` and `retryCount` contract fields).
2. Define router fallback behavior for unrecognized `--behave` values.
3. Distinguish transient vs permanent failures in execution policy and route accordingly.
4. Define state snapshot/rollback behavior for multi-step execution failures.
5. Define explicit escalation rules (including non-interactive mode) after retry budget exhaustion.
6. Make shell safety policy explicit for V1 runtime execution (approval gate and/or sandbox requirement), plus credential-sensitive file protection.

## Addressing Status Snapshot

The following snapshot captures what the skill review identified and whether this repository already addresses it in architecture text.

| Item | From skill review | Current status in utCodeAgentCLI architecture |
| --- | --- | --- |
| Loop retry/iteration limits | Required | Not explicitly defined yet (pending). |
| Router fallback for unknown behave input | Required | Not explicitly defined yet (pending). |
| Transient vs permanent failure routing | Required | Not explicitly defined yet (pending). |
| State snapshot/rollback on multi-step failure | Required | Not explicitly defined yet (pending). |
| Escalation rule after retry budget exhaustion | Required | Control concepts exist, but explicit escalation threshold is pending. |
| Shell safety and credential-sensitive file policy | Required | Approval/control and redaction concerns exist, but explicit policy is pending. |

This issue intentionally records raw discovered gaps only. Detailed acceptance criteria and change plan belong to `SPEC_analyzeIssue` and later design/update commands.

## Open Questions

- Should the discovered updates above be kept as one combined issue or split into separate issues (routing, resilience, safety, and state management)?
- Should these updates be treated as architecture changes only, or also as detail-design contracts?

## Next Recommended Command

`/SPEC_analyzeIssue`
