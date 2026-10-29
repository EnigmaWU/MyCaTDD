# {{UserStoryTitle}}

> **Story ID:** {{StoryID}} | **State:** todo | **Priority:** <!-- filled from Priority section below -->
> **Source:** `.catdd/spec/analyzedNews/{{YYYYMMDD-original}}.md`
> **Correction of:** <!-- present only for SPEC_analyzeAbortedUserStory: abortUS/YYYYMMDD-UserStory.md -->
> **Parent Story:** <!-- present only for sub-UserStory: parent Story ID and `.catdd/spec/todoUS/{{parent}}.md` -->
> **CaTDD Class:** {{P0 Functional / P1 Design / P2 Quality / P3 Addons}}
> **Primary Category:** {{Typical / Edge / Misuse / Fault / State / Capability / Concurrency / Performance / Robust / Compatibility / Configuration / DemoExample}}
> **Created:** {{YYYY-MM-DD}}

<!-- How: {{StoryID}} is the complete, registered project-wide US ID. Preserve an existing ID;
     use US-<whoName>-<doWhat> with lowerCamelCase segments for new stories and check for
     collisions as specified in .catdd/methodPrompts/CaTDD_methodPrompt-testStructure.md#project-wide-traceability-ids.
     Each AC heading uses that ID and a unique stable child token. -->

---

## Story Statement

<!-- How: Extract role, capability, business value. If any missing, stop and ask — do not invent.
     (→ SKILL: write-user-story) -->

**As a** {{role}},
**I want** {{capability}},
**So that** {{business value}}.

---

## Story Readiness Snapshot

