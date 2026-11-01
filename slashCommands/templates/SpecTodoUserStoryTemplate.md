# {{UserStoryTitle}}

> **Story ID:** {{StoryID}} | **State:** todo | **Priority:** <!-- filled from Priority section below -->
> **StoryIdAlias:** {{StoryIdAlias}}
> **CreatedAt:** {{CreatedAt}}
> **Source:** `.catdd/spec/analyzedNews/{{YYYYMMDD-original}}.md`
> **Correction of:** <!-- present only for SPEC_analyzeAbortedUserStory: abortUS/YYYYMMDD-UserStory.md -->
> **Parent Story:** <!-- present only for sub-UserStory: parent Story ID and `.catdd/spec/todoUS/{{parent}}.md` -->
> **CaTDD Class:** {{P0 Functional / P1 Design / P2 Quality / P3 Addons}}
> **Primary Category:** {{Primary CaTDD category from methodPrompts/CaTDD_methodPrompt.md}}

<!-- How: {{StoryID}} is the complete, registered project-wide US ID. Preserve an existing ID;
     use US-<whoName>-<doWhat> with lowerCamelCase segments for new stories and check for
     collisions as specified in .catdd/methodPrompts/CaTDD_methodPrompt-testStructure.md#project-wide-traceability-ids.
     Register StoryIdAlias = US-YYMMDD.HHMMSS from the verified CreatedAt instant in UTC+08:00;
     CreatedAt is ISO 8601 with +08:00. Preserve both fields on revisions and lifecycle moves.
     Stop on an unknown creation time or collision; never manufacture a timestamp.
     Each new AC ID uses StoryIdAlias, its CaTDD category token, and a unique stable child token.
     Existing IDs need an explicit migration mapping, never silent renumbering. -->

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
| Concrete examples & exceptional paths exist | `E2 Singular` + `P2 Complete` | {{yes/no}} | {{Example Mapping rows, atomic scenarios, Edge/Misuse/Fault CaTDD-ACs}} |
| Every AC has source-backed evidence | `E3 Verifiable` + `I2 Consistent` | {{yes/no}} | {{each AC resolves at least one Example or Rule; missing both triggers AskWhy}} |
| Dependencies, assumptions & risks are declared | `P1 Dependency Control` | {{yes/no}} | {{Risks & Assumptions rows, upstream/downstream constraints}} |
| Story-specific completion conditions are stated | `E3.4 Completion & Readiness` | {{yes/no}} | {{Story Completion Conditions: TestLevel, TestScope, CaTDD categories, Not-Done rules}} |
| Template structure & stable IDs are preserved | `I1 Conforming` | {{yes/no}} | {{StoryID, StoryIdAlias, category-qualified CaTDD-AC IDs, RULE-n, EX-n, CEX-n}} |
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

## CaTDD-AC - P0-Functional (`MUST`)

<!-- How: P0-Functional and all four categories below are mandatory. State ACs from the
     user/caller perspective and give every AC a category-qualified ID. Keep 3-7 Typical
     scenarios, one behavior per scenario, then capture relevant Edge, Misuse, and Fault cases.
     Every CaTDD-AC uses the same From / Given / When / Then / Counter shape.
     CaTDD-AC evidence gate: Every AC MUST have a From section resolving at least one
     source-backed Example or Rule.
     If both are missing or unresolved, stop and AskWhy from the human. Save the human answer
     under From as `Example (AskWhy): ...` or `Rule (AskWhy): ...`. When both are
     available, record both; retain an applicable counter-example. AskWhy evidence is a trace
     rationale, not permission to invent behavior.
     Category meaning comes from CaTDD_methodPrompt.md; category labels do not turn ACs into TPs.
     (→ SKILL: write-user-story + facilitate-example-mapping) -->

### Typical (ValidFunc)

#### {{StoryIdAlias}}-AC-Typical-{{n}}: {{Happy Path Title}}

- **FROM**
  - **Example:** EX-{{n}}
  - **Rule:** {{business rule or constraint that governs this scenario}}
- **GIVEN**
  - {{precondition using canonical `README_UbiLang.md` terms}}
  - **AND** {{additional precondition}}
- **WHEN**
  - {{action or event}}
  - **AND** {{additional action or event}}
- **THEN**
  - {{observable outcome stated with `MUST` / `MUST NOT` (or conditional `SHOULD` / optional `MAY`)}}
- **COUNTER**
  - {{counter-example or invalid variant and its expected distinction}}

**Open Questions:** {{or "None"}}

#### {{StoryIdAlias}}-AC-Typical-{{n}}: {{Alternate Typical Path Title}}

