declare function require(moduleName: string): any;

const test = require("node:test");
const assert = require("node:assert/strict");

type InvocationResult = {
	exitCode: number;
	stderr: string;
	dispatchedBehavior?: string;
};

const { validateInvocation } = require("../src/cli/invocationValidator.ts");

//=================================================================================================
// [P0 Functional] / [Typical] Design Skeleton
//=================================================================================================
// @[Class]: P0 Functional / ValidFunc
// @[Category]: Typical
// @[Intent]: Prove the normal CLI invocation reaches behavior-dispatch readiness.
// @[UseWhen]: Required arguments are valid and the caller follows the CLI contract.
// @[AvoidWhen]: Required args are missing, invalid, conflicting, or external files fail.
// @[US]: US-USER-01
// @[AC]: AC-05
// @[TC]: TC-ARG-005
//=================================================================================================

// @[TC-ARG-005]
// @[Name]: verifyInvocationSuccess_byValidArgs_expectDispatchReady
// @[Category]: Typical
// @[US]: US-USER-01
// @[AC]: AC-05
// @[Priority]: P0
// @[Status]: GREEN
// @[Purpose]: Confirm valid invocation reaches behavior-dispatch readiness.
// @[Expect]: Exit code 0 and execution proceeds toward resolved behavior.
test("TC-ARG-005 verifyInvocationSuccess_byValidArgs_expectDispatchReady", () => {
	const result: InvocationResult = validateInvocation([
		"--goal",
		"design unit test skeletons for auth login",
		"--target",
		"tests/auth_login_test.cpp",
		"--behave",
		"designFuncTestsSkeleton",
	]);

	assert.equal(result.exitCode, 0);
	assert.equal(result.dispatchedBehavior, "designFuncTestsSkeleton");
	assert.equal(result.stderr, "");
});

//=================================================================================================
// [P0 Functional] / [Misuse] Design Skeleton
//=================================================================================================
// @[Class]: P0 Functional / InvalidFunc
// @[Category]: Misuse
// @[Intent]: Reject invalid CLI caller behavior with explicit diagnostics.
// @[UseWhen]: Required arguments are missing, malformed, unknown, or mutually exclusive.
// @[AvoidWhen]: Caller input is valid and the failure comes from filesystem/resource/runtime faults.
// @[US]: US-USER-01
// @[AC]: AC-01, AC-02, AC-03
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
	const result: InvocationResult = validateInvocation([
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
	const result: InvocationResult = validateInvocation([
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
	const result: InvocationResult = validateInvocation([
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
	const result: InvocationResult = validateInvocation([
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
	const result: InvocationResult = validateInvocation([
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
	const result: InvocationResult = validateInvocation([
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

//=================================================================================================
// [P0 Functional] / [Fault] Design Skeleton
//=================================================================================================
// @[Class]: P0 Functional / InvalidFunc
// @[Category]: Fault
// @[Intent]: Validate missing filesystem dependencies are surfaced with path-level diagnostics.
// @[UseWhen]: Caller shape is valid but referenced file-path dependencies are missing.
// @[AvoidWhen]: Use Misuse for missing required args, unknown behavior names, or conflicting flags.
// @[US]: US-USER-01
// @[AC]: AC-04
// @[TC]: TC-ARG-008..TC-ARG-012
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
	const result: InvocationResult = validateInvocation([
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
	const result: InvocationResult = validateInvocation([
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
	const result: InvocationResult = validateInvocation([
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
	const result: InvocationResult = validateInvocation([
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
	const result: InvocationResult = validateInvocation([
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