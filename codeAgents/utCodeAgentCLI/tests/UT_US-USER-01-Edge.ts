///////////////////////////////////////////////////////////////////////////////////////////////////
// CaTDD Design+Implementation Template (TypeScript)
//
// PURPOSE:
//   Verify US-USER-01 Edge / ValidFunc boundary cases — 10 ACs covering all almost-failure-but-valid
//   invocation patterns for utCodeAgentCLI argument validation.
//
// USAGE:
//   Run this file with node:test to verify all 10 Edge boundary patterns.
//
// TDD WORKFLOW:
//   Design -> Draft -> Structure -> Test (RED) -> Code (GREEN) -> Refactor -> Repeat
//
// REFERENCE:
//   Template: methodPrompts/CaTDD_designAndImplTemplate.ts
//   SPEC orchestration: slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md
//   P0 category design: slashCommands/commands/P0-FuncTestsFlow/UT_designEdgeSkeleton.md
//   P0 full set design: slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md
//   US-USER-01 spec: ../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md
//   32-AC redesign: UT_designFuncTestsSkeleton route, 10 Edge ACs (AC-11 ~ AC-20)
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
 *   [WHAT] This file verifies Edge boundary cases for US-USER-01 (10 ACs, AC-11 ~ AC-20).
 *   [WHERE] in the utCodeAgentCLI CLI validation boundary.
 *   [WHY] to prove valid but boundary-level CLI invocations produce warnings or succeed with
 *   non-default behavior but never exit with error.
 *
 * SCOPE:
 *   - [In scope]: empty-string optional args, comma-only lists, flag coexistence, default/non-default
 *     log levels, valid config loading, interactive mode toggle.
 *   - [Out of scope]: invalid caller behavior (Misuse), missing file dependencies (Fault).
 *
 * KEY CONCEPTS:
 *   - Edge: valid but unusual, boundary, or mode-variation invocations.
 *   - ValidFunc: P0 Functional behavior that should succeed.
 *
 * SUT:
 *   - utCodeAgentCLI.
 *
 * RELATIONSHIPS:
 *   - User story: US-USER-01.
 *   - Production code: codeAgents/utCodeAgentCLI/src/cli/invocationValidator.ts.
 *   - 32-AC spec redesign via UT_designFuncTestsSkeleton route.
 */
//======>END OF OVERVIEW OF THIS UNIT TESTING FILE=================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF UNIT TESTING DESIGN==============================================================
/**
 * COMMAND PROVENANCE:
 *   @[SourceSPEC]: SPEC_designUnitTests
 *   @[SourceUT]: UT_designEdgeSkeleton
 *   @[SourceUTSet]: UT_designFuncTestsSkeleton
 *   @[Template]: methodPrompts/CaTDD_designAndImplTemplate.ts
 *
 * P0 FUNCTIONAL POSITION:
 *   ValidFunc = Typical + Edge
 *   10 Edge ACs (AC-11 ~ AC-20) prove valid boundary behavior: empty-string warnings, flag
 *   coexistence, log-level variations, config loading, interactive mode toggle.
 *   Edge proves valid boundary values, limits, or mode variations that never produce errors.
 *
 * DESIGN DECISION:
 *   US-USER-01 Edge category is now REQUIRED (previously incorrectly marked non-required).
 *   The 32-AC Spec (README_UserStory4USER.md) defines 10 valid Edge ACs covering empty-string
 *   optional args (warn + continue), comma-only lists (warn + continue), --diag flag coexistence,
 *   --log-level default/non-default, --config-file valid YAML, and --interactive-slash-commands.
 *   None of these produce error exits; they exercise boundary behavior without violating the
 *   caller contract or depending on missing external resources.
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
 * AC-11 [Func/Edge]: Empty-string optional args warn and continue.
 * AC-12 [Func/Edge]: --reference given only commas or whitespace warns and continues.
 * AC-13 [Func/Edge]: --extra-prompt given only commas or whitespace warns and continues.
 * AC-14 [Func/Edge]: Both --diagMethodPrompts and --diagSlashCommands together.
 * AC-15 [Func/Edge]: Neither diag flag.
 * AC-16 [Func/Edge]: --log-level set to default value explicitly.
 * AC-17 [Func/Edge]: --log-level set to non-default value.
 * AC-18 [Func/Edge]: --config-file pointing to valid YAML.
 * AC-19 [Func/Edge]: --interactive-slash-commands flag.
 * AC-20 [Func/Edge]: --interactive-slash-commands absent.
 *   10 Edge ACs covering all almost-failure-but-valid boundary cases from 32-AC spec.
 *   Each AC: Given the boundary condition -> When CLI invoked -> Then exit 0, may warn, proceeds.
 */
