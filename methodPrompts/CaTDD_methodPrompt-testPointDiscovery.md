# CaTDD Method Prompt - Test Point Discovery

This subtopic explains how developers and CodeAgents discover and account for test points before writing or approving US/AC/TC comments. Use it after reading `CaTDD_methodPrompt-categorySemantics.md`, before any category skeleton, and again during independent design review.

## Purpose

`TestPointsInMind` is a thinking aid, not a coverage quota. It should help agents discover source-backed test points without inventing behavior.

**Test Point Missing** means a relevant behavior or condition was never identified as a verification obligation. All existing tests can pass, all four P0 categories can exist, and every written US/AC can have links while a whole behavior is absent. Cardinality checks cannot detect an item that was never written.

The goal is fewer omissions through systematic discovery, not more TCs for their own sake. This method does not guarantee exhaustive coverage or the absence of deployment bugs.

Discovery spans two design stages before implementation:

- **Stage-0: Freely Drafting**: source-first, breadth-first exploration of operations, rules, outcomes, and questions using Example Mapping and applicable discovery sweeps, without premature category lock-in.
- **Stage-1: Classifying Design**: routing source-backed candidates into CaTDD category skeletons (`P0 Functional`, `P1 Design`, `P2 Quality`, `P3 Addons`), maintaining a living ledger, and challenging the design through the Discovery Gate.

CaTDD's usage emphasis is:

1. **Embedded Linux (primary)**: user-space/kernel boundaries, POSIX/device contracts, constrained resources, timing, persistence, and recovery.
2. **Microservices (secondary)**: service contracts, distributed state, dependency failures, deployment differences, and operating evidence.
3. **LLM Agents (tertiary)**: model/tool contracts, execution control, permissions, budgets, and externally verifiable outcomes.

Choose the profile(s) relevant to the declared SUT. These priorities do not change category identity or require every project to implement every technology below.

Use this rule:

```text
Source artifact -> Rule -> Concrete Example -> Open Question -> CaTDD category -> US/AC/TC
```

If an expected result cannot trace back to a source artifact, record a QUESTION and ask for the missing decision. A category marked `@[NoTestPoints]: <reason>` because its source is missing is BLOCKED, not proven inapplicable. Never use that marker to hide unknown behavior.

## Behavior Inventory

Build the inventory **from sources before reading existing skeletons as coverage evidence**. Existing tests are useful later for reconciliation; they are not the inventory of what the product should do.

1. Declare the SUT boundary, feature scope, in-scope classes, test level, execution environment, and explicit developer-approved scope limits. Distinguish host simulation from on-target/HIL evidence and identify the applicable domain profile(s).
2. List source artifacts with stable references (path plus section, rule ID, or revision when available). Read relevant User Stories, ACs, UsageDesign, interface/schema contracts, design models, quality budgets/policies/matrices, and guide workflows. A header's signatures alone may not specify outcomes; a generic tactic or skill is not a product requirement.
3. Enumerate every in-scope operation, supported usage variant, rule, model invariant, quality predicate, guide outcome, and promised side effect. Assign local rule IDs when the source lacks them; do not change its meaning. One example per API is not sufficient if it has several distinct behaviors. Expand shared rules such as "both operations", "either", "each", or "same range" into explicit operation/rule obligations. Preserve the source's quantifiers: a shared rejection rule already defines each operation's result; do not turn that explicit rule into an unnecessary ambiguity question.
4. Name relevant input, caller, state, dependency, and deployment dimensions and their supported values. Every discovered source conflict, missing contract, or uncertain applicability must create a QUESTION ledger row with the decision needed and its owner (or a request to identify the owner). Silence is not a not-applicable decision.
5. Consult available incident reports, support cases, real usage examples, dependency documentation, and deployment differences as **discovery evidence**. Record whether these sources were reviewed, unavailable, or not applicable. Do not require incidents to exist in a new project. Implementation and mocks may reveal overlooked seams but are not the authority for expected behavior.

Keep the inventory in the feature's FreelyDrafts or test-file overview/design comments. Link it from category files rather than maintaining a competing external specification. For large scopes, slice explicitly with the developer instead of silently sampling away whole operations.

## Stage-0 Elicitation Toolkit

