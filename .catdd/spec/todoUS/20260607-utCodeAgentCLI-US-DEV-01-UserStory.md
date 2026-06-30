# User Story: utCodeAgentCLI DEVELOPER US-DEV-01 Actionable error messages for all failure states

Created by `/SPEC_importUserStory` on 2026-06-07.
Imported from `codeAgents/utCodeAgentCLI/README_UserStory4DEVELOPER.md` slice `US-DEV-01`.

## Source Trace

- Source story slice: [../../codeAgents/utCodeAgentCLI/README_UserStory4DEVELOPER.md](../../codeAgents/utCodeAgentCLI/README_UserStory4DEVELOPER.md)
- Paired usage context: [../../codeAgents/utCodeAgentCLI/README_UserGuide.md](../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Master requirements index: [../../codeAgents/utCodeAgentCLI/README_UserStory.md](../../codeAgents/utCodeAgentCLI/README_UserStory.md)
- Role area: `codeAgents/utCodeAgentCLI/`
- Import granularity: `US-by-US`
- Imported slice: `US-DEV-01 [P0]`

## Active Work Status

- Status: TODO.
- Active state: `.catdd/spec/todoUS/` ready for `SPEC_openUserStory`.
- Priority: P0 - critical.
- Confidence: high.
- Next recommended command: `/SPEC_openUserStory`.

## Story

As a DEVELOPER,
I want every error message to name the problem, identify the affected argument, and suggest the correction,
so that I can debug invocation issues without reading CLI source code.

## Independent Test Intent

A reviewer can inspect failure output and verify that the message names the problem, affected argument, and a correction suggestion for each supported failure mode.

## Acceptance Criteria

#### P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-04 | 4 | ✅ Error with correction |
| Edge | ValidFunc | AC-05 ~ AC-08 | 4 | ✅ Error boundary |
| Misuse | InvalidFunc | AC-09 ~ AC-12 | 4 | ❌ Degraded messages |
| Fault | InvalidFunc | AC-13 ~ AC-15 | 3 | ❌ Output channel |

---

### Typical (ValidFunc) — Error with correction

##### AC-01 [Func/Typical]: Typo suggests best-match correction
- **Given** `--behave "deisgnAllSkeleton"` (distance 1 from `designAllSkeleton`)
- **When** validation fails
- **Then** exit 1, stderr: recognized, Did you mean 'designAllSkeleton'?, lists valid values

##### AC-02 [Func/Typical]: Missing file includes exact path and arg name
- **Given** `--inputFile nonexistent/path.h`
- **When** validation fails
- **Then** exit 1, stderr includes path, `--inputFile`, and "file not found"

##### AC-03 [Func/Typical]: Mismatch explains why and suggests alternatives
- **Given** `--target tests/auth_test.cpp::TC-03 --behave designAllSkeleton`
- **When** validation detects mismatch
- **Then** exit 1, stderr explains skeleton needs file-level target, suggests pairings

##### AC-04 [Func/Typical]: Mutually exclusive args both named
- **Given** `--goalStory "..." --goalStoryFile "..."`
- **When** validation fails
- **Then** exit 1, stderr names both, "cannot be used together — choose one"

### Edge (ValidFunc) — Error boundary

##### AC-05 [Func/Edge]: Equal distance to two values suggests both
- **Given** `--behave "designAllSkeletom"` equidistant from two valid values
- **When** validation fails
- **Then** exit 1, stderr: Did you mean 'X' or 'Y'?

##### AC-06 [Func/Edge]: Very long value truncated
- **Given** 10,000+ char argument value
- **When** error emitted
- **Then** value truncated to ~100 chars, full value in trace if enabled

##### AC-07 [Func/Edge]: Unicode preserved in error output
- **Given** unicode characters (Chinese, emoji) in args
- **When** error emitted
- **Then** characters appear correctly, no mojibake

##### AC-08 [Func/Edge]: Whitespace-padded path hint
- **Given** `--inputFile "  src/AuthService.h  "` with spaces; trimmed path exists
- **When** validation fails
- **Then** stderr hints about leading/trailing spaces

### Misuse (InvalidFunc) — Degraded messages

##### AC-09 [Func/Misuse]: No close match — no false suggestion
- **Given** `--behave "xyzzy123"` (no valid value within distance 3)
- **When** validation fails
- **Then** stderr: "No close match found.", lists all valid values

##### AC-10 [Func/Misuse]: Every failure exit has non-empty stderr
- **Given** any failure (exit ≠ 0)
- **When** CLI exits
- **Then** stderr always has ≥1 diagnostic line

##### AC-11 [Func/Misuse]: Multiple failures — fail-fast on first
- **Given** `--goal "" --behave "invalid" --target ""`
- **When** validation runs
- **Then** reports only first failure with "First error: ..."

##### AC-12 [Func/Misuse]: `--log-level error` does not suppress validation errors
- **Given** `--log-level error` with validation failure
- **When** error emitted
- **Then** validation error still in stderr (bypasses log filter)

### Fault (InvalidFunc) — Output channel

##### AC-13 [Func/Fault]: `--log-file` not writable — warns, continues
- **Given** `--log-file /read-only/log.txt`
- **When** CLI opens log
- **Then** warns, continues with stderr output

##### AC-14 [Func/Fault]: `--log-file` is a directory
- **Given** `--log-file codeAgents/` (directory)
- **When** CLI opens
- **Then** exit 1, stderr: --log-file is a directory, not a file

##### AC-15 [Func/Fault]: Characters outside terminal encoding
- **Given** error contains unrenderable characters
- **When** stderr written
- **Then** replacement characters used, no crash

## Scope

In scope:

- Developer-facing diagnostics.
- Argument-specific corrections.
- Actionable suggestions for invalid invocations.

Out of scope:

- Logging verbosity controls.
- Interactive confirmations.
- Adapter interface design.

## Risks

- Vague errors slow down debugging.
- Missing argument names make automation brittle.
- No suggestions force source-code inspection.

## Assumptions

- Stderr is the primary failure channel.
- Suggestions are deterministic enough to test.
- Error wording can be asserted by tests.

## Acceptance Questions

- Should suggestions prioritize best match or list all alternatives first?
- Should argument names appear in every failure message?
- Should validation errors share a common prefix or format?

## Next Recommended Action

Run `/SPEC_openUserStory` to move this imported story into `.catdd/spec/doingUS/`.
