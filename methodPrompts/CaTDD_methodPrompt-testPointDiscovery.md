# CaTDD Method Prompt - Test Point Discovery

This subtopic explains how developers and CodeAgents discover and account for test points before writing or approving US/AC/TC comments. Use it after reading `CaTDD_methodPrompt-categorySemantics.md`, before any category skeleton, and again during independent design review.

## Purpose

`TestPointsInMind` is a thinking aid, not a coverage quota. It should help agents discover source-backed test points without inventing behavior.

**Test Point Missing** means a relevant behavior or condition was never identified as a verification obligation. All existing tests can pass, all four P0 categories can exist, and every written US/AC can have links while a whole behavior is absent. Cardinality checks cannot detect an item that was never written.

The goal is fewer omissions through systematic discovery, not more TCs for their own sake. This method does not guarantee exhaustive coverage or the absence of deployment bugs.

Use this rule:

```text
Source artifact -> Rule -> Concrete Example -> Open Question -> CaTDD category -> US/AC/TC
```

If an expected result cannot trace back to a source artifact, record a QUESTION and ask for the missing decision. A category marked `@[NoTestPoints]: <reason>` because its source is missing is BLOCKED, not proven inapplicable. Never use that marker to hide unknown behavior.

## Behavior Inventory

Build the inventory **from sources before reading existing skeletons as coverage evidence**. Existing tests are useful later for reconciliation; they are not the inventory of what the product should do.

1. Declare the SUT boundary, feature scope, test level, and explicit developer-approved scope limits.
2. List source artifacts with stable references (path plus section, rule ID, or revision when available). Read relevant User Stories, ACs, UsageDesign, interface/schema contracts, documented workflows, and functional error contracts. A header's signatures alone may not specify outcomes.
3. Enumerate every in-scope operation, supported usage variant, rule, precondition, output, and promised side effect. Assign local rule IDs when the source lacks them; do not change its meaning. One example per API is not sufficient if it has several distinct behaviors. Expand shared rules such as "both operations", "either", "each", or "same range" into explicit operation/rule obligations. Preserve the source's quantifiers: a shared rejection rule already defines each operation's result; do not turn that explicit rule into an unnecessary ambiguity question.
4. Name relevant input, caller, state, dependency, and deployment dimensions and their supported values. Every discovered source conflict, missing contract, or uncertain applicability must create a QUESTION ledger row with the decision needed and its owner (or a request to identify the owner). Silence is not a not-applicable decision.
5. Consult available incident reports, support cases, real usage examples, dependency documentation, and deployment differences as **discovery evidence**. Record whether these sources were reviewed, unavailable, or not applicable. Do not require incidents to exist in a new project. Implementation and mocks may reveal overlooked seams but are not the authority for expected behavior.

Keep the inventory in the feature's FreelyDrafts or test-file overview/design comments. Link it from category files rather than maintaining a competing external specification. For large scopes, slice explicitly with the developer instead of silently sampling away whole operations.

## Example Mapping First

Use Example Mapping as the first scenario derivation move over the inventory, breadth-first across rules before elaborating one category.

| Example Mapping card | CaTDD meaning |
| --- | --- |
| Story | The feature, capability, design concern, or quality attribute being verified. |
| Rule | The contract, design invariant, policy, threshold, source-of-truth statement, or category boundary. |
| Example | A concrete test point candidate with real inputs, state, actors, environment, and expected observable result. |
| Question | Missing acceptance criteria, missing source artifact, ambiguous threshold, unclear owner, or category-routing uncertainty. |

Workflow:

1. Name the story or design concern being verified.
2. Extract rules from the source artifact.
3. For each rule, find concrete examples for its distinct outcomes and relevant conditions, plus counter-examples when useful. One example is a starting point, not proof of completeness.
4. Capture questions instead of guessing.
5. Route each example to the CaTDD category that matches its verification lens.
6. Convert only source-backed examples into US/AC/TC.

## P0 Discovery Sweep

For every in-scope behavior, consider the following dimensions. Record resulting TP IDs or a source-backed not-applicable reason for each dimension. A blank cell means not examined; a generic checklist tick is not evidence. These are questions to ask, not automatic acceptance criteria.

