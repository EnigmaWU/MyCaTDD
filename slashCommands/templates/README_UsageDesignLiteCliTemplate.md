# {{ProjectName}} Lite CLI Usage Design

This is the SpecCoding template for project-root `README_UsageDesign.md` when a story defines or changes a bash-style CLI: command invocations, subcommands, options, environment variables, stdin/stdout/stderr behavior, generated files, or shell automation contracts.

Use this template from `SPEC_takeDetailDesign` before implementing tests or product code. Keep it traceable to the active story and synchronized with `README_UserGuide.md`, `README_DetailDesign.md`, and CaTDD unit-test skeletons.

## Who

- Primary user: {{developer/operator/CI job/automation script/persona}}
- Secondary user: {{maintainer/support engineer/release job/other persona}}
- Assistant consumer: CodeAgent or tool wrapper that must invoke the CLI non-interactively

## What

`{{tool-name}}` is a bash-style CLI that {{one-sentence capability}}.

The interface is optimized for:

- Copy-paste shell use.
- Scripted automation in CI or local developer workflows.
- Stable stdout/stderr and exit-code contracts.
- Non-interactive execution by default.

## When

Use this CLI when:

- {{usage condition 1}}
- {{usage condition 2}}
- {{usage condition 3}}

Do not use this CLI when:

- {{non-goal or unsupported condition 1}}
- {{non-goal or unsupported condition 2}}

## Where

- Command entry point: `{{path/to/tool-or-script}}`
- Working directory requirement: {{repository root / any directory / specific directory}}
- Reads from: {{arguments / stdin / env vars / config files / repository files}}
- Writes to: {{stdout / stderr / output files / temp files / no persistent files}}
- Related overview: [README.md](README.md)
- Related user guide: [README_UserGuide.md](README_UserGuide.md)
- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Related verification design: [README_VerifyDesign.md](README_VerifyDesign.md)
- Source story: {{.catdd/spec/doingUS path or issue link}}

## Why

- Outcome: {{business or developer outcome this CLI enables}}
- Risk reduced: {{manual mistake, drift, slow workflow, missing validation, unclear output, etc.}}
- Success signal: {{observable proof that the outcome was achieved}}

## Usage Outcome Model

Use this OOPSI-style section to work backward from outcome to exact shell inputs.

| Layer | Design answer |
| --- | --- |
| Outcome | {{What valuable result the user gets}} |
| Outputs | {{Files, stdout lines, state changes, reports, exit code, logs}} |
| Process | {{High-level steps the CLI performs}} |
| Scenarios | {{Happy path, edge cases, error paths, automation variants}} |
| Inputs | {{Args, flags, stdin, env vars, config files, current directory}} |

## CLI Synopsis

```text
{{tool-name}} {{subcommand-or-mode}} [OPTIONS] [--] [POSITIONAL_ARGS]

Common options:
  --{{arg1}} <value>          {{Description}}
  --{{arg2}} <value>          {{Description}}
  --{{flag1}}                 {{Description}}
  --{{flag2}}                 {{Description}}
  --output <path>             {{Write machine-readable output to path}}
  --dry-run                   {{Preview actions without persistent writes}}
  --verbose                   {{Print detailed diagnostics to stderr}}
  --help                      Show usage help and exit 0
```

## Shell Contract

| Surface | Contract |
| --- | --- |
| Invocation style | {{single command / subcommand / pipeline stage / batch script}} |
| Interactivity | Non-interactive by default; prompts require explicit `--interactive` or equivalent |
| stdout | {{machine-readable data / human summary / empty on success}} |
| stderr | {{diagnostics, warnings, progress, validation failures}} |
| stdin | {{ignored / reads lines / reads JSON / reads file paths / requires TTY}} |
| Exit code | `0` success; non-zero values defined in Exit Codes |
| Idempotency | {{safe to rerun / safe with --dry-run / creates unique outputs / not idempotent}} |
| Filesystem writes | {{none / output path only / temp files / project files}} |
| Network use | {{none / optional / required, with endpoint}} |
| Secrets | Do not print secrets; accept secrets only through {{env var / file / keychain / not supported}} |

