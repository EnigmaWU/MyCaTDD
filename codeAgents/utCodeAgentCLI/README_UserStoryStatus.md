# utCodeAgentCLI — UserStory Status

Live trace of every acceptance criterion. Mark `[x]` when verified against implementation.

---

## US-USER-01 — Parse and validate CLI arguments
- [ ] AC-01  Missing `--goal` → exit 1, stderr names it
- [ ] AC-02  `--goalStory` + `--goalStoryFile` together → exit 1, conflict
- [ ] AC-03  `--behave "nonexistent"` → exit 1, list valid values
- [ ] AC-04  File-path arg to nonexistent file → exit 1, names path
- [ ] AC-05  All args valid → exit 0, proceeds

## US-USER-02 — Design CaTDD test skeletons
- [ ] AC-01  Story + source + empty target → file gets US/AC/TC for all 4 P0 categories
- [ ] AC-02  Single-category design → file gets only that category's skeletons
- [ ] AC-03  Source but no story → skeletons generated, @[US] placeholder, stderr warns

## US-USER-03 — Review design skeletons (all tiers)
- [ ] AC-01  Skeleton TCs present → reviewFuncTestsSkeleton reports P0 counts per category/status
- [ ] AC-02  File is EMPTY → "0 skeletons found", exit 0
- [ ] AC-03  P1 design skeletons → reviewDesignTestsSkeleton reports P1 counts per category/status
- [ ] AC-04  P2 quality skeletons → reviewQualityTestsSkeleton reports P2 counts per category/status

## US-USER-04 — Select next test case to implement
- [ ] AC-01  File has PLANNED TCs → first PLANNED TC-ID in CaTDD priority
- [ ] AC-02  TC-01 RED, TC-02/03 PLANNED → selects TC-02, skips RED
- [ ] AC-03  All TCs RED or GREEN → "all implemented", exit 0

## US-USER-05 — Implement one executable test case (RED)
- [ ] AC-01  TC-04 PLANNED + valid skeleton → test code written, status → RED
- [ ] AC-02  TC-04 already RED → exit 1, "already implemented", no change
- [ ] AC-03  --target is whole file not single TC → exit 1, mismatch
- [ ] AC-04  TC-04 skeleton missing @[Category] → exit 1, integrity failure, no change

## US-USER-06 — Implement all test cases in a file
- [ ] AC-01  Mixed PLANNED/RED TCs → implemented in CaTDD priority order, summary
- [ ] AC-02  TC-02 fails mid-run → left PLANNED, continues, summary counts failures

## US-USER-07 — Batch skeleton design across multiple files
- [ ] AC-01  Multiple --target files + shared source → each file receives skeletons, per-file results

## US-USER-08 — Combined design-and-implement in one pass
- [ ] AC-01  Story + source + empty target → skeletons designed then all TCs → FULLY_RED

## US-USER-09 — Review implemented test case
- [ ] AC-01  TC-04 RED with preserved skeleton → stdout: preservation + test quality
- [ ] AC-02  TC-04 PLANNED (not implemented) → "not yet implemented", exit 0
- [ ] AC-03  --target is whole file not single TC → exit 1, mismatch

## US-USER-10 — Review all implemented test cases in a file
- [ ] AC-01  Mixed RED/PLANNED TCs → per-TC review for RED, PLANNED skipped, summary
- [ ] AC-02  No RED TCs (all PLANNED) → "0 implemented TCs", exit 0

## US-INVENTOR-01 — Delegate all CaTDD semantics to methodPrompts
- [ ] AC-01  CLI needs Edge category meaning → reads from methodPrompts/, exits if missing
- [ ] AC-02  --behave designFuncTestsSkeleton → invokes slashCommands/, no inline logic
- [ ] AC-03  CLI modifies test file, CaTDD content appears → from delegated layers, never hardcoded

## US-INVENTOR-02 — Produce machine-readable execution traces
- [ ] AC-01  Valid invocation succeeds → trace artifact: invocation, resolution, output
- [ ] AC-02  Valid invocation fails during execution → trace records failure point + completed steps
- [ ] AC-03  Trace artifact parsed by JSON/YAML → valid, fields match schema

## US-INVENTOR-03 — Diagnostic visibility into method resolution
- [ ] AC-01  --diagMethodPrompts → lists prompt paths and categories
- [ ] AC-02  --diagSlashCommands → lists command names and paths

## US-DEV-01 — Actionable error messages for all failure states
- [ ] AC-01  --behave typo → stderr suggests correction + lists valid values
- [ ] AC-02  --inputFile to missing file → stderr names path + argument name
- [ ] AC-03  TC target + skeleton design behavior → stderr explains why + suggests alternatives

## US-DEV-02 — Configurable logging and diagnostic output
- [ ] AC-01  --log-level error → stderr: only errors, stdout unaffected
- [ ] AC-02  --log-level debug → stderr shows state transitions

## US-DEV-03 — Interactive per-command confirmation
- [ ] AC-01  Interactive mode → prompts [y/n/s/a] before each slash command
- [ ] AC-02  User inputs "a" (abort) → no further commands, exit 1, trace records skipped

## US-DEV-04 — Runtime adapter interface
- [ ] AC-01  Adapter implements CliRuntimeAdapter → calls invoke() with full context
- [ ] AC-02  No custom adapter → built-in default adapter executes directly

## US-DEV-05 — Execute ASR reliability and safety policy deterministically
- [ ] AC-01  Retry/correction budget exhaustion → deterministic stop + trace escalation outcome
- [ ] AC-02  Unknown --behave → diagnostics fallback + argument-error exit
- [ ] AC-03  Transient vs permanent failure class routing → retry-eligible vs fail-fast behavior
- [ ] AC-04  Multi-step failure → step-consistency boundary preserved + mutating steps blocked
- [ ] AC-05  Non-interactive escalation → force abort + explicit escalation trace tag
- [ ] AC-06  Shell safety policy enforced → allowlist execution + sensitive-path deny + trace redaction
