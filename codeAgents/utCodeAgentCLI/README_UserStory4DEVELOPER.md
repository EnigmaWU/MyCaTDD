# utCodeAgentCLI Requirements — DEVELOPER

> Master index, state model, and quick-reference AC checklist: [README_UserStory.md](README_UserStory.md)

**As a** DEVELOPER: "I build, test, and extend the CLI. I need clear contracts, diagnostics, and adapter boundaries."

---

### US-DEV-01 [P0] — Actionable error messages for all failure states

**As a** DEVELOPER, **I want** every error message to name the problem, identify the affected argument, and suggest the correction, **so that** I can debug invocation issues without reading CLI source code.

#### AC-01: Unrecognized argument value suggests a correction
- **Given** the CLI is invoked with `--behave "deisgnAllSkeleton"` (typo)
- **When** validation fails
- **Then** stderr includes the string `"deisgnAllSkeleton"` is not recognized
- **And** stderr includes a suggestion: `"Did you mean 'designAllSkeleton'?"` (best match)
- **And** stderr includes the full list of valid values

#### AC-02: Missing file error includes the exact path
- **Given** `--inputFile nonexistent/path.h`
- **When** validation fails
- **Then** stderr includes the full resolved path `nonexistent/path.h`
- **And** stderr states the argument name (`--inputFile`)

#### AC-03: Target/behavior mismatch explains why and suggests alternatives
- **Given** `--target tests/auth_test.cpp::TC-03 --behave designAllSkeleton`
- **When** validation detects the mismatch
- **Then** stderr explains: skeleton design requires a file-level `--target`, not a TC-level target
- **And** stderr suggests valid `--target` forms for skeleton design or valid `--behave` values for TC-level targets

---

### US-DEV-02 [P1] — Configurable logging and diagnostic output

**As a** DEVELOPER, **I want** `--log-level` to control output verbosity, **so that** I can run quietly in production or verbosely when debugging.

#### AC-01: --log-level error suppresses non-error output
- **Given** any valid invocation with `--log-level error`
- **When** the CLI executes successfully
- **Then** only error-class messages appear in stderr
- **And** stdout is unaffected (behavior output still appears)

#### AC-02: --log-level debug reveals internal resolution
- **Given** any valid invocation with `--log-level debug`
- **When** the CLI executes
- **Then** stderr includes state transitions: argument parsing, behavior resolution, slash-command selection, file writes

---

### US-DEV-03 [P1] — Interactive per-command confirmation

**As a** DEVELOPER, **I want** to preview each slash command before it runs, **so that** I can approve, skip, or abort multi-step invocations without blind execution.

#### AC-01: Each slash command prompts before execution
- **Given** a `designAndImplTest` invocation with `--interactive-slash-commands`
- **When** the CLI resolves a slash command (e.g., `UT_designFuncTestsSkeleton`)
- **Then** stdout prompts: "Execute UT_designFuncTestsSkeleton on tests/auth_api_test.cpp? [y/n/s(kip)/a(bort)]"
- **And** the CLI waits for input before proceeding

#### AC-02: Abort stops all further execution
- **Given** an interactive session with multiple pending slash commands
- **When** the user inputs "a" (abort) at any prompt
- **Then** no further slash commands execute
- **And** the CLI exits with code 1
- **And** the trace records which commands were skipped

---

### US-DEV-04 [P2] — Runtime adapter interface

**As a** DEVELOPER, **I want** the CLI's slash-command execution backend to be replaceable through a documented adapter interface, **so that** `utCodeAgentCLI` can run on top of Copilot-native, OpenCode, or custom agent runtimes without rewriting the CLI core.

#### AC-01: Adapter conforms to a defined interface
- **Given** a runtime adapter implementing the `CliRuntimeAdapter` interface
- **When** the CLI needs to invoke a slash command
- **Then** it calls the adapter's `invoke(slashCommand, context)` method
- **And** the adapter receives the resolved command path, target, source, and goal context
- **And** the CLI does not assume any specific runtime (TypeScript, Python, shell)

#### AC-02: Default adapter is provided
- **Given** no custom adapter is configured
- **When** the CLI runs
- **Then** a built-in default adapter executes slash commands directly
