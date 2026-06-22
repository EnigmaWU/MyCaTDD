# {{ProjectName}} User Stories

This is the SpecCoding template for project-root `README_UserStories.md`. This file is the mandatory project-level ledger for user story lifecycle state (TODO/DOING/DONE) and acceptance criteria trace/status.

## Story Ledger

### TODO / DOING Stories

| Story ID | Title | State | Source | Trace Link |
| --- | --- | --- | --- | --- |
| US-{{n}} | {{Story title}} | {{todo/doing}} | {{Issue/feature/input}} | {{.catdd/spec/todoUS or doingUS path}} |

### SUSPENDED Stories

| Story ID | Title | Suspended On | Resume Reference | Trace Link |
| --- | --- | --- | --- | --- |
| US-{{n}} | {{Story title}} | {{YYYY-MM-DD}} | {{git branch / worktree}} | {{.catdd/spec/suspendUS path}} |

### DONE Stories

| Story ID | Title | Closed On | Evidence | Trace Link |
| --- | --- | --- | --- | --- |
| US-{{n}} | {{Story title}} | {{YYYY-MM-DD}} | {{commit/CI/review reference}} | {{.catdd/spec/doneUS path}} |

## Active Story

```text
US-{{n}}: As a {{role}},
         I want {{capability}},
         So that {{value}}.
```

## Acceptance Criteria Ledger

| AC ID | Story | Given | When | Then | Status | Verification Trace |
| --- | --- | --- | --- | --- | --- |
| AC-{{n}} | US-{{n}} | {{context}} | {{action}} | {{observable result}} | {{draft/reviewed/verified}} | {{TC ID / test file / review evidence}} |

## Lifecycle Links

- Pending input: `.catdd/spec/pendingNews/{{file}}`
- Todo story: `.catdd/spec/todoUS/{{file}}`
- Active story: `.catdd/spec/doingUS/{{file}}`
- Suspended story: `.catdd/spec/suspendUS/{{file}}`
- Done story: `.catdd/spec/doneUS/{{file}}`

## Sync Rules

- Keep each opened story in TODO/DOING until closure is complete.
- Move a story to SUSPENDED only when a durable resume reference (such as a git branch or worktree) exists.
- Move a story to DONE only when closure evidence exists (review + commit + CI or accepted equivalent).
- Keep AC status aligned with story lifecycle and verification evidence.
- Do not leave story ID state mismatches between this ledger and `.catdd/spec/*US/` artifacts.
- Do not close or update a story whose ledger state is SUSPENDED until it has been resumed via `SPEC_resumeUserStory`.

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

Keep this file as the mandatory project-level ledger for TODO/DOING/DONE and AC status. Keep active work details in `.catdd/spec/doingUS/` until the story is ready to close.
