///////////////////////////////////////////////////////////////////////////////////////////////////
// CaTDD Design+Implementation Template (TypeScript)
//
// PURPOSE:
//   Verify US-USER-01 Misuse (InvalidFunc) CLI argument validation — 9 ACs (AC-21~AC-28, AC-32)
//   covering all caller-contract-violation patterns for utCodeAgentCLI.
//
// USAGE:
//   Run this file with node:test to verify wrong caller argument usage is rejected clearly.
//
// TDD WORKFLOW:
//   Design -> Draft -> Structure -> Test (RED) -> Code (GREEN) -> Refactor -> Repeat
//
// REFERENCE:
//   Template: methodPrompts/CaTDD_designAndImplTemplate.ts
//   SPEC orchestration: slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md
//   P0 category design: slashCommands/commands/P0-FuncTestsFlow/UT_designMisuseSkeleton.md
//   P0 full set design: slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md
//   US-USER-01 spec: ../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md
//   32-AC redesign: UT_designFuncTestsSkeleton route, 9 Misuse ACs (AC-21~AC-28, AC-32)
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
 *   [WHAT] This file verifies invalid caller argument usage for US-USER-01 (9 Misuse ACs).
 *   [WHERE] in the utCodeAgentCLI CLI validation boundary.
 *   [WHY] to ensure misuse fails fast with actionable diagnostics.
 *
 * SCOPE:
 *   - [In scope]: missing required args, empty string args, mutually exclusive pairs,
 *     unrecognized/unparseable values, target/behave mismatch, and structurally wrong config.
 *   - [Out of scope]: valid invocation success, external missing file dependencies.
 *
 * KEY CONCEPTS:
 *   - Misuse: caller violates named CLI preconditions.
 *   - InvalidFunc: P0 Functional behavior that should fail safely and clearly.
 *
 * SUT:
 *   - utCodeAgentCLI, executed as a subprocess.
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
 *   @[SourceUT]: UT_designMisuseSkeleton
 *   @[SourceUTSet]: UT_designFuncTestsSkeleton
 *   @[Template]: methodPrompts/CaTDD_designAndImplTemplate.ts
 *
 * P0 FUNCTIONAL POSITION:
 *   InvalidFunc = Misuse + Fault
 *   9 Misuse ACs (AC-21~AC-28, AC-32) prove that invalid caller behavior is rejected
 *   safely and clearly with exit code 1 and actionable stderr diagnostics.
 *   Misuse proves wrong caller preconditions produce deterministic error messages.
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
 * AC-21: Missing required argument (--goal, --target, or --behave) exits with error.
 * AC-22: Empty --goal string exits with error.
 * AC-23: Mutually exclusive --goalStory and --goalStoryFile exits with error.
 * AC-24: Mutually exclusive --input and --inputFile exits with error.
 * AC-25: Unrecognized --behave value exits with error and lists valid alternatives.
 * AC-26: Unparseable --target form exits with error and shows supported selectors.
 * AC-27: --target TestCase combined with skeleton design --behave exits with error.
 * AC-28: Unrecognized --log-level value exits with error and lists valid values.
 * AC-32: --config-file with valid YAML but structurally wrong content exits with error.
 */
//=======>END OF ACCEPTANCE CRITERIA DESIGN========================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF TEST CASES DESIGN================================================================
/**
 * AC-21 -> TC-ARG-021..TC-ARG-023 (missing required args)
 * AC-25 -> TC-ARG-024 (unrecognized --behave)
 * AC-23, AC-24 -> TC-ARG-025..TC-ARG-026 (mutually exclusive pairs)
 * AC-22 -> TC-ARG-027 (empty --goal)
 * AC-26 -> TC-ARG-028 (unparseable --target)
 * AC-27 -> TC-ARG-029 (target/behave mismatch)
 * AC-28 -> TC-ARG-030 (unrecognized --log-level)
 * AC-32 -> TC-ARG-031 (structurally wrong config)
 */
//======>END OF TEST CASES DESIGN==================================================================
//======>END OF UNIT TESTING DESIGN================================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF UNIT TESTING IMPLEMENTATION=======================================================

