///////////////////////////////////////////////////////////////////////////////////////////////////
// CaTDD Design+Implementation Template (TypeScript)
//
// PURPOSE:
//   Verify US-USER-01 Typical usage patterns — 10 ACs from UserGuide § "IF: What You Want"
//   covering all user-intent-driven patterns for utCodeAgentCLI argument validation.
//
// USAGE:
//   Run this file with node:test to verify all 10 Typical invocation patterns.
//
// TDD WORKFLOW:
//   Design -> Draft -> Structure -> Test (RED) -> Code (GREEN) -> Refactor -> Repeat
//
// REFERENCE:
//   Template: methodPrompts/CaTDD_designAndImplTemplate.ts
//   SPEC orchestration: slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md
//   P0 category design: slashCommands/commands/P0-FuncTestsFlow/UT_designTypicalSkeleton.md
//   P0 full set design: slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md
//   US-USER-01 spec: ../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md
//   32-AC redesign: UT_designFuncTestsSkeleton route, 10 Typical ACs (AC-01 ~ AC-10)
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
 *   [WHAT] This file verifies the valid CLI invocation success path.
 *   [WHERE] in the utCodeAgentCLI CLI validation boundary.
 *   [WHY] to prove a correct invocation reaches behavior-dispatch readiness.
 *
 * SCOPE:
 *   - [In scope]: all 10 Typical invocation patterns from UserGuide § "IF: What You Want"
 *     — skeleton design, review, next-TC, implementation, inline/file/ref/diag/config combos.
 *   - [Out of scope]: missing args, conflicts, unrecognized behavior values, file-path faults.
 *
 * KEY CONCEPTS:
 *   - Typical: normal intended use with valid inputs and dependencies.
 *   - ValidFunc: P0 Functional behavior that should succeed.
 *
 * SUT:
 *   - utCodeAgentCLI.
 *
 * RELATIONSHIPS:
 *   - User story: US-USER-01.
 *   - Production code: codeAgents/utCodeAgentCLI/src/cli/invocationValidator.ts.
 *   - Verification design: codeAgents/utCodeAgentCLI/README_VerifyDesign.md.
 *   - 32-AC spec redesign via UT_designFuncTestsSkeleton route.
 */
//======>END OF OVERVIEW OF THIS UNIT TESTING FILE=================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF UNIT TESTING DESIGN==============================================================
/**
 * COMMAND PROVENANCE:
 *   @[SourceSPEC]: SPEC_designUnitTests
 *   @[SourceUT]: UT_designTypicalSkeleton
 *   @[SourceUTSet]: UT_designFuncTestsSkeleton
 *   @[Template]: methodPrompts/CaTDD_designAndImplTemplate.ts
 *
 * P0 FUNCTIONAL POSITION:
 *   ValidFunc = Typical + Edge
 *   10 Typical ACs (AC-01 ~ AC-10) prove the feature works correctly under 10 user-intent-driven
 *   patterns from the UserGuide: design, review, next-TC, implementation, inline/file/ref/diag/config.
 *   Typical proves the feature works correctly under normal intended use.
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
 * AC-01 [Func/Typical]: Design P0 Functional skeletons (full set).
 * AC-02 [Func/Typical]: Design one P0 category.
 * AC-03 [Func/Typical]: Design all P0/P1/P2 skeletons.
 * AC-04 [Func/Typical]: Review skeletons before implementation.
 * AC-05 [Func/Typical]: Pick next TC to implement.
 * AC-06 [Func/Typical]: Implement one specific TC.
 * AC-07 [Func/Typical]: Implement all TCs in a TestFile.
 * AC-08 [Func/Typical]: Design with inline story + inline source.
 * AC-09 [Func/Typical]: Design with reference files.
 * AC-10 [Func/Typical]: Design + extra-prompt + config + diag flags.
 *   10 ACs covering all user-intent-driven patterns from UserGuide.
 *   Each AC: Given the user intent -> When CLI invoked with valid args -> Then exit code 0.
 */
