# US-DEV-05 [P1] — Execute ASR reliability and safety policy deterministically

**As a** DEVELOPER, **I want** ASR-derived reliability and safety policies to be executable and verifiable at CLI runtime, **so that** architecture contracts are enforced as final-delivery behavior instead of static documentation.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-06 | 6 | Policy enforced |
| Edge | ValidFunc | AC-07 ~ AC-10 | 4 | Policy boundary |
| Misuse | InvalidFunc | AC-11 ~ AC-14 | 4 | Policy violations |
| Fault | InvalidFunc | AC-15 ~ AC-18 | 4 | Infrastructure failure |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 6 | 0 | 0 | 0 | 0 | 0 | 6 |
| Edge | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Misuse | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| Fault | 4 | 0 | 0 | 0 | 0 | 0 | 4 |
| **Total** | **18** | **0** | **0** | **0** | **0** | **0** | **18** |

---

## Typical (ValidFunc) — Policy enforced

### 【PENDING】AC-01 [Func/Typical]: Retry budget exhaustion deterministic (ASR-R1)
- **Given** step fails retry-eligible, budget=3
- **When** fails 3 times
- **Then** CLI stops, exit 1, trace records exhaustion

### 【PENDING】AC-02 [Func/Typical]: Unknown --behave exits with diagnostics (ASR-R2)
- **Given** --behave unknown
- **When** resolution runs
- **Then** CLI prints supported, exit 1

### 【PENDING】AC-03 [Func/Typical]: Transient failure retried (ASR-R3)
- **Given** transient error (temporary file lock)
- **When** error handling evaluates
- **Then** classified transient, retries up to budget

### 【PENDING】AC-04 [Func/Typical]: Permanent failure fails fast (ASR-R3)
- **Given** permanent error (missing required file)
- **When** error handling evaluates
- **Then** classified permanent, no retry, exit 1

### 【PENDING】AC-05 [Func/Typical]: Step-consistency preserved (ASR-R4)
- **Given** step 1 completed, step 2 fails
- **When** failure handling executes
- **Then** step 1 preserved, no further steps

### 【PENDING】AC-06 [Func/Typical]: Shell safety allowlist (ASR-R6)
- **Given** path within slashCommands/commands/
- **When** CLI invokes command
- **Then** path verified, outside blocked exit 1

---

## Edge (ValidFunc) — Policy boundary

### 【PENDING】AC-07 [Func/Edge]: Budget exactly exhausted on last retry
- **Given** budget=3, 3rd retry fails
- **When** counter reaches 0
- **Then** CLI stops, trace: retries=3, remaining=0

### 【PENDING】AC-08 [Func/Edge]: Zero retry budget
- **Given** budget=0
- **When** transient error occurs
- **Then** no retry, fails immediately

### 【PENDING】AC-09 [Func/Edge]: Non-interactive escalation (ASR-R5)
- **Given** non-interactive mode + escalation conditions
- **When** control evaluates
- **Then** force-abort exit 1, no prompt

### 【PENDING】AC-10 [Func/Edge]: Sensitive paths denied (ASR-R6)
- **Given** path outside project root
- **When** safety check runs
- **Then** denied: outside project boundary

---

## Misuse (InvalidFunc) — Policy violations

### 【PENDING】AC-11 [Func/Misuse]: Env override ignored when disabled
- **Given** CATDD_RETRY_BUDGET=999 but allowEnvOverride:false
- **When** CLI loads policy
- **Then** env ignored, diag logs override blocked

### 【PENDING】AC-12 [Func/Misuse]: Circular policy reference
- **Given** config with mutually referencing keys
- **When** CLI resolves
- **Then** exit 1, stderr: circular reference

### 【PENDING】AC-13 [Func/Misuse]: Mutate completed step blocked
- **Given** step 1 done, step 2 failed, recovery retries step 1
- **When** guard evaluates
- **Then** blocked, trace: blockedMutation

### 【PENDING】AC-14 [Func/Misuse]: Config disables mandatory safety
- **Given** config: safety:{pathAllowlist:false}
- **When** policy loading runs
- **Then** exit 1, stderr: mandatory cannot be disabled

---

## Fault (InvalidFunc) — Infrastructure failure

### 【PENDING】AC-15 [Func/Fault]: Policy config file missing
- **Given** policy file not found
- **When** loading runs
- **Then** exit 1, stderr: not found

### 【PENDING】AC-16 [Func/Fault]: Policy config unparseable
- **Given** invalid YAML in policy file
- **When** CLI parses
- **Then** exit 1, includes parse error with line

### 【PENDING】AC-17 [Func/Fault]: Runtime adapter missing
- **Given** custom adapter path not found
- **When** CLI invokes
- **Then** exit 1, stderr: adapter not found

### 【PENDING】AC-18 [Func/Fault]: Policy values semantically invalid
- **Given** retryBudget:"unlimited" (string, not int)
- **When** policy validation runs
- **Then** exit 1, stderr: expected integer