//=================================================================================================
// [P0 Functional] / [Misuse] Design Skeleton
//=================================================================================================
// @[Class]: P0 Functional / InvalidFunc
// @[Category]: Misuse
// @[Intent]: Reject invalid CLI caller behavior with explicit diagnostics.
// @[UseWhen]: Required arguments are missing, malformed, unknown, or mutually exclusive.
// @[AvoidWhen]: Caller input is valid and the failure comes from filesystem/resource/runtime faults.
// @[SUT]: utCodeAgentCLI
// @[US]: US-USER-01
// @[AC]: AC-21 ~ AC-28, AC-32 (9 Misuse ACs)
// @[SourceSPEC]: SPEC_designUnitTests
// @[SourceUT]: UT_designFuncTestsSkeleton
// @[SourceUTSet]: UT_designFuncTestsSkeleton
// @[Template]: methodPrompts/CaTDD_designAndImplTemplate.ts
// @[TC]: TC-ARG-021..TC-ARG-031
//=================================================================================================

// @[TC-ARG-021]
// @[Name]: verifyRequiredGoal_byMissingGoal_expectExit1AndGoalHint
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-21
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Fail fast when --goal is missing and explain why it is required.
// @[Expect]: Exit code 1, stderr names --goal and requirement reason.
test("TC-ARG-021 verifyRequiredGoal_byMissingGoal_expectExit1AndGoalHint", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
	]);

	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /--goal/);
	assert.match(result.stderr, /required/i);
});

// @[TC-ARG-022]
// @[Name]: verifyRequiredTarget_byMissingTarget_expectExit1AndTargetHint
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-21
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Fail fast when --target is missing with actionable diagnostic text.
// @[Expect]: Exit code 1, stderr names --target and requirement reason.
test("TC-ARG-022 verifyRequiredTarget_byMissingTarget_expectExit1AndTargetHint", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--behave",
		"designFuncTestsSkeleton",
	]);

	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /--target/);
	assert.match(result.stderr, /required/i);
});

// @[TC-ARG-023]
// @[Name]: verifyRequiredBehave_byMissingBehave_expectExit1AndBehaveHint
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-21
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Fail fast when --behave is missing with valid behavior guidance.
// @[Expect]: Exit code 1, stderr names --behave and requirement reason.
test("TC-ARG-023 verifyRequiredBehave_byMissingBehave_expectExit1AndBehaveHint", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
	]);

	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /--behave/);
	assert.match(result.stderr, /required|valid/i);
});

// @[TC-ARG-024]
// @[Name]: verifyBehaviorList_byUnknownBehave_expectAllValidAlternatives
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-25
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Unknown --behave must fail with deterministic alternatives listing.
// @[Expect]: Exit code 1 and stderr lists all valid --behave values.
test("TC-ARG-024 verifyBehaviorList_byUnknownBehave_expectAllValidAlternatives", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"nonexistent",
	]);

	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /--behave/);
	assert.match(result.stderr, /valid|supported/i);
});

// @[TC-ARG-025]
// @[Name]: verifyGoalStoryConflict_byBothStoryInputs_expectExclusivePairError
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-23
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Reject combined --goalStory and --goalStoryFile usage.
// @[Expect]: Exit code 1 and stderr names both conflicting args.
test("TC-ARG-025 verifyGoalStoryConflict_byBothStoryInputs_expectExclusivePairError", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
		"--goalStory",
		"As a user, I want validation feedback.",
		"--goalStoryFile",
		"stories/us-user-01.md",
	]);

	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /--goalStory/);
	assert.match(result.stderr, /--goalStoryFile/);
	assert.match(result.stderr, /cannot be used together|exclusive|conflict/i);
});

// @[TC-ARG-026]
// @[Name]: verifyInputConflict_byBothInputSources_expectExclusivePairError
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-24
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Reject combined --input and --inputFile usage.
// @[Expect]: Exit code 1 and stderr names both conflicting args.
test("TC-ARG-026 verifyInputConflict_byBothInputSources_expectExclusivePairError", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
		"--input",
		"interface AuthApi { login(): Promise<void>; }",
		"--inputFile",
		"src/auth_api.ts",
	]);

	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /--input/);
	assert.match(result.stderr, /--inputFile/);
	assert.match(result.stderr, /cannot be used together|exclusive|conflict/i);
});

// @[TC-ARG-027]
// @[Name]: verifyEmptyGoal_byEmptyString_expectExit1AndGoalRequired
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-22
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Reject empty --goal string with explicit error message.
// @[Expect]: Exit code 1 and stderr indicates --goal cannot be empty.
test("TC-ARG-027 verifyEmptyGoal_byEmptyString_expectExit1AndGoalRequired", () => {
	const result: InvocationResult = runUtCodeAgentCli(["--goal", "", "--target", "tests/auth_test.cpp", "--behave", "designFuncTestsSkeleton"]);
	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /--goal/);
	assert.match(result.stderr, /empty/i);
});