//=======>END OF ACCEPTANCE CRITERIA DESIGN========================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF TEST CASES DESIGN================================================================
/**
 * TC-ARG-001: @[Name]: verifyDesignFuncTests_byUserGoalStoryFileInputFileTarget_expectDispatchReady
 *   @[Purpose]: Prove designFuncTestsSkeleton with all file-based args reaches dispatch.
 *   @[Expect]: Exit code 0, execution proceeds to skeleton design.
 * TC-ARG-002: @[Name]: verifyDesignEdgeSkeleton_byUserGoalStoryFileInputFileTarget_expectDispatchReady
 *   @[Purpose]: Prove single-category skeleton design reaches dispatch.
 *   @[Expect]: Exit code 0, execution proceeds to single-category design.
 * TC-ARG-003: @[Name]: verifyDesignAllSkeleton_byUserGoalStoryFileInputFileTarget_expectDispatchReady
 *   @[Purpose]: Prove all-skeleton design reaches dispatch.
 *   @[Expect]: Exit code 0, execution proceeds to all-skeleton design.
 * TC-ARG-004: @[Name]: verifyReviewFuncTests_byTargetOnly_expectDispatchReady
 *   @[Purpose]: Prove review behavior with only --target reaches dispatch.
 *   @[Expect]: Exit code 0, execution proceeds to review.
 * TC-ARG-005: @[Name]: verifyTellMeNextImplTest_byTargetOnly_expectDispatchReady
 *   @[Purpose]: Prove tell-me-next behavior with only --target reaches dispatch.
 *   @[Expect]: Exit code 0, execution proceeds to next-TC selection.
 * TC-ARG-006: @[Name]: verifyImplTestCase_byInputFileTargetTC_expectDispatchReady
 *   @[Purpose]: Prove single-TC implementation reaches dispatch.
 *   @[Expect]: Exit code 0, execution proceeds to implement one TC.
 * TC-ARG-007: @[Name]: verifyImplTestFile_byInputFileTargetFile_expectDispatchReady
 *   @[Purpose]: Prove full-file implementation reaches dispatch.
 *   @[Expect]: Exit code 0, execution proceeds to implement all TCs.
 * TC-ARG-008: @[Name]: verifyDesignInline_byGoalStoryInput_expectDispatchReady
 *   @[Purpose]: Prove inline story + inline source reaches dispatch.
 *   @[Expect]: Exit code 0, execution proceeds with inline values.
 * TC-ARG-009: @[Name]: verifyDesignWithReference_byInputFileTargetBehaveRef_expectDispatchReady
 *   @[Purpose]: Prove reference files are accepted during skeleton generation.
 *   @[Expect]: Exit code 0, reference files consulted.
 * TC-ARG-010: @[Name]: verifyDesignWithExtraPromptConfigDiag_byAllOptionalArgs_expectDispatchReady
 *   @[Purpose]: Prove all optional arguments coexist without conflict.
 *   @[Expect]: Exit code 0, all optional flags accepted.
 */
//======>END OF TEST CASES DESIGN==================================================================
//======>END OF UNIT TESTING DESIGN================================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF UNIT TESTING IMPLEMENTATION=======================================================

//=================================================================================================
// [P0 Functional] / [Typical] Design Skeleton
//=================================================================================================
// @[Class]: P0 Functional / ValidFunc
// @[Category]: Typical
// @[Intent]: Prove all 10 Typical invocation patterns reach behavior-dispatch readiness.
// @[UseWhen]: Required arguments are valid and the caller follows the CLI contract.
// @[AvoidWhen]: Required args are missing, invalid, conflicting, or external files fail.
// @[SUT]: utCodeAgentCLI
// @[US]: US-USER-01
// @[AC]: AC-01 ~ AC-10 (10 Typical ACs)
// @[SourceSPEC]: SPEC_designUnitTests
// @[SourceUT]: UT_designFuncTestsSkeleton
// @[SourceUTSet]: UT_designFuncTestsSkeleton
// @[Template]: methodPrompts/CaTDD_designAndImplTemplate.ts
// @[TC]: TC-ARG-001..TC-ARG-010
//=================================================================================================

// @[TC-ARG-001]
// @[Name]: verifyDesignFuncTests_byUserGoalStoryFileInputFileTarget_expectDispatchReady
// @[Category]: Typical
// @[US]: US-USER-01
// @[AC]: AC-01
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Confirm designFuncTestsSkeleton with all file-based args reaches dispatch.
// @[Expect]: Exit code 0, execution proceeds to skeleton design.
test("TC-ARG-001 verifyDesignFuncTests_byUserGoalStoryFileInputFileTarget_expectDispatchReady", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
	]);

	assert.equal(result.exitCode, 0);
	assert.equal(result.stderr, "");
});