Use Example Mapping as the scenario-derivation backbone. The following are optional supporting heuristics, not a mandatory sequence before it. OOPSI and business-rule extraction apply to functional workflows; do not force business rules onto a driver synchronization model or a timing budget. Use the corresponding P1/P2 sources and sweeps directly for those concerns. Ambiguity checks apply to every source type.

### 1. OOPSI Model (Outcome -> Outputs -> Process -> Scenarios -> Inputs)

Starting test design from inputs ("What parameters can I pass?") obscures the business purpose and misses unstated side effects. Reverse the inquiry:

1. **Outcome**: What is the overarching business goal or contract intent?
2. **Outputs**: What tangible artifacts, return values, emitted events, or state changes prove the outcome was achieved? (This defines the verifiable test oracle).
3. **Process**: What high-level workflow steps produce those outputs?
4. **Scenarios**: What are the alternate paths, edge cases, error branches, and boundary conditions within that process?
5. **Inputs**: What exact parameters, payloads, or preconditions trigger each scenario?

Every scenario needs a source-backed observable oracle. Manual or hybrid verification is valid when its procedure, expected observation, and evidence capture are specified, including on-target or hardware-in-the-loop (HIL) checks. Record the verification method and execution environment separately from the expected behavior. Missing automation alone is not a QUESTION; missing intent, applicability, or an oracle is. An undesigned verification procedure is a GAP; unavailable execution equipment is an execution limitation, not automatically a design blocker.

### 2. Business Rules Taxonomy

For functional sources containing business/domain rules, use the taxonomy to ask additional discovery questions:

| Rule Type | Definition | Discovery questions |
| --- | --- | --- |
| **Fact** | A source-defined truth about the domain. | Which observable behaviors depend on it, and under which stated conditions? |
| **Constraint** | A restriction on an allowed action or value. | Which compliant and violating scenarios have distinct promised outcomes? |
| **Action Enabler** | A condition that triggers a workflow. | What happens when the condition holds and when it does not? |
| **Inference** | A conclusion derived from stated rules. | Which input partitions lead to each distinct conclusion? |
| **Computation** | A source-defined formula or calculation. | What ordinary results, rounding rules, valid precision, and boundaries must be checked? |

Rule type does not determine CaTDD category. An ordinary sensor-value computation can be Typical, its valid boundary can be Edge, and a State test requires an actual internal design model. Route each candidate by its verification lens after discovery. If a rule or boundary is unstated, record a QUESTION rather than inferring product policy.

### 3. Ambiguity and Exception Path Hunting

Before accepting drafted requirements into design:

- **Hunt Ambiguity**: Flag subjective words ("fast", "reliable", "seamless", "graceful", "properly", "safe"). Ask for an observable predicate or, for a numeric budget, a threshold with units. Do not invent either.
- **Probe Exception Paths**: Systematically ask "What if..." for every happy path:
  - *What if* the caller is unauthenticated or unauthorized?
  - *What if* the network, filesystem, or hardware is disconnected mid-transaction?
  - *What if* the input is null, empty, negative, or max-sized?
  - *What if* the operation is cancelled or repeated immediately?

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

For every applicable P0/P1/P2/P3 sweep below, record source/rule references, dimensions and outcomes, TP IDs, or an explicit exclusion rationale. Keep verification methods, execution environments, feasible combinations, and sampling limits visible. A category heading or a checklist tick alone is not discovery evidence. A narrower declared scope does not require unrelated classes or domain profiles, but unresolved applicability within that scope is a QUESTION.

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

## P1 Design Discovery Sweep

P1 Design proves the internal model against confirmed design sources. Architectural viewpoints help discover concerns; they are neither product requirements nor a one-to-one category taxonomy. Check relevant context, functional, information, concurrency, deployment, and operational views for consistent responsibilities and boundaries without inventing new CaTDD categories.