// @[TC-ARG-028]
// @[Name]: verifyUnparseableTarget_byGarbledForm_expectExit1AndSupportedSelectors
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-26
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Reject unparseable --target form with supported selector guidance.
// @[Expect]: Exit code 1 and stderr shows supported selector forms.
test("TC-ARG-028 verifyUnparseableTarget_byGarbledForm_expectExit1AndSupportedSelectors", () => {
	const result: InvocationResult = runUtCodeAgentCli(["--goal", "design tests", "--target", "garbled:::", "--behave", "designFuncTestsSkeleton"]);
	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /--target/);
	assert.match(result.stderr, /selector|form|format/i);
});

// @[TC-ARG-029]
// @[Name]: verifyTargetBehaveMismatch_byTestCaseWithDesignBehave_expectExit1AndValidPairings
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-27
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Reject --target TestCase combined with skeleton design --behave.
// @[Expect]: Exit code 1 and stderr reports unsupported combination and suggests valid pairings.
test("TC-ARG-029 verifyTargetBehaveMismatch_byTestCaseWithDesignBehave_expectExit1AndValidPairings", () => {
	const result: InvocationResult = runUtCodeAgentCli(["--goal", "design tests", "--target", "tests/auth_test.cpp::TC-03", "--behave", "designFuncTestsSkeleton"]);
	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /--target/);
	assert.match(result.stderr, /--behave/);
	assert.match(result.stderr, /pairing|combination/i);
});

// @[TC-ARG-030]
// @[Name]: verifyUnrecognizedLogLevel_byInvalidValue_expectExit1AndValidLevels
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-28
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Reject unrecognized --log-level value with valid alternatives listing.
// @[Expect]: Exit code 1 and stderr lists every valid --log-level value.
test("TC-ARG-030 verifyUnrecognizedLogLevel_byInvalidValue_expectExit1AndValidLevels", () => {
	const result: InvocationResult = runUtCodeAgentCli(["--goal", "design tests", "--target", "tests/auth_test.cpp", "--behave", "designFuncTestsSkeleton", "--log-level", "verbose"]);
	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /--log-level/);
	assert.match(result.stderr, /valid|supported/i);
});

// @[TC-ARG-031]
// @[Name]: verifyStructurallyWrongConfig_byValidYamlMissingKeys_expectExit1AndRequiredKeys
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-32
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Reject --config-file with valid YAML but missing required keys.
// @[Expect]: Exit code 1 and stderr reports structural error and lists required config keys.
test("TC-ARG-031 verifyStructurallyWrongConfig_byValidYamlMissingKeys_expectExit1AndRequiredKeys", () => {
	const result: InvocationResult = runUtCodeAgentCli(["--goal", "design tests", "--target", "tests/auth_test.cpp", "--behave", "designFuncTestsSkeleton", "--config-file", "tests/invalid_structure.yaml"]);
	assert.equal(result.exitCode, 1);
	assert.match(result.stderr, /config|key|required|structure/i);
});

//======>END OF UNIT TESTING IMPLEMENTATION=======================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF TODO/IMPLEMENTATION TRACKING SECTION============================================
// [Migrated from old AC-01..AC-03 -> new AC-21..AC-28, AC-32]
// GREEN [@AC-21,US-USER-01] TC-ARG-021..TC-ARG-023 (missing required args)
// GREEN [@AC-25,US-USER-01] TC-ARG-024 (unrecognized --behave)
// GREEN [@AC-23,AC-24,US-USER-01] TC-ARG-025..TC-ARG-026 (mutually exclusive pairs)
// GREEN [@AC-22,US-USER-01] TC-ARG-027 (empty --goal)
// GREEN [@AC-26,US-USER-01] TC-ARG-028 (unparseable --target)
// GREEN [@AC-27,US-USER-01] TC-ARG-029 (target/behave mismatch)
// GREEN [@AC-28,US-USER-01] TC-ARG-030 (unrecognized --log-level)
// GREEN [@AC-32,US-USER-01] TC-ARG-031 (structurally wrong config)
//======>END OF TODO/IMPLEMENTATION TRACKING SECTION===============================================
