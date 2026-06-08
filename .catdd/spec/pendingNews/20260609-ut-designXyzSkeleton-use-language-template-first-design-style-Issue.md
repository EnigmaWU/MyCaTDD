# Issue: UT_designXyzSkeleton should use language template as first-design-style

Imported via SPEC_importIssue on 2026-06-09.

## Source

"UT_designXyzSkeleton SHOULD use language template such as #file:CaTDD_designAndImplTemplate.cxx , follow and treat the template file as first-design-style"

## Classification

- Type: design-template constraint / workflow policy issue.
- Area: UT design skeleton generation and language-template selection.
- Severity: P1 - important for consistency of verification-design outputs.

## Observed Behavior

Without an explicit template-first rule, UT skeleton generation may drift across ad hoc formats and lose alignment with the CaTDD first-design comment skeleton style.

## Expected Behavior

1. `UT_designXyzSkeleton` uses a language template during skeleton generation.
2. A template like `methodPrompts/CaTDD_designAndImplTemplate.cxx` is treated as first-design-style guidance.
3. The generated skeleton preserves CaTDD design-first structure before implementation details.

## Related

- `methodPrompts/CaTDD_designAndImplTemplate.cxx`
- `methodPrompts/CaTDD_methodPrompt.md`
- `slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md`

## Open Clarification

- Should this template-first policy be mandatory for all language targets, or mandatory only when a matching language template exists?

## Next Recommended Command

`/SPEC_analyzeIssue`