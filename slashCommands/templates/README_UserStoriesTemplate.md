# {{ProjectName}} User Stories

This is the SpecCoding template for project-root `README_UserStories.md`. Create or update it from `SPEC_analyzeIssue`, `SPEC_analyzeFeature`, `SPEC_openUserStory`, or `SPEC_takeDetailDesign` when project or module stories need a shared index.

## Story Index

| Story ID | Title | State | Source | Trace Link |
| --- | --- | --- | --- | --- |
| US-{{n}} | {{Story title}} | {{pending/todo/doing/done}} | {{Issue/feature/input}} | {{.catdd/spec path}} |

## Active Story

```text
US-{{n}}: As a {{role}},
         I want {{capability}},
         So that {{value}}.
```

## Acceptance Criteria Summary

| AC ID | Story | Given | When | Then | Status |
| --- | --- | --- | --- | --- | --- |
| AC-{{n}} | US-{{n}} | {{context}} | {{action}} | {{observable result}} | {{draft/reviewed/verified}} |

## Lifecycle Links

- Pending input: `.catdd/spec/pendingNews/{{file}}`
- Todo story: `.catdd/spec/todoUS/{{file}}`
- Active story: `.catdd/spec/doingUS/{{file}}`
- Done story: `.catdd/spec/doneUS/{{file}}`

## Traceability Notes

- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Related verification design: [README_VerifyDesign.md](README_VerifyDesign.md)
- Related user guide: [README_UserGuide.md](README_UserGuide.md)

## Usage Example

Run from the repository root to instantiate this user-stories template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_UserStories.md"
cp slashCommands/templates/README_UserStoriesTemplate.md "$TMP_DOC"
sed -n '1,100p' "$TMP_DOC"
```

Expected result: the temporary file shows a user-story index, acceptance criteria summary, and lifecycle links.

## Maintenance Rule

Keep this file as the shared story index. Keep active work details in `.catdd/spec/doingUS/` until the story is ready to close.
