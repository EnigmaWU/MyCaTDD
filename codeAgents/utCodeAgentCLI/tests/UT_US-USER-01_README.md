# Test Case: US-USER-01 CaTDD Functional UnitTesting

## Purpose
These four test files collectively verify `US-USER-01` CLI argument-validation behavior for
`utCodeAgentCLI` using CaTDD category-specific UnitTesting files. Each file covers one P0
functional category (Typical, Edge, Misuse, Fault), exercising all 32 Acceptance Criteria from
the 32-AC spec redesign.

## Status
All tests GREEN (passing in local node test run across all four categories).

## Covered
- **User Story**: `US-USER-01`
- **Total ACs**: 32 (AC-01 ~ AC-32)
- **Total TCs**: 33

### Category Breakdown

| File | Category | Func Class | ACs | TCs | Status |
|------|----------|------------|-----|-----|--------|
| `UT_US-USER-01-Typical.ts` | Typical | ValidFunc | AC-01 ~ AC-10 (10 ACs) | TC-ARG-001 ~ TC-ARG-010 (10 TCs) | GREEN |
| `UT_US-USER-01-Edge.ts` | Edge | ValidFunc | AC-11 ~ AC-20 (10 ACs) | TC-ARG-011 ~ TC-ARG-020 (10 TCs) | GREEN |
| `UT_US-USER-01-Misuse.ts` | Misuse | InvalidFunc | AC-21 ~ AC-28, AC-32 (9 ACs) | TC-ARG-021 ~ TC-ARG-031 (9 TCs) | GREEN |
| `UT_US-USER-01-Fault.ts` | Fault | InvalidFunc | AC-29 ~ AC-31 (3 ACs) | TC-ARG-029 ~ TC-ARG-035 (7 TCs*) | GREEN |

\* Fault uses multiple TCs per AC because each file-path failure mode (nonexistent, unreadable,
invalid YAML, directory-as-config) is a distinct test case.

### SUT Boundary Under Test
- `codeAgents/utCodeAgentCLI/src/cli/main.ts` executed as a subprocess
- Delegated product code: `codeAgents/utCodeAgentCLI/src/cli/invocationValidator.ts`

### What's Verified Per Category

- **Typical (AC-01 ~ AC-10)**: All 10 user-intent-driven CLI patterns from UserGuide § "IF: What You
  Want" — design/review/next-TC/implement skeletons, inline/file/reference/diag/config combos.
- **Edge (AC-11 ~ AC-20)**: Valid but boundary-level behavior — empty-string optional args, flag
  coexistence, log-level variations, config loading, interactive mode toggle.
- **Misuse (AC-21 ~ AC-28, AC-32)**: Caller contract violations — missing required args, empty
  `--goal`, mutually exclusive pairs, unrecognized `--behave`/`--log-level`, unparseable
  `--target`, target/behave mismatch, structurally wrong config.
- **Fault (AC-29 ~ AC-31)**: External dependency failures — nonexistent/unreadable file paths for
  `--inputFile`, `--goalStoryFile`, `--reference`, `--extra-prompt`, `--config-file`; invalid YAML
  config; directory-as-config.

## Manual

```bash
# Run all 33 test cases across all four categories:
node --test \
  codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts \
  codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts \
  codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts \
  codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts
```

Expected result: **all tests pass** (exit code 0, no failures).

If failures occur, inspect:
- subprocess invocation through `codeAgents/utCodeAgentCLI/src/cli/main.ts`
- argument parsing and required-flag checks
- exclusive-pair checks (`--goalStory`/`--goalStoryFile`, `--input`/`--inputFile`)
- `--behave` allowlist handling
- file-path existence checks for `--inputFile`, `--goalStoryFile`, `--reference`, `--extra-prompt`, `--config-file`