## Argument Dictionary

| Name | Kind | Type/format | Values/range | Required | Default | Repeatable | Depends on/conflicts with | Validation failure |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `{{subcommand-or-mode}}` | positional | enum | `{{mode1}}` \| `{{mode2}}` | yes | none | no | {{dependency}} | {{message + exit code}} |
| `--{{arg1}}` | option | string | {{allowed values or pattern}} | {{yes/no}} | {{default}} | no | {{dependency/conflict}} | {{message + exit code}} |
| `--{{arg2}}` | option | path | existing file or directory | {{yes/no}} | {{default}} | no | {{dependency/conflict}} | {{message + exit code}} |
| `--{{flag1}}` | flag | boolean | present/absent | no | false | no | {{dependency/conflict}} | {{message + exit code}} |
| `{{ENV_VAR}}` | env var | string | {{allowed values or pattern}} | no | unset | no | overridden by `--{{arg1}}` | {{message + exit code}} |
| stdin | stream | {{text/json/line list}} | {{format}} | {{yes/no}} | none | n/a | conflicts with `--input` | {{message + exit code}} |

## Precedence Rules

When multiple input sources can define the same value, resolve them in this order:

1. Explicit CLI option, such as `--{{arg1}}`.
2. Environment variable, such as `{{ENV_VAR}}`.
3. Config file, such as `{{config-file}}`.
4. Built-in default.

If two explicit CLI options conflict, fail fast before performing writes.

## Behavior Scenarios

| Scenario ID | Given | When | Then | stdout | stderr | Exit | Writes | Trace |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| USAGE-SC-001 | {{valid working directory and required inputs}} | `{{tool-name}} {{mode1}} --{{arg1}} {{value1}}` | {{expected behavior}} | {{expected stdout}} | {{expected stderr}} | `0` | {{files/state}} | {{US/AC/TC}} |
| USAGE-SC-002 | {{valid input with dry-run}} | `{{tool-name}} {{mode1}} --dry-run` | {{preview without writes}} | {{expected stdout}} | {{expected stderr}} | `0` | none | {{US/AC/TC}} |
| USAGE-SC-003 | {{missing required input}} | `{{tool-name}} {{mode1}}` | {{validation failure}} | empty | {{exact message}} | `{{code}}` | none | {{US/AC/TC}} |
| USAGE-SC-004 | {{unsupported option combination}} | `{{tool-name}} {{mode1}} --{{arg1}} {{value1}} --{{arg2}} {{valueB}}` | {{validation failure}} | empty | {{exact message}} | `{{code}}` | none | {{US/AC/TC}} |

## Output Contracts

### Human Output

```text
{{Example human-readable success summary}}
```

Rules:

- Keep human summaries concise and stable enough for documentation.
- Put progress and diagnostics on stderr when stdout is reserved for data.
- Do not require parsing decorative text for automation.

### Machine Output

```json
{
  "status": "{{success|failure}}",
  "{{field}}": "{{value}}"
}
```

Rules:

- Document schema version when output is consumed by automation.
- Use deterministic field names and ordering when practical.
- Avoid absolute local paths unless the caller requested them.

## Exit Codes

| Code | Meaning | Recoverable | Typical stderr |
| --- | --- | --- | --- |
| `0` | Success | n/a | empty or informational diagnostics |
| `1` | General failure | maybe | `{{message}}` |
| `2` | Invalid arguments or unsupported combination | yes | `{{message}}` |
| `3` | Missing input or unreadable path | yes | `{{message}}` |
| `4` | Verification or validation failed | yes | `{{message}}` |
| `5` | External dependency failed | maybe | `{{message}}` |

## Error and Edge Handling

