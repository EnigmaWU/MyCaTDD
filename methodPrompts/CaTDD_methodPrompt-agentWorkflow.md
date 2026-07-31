# CaTDD Method Prompt - Agent Workflow

This subtopic defines how a CodeAgent should use CaTDD without skipping design, traceability, or RED/GREEN discipline.

## Phase 1: Understanding

Objective: gather enough context to design tests without guessing product intent.

Checklist:

- Read the component interface files.
- Read relevant usage, detail, state, error, resource, performance, compatibility, diagnosis, or verification design docs.
- Review nearby tests and fixtures.
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
- Capture freely drafted scenarios.
- Build a coverage matrix.
- Classify test points using `CaTDD_methodPrompt-categorySemantics.md`.
- Write US/AC/TC comments.
- Populate TODO/tracking status.
- Stop if a category lacks source evidence and the developer has not approved `@[NoTestPoints]`.

Checkpoint summary:

```text
CaTDD design complete for [component].
US count: [n]
AC count: [n]
TC count: [n]
Category distribution: [P0/P1/P2/P3]
Blocked categories: [list]
Ready for RED/GREEN: yes/no
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

- Design before code.
- Ask when source intent is missing.
- Keep category identity stable even when risk changes execution order.
- Keep comments synchronized with behavior.
- Use small RED/GREEN slices.
- Preserve existing user edits and unrelated work.

## Agent DON'T Rules

- Do not invent acceptance criteria.
- Do not write production code before a failing test exists.
- Do not move tests into a category because implementation code is nearby.
- Do not silently omit a category file.
- Do not expand a TC beyond its AC meaning during refactor.
- Do not treat P1/P2 as lower value; they are different confidence lenses.