- **FROM**
  - **Example:** EX-{{n}}
  - **Rule:** {{business rule or constraint}}
- **GIVEN**
  - {{precondition using canonical `README_UbiLang.md` terms}}
  - **AND** {{additional precondition}}
- **WHEN**
  - {{action or event}}
  - **AND** {{additional action or event}}
- **THEN**
  - {{observable outcome stated with `MUST` / `MUST NOT` (or conditional `SHOULD` / optional `MAY`)}}
- **COUNTER**
  - {{counter-example or invalid variant and its expected distinction}}

**Open Questions:** {{or "None"}}

#### {{StoryIdAlias}}-AC-Typical-{{n}}: {{Additional Scenario Title}}

- **FROM**
  - **Example:** EX-{{n}}
  - **Rule:** {{business rule or constraint}}
- **GIVEN**
  - {{precondition}}
  - **AND** {{additional precondition}}
- **WHEN**
  - {{action or event}}
  - **AND** {{additional action or event}}
- **THEN**
  - {{observable outcome}}
- **COUNTER**
  - {{counter-example and its expected distinction, or "None"}}

### Edge (ValidFunc)

#### {{StoryIdAlias}}-AC-Edge-{{n}}: {{Valid Boundary or Variation Title}}

- **FROM**
  - **Example:** EX-{{n}}
  - **Rule:** {{business rule or constraint}}
- **GIVEN**
  - {{valid boundary, option, limit, or lifecycle variation}}
  - **AND** {{additional relevant precondition}}
- **WHEN**
  - {{action or event}}
  - **AND** {{additional action or event}}
- **THEN**
  - {{observable outcome}}
- **COUNTER**
  - {{nearby invalid or out-of-scope value and the expected distinction}}

### Misuse (InvalidFunc)

#### {{StoryIdAlias}}-AC-Misuse-{{n}}: {{Caller Misuse Title}}

- **FROM**
  - **Example:** EX-{{n}}
  - **Rule:** {{API contract or precondition violated by the caller}}
- **GIVEN**
  - {{caller violates the API contract or uses invalid input/state}}
  - **AND** {{additional relevant precondition}}
- **WHEN**
  - {{action or event}}
  - **AND** {{additional action or event}}
- **THEN**
  - {{system MUST reject or protect as specified}}
- **COUNTER**
  - {{valid caller behavior that must not be rejected as misuse}}

### Fault (InvalidFunc)

#### {{StoryIdAlias}}-AC-Fault-{{n}}: {{Runtime Fault Title}}

- **FROM**
  - **Example:** EX-{{n}}
  - **Rule:** {{dependency, resource, or runtime failure contract}}
- **GIVEN**
  - {{valid caller behavior with an injected or real system fault}}
  - **AND** {{additional relevant precondition}}
- **WHEN**
  - {{action or event}}
  - **AND** {{additional action or event}}
- **THEN**
  - {{cleanup, diagnostic, or deterministic failure behavior}}
- **COUNTER**
  - {{healthy dependency or normal runtime path that must not enter fault handling}}

TP/TC references are not definitions. Reconcile each TP's owning AC and covering TC rather than inferring links from numeric suffixes; authoritative TP definitions and links stay in verification design.

## CaTDD-AC - P1-Design (`OPTIONAL`)

<!-- How: Include this section only when the story needs P1-Design coverage. Use the current
     CaTDD category list and definitions rather than copying the full taxonomy here. The two
     Concurrency/Capability blocks below are examples; replace them with applicable categories.
     Full taxonomy: ../../methodPrompts/CaTDD_methodPrompt.md#category-semantics -->

#### {{StoryIdAlias}}-AC-Concurrency-{{n}}: {{P1 Concurrency Example Title}}

- **FROM**
  - **Example:** EX-{{n}}
  - **Rule:** {{concurrency or synchronization rule}}
- **GIVEN**
  - {{source-backed concurrent execution state and preconditions}}
  - **AND** {{additional relevant precondition}}
- **WHEN**
  - {{concurrent action or interleaving}}
  - **AND** {{additional concurrent action or interleaving}}
- **THEN**
  - {{concurrency-safe externally observable outcome}}
- **COUNTER**
  - {{race, ordering violation, or unsafe interleaving and its expected distinction}}

#### {{StoryIdAlias}}-AC-Capability-{{n}}: {{P1 Capability Example Title}}

- **FROM**
  - **Example:** EX-{{n}}
  - **Rule:** {{design capability or enabled-behavior rule}}
- **GIVEN**
  - {{source-backed design capability and preconditions}}
  - **AND** {{additional relevant precondition}}