<!-- How: Stage 1 pre-open EPIC story sufficiency check (arXiv:2610.07534).
     Decide whether the story can enter SPEC_openUserStory before generating design or tests.
     A thoughtful story is not just formatted; it proves why now, what outcome matters, which
     examples are concrete, and which unknowns still block acceptance. The full 10-dimension
     artifact-set ledger (## EPIC Specification Sufficiency) is seeded later in *-UserStory-Tasks.md
     by SPEC_makePlan and maintained by SPEC_updateMadePlan. -->

| Lens | EPIC Dimension | Answer | Evidence |
| --- | --- | --- | --- |
| User value & behavioral scope are explicit | `C1 Scope Discipline` | {{yes/no}} | {{role + business value + in-scope/non-goals source}} |
| Observable & measurable outcome exists | `E1 Unambiguous` + `E3 Verifiable` | {{yes/no}} | {{output, state change, threshold, file, response, or behavior}} |
| Concrete examples & exceptional paths exist | `E2 Singular` + `P2 Complete` | {{yes/no}} | {{Example Mapping rows, atomic scenarios, Edge/Misuse/Fault seeds}} |
| Dependencies, assumptions & risks are declared | `P1 Dependency Control` | {{yes/no}} | {{Risks & Assumptions rows, upstream/downstream constraints}} |
| Story-specific completion conditions are stated | `E3.4 Completion & Readiness` | {{yes/no}} | {{Story Completion Conditions: TestLevel, TestScope, CaTDD categories, Not-Done rules}} |
| Template structure & stable IDs are preserved | `I1 Conforming` | {{yes/no}} | {{StoryID, qualified AC IDs, RULE-n, EX-n, E/M/F seeds}} |
| Blocking questions remain | `E1.1 Clarification-Seeking` | {{yes/no}} | {{Initial Acceptance Questions + Ambiguity Warnings references}} |
| Story size is acceptable | `E2 Singular` + `C1 Scope Discipline` | {{yes/no}} | {{Sub-UserStory Candidates / split rationale}} |
| Ready decision | Stage 1 Sufficiency Gate | {{Ready / Blocked / Too Large / Needs Split}} | {{why this decision is correct}} |

---

## Priority

<!-- How: Score Business Value, User Value, Cost, Risk 1-9 each. Score = (BV+UV)/(Cost+Risk).
     Score ≥18 elevates to P0. Rationale required. (→ SKILL: prioritize-requirements) -->

| Dimension | Score (1-9) | Rationale |
| --- | --- | --- |
| Business Value | {{n}} | {{why this matters to the company}} |
| User Value | {{n}} | {{how much this improves UX}} |
| Cost / Effort | {{n}} | {{estimated effort}} |
| Risk / Complexity | {{n}} | {{technical or domain uncertainty}} |

**Priority Score:** ({{BV}} + {{UV}}) / ({{Cost}} + {{Risk}}) = **{{X}}** | **Priority:** {{P0 / P1 / P2 / P3}}

---

## Example Mapping

<!-- How: Use breadth-first discovery before polishing BDD wording.
     Yellow = this story. Blue = rules. Green = concrete examples. Pink = open questions.
     If there are too many rules, split the story. If any pink card blocks the main outcome,
     mark Ready decision as Blocked. (→ SKILL: facilitate-example-mapping) -->

| Card | ID | Content | Trace / Decision |
| --- | --- | --- | --- |
| Yellow Story | {{StoryID}} | {{one-line story title}} | {{source note}} |
| Blue Rule | RULE-{{n}} | {{business rule or acceptance rule}} | {{AC/BR reference}} |
| Green Example | EX-{{n}} | {{specific values, actor, context, and expected result}} | {{Scenario reference}} |
| Green Counter-Example | CEX-{{n}} | {{specific invalid, alternate, or failure example}} | {{Edge/Misuse/Fault reference}} |
| Pink Question | Q-{{n}} | {{unknown that blocks or changes acceptance}} | {{blocking / non-blocking / split}} |

**Example Mapping Decision:** {{Ready / Blocked / Too Many Rules / Needs More Examples}}

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
| --- | --- | --- |
| 1 | {{unhandled transition, dead-end state, or missing path}} | {{clarifying question for developer}} |

---

## Input and Output Dictionary

<!-- How: Extract data elements the story consumes, produces, stores, or validates. Use TBD instead
     of guessing domain limits. Complex structures should decompose into primitives.
     (→ SKILL: build-data-dictionary + apply-oopsi-model) -->

| Element | Kind | Type / Format | Required | Allowed Values / Limits | Producer | Consumer | Validation / Question |
| --- | --- | --- | --- | --- | --- | --- | --- |
| {{InputName}} | input | {{string/path/json/object/etc.}} | {{yes/no}} | {{allowed values, range, pattern, or TBD}} | {{user/system/dependency}} | {{feature/module}} | {{rule or question}} |
| {{OutputName}} | output | {{string/path/json/object/etc.}} | {{yes/no}} | {{allowed values, range, pattern, or TBD}} | {{feature/module}} | {{user/system/dependency}} | {{rule or question}} |

---

## Acceptance Criteria

<!-- How: For a P0 Functional main UserStory, use this section for Typical behavior first:
     the main acceptance criteria and core scenarios that prove the user-visible capability works.
     Keep 3-7 scenarios, one behavior per scenario. Happy path first, then important alternate
     Typical paths. Put P0 Edge/Misuse/Fault in the second-part AC section below.
     If a concern is P1 Design or P2 Quality, do not force it into this AC list: create a
     sub-UserStory from this story when it is needed now, or raise an Initial Acceptance Question
     when the team must decide whether to split it. (→ SKILL: write-user-story + facilitate-example-mapping) -->

### {{StoryID}}-AC-{{n}}: {{Happy Path Title}}

**Example Trace:** EX-{{n}}
**Rule:** {{business rule or constraint that governs this scenario}}
**Given** {{precondition using canonical `README_UbiLang.md` terms}}
**When** {{action or event}}
**Then** {{observable outcome stated with `MUST` / `MUST NOT` (or conditional `SHOULD` / optional `MAY`)}}

| Concrete Examples | Counter-Examples |
| --- | --- |
| {{success case 1}} | {{failure case 1}} |

**Open Questions:** {{or "None"}}

### {{StoryID}}-AC-{{n}}: {{Alternate Typical Path Title}}

**Example Trace:** EX-{{n}}
**Rule:** {{business rule or constraint}}
**Given** {{precondition using canonical `README_UbiLang.md` terms}}
**When** {{action or event}}
**Then** {{observable outcome stated with `MUST` / `MUST NOT` (or conditional `SHOULD` / optional `MAY`)}}

| Concrete Examples | Counter-Examples |
| --- | --- |
| {{success case}} | {{failure case}} |

**Open Questions:** {{or "None"}}

### {{StoryID}}-AC-{{n}}: {{Additional Scenario Title}}

---

## Business Rules

<!-- How: Extract policies, calculations, regulations from the feature text. Separate business rules
     from functional requirements. Classify each: Fact, Constraint, Action Enabler, Inference,
     Computation. If a rule implies a functional requirement (e.g., "must be 18" → system needs
     birthdate input), note it — don't silently hardcode. (→ SKILL: extract-business-rules) -->

| ID | Rule | Type | Implied Functional Requirement |
| --- | --- | --- | --- |
| BR-{{n}} | {{rule definition}} | {{Fact/Constraint/ActionEnabler/Inference/Computation}} | {{what the system must do}} |

**Business Rule Decision:** {{all rules explicit / implied rule needs answer / no business rules found because this is technical or quality-focused}}

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
| --- | --- | --- | --- | --- | --- |
| E{{n}} | {{valid boundary, option, limit, or lifecycle variation}} | {{how the system should respond}} | {{StoryID}}-AC-{{n}} | {{qualified TC ID or pending}} | {{draft / needs clarification}} |

### Misuse (InvalidFunc)

| # | Condition | Expected Behavior | AC Seed | TC Seed | Status |
| --- | --- | --- | --- | --- | --- |
| M{{n}} | {{caller violates API contract or uses invalid input/state}} | {{how the system should reject or protect}} | {{StoryID}}-AC-{{n}} | {{qualified TC ID or pending}} | {{draft / needs clarification}} |

### Fault (InvalidFunc)

| # | Condition | Expected Behavior | AC Seed | TC Seed | Status |
| --- | --- | --- | --- | --- | --- |
| F{{n}} | {{dependency, resource, or runtime failure under valid caller behavior}} | {{cleanup, diagnostic, or deterministic failure behavior}} | {{StoryID}}-AC-{{n}} | {{qualified TC ID or pending}} | {{draft / needs clarification}} |

---

## Sub-UserStory Candidates

<!-- How: Preserve important non-P0 concerns without polluting the main story. If a P1/P2 concern
     is required for the current release or changes the main acceptance decision, create a
     sub-UserStory with Parent Story pointing here. If the need is uncertain, add it as an Initial
     Acceptance Question and keep the candidate row as trace evidence. -->

| Candidate | CaTDD Class / Category | Why It Is Not In Main AC | Recommendation | Status |
| --- | --- | --- | --- | --- |
| {{sub-story candidate}} | {{P1 Design: State/Capability/Concurrency or P2 Quality: Performance/Robust/Compatibility/Configuration}} | {{reason this is not P0 Typical/Edge/Misuse/Fault}} | {{create sub-UserStory / ask acceptance question / defer}} | {{open / deferred / created}} |

**Split Decision:** {{keep as one story / split before opening / create follow-up story after P0}}

---

## Scope

**In scope:**

- {{scope item 1}}
- {{scope item 2}}

**Non-goals:**

- {{explicitly excluded item 1}}
- {{explicitly excluded item 2}}

---

## Story Completion Conditions (`EPIC E3.4`)

<!-- How: State story-specific completion and readiness conditions inside the story specification
     itself rather than relying only on generic workflow checklists (arXiv:2610.07534 E3.4).
     Verified by SPEC_reviewUserStory (for specification completeness) and enforced by
     SPEC_closeUserStory / SPEC_partialCloseUserStory before moving doingUS -> doneUS. -->

| Completion Dimension | Requirement (`MUST` hold before `SPEC_closeUserStory`) |
| --- | --- |
| **Required `TestLevel`** | {{`UnitTesting` only / `UnitTesting + SysTesting` / `UnitTesting + SysTesting + UserTesting`}} |
| **Required `TestScope` & Environment** | {{`mockSysRtm` (`testPassOnMock`) sufficient / `MUST` also pass `realSysRtm` on target runtime/OS/hardware}} |
| **Required CaTDD Categories** | {{`P0 Functional (Typical, Edge, Misuse, Fault)` / `+ P1 (State, Capability, Interaction, Concurrency)` / `+ P2 (...)`}} |
| **Required SPEC & Doc Surfaces** | {{`README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_DetailVerifyDesign.md`, companion `*_readme.md`}} |
| **Not-Done Conditions (`MUST NOT close if`)** | {{explicit story-specific conditions that forbid premature closure, e.g., only mock passes when realSysRtm is required, or any AC lacks GREEN TC}} |
| **Approved Deferrals** | {{items explicitly deferred to Sub-UserStories or follow-up issues without invalidating this story's acceptance claim; if an in-scope AC fails at close, `MUST` use `SPEC_partialCloseUserStory`}} |

---

## Risks & Assumptions

| # | Risk / Assumption | Severity | Mitigation / Clarification Needed |
| --- | --- | --- | --- |
| 1 | {{risk description}} | {{High / Medium / Low}} | {{question or mitigation action}} |

---

## Initial Acceptance Questions

<!-- Gate: story is NOT ready for SPEC_openUserStory if any question is open.
     P1/P2 split questions may be open only if they do not block the P0 story; otherwise decide or
     create the sub-UserStory before opening this story.
     (→ SPEC_analyzeFeature Conflict Guard) -->

| # | Question | Raised By | Blocks Ready? | Owner / Next Evidence | Status |
| --- | --- | --- | --- | --- | --- |
| 1 | {{question}} | {{model gap / ambiguity hunt / business rule / pink card}} | {{yes/no}} | {{who or what evidence answers it}} | {{open / answered}} |

**Gate:** This story is READY for `SPEC_openUserStory` only when all blocking acceptance questions are answered. Non-blocking P1/P2 follow-up questions may remain only if they are explicitly traced in Sub-UserStory Candidates.

---

## Ambiguity Warnings

<!-- How: Scan the entire story for Ambiguity Smells using the Ambiguity Smell Taxonomy (AST):
     SMELL-ACTOR (passive without actor), SMELL-BOUND (unbounded adjectives: "fast", "robust", "seamless"),
     SMELL-BRANCH (missing negative branches), SMELL-STATE (unstated lifecycle bounds),
     SMELL-VAGUE (vague verbs/loopholes: "handle", "manage", "etc."),
     SMELL-MODAL (weak modals "should"/"might" without exception rules, or synonym drift against README_UbiLang.md),
     SMELL-RACE (unstated concurrency).
     For each, ask a clarifying question. Do not silently substitute thresholds or fabricate branches.
     (→ SKILL: validate-requirements-criteria) -->

| # | Smell Code | Ambiguous Term / Pattern | Found In Section | Clarifying Question |
| --- | --- | --- | --- | --- |
| 1 | `{{SMELL-CODE}}` | `"{{vague term or passive phrase}}"` | {{section name}} | `"{{precise question}}"` |

---

## Traceability

| From → To | Link |
| --- | --- |
| This story → Raw input & `## Chat History` | `.catdd/spec/analyzedNews/{{file}}` |
| Project story index | `README_UserStories.md` |
| Project ubiquitous language | `README_UbiLang.md` |
| Parent story | `.catdd/spec/todoUS/{{parent-story-file}}` |
| Sub-UserStory candidates | `.catdd/spec/todoUS/{{sub-story-file-or-candidate}}` |
| This story ID | {{StoryID}} |

---

## Abort Evidence

<!-- How: Present only when this is a corrected re-analysis of an aborted story.
     For SPEC_analyzeAbortedUserStory: read the abortUS story, TASKs.md, and any design/test evidence.
     Classify abort reason. Explicitly state what was kept (valid) and what was rejected (invalid).
     Do not replace the original abortUS/ files — they remain historical evidence.
     (→ SPEC_analyzeAbortedUserStory diagnostic) -->

| Field | Value |
| --- | --- |
| **Original Story** | {{OriginalStoryID}} in `abortUS/{{YYYYMMDD-UserStory.md}}` |
| **Abort Date** | {{YYYY-MM-DD}} |
| **Abort Reason** | {{why the story was aborted}} |
| **Phase at Abort** | {{Phase 1 / 2 / 3}} |
| **Evidence Preserved** | {{TASKs.md, design docs, test files, etc.}} |
| **What Was Kept** | {{valid parts of original story preserved unchanged}} |
| **What Was Rejected** | {{invalid assumptions explicitly discarded}} |
| **Summary of Changes** | {{what this corrected version changes and why}} |

### Re-Analysis Chat History

| Turn # | Speaker / Prompt | Question or Proposal | Developer Answer / Decision | Impact on Corrected Story |
| --- | --- | --- | --- | --- |
| 1 | {{CodeAgent / Developer}} | {{abort diagnosis or replacement intent question}} | {{developer decision or autonomous evidence}} | {{kept / rejected / revised AC or scope}} |
