# Issue: apply Agile Testing Quadrants to verification-design workflow and template

Imported via SPEC_importIssue on 2026-06-28.

## Source

Developer request:

> I want use 'apply-agile-testing-quadrants' SKILL in .github/skills dir to improve existing README_VerifyDesign, do you know what I mean?

Follow-up correction:

> No No No, not modify directly, but use .github/prompts/SPEC_importIssue.prompt.md, let this as pendingNews, also don't forget slashCommands/templates/README_VerifyDesignTemplate.md

Clarification:

> I want use CaTDD's category method X agile testing's Q1/2/3/4

Session context used for import:

- Skill requested: `.github/skills/apply-agile-testing-quadrants/SKILL.md`
- Skill detail files reviewed:
  - `.github/skills/apply-agile-testing-quadrants/details/quadrant-examples.md`
  - `.github/skills/apply-agile-testing-quadrants/details/test-planning-checklist.md`
- Prompt wrapper requested: `.github/prompts/SPEC_importIssue.prompt.md`
- Portable command followed: `slashCommands/commands/Px-SpecFlow/SPEC_importIssue.md`
- Existing verification design target: `README_VerifyDesign.md`
- Verification design template target: `slashCommands/templates/README_VerifyDesignTemplate.md`
- Active story context: `.catdd/spec/doingUS/20260628-utCodeAgentCLI-US-USER-01-UserStory.md`

## Classification

- Type: documentation-template / workflow improvement request.
- Area: verification design, SpecFlow issue intake, CaTDD category method, Agile Testing Quadrants guidance.
- Severity: P2 - improves consistency and prevents direct ad hoc README updates.

## Observed Behavior

`README_VerifyDesign.md` can be updated directly with test strategy improvements, which may bypass the intended SpecFlow intake path.

The current `slashCommands/templates/README_VerifyDesignTemplate.md` focuses on CaTDD category coverage, US/AC/TC traceability, risks, and embedded/media verification points. It does not explicitly guide authors to apply Agile Testing Quadrants as a balancing taxonomy across:

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

The expected template/design result should support a cross-mapping such as:

| CaTDD method axis | Agile quadrant axis | Meaning |
| --- | --- | --- |
| P0 Functional Typical/Edge/Misuse/Fault | Q1 and Q2 | Automated developer and acceptance checks that support implementation and verify business behavior. |
| P0 Functional Edge/Misuse/Fault | Q3 | Exploratory and user-facing critique of confusing, surprising, or abuse-prone flows. |
| P1 Design categories | Q1 and Q4 | Internal design checks, component contracts, architecture fitness, and maintainability critique. |
| P2 Quality categories | Q4, sometimes Q3 | Performance, robustness, compatibility, configuration, security, and operational critique. |

The resulting guidance should make clear that quadrants are a taxonomy, not a sequence, and that Q3 is often manual/exploratory rather than always automated.

## Related

- `.github/prompts/SPEC_importIssue.prompt.md`
- `slashCommands/commands/Px-SpecFlow/SPEC_importIssue.md`
- `.github/skills/apply-agile-testing-quadrants/SKILL.md`
- `.github/skills/apply-agile-testing-quadrants/README.md`
- `.github/skills/apply-agile-testing-quadrants/details/quadrant-examples.md`
- `.github/skills/apply-agile-testing-quadrants/details/test-planning-checklist.md`
- `README_VerifyDesign.md`
- `slashCommands/templates/README_VerifyDesignTemplate.md`
- `.catdd/spec/doingUS/20260628-utCodeAgentCLI-US-USER-01-UserStory.md`

## Open Clarification

- Should the Agile Testing Quadrants section become mandatory in every `README_VerifyDesign.md`, or only required when the story/test strategy has meaningful Q3/Q4 risk?
- Should the template update include a fixed quadrants table, a checklist, or a short optional section with guidance?
- Should the cross-mapping be represented as a single matrix in the template, or as an added `Quadrants` column in the existing CaTDD category coverage table?

## Next Recommended Command

`/SPEC_analyzeIssue`