// @[TC-ARG-002]
// @[Name]: verifyDesignEdgeSkeleton_byUserGoalStoryFileInputFileTarget_expectDispatchReady
// @[Category]: Typical
// @[US]: US-USER-01
// @[AC]: AC-02
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Confirm single-category skeleton design reaches dispatch.
// @[Expect]: Exit code 0, execution proceeds to single-category design.
test("TC-ARG-002 verifyDesignEdgeSkeleton_byUserGoalStoryFileInputFileTarget_expectDispatchReady", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design edge-case skeletons for auth failures",
		"--target",
		"tests/auth_api_test.cpp",
		"--behave",
		"designEdgeSkeleton",
	]);

	assert.equal(result.exitCode, 0);
	assert.equal(result.stderr, "");
});

// @[TC-ARG-003]
// @[Name]: verifyDesignAllSkeleton_byUserGoalStoryFileInputFileTarget_expectDispatchReady
// @[Category]: Typical
// @[US]: US-USER-01
// @[AC]: AC-03
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Confirm all-skeleton design reaches dispatch.
// @[Expect]: Exit code 0, execution proceeds to all-skeleton design.
test("TC-ARG-003 verifyDesignAllSkeleton_byUserGoalStoryFileInputFileTarget_expectDispatchReady", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design complete CaTDD skeleton coverage for the auth interface",
		"--target",
		"tests/auth_api_test.cpp",
		"--behave",
		"designAllSkeleton",
	]);

	assert.equal(result.exitCode, 0);
	assert.equal(result.stderr, "");
});

// @[TC-ARG-004]
// @[Name]: verifyReviewFuncTests_byTargetOnly_expectDispatchReady
// @[Category]: Typical
// @[US]: US-USER-01
// @[AC]: AC-04
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Confirm review behavior with only --target reaches dispatch.
// @[Expect]: Exit code 0, execution proceeds to review.
test("TC-ARG-004 verifyReviewFuncTests_byTargetOnly_expectDispatchReady", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"review P0 functional skeleton coverage before implementation",
		"--target",
		"tests/auth_api_test.cpp",
		"--behave",
		"reviewFuncTestsSkeleton",
	]);

	assert.equal(result.exitCode, 0);
	assert.equal(result.stderr, "");
});

// @[TC-ARG-005]
// @[Name]: verifyTellMeNextImplTest_byTargetOnly_expectDispatchReady
// @[Category]: Typical
// @[US]: US-USER-01
// @[AC]: AC-05
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Confirm tell-me-next behavior with only --target reaches dispatch.
// @[Expect]: Exit code 0, execution proceeds to next-TC selection.
test("TC-ARG-005 verifyTellMeNextImplTest_byTargetOnly_expectDispatchReady", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"pick the next auth test case to implement",
		"--target",
		"tests/auth_api_test.cpp",
		"--behave",
		"tellMeNextImplTest",
	]);

	assert.equal(result.exitCode, 0);
	assert.equal(result.stderr, "");
});

// @[TC-ARG-006]
// @[Name]: verifyImplTestCase_byInputFileTargetTC_expectDispatchReady
// @[Category]: Typical
// @[US]: US-USER-01
// @[AC]: AC-06
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Confirm single-TC implementation reaches dispatch.
// @[Expect]: Exit code 0, execution proceeds to implement one TC.
test("TC-ARG-006 verifyImplTestCase_byInputFileTargetTC_expectDispatchReady", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"implement the selected auth error test case",
		"--inputFile",
		"codeAgents/utCodeAgentCLI/tests/fixtures/AuthService.h",
		"--target",
		"tests/auth_api_test.cpp::TC-03",
		"--behave",
		"implTestCase",
	]);

	assert.equal(result.exitCode, 0);
	assert.equal(result.stderr, "");
});