| Category / Viewpoint | Discovery Dimensions | Probing Questions | Observable Oracle Expectation |
| --- | --- | --- | --- |
| **State** (*Information / Functional*) | States, transitions, guards, entry/exit effects, invariants. | Which transitions and rejected operations does the model define? Is repeated close rejected or idempotent? Which cleanup, failure, and recovery paths are specified? | Source-defined states and effects, observed through queries, events, persisted markers, or stable model-facing test seams; do not assume a particular recovery state. |
| **Capability** (*Functional*) | Responsibilities, supported modes, capacity and support boundaries. | What capability is supported, conditional, or unsupported? For each defined limit, what happens below, at, and beyond it at the valid domain precision? Which scope owns the capacity? | Supported/unsupported behavior, accepted work, excess handling, and capacity release exactly as designed; not an assumed error or backpressure policy. |
| **Interaction** (*Functional / Context*) | Delegation, sequence, payloads, ownership handoffs, alternate paths. | Which collaborator acts in which order and with what data? What does the design require before/after a partial handoff or missing acknowledgment? | Required order, data integrity, delegation, and the specified failure policy; rollback, retry, or compensation only when the source promises it. |
| **Concurrency** (*Concurrency / Deployment*) | Actors, shared resources, synchronization, interleavings. | Which thread/process/interrupt boundaries exist? Which schedules challenge ownership, lock order, cancellation, or shutdown invariants? What controlled seam reproduces each schedule? | Design invariants under named bounded schedules and evidence of completion/cleanup; a passing schedule or race detector is not proof of all possible interleavings. |

## P2 Quality Discovery Sweep

P2 Quality proves the operating envelope. Use tactics questions to elicit concerns and a **6-Part Quality Attribute Scenario** to describe each source-backed candidate:

$$\text{QAS} = \langle \text{Source}, \text{Stimulus}, \text{Artifact}, \text{Environment}, \text{Response}, \text{Response Measure} \rangle$$

Here, Source means the stimulus origin; keep the authoritative design/source-artifact reference separately. Response measures may be numeric thresholds or exact predicates: a supported compatibility-matrix result, a configuration winner, required diagnostic fields, or an allowed/denied policy outcome. Numeric budgets need source-defined units, thresholds, workloads, and measurement conditions; symbolic predicates need equally explicit expected evidence. Unknown expectations become QUESTION, but a valid non-numeric oracle does not. The verification method may be automated, manual, or hybrid.

| Category / Tactic | Quality Dimensions | Probing Questions | Observable Oracle Expectation |
| --- | --- | --- | --- |
| **Performance** (*Resource Control*) | Deadlines, jitter, latency, throughput, resource budgets. | Which worst-case or percentile measure is required, with which workload, build, target, tolerance, and sampling? What instrumentation overhead matters? | Compare each metric using its source-defined relation and unit: an upper latency bound is not a minimum throughput target. Do not substitute a percentile for a hard deadline. |
| **Robust** (*Fault Prevention & Soak*) | Sustained operation, resource churn, repeated recovery. | Which invariants must hold for the specified duration or repetition count, including defined failure/recovery cycles? | The specified stability, resource-residue, and recovery predicates throughout that workload; no assumed self-healing or fixed soak duration. |
| **Compatibility** (*Interoperability*) | Supported platforms, ABIs, versions, formats, protocols. | Which matrix rows are supported? Which outcomes must agree and which differences or negotiations are expressly allowed? | Source-defined compatibility relations, preserved data, and allowed differences per matrix row; byte-identical output is not universally required. |
| **Configuration** (*Defer Binding*) | Setting sources, defaults, precedence, combinations, reload. | Which build/boot/runtime sources exist and which wins? What is the specified behavior for missing, conflicting, or changed settings? | Exact resolved value/mode and the specified invalid-setting or reload outcome; do not invent a precedence order or require reload support. |
| **Diagnosis** (*Detect & Observe*) | Evidence surfaces, required fields, correlation, redaction. | Which success/failure events require what evidence for which operator or tool? Which sensitive fields must be absent? | Required codes, fields, causal/correlation links, and forbidden data on the specified surfaces; not an assumed logging framework or prose string. |
| **Security** (*Resist & React*) | Assets, trust boundaries, actors, permissions, integrity. | Which allowed/denied contrasts and threat conditions follow from the policy? What reaction or audit evidence is required? | Policy-defined denial, containment, integrity, and permitted effects; do not impose rate limiting, sanitization, or lockout unless specified. |

## P3 Addons Discovery Sweep

