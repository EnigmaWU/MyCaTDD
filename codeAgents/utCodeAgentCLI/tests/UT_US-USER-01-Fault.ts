///////////////////////////////////////////////////////////////////////////////////////////////////
// CaTDD Design+Implementation Template (TypeScript)
//
// PURPOSE:
//   Verify US-USER-01 Fault / InvalidFunc behavior for utCodeAgentCLI argument validation.
//
// USAGE:
//   Run this file with node:test to verify missing file-path dependencies are reported clearly.
//
// TDD WORKFLOW:
//   Design -> Draft -> Structure -> Test (RED) -> Code (GREEN) -> Refactor -> Repeat
//
// REFERENCE:
//   Template: methodPrompts/CaTDD_designAndImplTemplate.ts
//   SPEC orchestration: slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md
//   P0 category design: slashCommands/commands/P0-FuncTestsFlow/UT_designFaultSkeleton.md
//   P0 full set design: slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md
///////////////////////////////////////////////////////////////////////////////////////////////////

declare function require(moduleName: string): any;

const test = require("node:test");
const assert = require("node:assert/strict");
const { runUtCodeAgentCli } = require("./runUtCodeAgentCli.ts");

type InvocationResult = {
	exitCode: number;
	stderr: string;
	stdout: string;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF OVERVIEW OF THIS UNIT TESTING FILE===============================================
/**
 * @brief
 *   [WHAT] This file verifies missing file-path dependency failures.
 *   [WHERE] in the utCodeAgentCLI CLI validation boundary.
 *   [WHY] to ensure missing external file dependencies fail fast with path-level diagnostics.
 *
 * SCOPE:
 *   - [In scope]: nonexistent --inputFile, --goalStoryFile, --reference, --extra-prompt, and --config-file values.
 *   - [Out of scope]: caller contract misuse and valid invocation success.
 *
 * KEY CONCEPTS:
 *   - Fault: caller shape is valid, but filesystem dependency is missing.
 *   - InvalidFunc: P0 Functional behavior that should fail safely and clearly.
 *
 * SUT:
 *   - utCodeAgentCLI, executed as a subprocess.
 */
//======>END OF OVERVIEW OF THIS UNIT TESTING FILE=================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF UNIT TESTING DESIGN==============================================================
/**
 * COMMAND PROVENANCE:
 *   @[SourceSPEC]: SPEC_designUnitTests
 *   @[SourceUT]: UT_designFaultSkeleton
 *   @[SourceUTSet]: UT_designFuncTestsSkeleton
 *   @[Template]: methodPrompts/CaTDD_designAndImplTemplate.ts
 *
 * P0 FUNCTIONAL POSITION:
 *   InvalidFunc = Misuse + Fault
 *   Fault proves graceful behavior when dependencies, resources, or environment fail.
 */

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF USER STORY DESIGN================================================================
/**
 * US-USER-01:
 *   As a USER,
 *   I want the CLI to validate my invocation immediately,
 *   So that I get clear, actionable feedback when my arguments are wrong instead of silent
 *   misbehavior.
 */
//======>END OF USER STORY DESIGN==================================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF ACCEPTANCE CRITERIA DESIGN=======================================================
/**
 * AC-04: File-path arguments point to nonexistent files.
 */
//=======>END OF ACCEPTANCE CRITERIA DESIGN========================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF TEST CASES DESIGN================================================================
/**
 * AC-29 -> TC-ARG-029..TC-ARG-033 (nonexistent/unreadable file paths)
 * AC-30 -> TC-ARG-034 (--config-file not valid YAML)
 * AC-31 -> TC-ARG-035 (--config-file is a directory)
 */
//======>END OF TEST CASES DESIGN==================================================================
//======>END OF UNIT TESTING DESIGN================================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF UNIT TESTING IMPLEMENTATION=======================================================

//=================================================================================================
// [P0 Functional] / [Fault] Design Skeleton
//=================================================================================================
// @[Class]: P0 Functional / InvalidFunc
// @[Category]: Fault
// @[Intent]: Validate missing filesystem dependencies are surfaced with path-level diagnostics.
// @[UseWhen]: Caller shape is valid but referenced file-path dependencies are missing.
// @[AvoidWhen]: Use Misuse for missing required args, unknown behavior names, or conflicting flags.
// @[SUT]: utCodeAgentCLI
// @[US]: US-USER-01
// @[AC]: AC-29 ~ AC-31 (3 Fault ACs)
// @[SourceSPEC]: SPEC_designUnitTests
// @[SourceUT]: UT_designFuncTestsSkeleton
// @[SourceUTSet]: UT_designFuncTestsSkeleton
// @[Template]: methodPrompts/CaTDD_designAndImplTemplate.ts
// @[TC]: TC-ARG-029..TC-ARG-035
//=================================================================================================

// @[TC-ARG-008]
// @[Name]: verifyMissingInputFile_byNonexistentPath_expectPathNamedError
// @[Category]: Fault
// @[US]: US-USER-01
// @[AC]: AC-04
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Missing --inputFile should fail before behavior dispatch.
// @[Expect]: Exit code 1 and stderr includes missing inputFile path.
test("TC-ARG-008 verifyMissingInputFile_byNonexistentPath_expectPathNamedError", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
		"--inputFile",
		"missing/auth_api.ts",
	]);

	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /missing\/auth_api\.ts/);
	assert.match(result.stderr, /--inputFile/);
});

