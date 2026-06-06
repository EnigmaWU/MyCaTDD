# User Story: Harden utCodeAgentCLI Agentic Reliability Contracts

Created by `/SPEC_analyzeIssue` on 2026-06-06.
Opened by `/SPEC_openUserStory` on 2026-06-06.

## Source Trace

- Analyzed raw issue: [../analyzedNews/20260606-treat-updates-as-issue-first-Issue.md](../analyzedNews/20260606-treat-updates-as-issue-first-Issue.md)
- Source text: `first treat these updates as issue first`
- Discovery source skill: `design-agents-using-patterns`
- Reviewed target: `codeAgents/utCodeAgentCLI/README_ArchDesign.md`
- Area: `codeAgents/utCodeAgentCLI/`

## Active Work Status

- Status: OPEN.
- Active state: `.catdd/spec/doingUS/`.
- Opened from: [../todoUS/20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md](../todoUS/20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md)
- Priority: P1 - important (architecture contract hardening before implementation detail expansion).
- Confidence: medium-high.
- Next recommended command: `/SPEC_makePlan`.

## Observed Behavior

The architecture review driven by `design-agents-using-patterns` identified reliability and safety contract gaps in `utCodeAgentCLI` design that remain implicit:

- No explicit retry/iteration budget for loop/retry behavior.
- No fallback route for unknown `--behave` input.
- No explicit transient-vs-permanent failure routing policy.
- No snapshot/rollback policy for multi-step execution failures.
- No explicit escalation threshold after retry budget exhaustion.
- No explicit shell safety and credential-sensitive file protection policy for v1 runtime behavior.

## Expected Behavior

`utCodeAgentCLI` architecture and related design surfaces should explicitly define agentic reliability contracts aligned with pattern-based guardrails:

- bounded retries/iterations,
- deterministic fallback behavior,
- failure taxonomy with routing,
- rollback/compensation boundaries,
- escalation policy,
- shell safety and sensitive-file protection policy.

These expectations should be traceable to architecture decisions and guide detail design without silently expanding implementation scope.

## User Story

As a MyCaTDD architect/developer,
I want `utCodeAgentCLI` architecture to define explicit agentic reliability and safety contracts,
So that downstream detail design and implementation remain safe, bounded, diagnosable, and reviewable.

## Independent Test Intent

A reviewer can inspect updated architecture/design artifacts and verify that all six reliability/safety contract areas are explicitly specified with boundaries and routing behavior, and that each item traces back to this analyzed issue.

## Acceptance Scenarios

### AC-1: Retry/iteration limits are explicit

- **Given** looped retries or correction cycles can occur,
- **When** architecture contracts are reviewed,
- **Then** max retry/iteration limits are explicitly defined,
- **And** behavior at limit exhaustion is deterministic.

### AC-2: Router fallback behavior is explicit

- **Given** `--behave` may be unknown or ambiguous,
- **When** routing contracts are reviewed,
- **Then** a fallback path is explicitly defined,
- **And** it does not fail silently.

### AC-3: Failure taxonomy and routing are explicit

- **Given** failures can be transient or permanent,
- **When** execution-failure handling is reviewed,
- **Then** transient and permanent classes are distinguished,
- **And** each class has a documented routing policy.

### AC-4: State snapshot/rollback boundary is explicit

- **Given** multi-step execution can fail mid-flow,
- **When** state/control contracts are reviewed,
- **Then** snapshot/rollback (or equivalent compensation) boundary is documented,
- **And** partial failure handling is traceable.

### AC-5: Escalation threshold is explicit

- **Given** retries can exhaust budget,
- **When** control policy is reviewed,
- **Then** escalation conditions and target action are explicit,
- **And** non-interactive behavior is defined.

### AC-6: Shell safety and sensitive-file policy are explicit

- **Given** runtime adapters may execute commands and access files,
- **When** safety policy is reviewed,
- **Then** approval/sandbox requirements and sensitive-file protection are explicit,
- **And** credential exposure paths are constrained.

## Edge Cases

- Non-interactive CI mode where human approval is unavailable.
- Mixed adapter behavior where one runtime supports stronger controls than another.
- Repeated transient errors that should stop before runaway loops.

## Scope

In scope:

- Architecture/design contract updates for reliability and safety.
- Traceability from issue findings to architecture changes.
- Routing and control policy clarification.

Out of scope:

- Full runtime implementation of all controls.
- Production policy engine rollout.
- New adapter implementation code beyond design-level updates.

## Risks

- Over-constraining contracts may reduce adapter flexibility.
- Under-specifying contracts may allow unsafe defaults.
- Divergence between architecture and detail design if trace links are weak.

## Assumptions

- Existing architecture docs remain the primary source for these contracts.
- Reliability contracts can be expressed before implementation details are finalized.
- Pattern-based guardrails from `design-agents-using-patterns` are accepted review criteria.

## Acceptance Questions

- Should all six contract areas live in architecture docs, or split across architecture and detail design?
- What default retry budget is acceptable for v1?
- Is sandboxing mandatory for all command execution paths or policy-configurable?

## Next Recommended Action

Run `/SPEC_makePlan` to create the paired `.catdd/spec/doingUS/*-TASKs.md` artifact and decide the next lifecycle step.