- **WHEN**
  - {{capability is exercised}}
  - **AND** {{additional capability action}}
- **THEN**
  - {{capability-enabled externally observable outcome}}
- **COUNTER**
  - {{unsupported use or configuration where the capability must remain disabled}}

## CaTDD-AC - P2-Quality (`OPTIONAL`)

<!-- How: Include this section only when the story needs P2-Quality coverage. Use the current
     CaTDD category list and measurable source-backed constraints. The Performance/Security blocks
     below are examples; replace them with applicable categories.
     Full taxonomy: ../../methodPrompts/CaTDD_methodPrompt.md#category-semantics -->

#### {{StoryIdAlias}}-AC-Performance-{{n}}: {{P2 Performance Example Title}}

- **FROM**
  - **Example:** EX-{{n}}
  - **Rule:** {{measurable performance constraint and source}}
- **GIVEN**
  - {{specified workload, environment, and preconditions}}
  - **AND** {{additional relevant precondition}}
- **WHEN**
  - {{measured action or event}}
  - **AND** {{additional measured action}}
- **THEN**
  - {{observable metric result MUST remain within the stated threshold}}
- **COUNTER**
  - {{workload or environment outside the declared constraint scope}}

#### {{StoryIdAlias}}-AC-Security-{{n}}: {{P2 Security Example Title}}

- **FROM**
  - **Example:** EX-{{n}}
  - **Rule:** {{security policy, threat, or invariant}}
- **GIVEN**
  - {{specified threat scenario and protected state}}
  - **AND** {{additional relevant precondition}}
- **WHEN**
  - {{attempted action or event}}
  - **AND** {{additional attempted action}}
- **THEN**
  - {{observable safe denial, containment, or protection outcome}}
- **COUNTER**
  - {{unauthorized outcome or sensitive disclosure that MUST NOT occur}}

## CaTDD-AC - P3-DemoExample (`OPTIONAL`)

<!-- How: Include this section only when the story needs P3-Addons/Demo-Example coverage.
     Use the current CaTDD category list and definitions. These two blocks are illustrative.
     Full taxonomy: ../../methodPrompts/CaTDD_methodPrompt.md#category-semantics -->

#### {{StoryIdAlias}}-AC-DemoExample-{{n}}: {{First User-Facing Example Title}}

- **FROM**
  - **Example:** EX-{{n}}
  - **Rule:** {{documented demo or guide behavior}}
- **GIVEN**
  - {{first documented setup and preconditions}}
  - **AND** {{additional documented precondition}}
- **WHEN**
  - {{documented user-facing step}}
  - **AND** {{additional documented user-facing step}}
- **THEN**
  - {{expected executable result}}
- **COUNTER**
  - {{misuse of the example or missing documented dependency and its expected distinction}}

#### {{StoryIdAlias}}-AC-DemoExample-{{n}}: {{Second User-Facing Example Title}}

- **FROM**
  - **Example:** EX-{{n}}
  - **Rule:** {{documented demo or guide behavior}}
- **GIVEN**
  - {{second documented setup and preconditions}}
  - **AND** {{additional documented precondition}}
- **WHEN**
  - {{documented user-facing step}}
  - **AND** {{additional documented user-facing step}}
- **THEN**
  - {{expected executable result}}
- **COUNTER**
  - {{observed result that means the example is stale or not executable}}

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

## Sub-UserStory Candidates

<!-- How: Preserve important non-P0 concerns without polluting the main story. If a P1/P2 concern
     is required for the current release or changes the main acceptance decision, create a
     sub-UserStory with Parent Story pointing here. If the need is uncertain, add it as an Initial
     Acceptance Question and keep the candidate row as trace evidence. -->

| Candidate | CaTDD Class / Category | Why It Is Not In Main AC | Recommendation | Status |
| --- | --- | --- | --- | --- |
| {{sub-story candidate}} | {{P1/P2/P3 CaTDD category from methodPrompts/CaTDD_methodPrompt.md}} | {{reason this is not P0 Typical/Edge/Misuse/Fault}} | {{create sub-UserStory / ask acceptance question / defer}} | {{open / deferred / created}} |

**Split Decision:** {{keep as one story / split before opening / create follow-up story after P0}}

---

## Scope

### In scope

- {{scope item 1}}
- {{scope item 2}}

### Non-goals

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
| **Required CaTDD Categories** | {{mandatory P0 Typical/Edge/Misuse/Fault + any opt-in P1/P2/P3 categories selected from methodPrompts/CaTDD_methodPrompt.md}} |
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
