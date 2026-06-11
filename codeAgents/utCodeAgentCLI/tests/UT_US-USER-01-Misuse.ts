///////////////////////////////////////////////////////////////////////////////////////////////////
// CaTDD Design+Implementation Template (TypeScript)
//
// PURPOSE:
//   Verify US-USER-01 Misuse / InvalidFunc behavior for utCodeAgentCLI argument validation.
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
 *   [WHAT] This file verifies invalid caller argument usage.
 *   [WHERE] in the utCodeAgentCLI CLI validation boundary.
 *   [WHY] to ensure misuse fails fast with actionable diagnostics.
 *
 * SCOPE:
 *   - [In scope]: missing required args, unknown --behave, and mutually exclusive pairs.
 *   - [Out of scope]: valid invocation success and external missing file dependencies.
 *
 * KEY CONCEPTS:
 *   - Misuse: caller violates named CLI preconditions.
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
 *   @[SourceUT]: UT_designMisuseSkeleton
 *   @[SourceUTSet]: UT_designFuncTestsSkeleton
 *   @[Template]: methodPrompts/CaTDD_designAndImplTemplate.ts
 *
 * P0 FUNCTIONAL POSITION:
 *   InvalidFunc = Misuse + Fault
 *   Misuse proves invalid caller behavior is rejected safely and clearly.
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
 * AC-01: Missing required argument exits with error.
 * AC-02: Mutually exclusive arguments are rejected.
 * AC-03: Unrecognized --behave value lists valid alternatives.
 */
//=======>END OF ACCEPTANCE CRITERIA DESIGN========================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF TEST CASES DESIGN================================================================
/**
 * AC-01 -> TC-ARG-001..TC-ARG-003
 * AC-03 -> TC-ARG-004
 * AC-02 -> TC-ARG-006..TC-ARG-007
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
// @[AC]: AC-01, AC-02, AC-03
// @[SourceSPEC]: SPEC_designUnitTests
// @[SourceUT]: UT_designMisuseSkeleton
// @[Template]: methodPrompts/CaTDD_designAndImplTemplate.ts
// @[TC]: TC-ARG-001..TC-ARG-004, TC-ARG-006..TC-ARG-007
//=================================================================================================

// @[TC-ARG-001]
// @[Name]: verifyRequiredGoal_byMissingGoal_expectExit1AndGoalHint
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-01
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Fail fast when --goal is missing and explain why it is required.
// @[Expect]: Exit code 1, stderr names --goal and requirement reason.
test("TC-ARG-001 verifyRequiredGoal_byMissingGoal_expectExit1AndGoalHint", () => {
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

// @[TC-ARG-002]
// @[Name]: verifyRequiredTarget_byMissingTarget_expectExit1AndTargetHint
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-01
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Fail fast when --target is missing with actionable diagnostic text.
// @[Expect]: Exit code 1, stderr names --target and requirement reason.
test("TC-ARG-002 verifyRequiredTarget_byMissingTarget_expectExit1AndTargetHint", () => {
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

// @[TC-ARG-003]
// @[Name]: verifyRequiredBehave_byMissingBehave_expectExit1AndBehaveHint
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-01
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Fail fast when --behave is missing with valid behavior guidance.
// @[Expect]: Exit code 1, stderr names --behave and requirement reason.
test("TC-ARG-003 verifyRequiredBehave_byMissingBehave_expectExit1AndBehaveHint", () => {
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

// @[TC-ARG-004]
// @[Name]: verifyBehaviorList_byUnknownBehave_expectAllValidAlternatives
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-03
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Unknown --behave must fail with deterministic alternatives listing.
// @[Expect]: Exit code 1 and stderr lists all valid --behave values.
test("TC-ARG-004 verifyBehaviorList_byUnknownBehave_expectAllValidAlternatives", () => {
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

// @[TC-ARG-006]
// @[Name]: verifyGoalStoryConflict_byBothStoryInputs_expectExclusivePairError
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-02
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Reject combined --goalStory and --goalStoryFile usage.
// @[Expect]: Exit code 1 and stderr names both conflicting args.
test("TC-ARG-006 verifyGoalStoryConflict_byBothStoryInputs_expectExclusivePairError", () => {
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

// @[TC-ARG-007]
// @[Name]: verifyInputConflict_byBothInputSources_expectExclusivePairError
// @[Category]: Misuse
// @[US]: US-USER-01
// @[AC]: AC-02
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Reject combined --input and --inputFile usage.
// @[Expect]: Exit code 1 and stderr names both conflicting args.
test("TC-ARG-007 verifyInputConflict_byBothInputSources_expectExclusivePairError", () => {
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

//======>END OF UNIT TESTING IMPLEMENTATION=======================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF TODO/IMPLEMENTATION TRACKING SECTION============================================
// GREEN [@AC-01,US-USER-01] TC-ARG-001..TC-ARG-003
// GREEN [@AC-03,US-USER-01] TC-ARG-004
// GREEN [@AC-02,US-USER-01] TC-ARG-006..TC-ARG-007
//======>END OF TODO/IMPLEMENTATION TRACKING SECTION===============================================