- Missing required option: {{exact message, exit code, stdout/stderr behavior}}
- Unknown option: {{exact message, exit code, stdout/stderr behavior}}
- Unsupported option combination: {{exact message, exit code, stdout/stderr behavior}}
- Missing file or directory: {{exact message, exit code, stdout/stderr behavior}}
- Empty stdin: {{accepted or rejected, message, exit code}}
- Non-TTY execution: {{supported behavior}}
- Interrupted execution: {{cleanup behavior and exit code}}
- Partial write failure: {{rollback, temp-file cleanup, or resume behavior}}
- Permission denied: {{message, exit code, no secret leakage}}

## Bash Integration Examples

```bash
# Happy path
{{tool-name}} {{mode1}} --{{arg1}} {{value1}}

# Dry-run before writing
{{tool-name}} {{mode1}} --{{arg1}} {{value1}} --dry-run

# Capture machine-readable output
{{tool-name}} {{mode1}} --{{arg1}} {{value1}} --output "$TMPDIR/{{output-file}}.json"

# Pipeline input
printf '%s\n' '{{input1}}' '{{input2}}' | {{tool-name}} {{mode1}} --stdin

# CI-friendly invocation
{{ENV_VAR}}={{value}} {{tool-name}} {{mode1}} --{{flag1}}
```

## CaTDD Verification Handoff

| Usage scenario | Feature token | Category token | Suggested test file | Test points |
| --- | --- | --- | --- | --- |
| {{happy path scenario}} | `{{feature_token}}` | `funcValidTypical` | `test_{{feature_token}}_funcValidTypical.{{ext}}` | {{TC list}} |
| {{valid edge scenario}} | `{{feature_token}}` | `funcValidEdge` | `test_{{feature_token}}_funcValidEdge.{{ext}}` | {{TC list or `@[NoTestPoints]: <reason>`}} |
| {{invalid caller scenario}} | `{{feature_token}}` | `funcInvalidMisuse` | `test_{{feature_token}}_funcInvalidMisuse.{{ext}}` | {{TC list or `@[NoTestPoints]: <reason>`}} |
| {{external failure scenario}} | `{{feature_token}}` | `funcInvalidFault` | `test_{{feature_token}}_funcInvalidFault.{{ext}}` | {{TC list or `@[NoTestPoints]: <reason>`}} |
| {{concurrency scenario}} | `{{feature_token}}` | `designConcurrency` | `test_{{feature_token}}_designConcurrency.{{ext}}` | {{TC list or `@[NoTestPoints]: <reason>`}} |
| {{performance scenario}} | `{{feature_token}}` | `qualityPerformance` | `test_{{feature_token}}_qualityPerformance.{{ext}}` | {{TC list or `@[NoTestPoints]: <reason>`}} |

## Open Questions

- {{Question about unclear output, exit code, option precedence, write behavior, or test trace}}

## Usage Example

Run from the repository root to instantiate this lite CLI usage-design template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_UsageDesign.md"
cp slashCommands/templates/README_UsageDesignLiteCliTemplate.md "$TMP_DOC"
sed -n '1,180p' "$TMP_DOC"
```

Expected result: the temporary file shows 5W1H context, usage outcome model, bash CLI shell contract, argument dictionary, behavior scenarios, exit codes, and CaTDD verification handoff sections.

## Review Checklist

- 5W1H context is complete enough for a new developer or CodeAgent.
- Outcome, outputs, process, scenarios, and inputs are traceable to the active story.
- Every CLI argument, flag, env var, stdin mode, and config source has type, values, default, validation, and conflict rules.
- stdout, stderr, exit codes, filesystem writes, and idempotency are explicit.
- Every behavior scenario has Given/When/Then semantics and expected stdout/stderr/exit behavior.
- Error precedence is defined before implementation begins.
- Bash examples are copy-pasteable and non-interactive by default.
- Usage scenarios map to CaTDD feature/category test files or explicit `@[NoTestPoints]: <reason>` decisions.
- Open questions are resolved or intentionally carried before `SPEC_reviewDetailDesign` passes.