| Dimension | Discovery questions |
| --- | --- |
| Operations and outcomes | Have all operations and distinct supported workflows been considered, not just the first happy path? What output, persisted state, event, or absence of side effect proves each promise? |
| Input partitions | Which values are equivalent under the rule? Consider absent versus null versus empty versus zero, valid alternatives, malformed values, duplicates, order, encoding, and size only where meaningful to the interface. |
| Boundaries | For each named boundary, consider immediately below, exactly at, and immediately above it using the domain's valid precision. Which are still valid Edge, which violate caller rules and belong in Misuse, and which have unspecified behavior? |
| Relationships and combinations | Can individually valid fields, modes, roles, or options conflict together? Which rule conditions depend on each other? Are both outcomes of conditional rules represented? |
| Public usage sequences | What does the contract promise for first use, repeated calls, retry, cancellation, restart, or calls in the wrong order? Keep externally observable obligations in P0; refer internal state/interleaving proofs to P1. |
| Dependency failures and timing | For each dependency boundary, explicitly account for before work, during partial work, and after a side effect but before acknowledgment with TP IDs or a source-backed not-applicable reason per phase. Consider unavailable, delayed, malformed, partial, or duplicate responses where relevant; unknown phase applicability or behavior becomes QUESTION, never assumed retry/rollback semantics. |
| Production differences | What relevant differences exist between local fixtures and supported deployment: permissions, paths, real payloads, process lifecycle, configuration, versions, locale, or network behavior? Which are P0 outcomes and which need P2 Compatibility, Configuration, Robust, or other quality verification? |
| Oracles and test level | What observable result distinguishes correct behavior from merely returning success? What must not change on rejection/failure? Could a mock hide the issue? Does it need component, integration, system, or manual verification rather than a forced unit test? |

Then sweep all four P0 lenses over that inventory:

- **Typical**: every distinct ordinary supported workflow, not just one representative API call.
- **Edge**: each relevant valid partition and boundary outcome; unusual does not mean invalid.
- **Misuse**: each named caller constraint, including cross-field violations and promised rejection side effects.
- **Fault**: each relevant dependency failure and partial-work outcome under valid caller behavior.

For combinations, enumerate all feasible combinations when the decision table is small. Otherwise document the chosen dimensions, constraints, representative or pairwise selection, and omissions. Always add explicit risk-significant combinations, including three-way or higher interactions justified by rules or incidents; pairwise is not proof of completeness. Do not fabricate unsupported combinations or numeric limits to fill a matrix.

A representative TC plus a source-backed equivalence rationale can cover a partition; do not label every other untested value in that partition a GAP. For example, testing an ordinary count of 2 does not automatically require another Typical TC at 4 when the rule makes no distinction. Keep distinct outcomes, boundary obligations, and risk-significant combinations explicit rather than inflating TC counts.

## Test-Point Ledger

Keep one `discovery_ledger` in living comments, alongside the inventory and coverage matrix. Use stable local TP IDs distinct from US/AC/TC IDs. Each row represents a specific condition and observable obligation, not just a category name.

| Field | Required content |
| --- | --- |
| TP ID and rule/source | Stable TP ID; source reference and rule ID, or evidence reference plus missing-source question. |
| Scenario | Concrete inputs, state, relevant environment/dependencies, and action. |
| Oracle | Expected observable result and important promised side effects/non-effects; write unknown if unresolved. |
| Category and test level | Owning verification lens and intended verification boundary; provisional when unresolved. |
| Disposition and evidence | One disposition below, with actual links, rationale, question, or destination. |

| Disposition | Meaning and required evidence |
| --- | --- |
| DESIGNED | Linked category file plus US/AC/TC IDs actually specify this scenario and oracle. TODO TCs count as designed, not implemented or GREEN. |
| QUESTION | Missing/conflicting source, expected behavior, or scope decision. Record the question and decision owner, or ask who owns it. Do not invent a TC expectation. |
| EXCLUDED | Source-backed not-applicable condition or explicit developer-approved scope exclusion, with rationale and approval reference. Difficulty or low execution priority is not an exclusion. |
| REFERRED | Another category or test level owns the concern. Record the reason, concrete destination artifact/work item, and responsible owner or pending handoff question. Referral is not verified coverage. |
| GAP | A known in-scope source-backed point has no adequate TC. Name what must be designed; a weak oracle or a dangling TC link is also a gap. |

Every source rule and every applicable sweep dimension must link to ledger rows; each row must have a disposition. Multiple TCs may be needed per rule. A TC may support several rows only when its setup and assertions genuinely distinguish those obligations.