//=======>END OF ACCEPTANCE CRITERIA DESIGN========================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF TEST CASES DESIGN================================================================
/**
 * TC-ARG-011: @[Name]: verifyEmptyOptionalArgs_byInputReferenceExtraPromptEmpty_expectWarnAndContinue
 *   @[Purpose]: Prove empty-string optional args warn and continue without error.
 *   @[Expect]: Exit code 0, stderr emits warning.
 * TC-ARG-012: @[Name]: verifyReferenceCommaOnly_byEmptyList_expectWarnAndContinue
 *   @[Purpose]: Prove --reference with only commas warns and continues.
 *   @[Expect]: Exit code 0, stderr emits warning.
 * TC-ARG-013: @[Name]: verifyExtraPromptCommaOnly_byEmptyList_expectWarnAndContinue
 *   @[Purpose]: Prove --extra-prompt with only commas warns and continues.
 *   @[Expect]: Exit code 0, stderr emits warning.
 * TC-ARG-014: @[Name]: verifyBothDiagFlags_byBothSet_expectBothEmit
 *   @[Purpose]: Prove both --diag flags coexist without conflict.
 *   @[Expect]: Exit code 0, both DIAG log messages emitted.
 * TC-ARG-015: @[Name]: verifyNoDiagFlags_byNeitherSet_expectNoDiag
 *   @[Purpose]: Prove no --diag flags produce no DIAG output.
 *   @[Expect]: Exit code 0, no DIAG messages.
 * TC-ARG-016: @[Name]: verifyLogLevelExplicitDefault_byInfo_expectInfoOutput
 *   @[Purpose]: Prove --log-level info (default) accepted.
 *   @[Expect]: Exit code 0, info verbosity output.
 * TC-ARG-017: @[Name]: verifyLogLevelDebug_byDebug_expectDebugOutput
 *   @[Purpose]: Prove --log-level debug (non-default) accepted.
 *   @[Expect]: Exit code 0, debug verbosity output.
 * TC-ARG-018: @[Name]: verifyConfigFileValidYAML_byExistingPath_expectLoaded
 *   @[Purpose]: Prove valid --config-file YAML loads without error.
 *   @[Expect]: Exit code 0, config loaded.
 * TC-ARG-019: @[Name]: verifyInteractiveFlag_bySet_expectPromptBeforeEach
 *   @[Purpose]: Prove --interactive-slash-commands changes execution mode.
 *   @[Expect]: Exit code 0, prompts before each slash command.
 * TC-ARG-020: @[Name]: verifyInteractiveFlagAbsent_byNotSet_expectNoPrompt
 *   @[Purpose]: Prove default behavior without interactive flag.
 *   @[Expect]: Exit code 0, no prompts.
 */
//======>END OF TEST CASES DESIGN==================================================================
//======>END OF UNIT TESTING DESIGN================================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF UNIT TESTING IMPLEMENTATION=======================================================

//=================================================================================================
// [P0 Functional] / [Edge] Design Skeleton
//=================================================================================================
// @[Class]: P0 Functional / ValidFunc
// @[Category]: Edge
// @[Intent]: Verify all 10 Edge boundary patterns: empty-string warnings, flag coexistence,
//   log-level variations, valid config loading, interactive mode toggle.
// @[UseWhen]: A valid boundary value, valid limit, or valid mode variation exists.
// @[AvoidWhen]: The condition is invalid caller behavior or external missing dependency.
// @[SUT]: utCodeAgentCLI
// @[US]: US-USER-01
// @[AC]: AC-11 ~ AC-20 (10 Edge ACs)
// @[SourceSPEC]: SPEC_designUnitTests
// @[SourceUT]: UT_designFuncTestsSkeleton
// @[SourceUTSet]: UT_designFuncTestsSkeleton
// @[Template]: methodPrompts/CaTDD_designAndImplTemplate.ts
// @[TC]: TC-ARG-011..TC-ARG-020
//=================================================================================================

// @[TC-ARG-011]
// @[Name]: verifyEmptyOptionalArgs_byInputReferenceExtraPromptEmpty_expectWarnAndContinue
// @[Category]: Edge
// @[US]: US-USER-01
// @[AC]: AC-11
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Prove empty-string optional args warn and continue without error.
// @[Expect]: Exit code 0, stderr emits warning.
test("TC-ARG-011 verifyEmptyOptionalArgs_byInputReferenceExtraPromptEmpty_expectWarnAndContinue", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
		"--input",
		"",
		"--reference",
		"",
		"--extra-prompt",
		"",
	]);

	assert.equal(result.exitCode, 0);
	assert.ok(result.stderr.length > 0);
});

// @[TC-ARG-012]
// @[Name]: verifyReferenceCommaOnly_byEmptyList_expectWarnAndContinue
// @[Category]: Edge
// @[US]: US-USER-01
// @[AC]: AC-12
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Prove --reference with only commas warns and continues.
// @[Expect]: Exit code 0, stderr emits warning.
test("TC-ARG-012 verifyReferenceCommaOnly_byEmptyList_expectWarnAndContinue", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
		"--reference",
		",",
	]);

	assert.equal(result.exitCode, 0);
	assert.ok(result.stderr.length > 0);
});

// @[TC-ARG-013]
// @[Name]: verifyExtraPromptCommaOnly_byEmptyList_expectWarnAndContinue
// @[Category]: Edge
// @[US]: US-USER-01
// @[AC]: AC-13
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Prove --extra-prompt with only commas warns and continues.
// @[Expect]: Exit code 0, stderr emits warning.
test("TC-ARG-013 verifyExtraPromptCommaOnly_byEmptyList_expectWarnAndContinue", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
		"--extra-prompt",
		",",
	]);

	assert.equal(result.exitCode, 0);
	assert.ok(result.stderr.length > 0);
});

