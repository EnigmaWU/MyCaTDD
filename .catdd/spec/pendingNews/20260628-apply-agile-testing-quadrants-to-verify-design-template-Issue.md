# Issue: apply Agile Testing Quadrants to verification-design workflow and template

Imported via SPEC_importIssue on 2026-06-28.

## Source

Developer request:

> I want use 'apply-agile-testing-quadrants' SKILL in .github/skills dir to improve existing README_VerifyDesign, do you know what I mean?

Follow-up correction:

> No No No, not modify directly, but use .github/prompts/SPEC_importIssue.prompt.md, let this as pendingNews, also don't forget slashCommands/templates/README_VerifyDesignTemplate.md

Clarification:

> I want use CaTDD's category method X agile testing's Q1/2/3/4

Follow-up clarification:

> README_VerifyDesign is design. It takes WHAT verification constraints we must meet as WHY, then designs what strategy and how tests meet the goal. It is not a test trace.

Additional artifact clarification:

> Add `README_VerifyStatusTraces.md` as the dynamic part of `README_VerifyDesign.md`.

Session context used for import:

- Skill requested: `.github/skills/apply-agile-testing-quadrants/SKILL.md`
- Skill detail files reviewed:
  - `.github/skills/apply-agile-testing-quadrants/details/quadrant-examples.md`
  - `.github/skills/apply-agile-testing-quadrants/details/test-planning-checklist.md`
- Prompt wrapper requested: `.github/prompts/SPEC_importIssue.prompt.md`
- Portable command followed: `slashCommands/commands/Px-SpecFlow/SPEC_importIssue.md`
- Existing verification design target: `README_VerifyDesign.md`
- Proposed dynamic verification status/trace target: `README_VerifyStatusTraces.md`
- Verification design template target: `slashCommands/templates/README_VerifyDesignTemplate.md`
- Proposed verification status/trace template target: `slashCommands/templates/README_VerifyStatusTracesTemplate.md`
- Active story context: `.catdd/spec/doingUS/20260628-utCodeAgentCLI-US-USER-01-UserStory.md`

## Classification

- Type: documentation-template / workflow improvement request.
- Area: verification design semantics, SpecFlow issue intake, CaTDD category method, Agile Testing Quadrants guidance.
- Severity: P2 - improves consistency and prevents direct ad hoc README updates.

## Observed Behavior

`README_VerifyDesign.md` can be updated directly with test strategy improvements, which may bypass the intended SpecFlow intake path.

The current `slashCommands/templates/README_VerifyDesignTemplate.md` focuses on CaTDD category coverage, US/AC/TC traceability, risks, and embedded/media verification points. This can make `README_VerifyDesign.md` look like a test-trace ledger instead of a verification design artifact.

The intended role of `README_VerifyDesign.md` is different:

- It starts from WHAT verification constraints, acceptance concerns, design constraints, and risk constraints must be satisfied.
- It uses those constraints as WHY the verification strategy exists.
- It designs WHICH CaTDD categories and Agile Testing Quadrants are needed.
- It explains HOW the selected UnitTesting, ModuleTesting, UserTesting, automated checks, manual checks, or exploratory checks meet the verification goal.
- It may reference `README_VerifyStatusTraces.md`, US/AC/TC story artifacts, or test files as evidence/handoff, but it should not duplicate the detailed changing trace.

The proposed role of `README_VerifyStatusTraces.md` is the dynamic companion:

- It records current US/AC/TC/test-file status, RED/GREEN/REVIEWED markers, execution commands, run results, and temporary gaps.
- It changes as implementation and verification progress.
- It inherits the strategy from `README_VerifyDesign.md` instead of redefining the verification design.
- It is allowed to be trace-led because its purpose is status and evidence, not design rationale.

The current template also does not explicitly guide authors to apply Agile Testing Quadrants as a balancing taxonomy across:

- Q1 Technology / Support.
- Q2 Business / Support.
- Q3 Business / Critique.
- Q4 Technology / Critique.

The intended improvement is not to replace CaTDD categories with Agile Testing Quadrants. It is to combine them as two axes:

- CaTDD category method identifies priority and test category, such as P0 Functional Typical/Edge/Misuse/Fault, P1 Design, and P2 Quality.
- Agile Testing Quadrants identify test intent and audience, such as technology-facing/business-facing and support-the-team/critique-the-product.

## Expected Behavior

Verification-design improvements discovered during a session should first be imported as pending issue/news input under `.catdd/spec/pendingNews/`.

The later analysis and implementation flow should consider both:

- Updating `README_VerifyDesign.md` only through the proper SpecFlow lifecycle.
- Updating `slashCommands/templates/README_VerifyDesignTemplate.md` so future verification designs remember to include Agile Testing Quadrants guidance where appropriate.
- Reframing `README_VerifyDesign.md` as a design document, not a test trace document.
- Adding `README_VerifyStatusTraces.md` as the dynamic companion artifact for live trace/status/evidence details.
- Adding `slashCommands/templates/README_VerifyStatusTracesTemplate.md` if a reusable template is needed for the dynamic companion.

The expected design flow should answer:

| Design question | README_VerifyDesign responsibility |
| --- | --- |
| WHAT must be verified? | Capture verification constraints from US/AC intent, architecture/detail design, failure modes, quality envelopes, and domain constraints. |
| WHY this verification is required? | Explain the risk, contract, or product goal that makes each verification area necessary. |
| WHICH strategy applies? | Select CaTDD priority/category coverage and Agile Testing Quadrants as complementary design axes. |
| HOW will tests meet the goal? | Describe the intended test level, automation/manual balance, fixture/mocking boundary, exploratory need, and evidence expected from target test files. |
| WHERE is detailed trace kept? | Link to `README_VerifyStatusTraces.md` and story/test artifacts as evidence; do not turn this README into the canonical US/AC/TC status ledger. |

The expected artifact split should be:

| Artifact | Stability | Responsibility |
| --- | --- | --- |
| `README_VerifyDesign.md` | Stable design artifact | Verification constraints/goals, rationale, CaTDD x Agile Quadrants strategy, test approach design, mocking/fixture/level decisions, and evidence handoff links. |
| `README_VerifyStatusTraces.md` | Dynamic status artifact | Live US/AC/TC/test-file mapping, current test statuses, execution commands/results, temporary gaps, and verification evidence snapshots. |

The expected template/design result should support a cross-mapping such as:

| CaTDD method axis | Agile quadrant axis | Verification-design meaning |
| --- | --- | --- |
| P0 Functional Typical/Edge/Misuse/Fault | Q1 and Q2 | Design automated developer and acceptance checks that prove the core contract and business behavior. |
| P0 Functional Edge/Misuse/Fault | Q3 | Design exploratory or user-facing critique for confusing, surprising, or abuse-prone flows. |
| P1 Design categories | Q1 and Q4 | Design internal checks for component contracts, architecture fitness, state/capability/concurrency behavior, and maintainability critique. |
| P2 Quality categories | Q4, sometimes Q3 | Design quality verification for performance, robustness, compatibility, configuration, security, and operational critique. |

The resulting guidance should make clear that quadrants are a taxonomy, not a sequence, and that Q3 is often manual/exploratory rather than always automated.

The `README_VerifyDesign.md` template should prefer sections such as `Verification Constraints and Goals`, `Strategy Selection`, `CaTDD x Agile Quadrants Coverage`, `Test Approach Design`, and `Evidence Handoff` over a trace-led structure. If a US/AC/TC table remains, it should be explicitly labeled as a lightweight evidence handoff or summary, not the purpose of the document.

The `README_VerifyStatusTraces.md` companion can contain the trace-led structure that was removed or demoted from `README_VerifyDesign.md`, such as:

- Current story/test status summary.
- US/AC/TC to test-file mapping.
- Test command inventory and last-run evidence.
- Open trace gaps, planned cases, and review state.
- Links back to the governing verification design section that explains WHY the trace exists.

## Related

- `.github/prompts/SPEC_importIssue.prompt.md`
- `slashCommands/commands/Px-SpecFlow/SPEC_importIssue.md`
- `.github/skills/apply-agile-testing-quadrants/SKILL.md`
- `.github/skills/apply-agile-testing-quadrants/README.md`
- `.github/skills/apply-agile-testing-quadrants/details/quadrant-examples.md`
- `.github/skills/apply-agile-testing-quadrants/details/test-planning-checklist.md`
- `README_VerifyDesign.md`
- `README_VerifyStatusTraces.md`
- `slashCommands/templates/README_VerifyDesignTemplate.md`
- `slashCommands/templates/README_VerifyStatusTracesTemplate.md`
- `.catdd/spec/doingUS/20260628-utCodeAgentCLI-US-USER-01-UserStory.md`

## Open Clarification

- Should the Agile Testing Quadrants section become mandatory in every `README_VerifyDesign.md`, or only required when the story/test strategy has meaningful Q3/Q4 risk?
- Should the template update include a fixed quadrants table, a checklist, or a short optional section with guidance?
- Should the cross-mapping be represented as a single matrix in the template, or as an added `Quadrants` column in the existing CaTDD category coverage table?
- Should `README_VerifyStatusTraces.md` always be created with `README_VerifyDesign.md`, or only when there is non-trivial live trace/status data?
- Should `README_VerifyStatusTraces.md` be project-root only, module-local only, or allowed at both levels following the same ownership rule as `README_VerifyDesign.md`?

## Next Recommended Command

`/SPEC_analyzeIssue`