P3 Addons proves the learning surface. Sourced from developer onboarding, user guides, and copy-exec documentation.

| Category | Discovery Dimensions | Probing Questions | Observable Oracle Expectation |
| --- | --- | --- | --- |
| **DemoExample** | Guide paths, setup, visible outcomes, cleanup, repeatability. | Which documented workflows can a newcomer follow? Are prerequisites and manual steps explicit? Are simulated dependencies distinguished from a live target/provider? | The documented outputs, statuses, artifacts or non-effects, and cleanup. An intentional error example may return nonzero; not every demo creates files or uses stdout. |

A demo may use documented fake dependencies, but must not claim that simulated hardware/provider behavior validates the real target. It must exercise the declared SUT and cannot replace P0/P1/P2 obligations.

## Domain Archetype Discovery (Embedded, Microservice, LLM Agent)

This is a usage-priority guide, not a historical lineage or a source of product requirements. Embedded Linux comes first, followed by Microservices and LLM Agents. Apply only relevant profiles, combining them for mixed systems when justified. Every candidate still needs a source, an oracle, and an explicit disposition; unsupported hypotheses remain questions, not mandatory features or automatic exclusions.

### 1. Embedded Linux Domain

- **Boundary first**: Is the SUT a library, user-space daemon, kernel module, or device interface? Which evidence can a host fixture provide, and which requires a simulator, target board, or HIL procedure? Shared RAM atomics do not imply that atomic operations are supported on MMIO; use the platform's device-access and DMA ownership contract.
- **Functional (P0)**: Which frame lengths, units, precision, and operations are valid? What does the contract promise for short I/O, interrupted/nonblocking operations, device disconnection, or storage failure? Account for interruption before, during, and after persistent effects without inventing retry or power-loss recovery behavior.
- **Design (P1)**: Which lifecycle/cleanup transitions, queue/resource limits, daemon-driver handoffs, and thread/interrupt ownership rules are specified? Probe each source-defined guard, handoff, and interleaving rather than assuming a universal boot state machine.
- **Quality (P2)**: Which deadline/jitter, allocation, memory, power, or endurance budgets exist on the named target? What soak/recovery workload, supported board/ABI/kernel/libc matrix, and build/boot/runtime settings apply? Which reset/fault evidence and protection policies are required? Sanitizers can support a specified check, but do not prove target timing, DMA correctness, or complete memory safety.
- **Addons (P3)**: Can the documented loopback or device walkthrough be repeated with explicit board/host prerequisites, observable results, and cleanup? Label simulation and manual observations; do not imply a host-only demo validated hardware.

### 2. Microservices Domain

- **Functional (P0)**: Which request/workflow outcomes, protocol status codes, payloads, and side effects are promised? What happens on a partial response or lost acknowledgment under the documented delivery/retry contract?
- **Design (P1)**: Which service lifecycles, pool limits, collaboration sequences, transaction boundaries, and concurrent ownership rules exist? Do not require sagas, circuit breakers, or distributed locks merely because the SUT is a service.
- **Quality (P2)**: Use source-defined workload/budget pairs, sustained-failure invariants, supported API/schema matrices, actual configuration precedence, required correlation evidence, and threat policies. Do not impose a latency target, logging framework, or precedence hierarchy.
- **Addons (P3)**: Does the documented local setup/request/cleanup flow show its promised output and clearly identify any simulated services?

### 3. LLM Agent Domain

- **Boundary first**: Is the SUT the orchestrator, a provider adapter, or the tool executor? Malformed caller arguments and a malformed upstream model response need different routing. A remote rejection alone does not establish a dependency Fault.
- **Functional (P0)**: Which observable task results, permitted tool effects, streaming/cancellation outcomes, and input partitions are defined? Derive context boundaries from the actual provider contract, including history/tool/schema overhead and reserved output where applicable; a percentage chosen by the method is not a boundary.
- **Design (P1)**: Which run/checkpoint states, tool/delegation limits, permission-before-execution handoffs, and parallel session-memory ownership rules must hold? Use the designed stop/recovery behavior rather than assuming a universal planning loop.
- **Quality (P2)**: Which latency/cost budgets, repeated-run invariants, supported model/tool-schema versions, settings, trace/redaction fields, and sandbox policies exist? Separate deterministic tool/state checks from source-defined model-output evaluation, recording fixtures, variability, and acceptance criteria. An agent's own success claim is not evidence.
- **Addons (P3)**: Does the guide distinguish recorded/fake provider responses from live calls, explain permissions/cost prerequisites, and expose the promised result and cleanup?