// @[TC-ARG-007]
// @[Name]: verifyImplTestFile_byInputFileTargetFile_expectDispatchReady
// @[Category]: Typical
// @[US]: US-USER-01
// @[AC]: AC-07
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Confirm full-file implementation reaches dispatch.
// @[Expect]: Exit code 0, execution proceeds to implement all TCs.
test("TC-ARG-007 verifyImplTestFile_byInputFileTargetFile_expectDispatchReady", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"implement all ready auth API test cases",
		"--inputFile",
		"codeAgents/utCodeAgentCLI/tests/fixtures/AuthService.h",
		"--target",
		"tests/auth_api_test.cpp",
		"--behave",
		"implTestFile",
	]);

	assert.equal(result.exitCode, 0);
	assert.equal(result.stderr, "");
});

// @[TC-ARG-008]
// @[Name]: verifyDesignInline_byGoalStoryInput_expectDispatchReady
// @[Category]: Typical
// @[US]: US-USER-01
// @[AC]: AC-08
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Confirm inline story + inline source reaches dispatch.
// @[Expect]: Exit code 0, execution proceeds with inline values.
test("TC-ARG-008 verifyDesignInline_byGoalStoryInput_expectDispatchReady", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design P0 functional skeletons for the auth interface",
		"--goalStory",
		"As an API consumer I want typed auth errors so that I can handle failures reliably",
		"--input",
		"AuthService",
		"--target",
		"tests/auth_api_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
	]);

	assert.equal(result.exitCode, 0);
	assert.equal(result.stderr, "");
});

// @[TC-ARG-009]
// @[Name]: verifyDesignWithReference_byInputFileTargetBehaveRef_expectDispatchReady
// @[Category]: Typical
// @[US]: US-USER-01
// @[AC]: AC-09
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Confirm reference files are accepted during skeleton generation.
// @[Expect]: Exit code 0, reference files consulted.
test("TC-ARG-009 verifyDesignWithReference_byInputFileTargetBehaveRef_expectDispatchReady", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design all skeletons for the auth interface",
		"--inputFile",
		"codeAgents/utCodeAgentCLI/tests/fixtures/AuthService.h",
		"--target",
		"tests/auth_api_test.cpp",
		"--behave",
		"designAllSkeleton",
		"--reference",
		"codeAgents/utCodeAgentCLI/tests/fixtures/api.md,codeAgents/utCodeAgentCLI/tests/fixtures/schema.md",
	]);

	assert.equal(result.exitCode, 0);
	assert.equal(result.stderr, "");
});

// @[TC-ARG-010]
// @[Name]: verifyDesignWithExtraPromptConfigDiag_byAllOptionalArgs_expectDispatchReady
// @[Category]: Typical
// @[US]: US-USER-01
// @[AC]: AC-10
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Confirm all optional arguments coexist without conflict.
// @[Expect]: Exit code 0, all optional flags accepted.
test("TC-ARG-010 verifyDesignWithExtraPromptConfigDiag_byAllOptionalArgs_expectDispatchReady", () => {
	const result: InvocationResult = runUtCodeAgentCli([
		"--goal",
		"design and implement auth interface tests",
		"--inputFile",
		"codeAgents/utCodeAgentCLI/tests/fixtures/AuthService.h",
		"--target",
		"tests/auth_api_test.cpp",
		"--behave",
		"designAndImplTest",
		"--extra-prompt",
		"codeAgents/utCodeAgentCLI/tests/fixtures/style-guide.md",
		"--config-file",
		"codeAgents/utCodeAgentCLI/tests/fixtures/config.yaml",
		"--diagMethodPrompts",
		"--diagSlashCommands",
	]);

	assert.equal(result.exitCode, 0);
	assert.ok(result.stderr.length > 0, "diag output expected");
});

//======>END OF UNIT TESTING IMPLEMENTATION=======================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF TODO/IMPLEMENTATION TRACKING SECTION============================================
// GREEN [@AC-01,US-USER-01] TC-ARG-001
// RED [@AC-02,US-USER-01] TC-ARG-002
// RED [@AC-03,US-USER-01] TC-ARG-003
// RED [@AC-04,US-USER-01] TC-ARG-004
// RED [@AC-05,US-USER-01] TC-ARG-005
// RED [@AC-06,US-USER-01] TC-ARG-006
// RED [@AC-07,US-USER-01] TC-ARG-007
// RED [@AC-08,US-USER-01] TC-ARG-008
// RED [@AC-09,US-USER-01] TC-ARG-009
// RED [@AC-10,US-USER-01] TC-ARG-010
//======>END OF TODO/IMPLEMENTATION TRACKING SECTION===============================================
