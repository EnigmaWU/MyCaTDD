# {{ProjectName}}

{{ProjectName}} is {{one-sentence project or module positioning}}.

This is the SpecCoding template for project-root `README.md`. Create or update it from `SPEC_takeDetailDesign` when a story needs shared project or module overview, ownership, public behavior, or links to deeper SPEC docs.

## What

{{Describe the project or module capability in user-visible terms.}}

Key surfaces:

- {{Public behavior or API surface 1}}
- {{Public behavior or API surface 2}}
- {{Important limitation or non-goal}}

## Why

{{Explain the user or engineering value this project/module provides.}}

## Ownership

| Area | Owner | Notes |
| --- | --- | --- |
| {{Area}} | {{Owner}} | {{Decision or responsibility}} |

## SPEC Docs

| File | Purpose |
| --- | --- |
| [README_ArchDesign.md](README_ArchDesign.md) | Architecture design, module boundaries, dependencies, data flow, and key decisions. |
| [README_UserStories.md](README_UserStories.md) | Project or module-scoped user stories and trace links. |
| [README_UserGuide.md](README_UserGuide.md) | User-facing or developer-facing usage guidance. |
| [README_DetailDesign.md](README_DetailDesign.md) | Detailed design, acceptance criteria, interfaces, state, and behavior decisions. |
| [README_CompatDesign.md](README_CompatDesign.md) | Compatibility matrix, supported versions, platforms, protocols, formats, toolchains, and integration boundaries. |
| [README_VerifyDesign.md](README_VerifyDesign.md) | Verification design, CaTDD category coverage, US/AC/TC traceability, and test strategy. |

## Current Scope

- In scope: {{Scope item}}
- Out of scope: {{Non-goal}}
- Open question: {{Question}}

## Usage Example

Run from the repository root to instantiate this overview template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README.md"
cp slashCommands/templates/README_Template.md "$TMP_DOC"
sed -n '1,80p' "$TMP_DOC"
```

Expected result: the temporary file shows the project overview README structure and placeholders to replace.

## Maintenance Rule

Keep this file focused on WHAT the project/module is, WHY it exists, ownership, public behavior, and links to deeper SpecCoding docs.
