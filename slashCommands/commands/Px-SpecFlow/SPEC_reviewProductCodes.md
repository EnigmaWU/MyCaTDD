# SPEC_reviewProductCodes

## Purpose

Review product code, tests, and traceability before post-product-code unit-test implementation review, commit, or abort routing.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the changed product and test files, reason about behavior, traceability to README SPEC docs, minimality, and quality risk, produce a review finding, and verify that the finding clearly routes to the next action (commit, return to design/test work, abort, or ask the developer). The reasoning loop stops when all review criteria are explicitly addressed or a quality failure is reported.

### ReACT Execution

Repeat until all four review criteria are explicitly addressed.

1. **Thought** — Read `changed_files` against `doing_user_story` and `readme_spec_files`. Check four criteria in order: correctness, traceability to a README SPEC doc, minimality, and quality risk.
2. **Action** — Write the verdict — `pass`, `update design`, `add tests`, `abort story`, or `ask developer` — with findings ordered by those criteria.
3. **Observation** — Check that `verification_output` explains the result, and that each finding names a file and a route. Code changed but traced to no README SPEC doc, or an unexplained verification gap, returns to **Thought**.
4. **Stop** — Exit on a stable verdict. On `pass`, report `next_command = SPEC_reviewImplUnitTests`; never route straight to `SPEC_commitStoryWorks`.

### Worked Example

Product code was just implemented against RED tests:

```text
/SPEC_reviewProductCodes
changed_files: services/payment/gatewayPort.ts, services/payment/adapters/stripe.ts
doing_user_story: .catdd/spec/doingUS/20260904-multi-gateway-UserStory.md
verification_output: 12 passing, 0 failing
```

Expected result:

- **Thought**: correctness — tests now GREEN and each maps to an AC. Traceability — `gatewayPort.ts` matches `README_DetailDesign.md`, but `stripe.ts` adds a response cache that appears in no design doc. Minimality — the cache is beyond the story. Quality risk — a cache on payment responses is a correctness hazard.
- **Action**: verdict `update design`; finding cites `stripe.ts` and the missing design entry.
- **Observation**: the finding names a file and a route → actionable. Verification is explained: GREEN is traceable to the implemented ACs.
- **Stop**: reported `next_command = SPEC_updateDetailDesign` — either document the cache or remove it. Commit is blocked.

## Inputs

- `changed_files`: product and test files changed for the active story.
- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `readme_spec_files`: optional project-root `README*` SPEC files relevant to the changed code.
- `verification_output`: test, lint, build, or manual verification output.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- `review_verdict`: `PASS` when the product code matches its design and tests and the next step is `SPEC_reviewImplUnitTests`; `REVISE` with `rework_route = SPEC_updateDetailDesign` for a design gap, `SPEC_designUnitTests` for missing coverage, or `SPEC_abortUserStory` when the story must be abandoned; `ASK` when the developer must decide; `BLOCKED` when the design or verification evidence needed for the review is unavailable.
- `severity`: optional `blocking | advisory`, defaulting to `blocking`.
- Findings prioritized by correctness, traceability to project-root README SPEC docs, and quality risk.
- Next recommended command: `SPEC_reviewImplUnitTests` when product-code review passes, `SPEC_updateDetailDesign`, `SPEC_designUnitTests`, `SPEC_abortUserStory`, or `SPEC_importIssue`.

## Review Gate Contract

- Reviews: product code and its traceability to the approved design and to the tests that prove it.
- Does not: review the test implementation itself (that lens belongs to `SPEC_reviewImplUnitTests`), fix code, redesign, or commit.
- `review_verdict`: exactly one of `PASS`, `REVISE`, `BLOCKED`, or `ASK` per pass. `ASK` brings the human developer into the loop and is the same outcome `ONE-MORE-THING` produces.
- `severity`: optional `blocking | advisory` (default `blocking`); `advisory` marks findings that do not stop the gate.
- `rework_route`: required whenever the verdict is not `PASS`; it names the owning command for each finding.
- Read-only by default: report and route. Do not repair the reviewed artifact unless the developer explicitly approves a repair.
- Source-first: read the upstream source artifact before judging the artifact under review.
- Every finding cites a file, an ID, or a verification signal; an uncitable finding is dropped or chased with one more read.
- One verdict per pass, stable across passes; a repeat pass with identical findings and no changed evidence is the last pass.
- Rework is bounded by `max_rework_attempts` (default `3`) and the `Px-SpecFlow` Loop Guard stop conditions.
- Report `next_command = <COMMAND>` whenever the verdict is not `PASS`. The mapping from older verdict wording lives in the flow's Review Gate Contract table.

## Loop Guard

Rework routes from this review to `SPEC_updateDetailDesign` or `SPEC_designUnitTests` must record structured findings. Each `impl -> review -> rework` cycle is bounded by `max_rework_attempts` (default `3`) and the `Px-SpecFlow` Loop Guard stop conditions: after repeated no-progress or exhausted attempts, route to `SPEC_abortUserStory` or `ASK`, never a third silent retry. Do not claim product-code review progress without changed evidence between passes.

## Conflict Guard

Do not commit when quality is not met or when verification evidence is missing without explanation. Do not route directly to `SPEC_commitStoryWorks`; run `SPEC_reviewImplUnitTests` after product-code review when product code changed.

ONE-MORE-THING: ask developer if something not sure
