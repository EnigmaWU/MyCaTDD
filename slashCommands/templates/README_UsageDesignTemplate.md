# {{ProjectName}} Usage Design

This is the SpecCoding template for project-root `README_UsageDesign.md`. Create or update it from `SPEC_takeDetailDesign` when a story defines or changes a CLI interface, command arguments, option flags, or user-facing invocation behavior.

## Story Context

- Story: {{US identifier and title}}
- Source artifact: {{.catdd/spec/doingUS path or issue link}}
- Related overview: [README.md](README.md)
- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)

## CLI Interface

```text
{{tool-name}} [OPTIONS]

Options:
  --{{arg1}}   <value>   {{Description}}
  --{{arg2}}   <value>   {{Description}}
  --{{flag1}}            {{Description}}
  --{{flag2}}            {{Description}}
```

## Argument Reference

| Argument | Type | Values | Required | Description |
| --- | --- | --- | --- | --- |
| `--{{arg1}}` | string | `{{value1}}` \| `{{value2}}` | {{yes/no}} | {{What this argument selects or controls}} |
| `--{{arg2}}` | string | `{{value1}}` \| `{{value2}}` | {{yes/no}} | {{What behavior this argument triggers}} |
| `--{{flag1}}` | flag | — | no | {{What diagnostic or informational output this flag enables}} |
| `--{{flag2}}` | flag | — | no | {{What diagnostic or informational output this flag enables}} |

## Behavior Matrix

| `--{{arg1}}` | `--{{arg2}}` | Expected behavior |
| --- | --- | --- |
| `{{value1}}` | `{{valueA}}` | {{Outcome}} |
| `{{value1}}` | `{{valueB}}` | {{Outcome}} |
| `{{value2}}` | `{{valueA}}` | {{Outcome}} |

## Invocation Examples

```bash
# {{Example 1: short description}}
{{tool-name}} --{{arg1}} {{value1}} --{{arg2}} {{valueA}}

# {{Example 2: short description}}
{{tool-name}} --{{arg1}} {{value2}} --{{flag1}}

# {{Example 3: diagnostic invocation}}
{{tool-name}} --{{flag2}}
```

## Error and Edge Handling

- `--{{arg1}}` missing when required -> {{Error message and exit behavior}}
- `--{{arg2}}` given an unrecognized value -> {{Error message and exit behavior}}
- `--{{arg1}}` and `--{{arg2}}` combination not supported -> {{Error message and exit behavior}}

## Open Questions

- {{Question}}

## Usage Example

Run from the repository root to instantiate this usage-design template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_UsageDesign.md"
cp slashCommands/templates/README_UsageDesignTemplate.md "$TMP_DOC"
sed -n '1,120p' "$TMP_DOC"
```

Expected result: the temporary file shows CLI interface, argument reference, behavior matrix, and usage examples sections.

## Review Checklist

- Every argument has a type, value set, and clear description.
- Every supported combination in the behavior matrix has an expected outcome.
- Error and edge cases have explicit exit behavior.
- Open questions are visible before implementation begins.
