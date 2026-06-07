# User Story: methodPrompts rename design+impl template and add TypeScript counterpart

Created by `/SPEC_analyzeIssue` on 2026-06-08.
Analyzed from `.catdd/spec/analyzedNews/20260608-rename-CaTDD-ImplTemplate-and-add-ts-template-Issue.md`.

## Source Trace

- Raw issue archive: [../analyzedNews/20260608-rename-CaTDD-ImplTemplate-and-add-ts-template-Issue.md](../analyzedNews/20260608-rename-CaTDD-ImplTemplate-and-add-ts-template-Issue.md)
- Related area: `methodPrompts/`
- Related reference: `methodPrompts/CaTDD_methodPrompt.md`

## Active Work Status

- Status: CLOSED.
- Active state: `.catdd/spec/doneUS/` completed artifact.
- Priority: P2 - improves naming clarity and language coverage.
- Confidence: high.
- Next recommended command: `/SPEC_analyzeIssue`.

## Story

As a template maintainer,
I want the design+implementation template naming to be explicit and language-balanced,
so that users can discover and apply equivalent CaTDD templates in both C++ and TypeScript.

## Observed Behavior

- The current C++ template name `CaTDD_ImplTemplate.cxx` does not clearly express design+implementation intent.
- There is no TypeScript design+implementation template in `methodPrompts/`.

## Expected Behavior

1. Rename `methodPrompts/CaTDD_ImplTemplate.cxx` to `methodPrompts/CaTDD_designAndImplTemplate.cxx`.
2. Add `methodPrompts/CaTDD_designAndImplTemplate.ts`.
3. Keep intent and usage semantics aligned across C++ and TypeScript variants.

## Independent Test Intent

A reviewer can inspect `methodPrompts/` and verify that the old C++ template path is replaced by the new explicit name, a TypeScript counterpart exists, and both templates communicate the same design+implementation purpose.

## Acceptance Criteria

### AC-01: C++ template uses explicit design+implementation naming
- **Given** the repository `methodPrompts/` directory
- **When** template files are listed
- **Then** `CaTDD_ImplTemplate.cxx` is no longer present
- **And** `CaTDD_designAndImplTemplate.cxx` exists

### AC-02: TypeScript counterpart template exists
- **Given** the repository `methodPrompts/` directory
- **When** template files are listed
- **Then** `CaTDD_designAndImplTemplate.ts` exists

### AC-03: Cross-language intent remains aligned
- **Given** the C++ and TypeScript design+implementation templates
- **When** their purpose sections are reviewed
- **Then** both describe the same design+implementation workflow intent
- **And** neither conflicts with `CaTDD_methodPrompt.md`

## Edge Cases

- Existing docs or scripts may still reference the old file name.
- Tooling that expects only `.cxx` templates should not break when `.ts` template is added.

## Scope

In scope:

- Rename of the C++ template file.
- Addition of a TypeScript design+implementation template.
- Minimal doc/reference alignment needed for path correctness.

Out of scope:

- Broader restructuring of methodPrompts taxonomy.
- Changes to unrelated slash commands or code agent runtime behavior.

## Non-Goals

- Redesigning CaTDD method semantics.
- Introducing new category definitions.

## Risks

- Broken references to the old C++ template path.
- Divergence of purpose text between C++ and TypeScript templates over time.

## Assumptions

- Template file rename is acceptable for downstream users if references are updated in the same change.
- TypeScript template should mirror design+implementation intent, not replicate all C++ syntax details.

## Acceptance Questions

- Should a compatibility stub or redirect note be kept for one release cycle for the old template name?
- Should README/UserGuide examples explicitly show both `.cxx` and `.ts` template usage in this same story?

## Mutual Intent Contract

- Developer intent:
	- Keep this story narrow: rename the C++ template to explicit design+implementation naming and add a TypeScript counterpart.
	- Update only references required for path correctness and packaging/test stability.
- CodeAgent intent:
	- Implement only file rename/add plus minimal reference alignment required to satisfy AC-01..AC-03.
	- Avoid changing CaTDD method semantics, taxonomy, or unrelated runtime/slash-command behavior.
- In scope:
	- `methodPrompts/CaTDD_ImplTemplate.cxx` -> `methodPrompts/CaTDD_designAndImplTemplate.cxx`.
	- Add `methodPrompts/CaTDD_designAndImplTemplate.ts` with matching design+implementation purpose.
	- Align affected documentation/script references that would otherwise break path correctness.
- Out of scope:
	- Rewriting CaTDD category definitions or method semantics.
	- Broader restructuring outside template rename/addition scope.
- Success signal:
	- AC-01..AC-03 are satisfied by repository inspection.
	- No active references require `CaTDD_ImplTemplate.cxx` as the canonical path.
	- Affected packaging/doc checks remain passing after rename.
- Assumptions:
	- Downstream consumers accept the renamed canonical C++ template path once references are updated in the same change.
	- TypeScript template must mirror intent, not syntax, of the C++ template.
- Open questions:
	- Whether to keep a temporary compatibility stub for one release cycle is still a release-policy decision.
	- Whether to expand user-facing examples for both `.cxx` and `.ts` in this story can be decided as follow-up documentation scope.
- Review result: CLEARED.

## Next Recommended Action

Run `/SPEC_analyzeIssue` on one pending issue to continue the next story cycle.

## Unit Test Design Output

- Designed test skeleton file: `methodPrompts/design_and_impl_template.design.test.ts`.
- Category scope: P0 Functional / Typical.
- Designed TCs: `TC-MP-001..TC-MP-003`.
- Current TC status: implemented through repository-level closure evidence for AC-01..AC-03.

## Closure Summary

- Product/docs/scripts changes committed in `69f5b31`.
- C++ template renamed to `methodPrompts/CaTDD_designAndImplTemplate.cxx` and TypeScript template added at `methodPrompts/CaTDD_designAndImplTemplate.ts`.
- Path references normalized from `CaTDD_ImplTemplate.cxx` to `CaTDD_designAndImplTemplate.cxx` across docs, skill packaging metadata, and validation scripts.
- Verification summary:
	- `bash scripts/test_makeSkill.sh` passed.
	- `bash scripts/test_methodPrompts_standalone_user_guide.sh` passed.
- Story artifacts moved from `doingUS` to `doneUS`.