## Test-Point Ledger

Keep one `discovery_ledger` in living comments, alongside the inventory and coverage matrix. Use stable local TP IDs distinct from US/AC/TC IDs. Each row represents a specific condition and observable obligation, not just a category name.

| Field | Required content |
| --- | --- |
| TP ID and rule/source | Stable TP ID; source reference and rule ID, or evidence reference plus missing-source question. |
| Scenario | Concrete inputs, state, relevant environment/dependencies, and action. |
| Oracle | Expected observable result and important promised side effects/non-effects; write unknown if unresolved. |
| Verification method | Automated, manual, or hybrid procedure; execution environment and evidence capture. |
| Category and test level | Owning verification lens and intended verification boundary; provisional when unresolved. |
| Scope and routing | In-scope or out-of-scope relative to this review; destination artifact/work item and owner when handing off. Unresolved scope must be a QUESTION. |
| Disposition and evidence | One disposition below, with actual links, rationale, question, or destination. |

| Disposition | Meaning and required evidence |
| --- | --- |
| DESIGNED | Linked category file plus US/AC/TC IDs actually specify this scenario and oracle. TODO TCs count as designed, not implemented or GREEN. |
| QUESTION | Missing/conflicting source, expected behavior, or scope decision. Record the question and decision owner, or ask who owns it. Do not invent a TC expectation. |
| EXCLUDED | Source-backed not-applicable condition or explicit developer-approved scope exclusion, with rationale and approval reference. Difficulty or low execution priority is not an exclusion. |
| REFERRED | An accepted out-of-scope handoff with its scope boundary, reason, concrete destination artifact/work item, and responsible owner. A pending ownership decision is QUESTION. Referral is not designed or verified coverage in this scope. |
| GAP | A known in-scope source-backed point has no adequate TC. Name what must be designed; a weak oracle or a dangling TC link is also a gap. |

Routing is independent of disposition. An in-scope point awaiting a TC at another test level stays GAP (or QUESTION if its source/oracle/ownership is unresolved), with the destination recorded separately. Once that design is linked and adequate, it is DESIGNED. Use REFERRED only for an accepted handoff outside the declared scope; never duplicate a TP ID merely to record its destination.

Handoff acceptance never changes scope. Only an explicit developer-approved scope change can move an existing obligation out of scope; accepting an integration-test work item is not that approval. For a known source-backed obligation:

| Situation in the current review | Disposition | Evidence to retain |
| --- | --- | --- |
| In scope; destination/owner accepted; no adequate TC | GAP | Source obligation plus the accepted destination; design is still missing. |
| In scope; adequate destination TC linked | DESIGNED | Actual source-backed setup/oracle and US/AC/TC links, even if execution is still TODO. |
| Explicitly out of scope; destination/owner accepted | REFERRED | Declared scope boundary (and approval if scope changed), destination, and owner; not coverage. |
| Applicability, scope, source, oracle, or ownership unresolved | QUESTION | The specific decision and responsible owner; unresolved in-scope questions block readiness. |

Every source rule and every applicable sweep dimension must link to ledger rows; each row must have a disposition. Multiple TCs may be needed per rule. A TC may support several rows only when its setup and assertions genuinely distinguish those obligations.

**accounted for does not mean covered**: QUESTION, EXCLUDED, REFERRED, and GAP are not DESIGNED. Do not report their sum as coverage. Missing-source `@[NoTestPoints]` requires a QUESTION; genuine inapplicability requires an EXCLUDED rationale. Neither silently removes the category file.

## Discovery Gate

Run this gate in addition to the US -> AC -> TC cardinality gate:

