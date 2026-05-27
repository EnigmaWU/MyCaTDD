# utCodeAgentCLI Usage Design

This document captures the CLI interface design for `utCodeAgentCLI`. It is based on [`slashCommands/templates/README_UsageDesignTemplate.md`](../../slashCommands/templates/README_UsageDesignTemplate.md).

- Story: Usage design for utCodeAgentCLI
- Source artifact: GitHub issue — "Usage design for utCodeAgentCLI"
- Related overview: [README.md](README.md)
- Related user guide: [README_UserGuide.md](README_UserGuide.md)

## CLI Interface

```text
utCodeAgentCLI [OPTIONS]

Options:
  --target      <value>    Select the CaTDD work target.
  --behave      <value>    Select the behavior to apply to the target.
  --reference   <FILEs>   Comma-separated list of reference files the agent should consult.
  --diagMethodPrompts      Emit DIAG log messages showing which method prompts the agent resolved.
  --diagSlashCommands      Emit DIAG log messages showing which slash commands the agent resolved.
```

## Argument Reference

| Argument | Type | Values | Required | Description |
| --- | --- | --- | --- | --- |
| `--target` | string | `TestCase` \| `TestFile` \| `InterfaceFile` \| `ProtocolFile` | yes | Selects the CaTDD artifact or scope the agent should act on. |
| `--behave` | string | `implTestCase` \| `implTestFile` \| `designTypical` \| `designEdge` \| `designTypicalSkeleton` \| `designEdgeSkeleton` \| `designAllSkeleton` \| `designAndImplTest` | yes | Selects the CaTDD workflow behavior the agent applies to the target. |
| `--reference` | string | Comma-separated file paths | no | One or more reference files the agent should consult when generating output. Multiple files are separated by commas. Paths may be absolute or relative to the repository root. |
| `--diagMethodPrompts` | flag | — | no | Emits DIAG-class log messages listing the method prompts the agent resolved for this invocation. Confirms correct CaTDD methodPrompt selection at runtime. |
| `--diagSlashCommands` | flag | — | no | Emits DIAG-class log messages listing the slash commands the agent resolved for this invocation. Confirms correct CaTDD slashCommand selection at runtime. |

### `--target` values

| Value | Meaning |
| --- | --- |
| `TestCase` | A single test case (one test function or method inside a test file). |
| `TestFile` | A whole test file containing multiple test cases. |
| `InterfaceFile` | An interface declaration file (e.g., a header, API contract, or abstract class). |
| `ProtocolFile` | A protocol or message-format file (e.g., a network protocol definition, IDL, or schema). |

### `--behave` values

| Value | Meaning |
| --- | --- |
| `implTestCase` | Implement a single test case in the target, following the RED step of CaTDD. Adds executable test code. |
| `implTestFile` | Implement all test cases in a target test file, following the RED step of CaTDD. Adds executable test code. |
| `designTypical` | Design test cases using the CaTDD **Typical** category. Produces a category skeleton with US/AC/TC entries appropriate for core happy-path scenarios. Does **not** add implementation test code. |
| `designEdge` | Design test cases using the CaTDD **Edge** category. Produces a category skeleton with US/AC/TC entries for valid boundary values, limits, and mode variations. Does **not** add implementation test code. |
| `designTypicalSkeleton` | Design a test file of the CaTDD **Typical** category only with US/AC/TC skeleton. No implementation test code is written. |
| `designEdgeSkeleton` | Design a test file of the CaTDD **Edge** category only with US/AC/TC skeleton. No implementation test code is written. |
| `designAllSkeleton` | Design skeletons for all applicable CaTDD categories (Typical, Edge, and others). US/AC/TC comments for every category are placed in the target file, but **no implementation test code** is written. |
| `designAndImplTest` | Design all category skeletons **and** implement their test cases in one combined step. Both US/AC/TC structure and executable test code are produced. |

> **Key distinction**: `designTypical`, `designEdge`, and other category-named values use a specific CaTDD-defined category to drive the design content. `designTypicalSkeleton`, `designEdgeSkeleton`, and `designAllSkeleton` produce only the US/AC/TC skeleton structure for their respective categories without any implementation test code.

## Behavior Matrix

