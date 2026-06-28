# Issue: align test-case-with-readme skill with CaTDD templates

Imported via SPEC_importIssue on 2026-06-28.

## Source

Our discussion on aligning the `test-case-with-readme` SKILL (defined in `.github/skills/test-case-with-readme/SKILL.md`) with CaTDD's test templates and prompts (such as `CaTDD_methodPrompt.md`'s `TC-n` template).

- Discussion: CaTDD's test with readme as this SKILL in prompts and templates, mapping `test-case-with-readme` as the automation and representation of the "test with readme" pattern in CaTDD.

## Classification

- Type: Integration / Method Alignment
- Area: CaTDD Method Prompts, Templates, and Git/IDE Skills
- Severity: P2 - Enhances automation and consistency of test case documentation across CaTDD.

## Observed Behavior

The `test-case-with-readme` skill exists under `.github/skills/test-case-with-readme/SKILL.md` to automate the generation of `*_readme.md` files. However, the relationship, mapping, and explicit references between the skill's generated `*_readme.md` files and the CaTDD method prompts/templates (such as the `TC-n` template in `CaTDD_methodPrompt.md` and language-specific templates) are not fully integrated or explicitly cross-referenced.

## Expected Behavior

1. The `test-case-with-readme` skill is recognized as the standard automation tool for generating and maintaining companion `*_readme.md` files for test cases under the CaTDD flow.
2. The mapping between the CaTDD `TC-n` template fields (`@[Name]`, `@[Purpose]`, `@[Brief]`, `@[Steps]`, `@[Expect]`, `@[Notes]`) and the skill's readme sections (`Purpose`, `Status`, `Covered`, `Manual`) is clearly documented and integrated into the templates and/or method prompts.
3. The method prompts and templates should explicitly mention or reference using the `test-case-with-readme` skill when designing, writing, or updating tests.

## Related

- `.github/skills/test-case-with-readme/SKILL.md`
- `methodPrompts/CaTDD_methodPrompt.md`
- `methodPrompts/CaTDD_designAndImplTemplate.ts`
- `methodPrompts/CaTDD_designAndImplTemplate.cxx`

## Open Clarification

- Should we update `CaTDD_methodPrompt.md` and the language templates (`.ts`, `.cxx`) to explicitly mention using this skill (e.g., via `@` references or inline instructions) during the test design/implementation phase?
- How does the skill parse the `TC-n` comments from the source file to automatically update the companion readme?

## Next Recommended Command

`/SPEC_analyzeIssue`