**accounted for does not mean covered**: QUESTION, EXCLUDED, REFERRED, and GAP are not DESIGNED. Do not report their sum as coverage. Missing-source `@[NoTestPoints]` requires a QUESTION; genuine inapplicability requires an EXCLUDED rationale. Neither silently removes the category file.

## Discovery Gate

Run this gate in addition to the US -> AC -> TC cardinality gate:

1. **Source -> design**: every in-scope operation/rule is inventoried; every relevant dimension and distinct outcome has ledger evidence. Look for omitted behaviors even when existing TCs all have valid links.
2. **Design -> source**: each DESIGNED row resolves to a real TC with source-backed setup and oracle. Detect wrong categories, duplicates, missing assertions, and invented expectations.
3. **Independent challenge**: derive expected behavior from the sources before consulting the designer's ledger/skeletons, preferably with a second reviewer. A solo developer/agent must perform a separate source-first pass and label it self-review, with shared-blind-spot risk explicit. Record reviewer/process, sources examined, and a source-derived operation/outcome checklist reconciled against the ledger; a bare "reviewed" flag is insufficient. Ask, "Which realistic scenario could violate this contract while every proposed test still passes?" Record source-backed findings; turn unsupported hypotheses into questions.
4. **Disposition audit**: review unknowns, exclusions, unexamined evidence, sampling omissions, and referrals. An unimplemented designed TC is not a missing point. An in-scope P0 obligation referred to a higher test level remains a GAP until its design is linked, or the developer explicitly narrows the scope. Unresolved handoff ownership remains a QUESTION. A confirmed P1/P2 referral does not expand P0 but remains visible follow-up, not release readiness.
5. **Stop and report**: perform one discovery sweep and one independent challenge; allow at most two repair/recheck rounds. Stop earlier on missing intent or no progress. Never loop until a desired PASS appears; report remaining gaps and ask for the needed decision.

Report separately:

```text
Scope/SUT and source references: ...
Inventory and discovery_ledger location: ...
Dimensions considered / sampling limits: ...
Review provenance and source-derived checklist: ...
Disposition counts: DESIGNED / QUESTION / EXCLUDED / REFERRED / GAP
Cardinality gate: PASS | FAIL
discovery_status: PASS | GAPS | BLOCKED
ready_for_implementation: yes | no
Review evidence, open questions, referrals, residual risk, next action: ...
```

Use BLOCKED when an in-scope source, oracle, or scope decision is unresolved; otherwise GAPS when known obligations or required review evidence are missing; otherwise PASS **for the declared scope and reviewed sources only**. `ready_for_implementation: yes` requires both gates to pass and the independent review to be complete. All unresolved in-scope P0 questions block readiness, not just high-risk ones. A developer-approved smaller slice can be reviewed separately, but must not be reported as the whole feature being complete. Passing this design gate is not proof of test execution or release readiness.

### Report Consistency Audit

Before returning the report:

- Re-read the cited rule for every QUESTION. If it already specifies the result, replace the question with DESIGNED or GAP evidence; if sources actually conflict, cite both. Unclear applicability within the requested scope remains a blocking scope question until resolved, not an assumed exclusion.
- Count dispositions from the full ledger, one per TP ID. Totals must match actual rows; when presenting only a sample, label it partial and link the full ledger or omit totals. Every claimed referral needs its own REFERRED row and destination, not just a narrative footnote.
- Apply status precedence explicitly: any unresolved in-scope source/oracle/scope question -> BLOCKED; otherwise any known design/review gap -> GAPS; otherwise PASS. BLOCKED takes precedence even when known gaps also exist. Report both kinds of findings; non-PASS always means `ready_for_implementation: no`.
- Compare the independent operation/outcome checklist to ledger coverage once more. A grouped range is not evidence for missing endpoints; show concrete boundary examples. Correct inconsistent output within the same bounded review budget, or report the inconsistency without approving readiness.

## Escaped-Bug Feedback

When deployment exposes a missing scenario:

1. Capture a sanitized reproduction, relevant environment difference, observed result, and confirmed expected contract. Incident behavior is evidence, not automatically the intended result.
2. Locate the escape: missing source requirement, missed discovery dimension/combination, incorrect category or test level, weak oracle, over-simplified fixture/mock, or a designed test not implemented/run. Do not call every escaped bug a missing test point.
3. Resolve missing intent with the developer, then add the smallest regression TP -> US/AC/TC and confirm RED before a production fix. If behavior is already correct, record existing coverage rather than forcing fake RED.
4. Ask what reusable discovery question would have exposed this earlier, check related operations/boundaries, and update the relevant method checklist with evidence. Avoid adding a product-specific incident as a universal requirement.
5. Rerun the Discovery Gate and relevant regressions. Keep residual deployment risks explicit.

