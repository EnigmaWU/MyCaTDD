# {{UserStoryTitle}}

> **Story ID:** US-{{n}} | **State:** todo | **Priority:** <!-- filled from Priority section below -->
> **Source:** `.catdd/spec/analyzedNews/{{YYYYMMDD-original}}.md`
> **Correction of:** <!-- present only for SPEC_analyzeAbortedUserStory: abortUS/YYYYMMDD-UserStory.md -->
> **Parent Story:** <!-- present only for sub-UserStory: `.catdd/spec/todoUS/{{parent}}.md` -->
> **CaTDD Class:** {{P0 Functional / P1 Design / P2 Quality / P3 Addons}}
> **Primary Category:** {{Typical / Edge / Misuse / Fault / State / Capability / Concurrency / Performance / Robust / Compatibility / Configuration / DemoExample}}
> **Created:** {{YYYY-MM-DD}}

---

## Story Statement

<!-- How: Extract role, capability, business value. If any missing, stop and ask — do not invent.
     (→ SKILL: write-user-story) -->

**As a** {{role}},
**I want** {{capability}},
**So that** {{business value}}.

---

## Priority

<!-- How: Score Business Value, User Value, Cost, Risk 1-9 each. Score = (BV+UV)/(Cost+Risk).
     Score ≥18 elevates to P0. Rationale required. (→ SKILL: prioritize-requirements) -->

| Dimension | Score (1-9) | Rationale |
|---|---|---|
| Business Value | {{n}} | {{why this matters to the company}} |
| User Value | {{n}} | {{how much this improves UX}} |
| Cost / Effort | {{n}} | {{estimated effort}} |
| Risk / Complexity | {{n}} | {{technical or domain uncertainty}} |

**Priority Score:** ({{BV}} + {{UV}}) / ({{Cost}} + {{Risk}}) = **{{X}}** | **Priority:** {{P0 / P1 / P2 / P3}}

---

## Visual Model

<!-- How: Choose state diagram (status changes over time), flow diagram (action sequences),
     or context diagram (external actors). Render as Mermaid.js. Then trace: dead-end states?
     decisions with only one outcome? unhandled failure paths? List each gap as a question —
     do not invent paths. (→ SKILL: elicit-requirements-models) -->

```mermaid
{{stateDiagram-v2 / flowchart / graph}}
```

### Model Gap Analysis

| # | Gap Found | Question |
|---|---|---|
| 1 | {{unhandled transition, dead-end state, or missing path}} | {{clarifying question for developer}} |

---

## Acceptance Criteria

<!-- How: For a P0 Functional main UserStory, use this section for Typical behavior first:
     the main acceptance criteria and core scenarios that prove the user-visible capability works.
     Keep 3-7 scenarios, one behavior per scenario. Happy path first, then important alternate
     Typical paths. Put P0 Edge/Misuse/Fault in the second-part AC section below.
     If a concern is P1 Design or P2 Quality, do not force it into this AC list: create a
     sub-UserStory from this story when it is needed now, or raise an Initial Acceptance Question
     when the team must decide whether to split it. (→ SKILL: write-user-story + facilitate-example-mapping) -->

### Scenario 1: {{Happy Path Title}}

**Rule:** {{business rule or constraint that governs this scenario}}
**Given** {{precondition}}
**When** {{action or event}}
**Then** {{observable outcome}}

| Concrete Examples | Counter-Examples |
|---|---|
| {{success case 1}} | {{failure case 1}} |

**Open Questions:** {{or "None"}}

### Scenario 2: {{Alternate Typical Path Title}}

**Rule:** {{business rule or constraint}}
**Given** {{precondition}}
**When** {{action or event}}
**Then** {{observable outcome}}

| Concrete Examples | Counter-Examples |
|---|---|
| {{success case}} | {{failure case}} |

**Open Questions:** {{or "None"}}

### Scenario N: ...

---

## Business Rules

<!-- How: Extract policies, calculations, regulations from the feature text. Separate business rules
     from functional requirements. Classify each: Fact, Constraint, Action Enabler, Inference,
     Computation. If a rule implies a functional requirement (e.g., "must be 18" → system needs
     birthdate input), note it — don't silently hardcode. (→ SKILL: extract-business-rules) -->

| ID | Rule | Type | Implied Functional Requirement |
|---|---|---|---|
| BR-{{n}} | {{rule definition}} | {{Fact/Constraint/ActionEnabler/Inference/Computation}} | {{what the system must do}} |

---

## P0 Functional Second-Part Acceptance Criteria

<!-- How: For P0 Functional stories, keep Typical in the main Acceptance Criteria section above.
     Use this second part for P0 Functional coverage that sharpens the same story without changing
     its primary intent:
     - Edge = unusual but valid inputs, options, limits, or lifecycle states.
     - Misuse = invalid caller behavior or API contract violation.
     - Fault = dependency, resource, or runtime failure while the caller behavior is valid.
     Do not put P1 Design (State/Capability/Concurrency) or P2 Quality
     (Performance/Robust/Compatibility/Configuration) here. Split those into sub-UserStories or
     record them as open questions. (→ SKILL: write-user-story + elicit-requirements-models) -->

