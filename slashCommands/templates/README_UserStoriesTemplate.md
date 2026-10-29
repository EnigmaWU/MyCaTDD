# {{ProjectName}} User Stories

This is the SpecCoding template for project-root `README_UserStories.md`. This file is the mandatory project-level ledger for user story lifecycle state (TODO/DOING/DONE) and acceptance criteria trace/status.

## Story Identity Registry

Register each project-wide Story ID when its first todo artifact is created, including blocked drafts. Follow the Project-Wide Traceability IDs section in `.catdd/methodPrompts/CaTDD_methodPrompt-testStructure.md`: preserve an unambiguous existing ID; derive a new human-readable `US-<whoName>-<doWhat>` ID in lowerCamelCase from the story actor and observable behavior, such as `US-eventProducer-postEventsWithoutBlocking`. Check the project registry and known story sources before registration, refine collisions with meaningful context, and recheck when branches are integrated. Do not use arbitrary numeric suffixes or UUIDs merely to force uniqueness. The registry identifies the current authoritative story/AC source; it does not replace that source's requirements.

| Story ID | Authoritative Story / AC Source | Source IDs / Revision | Parent / Supersession |
| --- | --- | --- | --- |
| {{StoryID}} | {{story or requirements path}} | {{external or legacy aliases with source and revision, or none}} | {{parent, superseded ID, or none}} |

IDs are never reused for different meanings. Historical copies and declared partial-closure slices remain linked to their identity; distinguish them from independent stories and conflicting duplicate registrations. Record aliases and revisions explicitly rather than rewriting historical evidence.

## Story Ledger

### TODO / DOING Stories

| Story ID | Title | State | Source | Trace Link |
| --- | --- | --- | --- | --- |
| {{StoryID}} | {{Story title}} | {{todo/doing}} | {{Issue/feature/input}} | {{.catdd/spec/todoUS or doingUS path}} |

### SUSPENDED Stories

| Story ID | Title | Suspended On | Resume Reference | Trace Link |
| --- | --- | --- | --- | --- |
| {{StoryID}} | {{Story title}} | {{YYYY-MM-DD}} | {{git branch / worktree}} | {{.catdd/spec/suspendUS path}} |

### DONE Stories

| Story ID | Title | Closed On | Evidence | Trace Link |
| --- | --- | --- | --- | --- |
| {{StoryID}} | {{Story title}} | {{YYYY-MM-DD}} | {{commit/CI/review reference}} | {{.catdd/spec/doneUS path}} |

### ABORTED Stories

| Story ID | Title | Aborted On | Evidence / Successor | Trace Link |
| --- | --- | --- | --- | --- |
| {{StoryID}} | {{Story title}} | {{YYYY-MM-DD}} | {{reason and successor ID if any}} | {{.catdd/spec/abortUS path}} |

## Active Story

```text
{{StoryID}}: As a {{role}},
         I want {{capability}},
         So that {{value}}.
```

## Acceptance Criteria Ledger

| AC ID | Story | Given | When | Then | Status | Verification Trace |
| --- | --- | --- | --- | --- | --- |
| {{StoryID}}-AC-{{n}} | {{StoryID}} | {{context}} | {{action}} | {{observable result}} | {{draft/reviewed/verified}} | {{qualified TP / TC IDs and test or review evidence}} |

## Lifecycle Links

- Pending input: `.catdd/spec/pendingNews/{{file}}`
- Todo story: `.catdd/spec/todoUS/{{file}}`
- Active story: `.catdd/spec/doingUS/{{file}}`
- Suspended story: `.catdd/spec/suspendUS/{{file}}`
- Aborted story: `.catdd/spec/abortUS/{{file}}`
- Done story: `.catdd/spec/doneUS/{{file}}`

## Sync Rules

- Keep each opened story in TODO/DOING until closure is complete.
- Move a story to SUSPENDED only when a durable resume reference (such as a git branch or worktree) exists.
- Move a story to DONE only when closure evidence exists (review + commit + CI or accepted equivalent).
- Keep AC status aligned with story lifecycle and verification evidence.
- Preserve registered IDs across lifecycle moves; keep explicit historical revision, alias, and partial-closure links.
- Stop on an unresolved identity collision or reused AC meaning; do not silently renumber accepted IDs or conflate independent stories.
- Do not leave story ID state mismatches between this ledger and `.catdd/spec/*US/` artifacts.
- Do not close or update a story whose ledger state is SUSPENDED until it has been resumed via `SPEC_resumeUserStory`.

## Traceability Notes

- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Related verification design: [README_VerifyDesign.md](README_VerifyDesign.md)
- Related user guide: [README_UserGuide.md](README_UserGuide.md)

## Usage Example

Run from the project root to inspect this user-stories template in a temporary file. The source-repository layout is also supported:

```bash
if [[ -f .catdd/slashCommands/templates/README_UserStoriesTemplate.md ]]; then
    TEMPLATE=.catdd/slashCommands/templates/README_UserStoriesTemplate.md
else
    TEMPLATE=slashCommands/templates/README_UserStoriesTemplate.md
fi
TMP_DOC="$(mktemp -d)/README_UserStories.md"
cp "$TEMPLATE" "$TMP_DOC"
sed -n '1,100p' "$TMP_DOC"
```

Expected result: the temporary file shows a user-story index, acceptance criteria summary, and lifecycle links.

## Maintenance Rule

Keep this file as the mandatory project-level ledger for TODO/DOING/DONE and AC status. Keep active work details in `.catdd/spec/doingUS/` until the story is ready to close.