| `--target` | `--behave` | Expected behavior |
| --- | --- | --- |
| `TestCase` | `implTestCase` | Implement one test case. Adds executable test code. Preserves CaTDD comment skeleton and RED status. |
| `TestFile` | `implTestFile` | Implement all test cases in the file. Adds executable test code. Preserves CaTDD status discipline. |
| `TestFile` | `designTypical` | Design Typical category content using the CaTDD Typical category definition. Places US/AC/TC for core happy-path scenarios. No implementation test code. |
| `TestFile` | `designEdge` | Design Edge category content using the CaTDD Edge category definition. Places US/AC/TC for boundary values and valid limits. No implementation test code. |
| `TestFile` | `designTypicalSkeleton` | Place a Typical-category-only US/AC/TC skeleton in the test file. No implementation test code. |
| `TestFile` | `designEdgeSkeleton` | Place an Edge-category-only US/AC/TC skeleton in the test file. No implementation test code. |
| `TestFile` | `designAllSkeleton` | Place US/AC/TC skeletons for all applicable CaTDD categories in the test file. No implementation test code. |
| `TestFile` | `designAndImplTest` | Design all category skeletons and implement them. Produces both US/AC/TC structure and executable test code. |
| `InterfaceFile` | `designAllSkeleton` | Place US/AC/TC skeletons for all interface functions or methods. No implementation test code. |
| `InterfaceFile` | `designAndImplTest` | Design all skeletons for interface functions and implement their test cases. |
| `ProtocolFile` | `designAllSkeleton` | Place US/AC/TC skeletons for all protocol message or field cases. No implementation test code. |
| `ProtocolFile` | `designAndImplTest` | Design all skeletons for protocol cases and implement their test cases. |

## Invocation Examples

```bash
# Design all test skeletons for a test file
utCodeAgentCLI --target TestFile --behave designAllSkeleton

# Implement a single test case
utCodeAgentCLI --target TestCase --behave implTestCase

# Design and implement tests from an interface file
utCodeAgentCLI --target InterfaceFile --behave designAndImplTest

# Consult one reference file when implementing a test case
utCodeAgentCLI --target TestCase --behave implTestCase --reference docs/api-contract.md

# Consult multiple reference files (comma-separated) when designing skeletons
utCodeAgentCLI --target TestFile --behave designAllSkeleton --reference docs/api.md,docs/schema.md

# Emit DIAG log messages showing resolved method prompts during execution
utCodeAgentCLI --target TestFile --behave designAllSkeleton --diagMethodPrompts

# Emit DIAG log messages showing resolved slash commands during execution
utCodeAgentCLI --target TestFile --behave designAndImplTest --diagSlashCommands
```

## Error and Edge Handling

- `--target` missing -> Print usage and exit with a non-zero status code.
- `--behave` missing -> Print usage and exit with a non-zero status code.
- `--target` given an unrecognized value -> Print supported values and exit with a non-zero status code.
- `--behave` given an unrecognized value -> Print supported values and exit with a non-zero status code.
- `--target TestCase` combined with `--behave designTypicalSkeleton`, `designEdgeSkeleton`, or `designAllSkeleton` -> Unsupported combination. Print error and exit; skeleton behaviors require a file-level target.
- `--reference` given a path that does not exist -> Print the missing path and exit with a non-zero status code.
- `--reference` given an empty string or only commas -> Treat as if `--reference` was not provided; emit a warning.
- `--diagMethodPrompts` and `--diagSlashCommands` both provided -> Emit DIAG log messages for both during execution.

## Open Questions

- Should `--target` accept a file path argument in addition to the type selector?

## Usage Example

Run from the repository root to inspect this usage design without changing source files:

```bash
TMP_DOC="$(mktemp -d)/README_UsageDesign.md"
cp codeAgents/utCodeAgentCLI/README_UsageDesign.md "$TMP_DOC"
grep -E '^##|--target|--behave|--reference|--diag' "$TMP_DOC"
```

Expected result: the temporary file path is printed, and the grep output shows all CLI argument names and section headings.

## Review Checklist

- Every argument has a type, value set, and clear description.
- Every supported combination in the behavior matrix has an expected outcome.
- Unsupported combinations have explicit error behavior.
- Open questions are visible before implementation begins.
- No runnable CLI implementation is claimed before it exists.