## Usage Example

Copy this self-contained request into a CodeAgent with this method available, or work it manually. This is an illustrative exporter contract, not a claim about repository product behavior:

```text
Apply the CaTDD test-point Discovery Gate to the following design. Review only;
do not implement code. SUT: batch exporter public API, P0 scope.

Source contract:
R1: write(records, destination) accepts 1..100 valid records, persists exactly
those records, and returns OK on success.
R2: preview(records) accepts the same range, returns their rendered content,
and never creates or changes files.
R3: zero or more than 100 records on either operation returns INVALID_COUNT
without creating or changing files.
R4: storage failure at open or during write returns IO_ERROR and preserves
the previous destination content.
No timeout behavior is specified; ask the developer if it is needed.

Existing skeleton (every AC has one linked TODO TC):
US-1 / AC-1 / TC-1 Typical: write 2 records -> OK and exact persisted content.
US-1 / AC-2 / TC-2 Edge: write 100 records -> OK and exact persisted content.
US-1 / AC-3 / TC-3 Misuse: write 0 records -> INVALID_COUNT and unchanged files.
US-1 / AC-4 / TC-4 Fault: storage open failure -> IO_ERROR and old content intact.

Build the source inventory independently, perform the P0 sweep, and reconcile
the discovery_ledger. Identify omissions using TP/rule IDs even if no TC exists.
Report cardinality separately from discovery_status and ready_for_implementation.
```

Expected review includes these rows (not an exhaustive ledger):

| TP | Source | Scenario / oracle | Disposition |
| --- | --- | --- | --- |
| TP-01 | R1 | Write 2 records -> OK plus exact content | DESIGNED: US-1 / AC-1 / TC-1 |
| TP-05 | R2 | Preview 2 records -> rendered content and no file changes | GAP: missing Typical workflow despite four populated categories |
| TP-06 | R1 | Write 1 record -> OK plus exact content | GAP: missing valid lower boundary |
| TP-07 | R3 | Write 101 records -> INVALID_COUNT and unchanged files | GAP: invalid upper neighbor belongs to Misuse, not Edge |
| TP-08 | R4 | Failure during partial write -> IO_ERROR and old content intact | GAP: open failure alone does not prove this outcome |
| TP-09 | Missing timeout contract | Delayed storage response -> expected result unknown | QUESTION: ask developer; do not invent a timeout or retry count |

The existing cardinality gate passes, but discovery finds GAPS; with the timeout question unresolved for this scope, report `discovery_status: BLOCKED` and `ready_for_implementation: no`. Resolve its applicability explicitly; even if excluded, the known gaps still prevent readiness. Also examine preview boundaries/rejections rather than blindly reusing write coverage. Keeping four category files or increasing TC count alone would not catch these omissions.

## Category-by-Category Example Mapping Prompts

Use these prompts to turn `TestPointsInMind` into concrete examples.

