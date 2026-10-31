# CaTDD Method Prompt - Agent Workflow

This subtopic defines how a CodeAgent should use CaTDD without skipping design, traceability, or RED/GREEN discipline.

## Phase 1: Understanding

Objective: gather enough context to design tests without guessing product intent.

Checklist:

- Read the component interface files.
- Read relevant usage, detail, state, error, resource, performance, compatibility, diagnosis, or verification design docs.
- Inventory source-backed operations/rules before reviewing nearby tests and fixtures as coverage evidence.
- Consult available usage/deployment/incident evidence for overlooked conditions; record unavailable evidence and unknown expectations explicitly.
- Identify dependencies, build commands, and test commands.
- Ask the developer when product behavior, acceptance criteria, or category source evidence is missing.

Checkpoint summary:

```text
I analyzed [component].
SUT: [system/module/function]
Relevant sources: [files]
Main behaviors: [list]
Open questions: [list]
Ready for CaTDD design: yes/no
```

## Phase 2: Design Comments First

Objective: write the living design before writing executable test code.

Checklist:

- Fill the OVERVIEW section.
- Declare SUT explicitly.
- Apply [CaTDD_methodPrompt-testPointDiscovery.md](CaTDD_methodPrompt-testPointDiscovery.md): capture freely drafted scenarios, systematic discovery dimensions, and a coverage matrix.
- Keep the authoritative `discovery_ledger` in the verification-design document, with owning ACs, covering TC links, or explicit questions, exclusions, referrals, and gaps. Test comments reference its TPs and define TCs.
- Resolve each Story ID/StoryIdAlias pair through the registry before allocating alias-qualified AC/TP/TC IDs; preserve existing identities and creation times.
- Classify test points using `CaTDD_methodPrompt-categorySemantics.md`.
- Write US/AC/TC comments.
- Populate TODO/tracking status.
- Perform a source-first independent challenge and pass the **Discovery Gate** as well as cardinality before declaring readiness.
- Stop if in-scope behavior lacks source evidence or an oracle. A missing-source `@[NoTestPoints]` cannot bypass this gate; an explicitly narrowed scope must be reported as a smaller slice.

Checkpoint summary:

```text
CaTDD design assessment for [component and declared scope].
Inventory/discovery_ledger: [location]
US count: [n]
AC count: [n]
TC count: [n]
Category distribution: [P0/P1/P2/P3]
Disposition counts: [DESIGNED / QUESTION / EXCLUDED / REFERRED / GAP]
Cardinality gate: [PASS/FAIL]
discovery_status: [PASS/GAPS/BLOCKED]
Independent review evidence and residual risk: [references/list]
Blocked categories: [list]
ready_for_implementation: yes/no
```

## Phase 3: Implementation

Objective: implement one TC at a time using RED/GREEN.

Checklist:

- Select one TODO TC.
- Write only the test needed for that TC.
- Run the test and confirm RED for the intended reason.
- Implement the minimum production change to make it GREEN.
- Run the focused test and relevant regression scope.
- Update TC status.
- Refactor comments, test code, and production code in that order.

Do not batch multiple unrelated TCs into one implementation step.

## Phase 4: Finalization

Objective: finish with traceable design, passing tests, and visible residual risk.

Checklist:

- Verify US -> AC -> TC traceability.
- Reconcile source -> discovery ledger -> US/AC/TC after any changed requirement or newly discovered scenario; do not infer completeness from GREEN tests.
- Verify category file placement.
- Verify `@[NoTestPoints]` decisions are explicit.
- Run focused and relevant broader tests.
- Summarize coverage, open gaps, and next recommended category.

Final report shape:

```text
CaTDD work complete for [component].
Tests implemented: [count]
Passing: [yes/no]
Categories covered: [list]
No-test-points decisions: [list]
Residual risk: [list]
Next step: [recommendation]
```

## Agent DO Rules

- **MUST** design living comments before writing executable test or production code.
- **MUST** ask via `ONE-MORE-THING` when source intent, expected outcome, or modal obligation (`MUST` vs `SHOULD` vs `MAY`) is missing.
- **MUST** keep category identity stable even when risk changes execution order.
- **MUST** use canonical terminology from `README_UbiLang.md` and keep comments synchronized with behavior.
- **MUST** use small RED/GREEN slices verified through the Semantic Falsification Gate (`🔴 RED` on domain assertion, never `⚠️ BROKEN_TEST`).
- **MUST** preserve existing user edits and unrelated work.

## Agent DON'T Rules

- **MUST NOT** invent acceptance criteria, thresholds, or fallback branches.
- **MUST NOT** write production code before a valid `🔴 RED` failing test exists.
- **MUST NOT** move tests into a category because implementation code is nearby.
- **MUST NOT** silently omit a category file or introduce synonym drift against `README_UbiLang.md`.
- **MUST NOT** expand a TC beyond its AC meaning during refactor.
- **MUST NOT** treat P1/P2 as lower value; they are different confidence lenses.
