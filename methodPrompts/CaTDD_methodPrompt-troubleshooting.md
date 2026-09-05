# CaTDD Method Prompt - Troubleshooting

This subtopic helps agents and developers recover when CaTDD design or implementation gets stuck.

## Issue 1: Test Compilation Fails

Symptoms:

- Missing types, functions, imports, or headers.
- Undefined references or module resolution errors.
- Test framework symbols unavailable.

Resolution:

1. Re-read the SUT interface.
2. Check imports/includes and build configuration.
3. Compare with nearby working tests.
4. Verify the selected test framework and language template.
5. If the API is genuinely missing, keep the TC RED and implement the minimum production code.

## Issue 2: Test Design Seems Incomplete

Symptoms:

- TC does not trace to an AC.
- AC does not trace to a US.
- Category has no source-of-truth artifact.
- Coverage matrix exposes an unhandled scenario.

Resolution:

1. Rebuild the behavior inventory from sources, not only the existing US -> AC -> TC chain. Use [CaTDD_methodPrompt-testPointDiscovery.md](CaTDD_methodPrompt-testPointDiscovery.md).
2. Sweep missing conditions and outcomes, reconcile the discovery ledger, and repair linkage gaps separately.
3. Reclassify by verification lens and ask whether missing behavior belongs in the current story or a sub-story.
4. Mark `@[NoTestPoints]: <reason>` only after explicit consideration. Missing source remains QUESTION/BLOCKED, not a passed discovery gate.

## Issue 3: Production Behavior Is Unclear

Symptoms:

- Edge behavior is ambiguous.
- Error code or diagnostic is unknown.
- State transition is not designed.
- Performance or compatibility threshold is missing.

Resolution:

1. Look for UsageDesign, DetailDesign, StateDesign, ErrorDesign, PerfDesign, CompatDesign, DiagnosisDesign, or VerifyDesign.
2. If the source artifact is missing, ask the developer.
3. Do not make up thresholds or business rules.
4. Preserve the question in the test design comments.

## Issue 4: Test Fails Unexpectedly

Symptoms:

- Test fails for setup rather than behavior.
- Test fails due to environment or dependency issue.
- Multiple assertions hide the real failure.

Resolution:

1. Confirm the failure is in SETUP, BEHAVIOR, VERIFY, or CLEANUP.
2. Reduce to the smallest focused TC.
3. Keep no more than three key assertions.
4. If the world failed while caller behavior was valid, classify as Fault.
5. If the caller contract is invalid, classify as Misuse.

## Issue 5: Unable To Proceed

Symptoms:

- Required source docs are absent.
- Product intent conflicts with implementation.
- Test category cannot be justified.

Resolution:

1. Stop writing test code.
2. Record the blocking question.
3. Ask the developer for the missing source or approval to mark `@[NoTestPoints]`.
4. If the story itself is unsafe or incoherent, route back to SpecFlow story/design review.

## Issue 6: Test Passes When It Should Be RED

Symptoms:

- New TC passes immediately.
- Test does not exercise missing behavior.
- Existing implementation accidentally satisfies the assertion.

Resolution:

1. Verify the TC expectation really proves the AC.
2. Strengthen setup or observable verification.
3. Confirm the test would fail if the behavior were removed.
4. If behavior already exists, mark the TC as existing coverage and run regression instead of forcing fake RED.

## Issue 7: Deployment Finds a Missing Test Point

Symptoms:

- Every written US/AC/TC is linked, but a production scenario has no corresponding test design.
- Mocks hide a relevant dependency outcome or deployment difference.
- The same kind of escaped bug recurs across related operations.

Resolution:

1. Follow **Escaped-Bug Feedback** in [CaTDD_methodPrompt-testPointDiscovery.md](CaTDD_methodPrompt-testPointDiscovery.md).
2. Distinguish a missing requirement or discovery point from a weak oracle, unimplemented test, or test not run in the relevant environment.
3. Confirm expected behavior, add the source-backed regression skeleton, then follow RED/GREEN for the fix.
4. Record the reusable discovery question that was missed and review neighboring scenarios; do not merely add one incident-specific TC and declare completeness.

## Decision Tree

```text
Problem found
  -> Is product intent unclear?
       yes: ask developer / update story or design
       no: continue
  -> Is category source missing?
       yes: ask for source or mark NoTestPoints
       no: continue
  -> Is test failing for setup/tooling?
       yes: repair local test harness
       no: continue
  -> Is test failing for intended behavior?
       yes: implement minimal production change
       no: reclassify or split the TC
```

## General Principles

- Prefer a focused failing check over broad debugging.
- Preserve category identity while debugging.
- Treat design comments as living evidence, not decoration.
- Keep blockers visible instead of burying them in implementation choices.