| Category | Rule to Extract | Example to Ask For | Question to Preserve |
| --- | --- | --- | --- |
| Typical | Main success contract from User Story, AC, UsageDesign, or API contract. | What is the shortest valid workflow that delivers the promised output? | What observable result proves the core behavior rather than just no error? |
| Edge | Valid boundary, valid mode, or documented non-success result. | What happens at zero, empty, first, last, min, max, full, timeout, sync, async, or one-before/at boundary? | Is this still valid Edge, or did it cross into Misuse, Fault, Capability, Performance, State, Interaction, Concurrency, Diagnosis, or Security? |
| Misuse | Caller contract, precondition, or call-sequence rule. | What exact wrong caller action should be rejected safely? | Is the caller wrong, or is the world/dependency wrong? |
| Fault | Dependency, resource, environment, process, runtime, or infrastructure failure rule. | What deterministic injected fault proves graceful failure, cleanup, or recovery? | What fault injection seam makes the test repeatable? |
| State | State model, transition table, lifecycle rule, or invariant. | Which allowed or rejected transition proves the state model? | How can the state be observed without relying only on a return code? |
| Capability | Capacity source, limit, responsibility boundary, or maximum ability claim. | What below-limit, at-limit, and one-over-limit examples prove the ability contract? | Is this maximum ability, or is it speed, sustained stability, or concurrency correctness? |
| Interaction | Sequence diagram, collaboration rule, handoff contract, or orchestration policy. | Which collaborators must coordinate in what order, with what handoff data? | Is this internal design interaction, or externally visible P0 behavior? |
| Concurrency | Shared resource, synchronization rule, ownership rule, or interleaving invariant. | What controlled interleaving could lose work, duplicate work, corrupt state, or deadlock? | Can the interleaving be made deterministic enough to diagnose? |
| Performance | SLO, threshold, metric, workload, or resource budget. | What metric, target, workload, sample size, and tolerance prove the budget? | Who owns the threshold, and what environment makes the measurement meaningful? |
| Robust | Sustained-use invariant, repeat count, soak window, stress shape, or resource-churn rule. | What repeated or long-running scenario proves stable invariants and cleanup? | What evidence will make a late-cycle failure diagnosable? |
| Compatibility | Compatibility matrix, version rule, supported environment, protocol, schema, or integration contract. | Which old/new, platform, version, schema, path, locale, or encoding example proves compatibility? | What variation is supported, unsupported, or allowed to differ? |
| Configuration | Setting source, default, precedence rule, feature flag, profile, or deployment mode. | What default, override, precedence, supported combination, or invalid config proves configuration behavior? | Which setting source wins, and how is global state cleaned after the test? |
| Diagnosis | Required evidence field, surface, diagnostic contract, or explainability rule. | What log, trace, metric, stderr, health report, or error field makes the situation actionable? | What sensitive value must be absent from diagnostic output? |
| Security | Threat model, policy, trust boundary, protected asset, or compliance rule. | What allowed/denied contrast or threat attempt proves the protection property? | What source policy justifies the test, and what must not leak? |
| DemoExample | UserGuide flow, README example, onboarding path, or copy-exec command. | What smallest documented workflow can a new user run and observe? | Does this demo rely on behavior already proven by P0/P1/P2 instead of replacing it? |

## Agile Testing Quadrants in CaTDD

Agile Testing Quadrants are a balance check, not a replacement for CaTDD category identity.

CaTDD answers:

```text
What confidence lens owns this test point?
```

Agile Testing Quadrants answer:

```text
Is our overall test strategy balanced across team support and product critique?
```

Map them this way:

| Agile Quadrant | Purpose | CaTDD Categories That Often Contribute | How to Use in CaTDD |
| --- | --- | --- | --- |
| Q1 Technology-facing / supports the team | Guide implementation with fast technical feedback. | P0 Typical, Edge, Misuse, Fault; P1 State, Capability, Interaction, Concurrency. | Use for unit/component RED-GREEN slices and internal design confidence. |
| Q2 Business-facing / supports the team | Prove business rules and user-visible story behavior. | P0 Typical, Edge, Misuse, Fault; P3 DemoExample when examples are story-facing. | Use Example Mapping to connect rules and concrete examples to ACs. |
| Q3 Business-facing / critiques the product | Explore usability, workflow fit, surprise cases, and user learning. | P3 DemoExample; selected P0 Edge/Misuse scenarios; exploratory notes outside automated unit scope. | Use to discover questions and manual/exploratory gaps; do not force all Q3 items into unit tests. |
| Q4 Technology-facing / critiques the product | Evaluate quality attributes and technical risk. | P2 Performance, Robust, Compatibility, Configuration, Diagnosis, Security. | Use tactics-style questions to find measurable quality scenarios and missing source artifacts. |

Rules:

- Do not rename CaTDD categories to quadrant names.
- Do not treat quadrants as execution order; CaTDD workflow owns execution order.
- Do not force every story to fill every quadrant.
- Use quadrants to detect blind spots after category routing is done.

## Discovery Review Checklist

Before converting discovered examples into US/AC/TC, verify:

- The Behavior Inventory, P0 Discovery Sweep where applicable, and Test-Point Ledger are available in living comments.
- Every example has a source-backed rule.
- Every rule's distinct outcomes and relevant conditions have concrete examples or explicit dispositions, not merely one example by quota.
- Every unresolved question is visible and not silently converted into a test.
- Every example is routed by verification lens, not by implementation proximity.
- P2 examples have measurable thresholds, matrices, policies, or evidence surfaces.
- Q1/Q2/Q3/Q4 have been considered as a balance check where the feature risk justifies it.
- The Discovery Gate is reported separately from cardinality; unknowns and residual risks are not claimed as coverage.
