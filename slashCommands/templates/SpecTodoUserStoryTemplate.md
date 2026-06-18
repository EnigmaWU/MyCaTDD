# {{UserStoryTitle}}

> **Story ID:** US-{{n}} | **State:** todo | **Priority:** <!-- filled from Priority section below -->
> **Source:** `.catdd/spec/analyzedNews/{{YYYYMMDD-original}}.md`
> **Correction of:** <!-- present only for SPEC_analyzeAbortedUserStory: abortUS/YYYYMMDD-UserStory.md -->
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

<!-- How: 3-7 scenarios. Happy path first, then alternate, then error. One behavior per scenario.
     For each scenario: state the governing Rule, give concrete Examples, list open Questions.
     Keep it fast — don't debate Gherkin syntax during discovery. If too many Rules, consider
     splitting the story. (→ SKILL: write-user-story + facilitate-example-mapping) -->

### Scenario 1: {{Happy Path Title}}

**Rule:** {{business rule or constraint that governs this scenario}}
**Given** {{precondition}}
**When** {{action or event}}
**Then** {{observable outcome}}

| Concrete Examples | Counter-Examples |
|---|---|
| {{success case 1}} | {{failure case 1}} |

**Open Questions:** {{or "None"}}

### Scenario 2: {{Alternate / Error Path Title}}

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

## Edge Cases & Error Paths

<!-- How: From scenario discovery + model gap analysis. What if input is empty? What if network fails?
     What if user is logged out? What if timeout occurs? One row per edge case.
     (→ SKILL: write-user-story + elicit-requirements-models) -->

| # | Condition | Expected Behavior | Status |
|---|---|---|---|
| 1 | {{edge condition}} | {{how the system should respond}} | {{draft / needs clarification}} |

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
     (→ SPEC_analyzeFeature Conflict Guard) -->

| # | Question | Raised By | Status |
|---|---|---|---|
| 1 | {{question}} | {{model gap / ambiguity hunt / business rule}} | {{open / answered}} |

**Gate:** If any question is open, this story is NOT ready for `SPEC_openUserStory`.

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
