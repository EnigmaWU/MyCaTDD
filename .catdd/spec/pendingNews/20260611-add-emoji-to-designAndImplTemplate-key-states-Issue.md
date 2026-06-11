# Issue: add emoji cues to designAndImplTemplate key states

Imported via SPEC_importIssue on 2026-06-11.

## Source

"add more 'emoji' in designAndImplTemplate for easy catch key point such as RED/GREEN/BLUE state"

## Classification

- Type: documentation/template usability issue.
- Area: CaTDD design+implementation templates.
- Severity: P2 - improves scanability and authoring ergonomics without changing CaTDD semantics.

## Observed Behavior

The current design+implementation template may be harder to scan quickly when readers need to catch key verification states such as RED, GREEN, and BLUE.

## Expected Behavior

1. The relevant `designAndImplTemplate` artifacts make key CaTDD states easier to visually catch.
2. RED, GREEN, and BLUE state markers are visually distinct in the template.
3. Added cues improve readability without redefining CaTDD method semantics.

## Related

- `methodPrompts/CaTDD_designAndImplTemplate.ts`
- `methodPrompts/CaTDD_designAndImplTemplate.cxx`
- `methodPrompts/CaTDD_methodPrompt.md`

## Open Clarification

- Which exact emoji markers should represent RED, GREEN, and BLUE in the templates?
- Should emoji cues be added to all language-specific design+implementation templates or only the TypeScript template first?

## Next Recommended Command

`/SPEC_analyzeIssue`