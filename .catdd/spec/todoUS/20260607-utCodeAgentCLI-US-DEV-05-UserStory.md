# User Story: utCodeAgentCLI DEVELOPER US-DEV-05 Execute ASR reliability and safety policy deterministically

Created by `/SPEC_importUserStory` on 2026-06-07.
Imported from `codeAgents/utCodeAgentCLI/README_UserStory4DEVELOPER.md` slice `US-DEV-05`.

## Source Trace

- Source story slice: [../../codeAgents/utCodeAgentCLI/README_UserStory4DEVELOPER.md](../../codeAgents/utCodeAgentCLI/README_UserStory4DEVELOPER.md)
- Paired usage context: [../../codeAgents/utCodeAgentCLI/README_UserGuide.md](../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Master requirements index: [../../codeAgents/utCodeAgentCLI/README_UserStory.md](../../codeAgents/utCodeAgentCLI/README_UserStory.md)
- Role area: `codeAgents/utCodeAgentCLI/`
- Import granularity: `US-by-US`
- Imported slice: `US-DEV-05 [P1]`

## Active Work Status

- Status: TODO.
- Active state: `.catdd/spec/todoUS/` ready for `SPEC_openUserStory`.
- Priority: P1 - important.
- Confidence: medium-high.
- Next recommended command: `/SPEC_openUserStory`.

## Story

As a DEVELOPER,
I want ASR-derived reliability and safety policies to be executable and verifiable at CLI runtime,
so that architecture contracts are enforced as final-delivery behavior instead of static documentation.

## Independent Test Intent

A reviewer can inspect runtime behavior and verify that each ASR-derived policy is enforced deterministically with traceable outcomes.

## Acceptance Criteria

#### P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-06 | 6 | ✅ Policy enforced |
| Edge | ValidFunc | AC-07 ~ AC-10 | 4 | ✅ Policy boundary |
| Misuse | InvalidFunc | AC-11 ~ AC-14 | 4 | ❌ Policy violations |
| Fault | InvalidFunc | AC-15 ~ AC-18 | 4 | ❌ Infrastructure failure |

---

### Typical (ValidFunc) — Policy enforced

##### AC-01 [Func/Typical]: Retry budget exhaustion deterministic (ASR-R1)
- **Given** step fails with retry-eligible errors, budget=3
- **When** fails 3 times
- **Then** CLI stops, exit 1, trace records exhaustion

##### AC-02 [Func/Typical]: Unknown --behave exits with diagnostics (ASR-R2)
- **Given** --behave unknown
- **When** behavior resolution runs
- **Then** CLI prints supported values, exit 1, permanent failure

##### AC-03 [Func/Typical]: Transient failure retried (ASR-R3)
- **Given** transient error (temporary file lock)
- **When** error handling evaluates
- **Then** classified transient, retries up to budget

##### AC-04 [Func/Typical]: Permanent failure fails fast (ASR-R3)
- **Given** permanent error (missing required file)
- **When** error handling evaluates
- **Then** classified permanent, no retry, exit 1

##### AC-05 [Func/Typical]: Step-consistency preserved (ASR-R4)
- **Given** step 1 completed, step 2 fails
- **When** failure handling executes
- **Then** step 1 preserved, no further steps

##### AC-06 [Func/Typical]: Shell safety allowlist (ASR-R6)
- **Given** path within slashCommands/commands/
- **When** CLI invokes command
- **Then** path verified against allowlist, outside blocked exit 1

### Edge (ValidFunc) — Policy boundary

##### AC-07 [Func/Edge]: Budget exactly exhausted on last retry
- **Given** budget=3, 3rd retry fails
- **When** counter reaches 0
- **Then** CLI stops, trace: retries=3, remainingBudget=0

##### AC-08 [Func/Edge]: Zero retry budget
- **Given** budget=0
- **When** transient error occurs
- **Then** no retry logic entered, fails immediately

##### AC-09 [Func/Edge]: Non-interactive escalation deterministic (ASR-R5)
- **Given** non-interactive mode + escalation conditions
- **When** control evaluates
- **Then** force-abort exit 1, no prompt, trace has tag

##### AC-10 [Func/Edge]: Sensitive paths denied (ASR-R6)
- **Given** path outside project root
- **When** safety check runs
- **Then** denied: path outside project boundary

### Misuse (InvalidFunc) — Policy violations

##### AC-11 [Func/Misuse]: Env override ignored when disabled
- **Given** CATDD_RETRY_BUDGET=999 but allowEnvOverride:false
- **When** CLI loads policy
- **Then** env ignored, diag logs override blocked

##### AC-12 [Func/Misuse]: Circular policy reference
- **Given** config with mutually referencing keys
- **When** CLI resolves
- **Then** exit 1, stderr: circular policy reference

##### AC-13 [Func/Misuse]: Mutate completed step blocked
- **Given** step 1 done, step 2 failed, recovery attempts step 1
- **When** guard evaluates
- **Then** blocked, trace: blockedMutation

##### AC-14 [Func/Misuse]: Config disables mandatory safety
- **Given** config contains safety:{pathAllowlist:false}
- **When** policy loading runs
- **Then** exit 1, stderr: mandatory policy cannot be disabled

### Fault (InvalidFunc) — Infrastructure failure

##### AC-15 [Func/Fault]: Policy config file missing
- **Given** policy file not found
- **When** loading runs
- **Then** exit 1, stderr: policy configuration file not found

##### AC-16 [Func/Fault]: Policy config unparseable
- **Given** invalid YAML in policy file
- **When** CLI parses
- **Then** exit 1, includes parse error with line number

##### AC-17 [Func/Fault]: Runtime adapter not found
- **Given** custom adapter path not found
- **When** CLI invokes adapter
- **Then** exit 1, stderr: runtime adapter not found

##### AC-18 [Func/Fault]: Policy values semantically invalid
- **Given** retryBudget:"unlimited" (string, not int)
- **When** policy validation runs
- **Then** exit 1, stderr: expected integer got string

## Scope

In scope:

- Runtime-enforced reliability/safety policies.
- Deterministic failure routing and trace recording.
- ASR-to-runtime enforcement.

Out of scope:

- Full policy engine rollout.
- Adapter implementation details.
- Architecture-only documentation without runtime effect.

## Risks

- Policy drift between architecture and runtime.
- Overly strict enforcement could break valid flows.
- Missing redaction or rollback behavior could expose unsafe state.

## Assumptions

- ASR-R1..R6 are authoritative policy inputs.
- Runtime traces can record policy outcomes.
- Non-interactive CI behavior must be deterministic.

## Acceptance Questions

- Should retry budgets be global or per-step?
- Which errors are retry-eligible by default?
- Should policy violations be surfaced as distinct exit codes?

## Next Recommended Action

Run `/SPEC_openUserStory` to move this imported story into `.catdd/spec/doingUS/`.