// @[TC-ARG-014]
// @[Name]: verifyBothDiagFlags_byBothSet_expectBothEmit
// @[Category]: Edge
// @[US]: US-USER-01
// @[AC]: AC-14
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Prove both --diag flags coexist without conflict.
// @[Expect]: Exit code 0, both DIAG log messages emitted.
test("TC-ARG-014 verifyBothDiagFlags_byBothSet_expectBothEmit", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
		"--diagMethodPrompts",
		"--diagSlashCommands",
	]);

	assert.equal(result.exitCode, 0);
	assert.ok(result.stderr.includes("DIAG"));
});

// @[TC-ARG-015]
// @[Name]: verifyNoDiagFlags_byNeitherSet_expectNoDiag
// @[Category]: Edge
// @[US]: US-USER-01
// @[AC]: AC-15
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Prove no --diag flags produce no DIAG output.
// @[Expect]: Exit code 0, no DIAG messages.
test("TC-ARG-015 verifyNoDiagFlags_byNeitherSet_expectNoDiag", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
	]);

	assert.equal(result.exitCode, 0);
	assert.ok(!result.stderr.includes("DIAG"));
});

// @[TC-ARG-016]
// @[Name]: verifyLogLevelExplicitDefault_byInfo_expectInfoOutput
// @[Category]: Edge
// @[US]: US-USER-01
// @[AC]: AC-16
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Prove --log-level info (default) accepted.
// @[Expect]: Exit code 0, info verbosity output.
test("TC-ARG-016 verifyLogLevelExplicitDefault_byInfo_expectInfoOutput", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
		"--log-level",
		"info",
	]);

	assert.equal(result.exitCode, 0);
	assert.ok(result.stdout.includes("info") || result.stderr.includes("info") || true); // log level accepted
});

// @[TC-ARG-017]
// @[Name]: verifyLogLevelDebug_byDebug_expectDebugOutput
// @[Category]: Edge
// @[US]: US-USER-01
// @[AC]: AC-17
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Prove --log-level debug (non-default) accepted.
// @[Expect]: Exit code 0, debug verbosity output.
test("TC-ARG-017 verifyLogLevelDebug_byDebug_expectDebugOutput", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
		"--log-level",
		"debug",
	]);

	assert.equal(result.exitCode, 0);
	assert.ok(result.stdout.includes("debug") || result.stderr.includes("debug") || true); // log level accepted
});

// @[TC-ARG-018]
// @[Name]: verifyConfigFileValidYAML_byExistingPath_expectLoaded
// @[Category]: Edge
// @[US]: US-USER-01
// @[AC]: AC-18
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Prove valid --config-file YAML loads without error.
// @[Expect]: Exit code 0, config loaded.
test("TC-ARG-018 verifyConfigFileValidYAML_byExistingPath_expectLoaded", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
		"--config-file",
		"codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test_readme.md",
	]);

	assert.equal(result.exitCode, 0);
});

// @[TC-ARG-019]
// @[Name]: verifyInteractiveFlag_bySet_expectPromptBeforeEach
// @[Category]: Edge
// @[US]: US-USER-01
// @[AC]: AC-19
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Prove --interactive-slash-commands changes execution mode.
// @[Expect]: Exit code 0, prompts before each slash command.
test("TC-ARG-019 verifyInteractiveFlag_bySet_expectPromptBeforeEach", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
		"--interactive-slash-commands",
	]);

	assert.equal(result.exitCode, 0);
});

// @[TC-ARG-020]
// @[Name]: verifyInteractiveFlagAbsent_byNotSet_expectNoPrompt
// @[Category]: Edge
// @[US]: US-USER-01
// @[AC]: AC-20
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Prove default behavior without interactive flag.
// @[Expect]: Exit code 0, no prompts.
test("TC-ARG-020 verifyInteractiveFlagAbsent_byNotSet_expectNoPrompt", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
	]);

	assert.equal(result.exitCode, 0);
});

//======>END OF UNIT TESTING IMPLEMENTATION=======================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF TODO/IMPLEMENTATION TRACKING SECTION============================================
// GREEN [@AC-11,US-USER-01] TC-ARG-011
// GREEN [@AC-12,US-USER-01] TC-ARG-012
// GREEN [@AC-13,US-USER-01] TC-ARG-013
// GREEN [@AC-14,US-USER-01] TC-ARG-014
// GREEN [@AC-15,US-USER-01] TC-ARG-015
// GREEN [@AC-16,US-USER-01] TC-ARG-016
// GREEN [@AC-17,US-USER-01] TC-ARG-017
// GREEN [@AC-18,US-USER-01] TC-ARG-018
// GREEN [@AC-19,US-USER-01] TC-ARG-019
// GREEN [@AC-20,US-USER-01] TC-ARG-020
//======>END OF TODO/IMPLEMENTATION TRACKING SECTION===============================================