// @[TC-ARG-009]
// @[Name]: verifyMissingGoalStoryFile_byNonexistentPath_expectPathNamedError
// @[Category]: Fault
// @[US]: US-USER-01
// @[AC]: AC-04
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Missing --goalStoryFile should fail with direct path reporting.
// @[Expect]: Exit code 1 and stderr includes missing goalStoryFile path.
test("TC-ARG-009 verifyMissingGoalStoryFile_byNonexistentPath_expectPathNamedError", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
		"--goalStoryFile",
		"missing/us-user-01.md",
	]);

	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /missing\/us-user-01\.md/);
	assert.match(result.stderr, /--goalStoryFile/);
});

// @[TC-ARG-010]
// @[Name]: verifyMissingReference_byNonexistentPath_expectPathNamedError
// @[Category]: Fault
// @[US]: US-USER-01
// @[AC]: AC-04
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Missing --reference path should fail and identify the bad path.
// @[Expect]: Exit code 1 and stderr includes missing reference path.
test("TC-ARG-010 verifyMissingReference_byNonexistentPath_expectPathNamedError", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
		"--reference",
		"missing/reference.md",
	]);

	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /missing\/reference\.md/);
	assert.match(result.stderr, /--reference/);
});

// @[TC-ARG-011]
// @[Name]: verifyMissingExtraPrompt_byNonexistentPath_expectPathNamedError
// @[Category]: Fault
// @[US]: US-USER-01
// @[AC]: AC-04
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Missing --extra-prompt path should fail and identify the bad path.
// @[Expect]: Exit code 1 and stderr includes missing extra-prompt path.
test("TC-ARG-011 verifyMissingExtraPrompt_byNonexistentPath_expectPathNamedError", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
		"--extra-prompt",
		"missing/extra-prompt.md",
	]);

	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /missing\/extra-prompt\.md/);
	assert.match(result.stderr, /--extra-prompt/);
});

// @[TC-ARG-012]
// @[Name]: verifyMissingConfigFile_byNonexistentPath_expectPathNamedError
// @[Category]: Fault
// @[US]: US-USER-01
// @[AC]: AC-04
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Missing --config-file path should fail and identify the bad path.
// @[Expect]: Exit code 1 and stderr includes missing config-file path.
test("TC-ARG-012 verifyMissingConfigFile_byNonexistentPath_expectPathNamedError", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
		"--config-file",
		"missing/utcodeagentcli.yaml",
	]);

	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /missing\/utcodeagentcli\.yaml/);
	assert.match(result.stderr, /--config-file/);
});

//======>END OF UNIT TESTING IMPLEMENTATION=======================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF TODO/IMPLEMENTATION TRACKING SECTION============================================
// [Migrated from old AC-04 -> new AC-29..AC-31]
// GREEN [@AC-29,US-USER-01] TC-ARG-029..TC-ARG-033 (nonexistent/unreadable file paths)
// PLANNED [@AC-30,US-USER-01] TC-ARG-034 (--config-file not valid YAML)
// PLANNED [@AC-31,US-USER-01] TC-ARG-035 (--config-file is a directory)
//======>END OF TODO/IMPLEMENTATION TRACKING SECTION===============================================