1. **Source -> design**: every in-scope operation, model rule, quality predicate, and guide outcome is inventoried; every applicable P0/P1/P2/P3 sweep dimension has ledger evidence. Look for omitted behaviors even when existing TCs all have valid links.
2. **Design -> source**: each DESIGNED row resolves to a real TC with source-backed setup, oracle, and verification procedure. Detect wrong categories, duplicates, missing observations/assertions, and invented expectations. Manual evidence and exact symbolic predicates are valid when specified.
3. **Independent challenge**: derive expected behavior from the sources before consulting the designer's ledger/skeletons, preferably with a second reviewer. A solo developer/agent must perform a separate source-first pass and label it self-review, with shared-blind-spot risk explicit. Record reviewer/process, sources examined, and a source-derived operation/outcome checklist reconciled against the ledger; a bare "reviewed" flag is insufficient. Ask, "Which realistic scenario could violate this contract while every proposed test still passes?" Record source-backed findings; turn unsupported hypotheses into questions.
4. **Disposition audit**: review unknowns, exclusions, unexamined evidence, sampling omissions, and routing. An unimplemented designed TC is not a missing point. An in-scope obligation in any class remains GAP until adequate design is linked, even if another category or test level will execute it. Unknown source/oracle/scope or unresolved handoff ownership remains QUESTION. An accepted out-of-scope handoff is REFERRED and visible follow-up, not covered behavior or release readiness.
5. **Stop and report**: perform one discovery sweep and one independent challenge; allow at most two repair/recheck rounds. Stop earlier on missing intent or no progress. Never loop until a desired PASS appears; report remaining gaps and ask for the needed decision.

Report separately:

```text
Scope/SUT, in-scope classes, domain profile(s), and source references: ...
Inventory and discovery_ledger location: ...
Verification methods / execution environments / evidence capture: ...
Dimensions considered / sampling limits: ...
Review provenance and source-derived checklist: ...
Disposition counts: DESIGNED / QUESTION / EXCLUDED / REFERRED / GAP
Cardinality gate: PASS | FAIL
discovery_status: PASS | GAPS | BLOCKED
ready_for_implementation: yes | no
Review evidence, open questions, referrals, residual risk, next action: ...
```

Use BLOCKED when an in-scope source, oracle, ownership, or scope decision is unresolved; otherwise GAPS when known obligations or required review evidence are missing; otherwise PASS **for the declared scope and reviewed sources only**. `ready_for_implementation: yes` requires both gates to pass and the independent review to be complete. All unresolved in-scope questions block readiness across P0/P1/P2/P3, not just high-risk ones. A developer-approved smaller slice can be reviewed separately, but must not be reported as the whole feature being complete. Passing this design gate is not proof of test execution, target-equipment availability, or release readiness.

### Report Consistency Audit

Before returning the report:

- Re-read the cited rule for every QUESTION. If it already specifies the result, replace the question with DESIGNED or GAP evidence; if sources actually conflict, cite both. Unclear applicability within the requested scope remains a blocking scope question until resolved, not an assumed exclusion.
- Count dispositions from the full ledger, one per TP ID. Totals must match actual rows; when presenting only a sample, label it partial and link the full ledger or omit totals. Every handoff needs routing evidence on its existing row. Only accepted out-of-scope handoffs use REFERRED; in-scope GAP/QUESTION rows retain their disposition and destination together.
- Apply status precedence explicitly: any unresolved in-scope source/oracle/ownership/scope question -> BLOCKED; otherwise any known design/review gap -> GAPS; otherwise PASS. BLOCKED takes precedence even when known gaps also exist. Report both kinds of findings; non-PASS always means `ready_for_implementation: no`.
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

- The Behavior Inventory, applicable P0/P1/P2/P3 discovery sweeps, and Test-Point Ledger are available in living comments.
- Every example has a source-backed rule.
- Every rule's distinct outcomes and relevant conditions have concrete examples or explicit dispositions, not merely one example by quota.
- Every unresolved question is visible and not silently converted into a test.
- Every example is routed by verification lens, not by implementation proximity.
- P2 examples have source-defined thresholds or exact matrix/policy/evidence predicates; verification methods and environments are explicit.
- Q1/Q2/Q3/Q4 have been considered as a balance check where the feature risk justifies it.
- The Discovery Gate is reported separately from cardinality; unknowns and residual risks are not claimed as coverage.