### Edge (ValidFunc)

| # | Condition | Expected Behavior | AC Seed | TC Seed | Status |
|---|---|---|---|---|---|
| E{{n}} | {{valid boundary, option, limit, or lifecycle variation}} | {{how the system should respond}} | {{Scenario / AS reference}} | {{verifyOperation_byCondition_expectOutcome}} | {{draft / needs clarification}} |

### Misuse (InvalidFunc)

| # | Condition | Expected Behavior | AC Seed | TC Seed | Status |
|---|---|---|---|---|---|
| M{{n}} | {{caller violates API contract or uses invalid input/state}} | {{how the system should reject or protect}} | {{Scenario / AS reference}} | {{verifyOperation_byMisuse_expectRejection}} | {{draft / needs clarification}} |

### Fault (InvalidFunc)

| # | Condition | Expected Behavior | AC Seed | TC Seed | Status |
|---|---|---|---|---|---|
| F{{n}} | {{dependency, resource, or runtime failure under valid caller behavior}} | {{cleanup, diagnostic, or deterministic failure behavior}} | {{Scenario / AS reference}} | {{verifyOperation_byFault_expectGracefulFailure}} | {{draft / needs clarification}} |

---

## Sub-UserStory Candidates

<!-- How: Preserve important non-P0 concerns without polluting the main story. If a P1/P2 concern
     is required for the current release or changes the main acceptance decision, create a
     sub-UserStory with Parent Story pointing here. If the need is uncertain, add it as an Initial
     Acceptance Question and keep the candidate row as trace evidence. -->

| Candidate | CaTDD Class / Category | Why It Is Not In Main AC | Recommendation | Status |
|---|---|---|---|---|
| {{sub-story candidate}} | {{P1 Design: State/Capability/Concurrency or P2 Quality: Performance/Robust/Compatibility/Configuration}} | {{reason this is not P0 Typical/Edge/Misuse/Fault}} | {{create sub-UserStory / ask acceptance question / defer}} | {{open / deferred / created}} |

---

## Scope

**In scope:**

- {{scope item 1}}
- {{scope item 2}}

**Non-goals:**

- {{explicitly excluded item 1}}
- {{explicitly excluded item 2}}

---

## Risks & Assumptions

| # | Risk / Assumption | Severity | Mitigation / Clarification Needed |
|---|---|---|---|
| 1 | {{risk description}} | {{High / Medium / Low}} | {{question or mitigation action}} |

---

## Initial Acceptance Questions

<!-- Gate: story is NOT ready for SPEC_openUserStory if any question is open.
     P1/P2 split questions may be open only if they do not block the P0 story; otherwise decide or
     create the sub-UserStory before opening this story.
     (→ SPEC_analyzeFeature Conflict Guard) -->

| # | Question | Raised By | Status |
|---|---|---|---|
| 1 | {{question}} | {{model gap / ambiguity hunt / business rule}} | {{open / answered}} |

**Gate:** This story is READY for `SPEC_openUserStory` only when all blocking acceptance questions are answered. Non-blocking P1/P2 follow-up questions may remain only if they are explicitly traced in Sub-UserStory Candidates.

---

## Ambiguity Warnings

<!-- How: Scan the entire story for vague terms — "fast", "robust", "seamless", "always", "never".
     For each, ask: "Is 'fast' 500ms or 5s?" Do not silently substitute precise thresholds.
     (→ SKILL: validate-requirements-criteria) -->

| # | Ambiguous Term | Found In Section | Clarifying Question |
|---|---|---|---|
| 1 | `"{{vague term}}"` | {{section name}} | `"{{precise question}}"` |

---

## Traceability

| From → To | Link |
|---|---|
| This story → Raw input | `.catdd/spec/analyzedNews/{{file}}` |
| Project story index | `README_UserStories.md` |
| Parent story | `.catdd/spec/todoUS/{{parent-story-file}}` |
| Sub-UserStory candidates | `.catdd/spec/todoUS/{{sub-story-file-or-candidate}}` |
| This story ID | US-{{n}} |

---

## Abort Evidence

<!-- How: Present only when this is a corrected re-analysis of an aborted story.
     For SPEC_analyzeAbortedUserStory: read the abortUS story, TASKs.md, and any design/test evidence.
     Classify abort reason. Explicitly state what was kept (valid) and what was rejected (invalid).
     Do not replace the original abortUS/ files — they remain historical evidence.
     (→ SPEC_analyzeAbortedUserStory diagnostic) -->

| Field | Value |
|---|---|
| **Original Story** | US-{{n}} in `abortUS/{{YYYYMMDD-UserStory.md}}` |
| **Abort Date** | {{YYYY-MM-DD}} |
| **Abort Reason** | {{why the story was aborted}} |
| **Phase at Abort** | {{Phase 1 / 2 / 3}} |
| **Evidence Preserved** | {{TASKs.md, design docs, test files, etc.}} |
| **What Was Kept** | {{valid parts of original story preserved unchanged}} |
| **What Was Rejected** | {{invalid assumptions explicitly discarded}} |
| **Summary of Changes** | {{what this corrected version changes and why}} |
