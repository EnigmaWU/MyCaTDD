# Issue: rename CaTDD_ImplTemplate and add TypeScript design+impl template

Imported via SPEC_importIssue on 2026-06-08.

## Source

rename 'CaTDD_ImplTemplate.cxx' to 'CaTDD_designAndImplTemplate.cxx', and add new 'CaTDD_designAndImplTemplate.ts' in methodPrompts

## Classification

- Type: refactor / template extension request.
- Area: `methodPrompts/`.
- Severity: P2 - improves naming clarity and language coverage.

## Observed Behavior

The current template is named `CaTDD_ImplTemplate.cxx`, which does not clearly express design+implementation intent. There is no TypeScript counterpart under `methodPrompts/`.

## Expected Behavior

1. Rename `methodPrompts/CaTDD_ImplTemplate.cxx` to `methodPrompts/CaTDD_designAndImplTemplate.cxx`.
2. Add new `methodPrompts/CaTDD_designAndImplTemplate.ts`.
3. Keep template intent aligned across C++ and TypeScript variants.

## Related

- `methodPrompts/CaTDD_ImplTemplate.cxx`
- `methodPrompts/CaTDD_methodPrompt.md`
- `methodPrompts/`

## Next Recommended Command

`/SPEC_analyzeIssue`
