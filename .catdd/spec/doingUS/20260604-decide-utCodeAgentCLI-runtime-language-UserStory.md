# User Story: Decide utCodeAgentCLI Runtime Language and ADR

Created by `/SPEC_analyzeIssue` on 2026-06-04.
Opened by `/SPEC_openUserStory` on 2026-06-04.

## Source Trace

- Analyzed raw issue: [../analyzedNews/20260604-decide-utCodeAgentCLI-runtime-language-Issue.md](../analyzedNews/20260604-decide-utCodeAgentCLI-runtime-language-Issue.md)
- Source text: `utCodeAgentCLI use TypeScript or Python or Go, it SHOULD be an architectural decision, and with a fine ADR`
- Area: `codeAgents/utCodeAgentCLI/`

## Active Work Status

- Status: OPEN.
- Active state: `.catdd/spec/doingUS/` active story.
- Opened from: [../todoUS/20260604-decide-utCodeAgentCLI-runtime-language-UserStory.md](../todoUS/20260604-decide-utCodeAgentCLI-runtime-language-UserStory.md)
- Planning artifact: [20260604-decide-utCodeAgentCLI-runtime-language-PLANING.md](20260604-decide-utCodeAgentCLI-runtime-language-PLANING.md).
- Next recommended command: `/SPEC_takeArchDesign`.

## Analysis Status

- Status: TODO.
- Priority: P1 — important (blocks implementation stack selection and ADR capture).
- Confidence: medium-high.

## Observed Behavior

`utCodeAgentCLI` architecture and detail design documents currently lean on TypeScript as the implementation target, but the language choice has not been captured as a dedicated architectural decision artifact with explicit tradeoffs and rationale.

This leaves a lifecycle gap: implementation planning can drift without a reviewed decision record, especially when Python and Go remain candidate options.

## Expected Behavior

The project should produce an explicit architecture decision for `utCodeAgentCLI` runtime language (TypeScript, Python, or Go), with a traceable ADR that records decision drivers, alternatives, tradeoffs, assumptions, risks, and consequences.

The decision should be specific enough to guide implementation and adapter strategy without prematurely coding the CLI runtime.

## User Story

As a MyCaTDD architect/developer,
I want to decide whether `utCodeAgentCLI` should use TypeScript, Python, or Go and record that choice in a formal ADR,
So that runtime implementation and adapter planning can proceed from a clear, reviewable architecture decision instead of implicit assumptions.

## Independent Test Intent

A reviewer can inspect the resulting architecture decision artifact and verify that it evaluates TypeScript, Python, and Go against explicit criteria, states a selected option with rationale, records non-goals and risks, and links back to this analyzed source issue.

## Acceptance Scenarios

### AC-1: Evaluate language alternatives with explicit criteria

- **Given** TypeScript, Python, and Go are candidate implementation languages for `utCodeAgentCLI`,
- **When** the architecture decision is drafted,
- **Then** it compares candidates using explicit criteria (ecosystem fit, maintainability, runtime integration, tooling, and team workflow alignment),
- **And** it avoids unsupported assumptions.

### AC-2: Select and justify one primary runtime language

- **Given** the alternatives are evaluated,
- **When** a decision is made,
- **Then** exactly one primary runtime language is selected,
- **And** the rationale includes tradeoffs and consequences for adapter strategy.

### AC-3: Capture a formal ADR with traceability

- **Given** the language decision is architecture-significant,
- **When** documentation is updated,
- **Then** a formal ADR-style record is produced,
- **And** it links to this source issue and affected architecture/detail design docs.

### AC-4: Clarify implementation boundaries and non-goals

- **Given** this step is analysis and design, not coding,
- **When** the story output is reviewed,
- **Then** it states what is in scope (decision and ADR) and out of scope (runtime implementation code),
- **And** it preserves future adapter extensibility expectations.

## Edge Cases

- Criteria may favor one language for v1 while still requiring future adapters in other ecosystems.
- Team workflow or toolchain constraints may conflict with pure technical preference.
- A decision may need to distinguish core runtime language from plugin/adapter language expectations.

## Scope

In scope:

- Analyze the runtime-language decision for `utCodeAgentCLI`.
- Produce a decision-oriented architecture update and ADR-style record.
- State assumptions, tradeoffs, risks, and consequences.

Out of scope:

- Implementing `utCodeAgentCLI` runtime in any language.
- Building adapters or changing execution code.
- Rewriting existing CaTDD method semantics.

## Risks

- Choosing a language without explicit criteria can cause future rework.
- Over-optimizing for one integration target can hurt portability.
- Delaying the decision too long can block implementation planning.

## Assumptions

- Existing `utCodeAgentCLI` design docs are the primary architecture context.
- The decision should produce a single primary language for v1.
- Additional adapter support can remain a later step when contracts stabilize.

## Acceptance Questions

- What criteria weighting should govern the final language choice?
- Must v1 optimize for current repository maintainers, downstream adapter reach, or runtime simplicity first?
- Should ADR content live in module-scoped docs, project-root ADR directory, or both?

## Next Recommended Action

Run `/SPEC_takeArchDesign` to draft the runtime-language architecture decision and ADR for `utCodeAgentCLI`.