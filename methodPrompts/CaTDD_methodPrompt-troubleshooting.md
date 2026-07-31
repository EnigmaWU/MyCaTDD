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

1. Rebuild the US -> AC -> TC chain.
2. Reclassify the test point using `CaTDD_methodPrompt-categorySemantics.md`.
3. Ask whether the missing behavior belongs in the current story or a sub-story.
4. Mark `@[NoTestPoints]: <reason>` only when the category was deliberately considered.

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
