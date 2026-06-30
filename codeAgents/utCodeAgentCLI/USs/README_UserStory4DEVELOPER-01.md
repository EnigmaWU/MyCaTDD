# US-DEV-01 [P0] — Actionable error messages for all failure states

**As a** DEVELOPER, **I want** every error message to name the problem, identify the affected argument, and suggest the correction, **so that** I can debug invocation issues without reading CLI source code.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-04 | 4 | Error with correction |
| Edge | ValidFunc | AC-05 ~ AC-08 | 4 | Error boundary |
| Misuse | InvalidFunc | AC-09 ~ AC-12 | 4 | Degraded messages |
| Fault | InvalidFunc | AC-13 ~ AC-15 | 3 | Output channel |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Edge | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Misuse | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Fault | 3 | 0 | 0 | 0 | 0 | 0 | 3 |
| **Total** | **15** | **0** | **0** | **0** | **0** | **0** | **15** |

---

## Typical (ValidFunc) — Actionable error messages

### 【PENDING】AC-01 [Func/Typical]: Typo suggests Levenshtein best-match
- **Given** `--behave "deisgnAllSkeleton"` (distance 1 from `designAllSkeleton`)
- **When** validation fails
- **Then** exit 1, stderr: Did you mean 'designAllSkeleton'?

### 【PENDING】AC-02 [Func/Typical]: Missing file includes exact path and arg
- **Given** `--inputFile nonexistent/path.h`
- **When** validation fails
- **Then** exit 1, stderr includes path and "--inputFile file not found"

### 【PENDING】AC-03 [Func/Typical]: Mismatch explains why + suggests alternatives
- **Given** `--target ::TC-03 --behave designAllSkeleton`
- **When** validation detects mismatch
- **Then** exit 1, explains skeleton needs file-level target

### 【PENDING】AC-04 [Func/Typical]: Mutually exclusive args both named
- **Given** `--goalStory` and `--goalStoryFile` together
- **When** validation fails
- **Then** exit 1, names both, "cannot be used together"

---

## Edge (ValidFunc) — Error boundary

### 【PENDING】AC-05 [Func/Edge]: Equal distance to two values
- **Given** `--behave` equidistant from two valid values
- **When** validation fails
- **Then** exit 1, suggests both candidates

### 【PENDING】AC-06 [Func/Edge]: Very long value truncated
- **Given** 10,000+ char argument value
- **When** error emitted
- **Then** truncated to ~100 chars

### 【PENDING】AC-07 [Func/Edge]: Unicode preserved in error
- **Given** Chinese/emoji characters in args
- **When** error emitted
- **Then** characters appear correctly

### 【PENDING】AC-08 [Func/Edge]: Whitespace-padded path hint
- **Given** `--inputFile "  path.h  "` with spaces; trimmed exists
- **When** validation fails
- **Then** hints about leading/trailing spaces

---

## Misuse (InvalidFunc) — Degraded messages

### 【PENDING】AC-09 [Func/Misuse]: No close match — no false suggestion
- **Given** `--behave "xyzzy123"` (no close match)
- **When** validation fails
- **Then** "No close match found.", lists valid values

### 【PENDING】AC-10 [Func/Misuse]: Every failure has non-empty stderr
- **Given** any failure (exit ≠ 0)
- **When** CLI exits
- **Then** stderr never empty

### 【PENDING】AC-11 [Func/Misuse]: Multiple failures — fail-fast
- **Given** `--goal "" --behave "invalid" --target ""`
- **When** validation runs
- **Then** reports only first failure

### 【PENDING】AC-12 [Func/Misuse]: `--log-level error` doesn't suppress validation errors
- **Given** `--log-level error` with validation failure
- **When** error emitted
- **Then** validation error still in stderr

---

## Fault (InvalidFunc) — Output channel

### 【PENDING】AC-13 [Func/Fault]: `--log-file` not writable — warns, continues
- **Given** `--log-file /read-only/log.txt`
- **When** CLI opens log
- **Then** warns, continues with stderr

### 【PENDING】AC-14 [Func/Fault]: `--log-file` is a directory
- **Given** `--log-file codeAgents/` (directory)
- **When** CLI opens
- **Then** exit 1, stderr: is a directory

### 【PENDING】AC-15 [Func/Fault]: Characters outside terminal encoding
- **Given** error contains unrenderable chars
- **When** stderr written
- **Then** replacement chars used, no crash