///////////////////////////////////////////////////////////////////////////////////////////////////
// CaTDD P0 Functional / ValidFunc / Typical Design Skeleton
//
// PURPOSE:
//   Design the normal successful delegation tests for US-INVENTOR-01 AC-01 through AC-04.
//
// PROVENANCE:
//   @[SourceSPEC]: slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md
//   @[SourceUT]: slashCommands/commands/P0-FuncTestsFlow/UT_designTypicalSkeleton.md
//   @[SourceUTSet]: slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md
//   @[Template]: methodPrompts/CaTDD_designAndImplTemplate.ts
///////////////////////////////////////////////////////////////////////////////////////////////////

export type AssetDelegationTypicalTestModule = never;

declare function require(moduleName: string): any;

const test = require("node:test");
const assert = require("node:assert/strict");
const path = require("node:path");
const { FakeAssetFileSystem } = require("./support/fakeAssetFileSystem.ts");
const { FakeRuntimeAdapter } = require("./support/fakeRuntimeAdapter.ts");

function VERIFY_KEYPOINT_noImplementationError(error: unknown): void {
	assert.equal(
		error,
		undefined,
		`Expected the designed asset-delegation modules to load and prepare a run: ${String(error)}`,
	);
}

function VERIFY_KEYPOINT_edgePromptCapture(actual: unknown, expected: unknown): void {
	assert.deepEqual(actual, expected);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF OVERVIEW OF THIS UNIT TESTING FILE===============================================
/**
 * @brief
 *   [WHAT] Verify successful runtime delegation from CaTDD source assets into generic run inputs.
 *   [WHERE] In the utCodeAgentCLI asset-resolution, run-plan, executor, and fake-runtime boundary.
 *   [WHY] Ensure the CLI consumes current method/command content without embedding CaTDD semantics.
 *
 * SUT:
 *   - utCodeAgentCLI CaTDD asset-delegation module interface.
 *
 * SCOPE:
 *   - In scope: Edge prompt capture, aggregate command delegation, source provenance, event order.
 *   - Out of scope: generated test artifacts (US-USER-02) and CLI diagnostics (US-INVENTOR-03).
 *
 * DEPENDENCIES:
 *   - InvocationAssetSession, AgentRunPlanBuilder, DelegationEvidenceCollector.
 *   - FakeAssetFileSystem and FakeRuntimeAdapter.
 */
//======>END OF OVERVIEW OF THIS UNIT TESTING FILE=================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF UNIT TESTING DESIGN==============================================================
// @[Class]: P0 Functional / ValidFunc
// @[Category]: Typical
// @[Intent]: Prove the ordinary successful asset-delegation workflow.
// @[UseWhen]: Configured roots and required assets are valid, readable, and non-empty.
// @[AvoidWhen]: Use Edge for valid mode boundaries, Misuse for rejected asset topology, or Fault
//               for missing/unreadable dependencies.
// @[SUT]: utCodeAgentCLI
// @[US]: US-INVENTOR-01
// @[AC]: AC-01, AC-02, AC-03, AC-04
// @[TC]: TC-DELEGATE-001..TC-DELEGATE-004

/**
 * @[TC]: TC-DELEGATE-001
 * @[Name]: verifyEdgePromptResolution_byValidInvocation_expectCurrentContentCapture
 * @[US]: US-INVENTOR-01
 * @[AC]: AC-01
 * @[Category:Typical]
 * @[Priority]: P0
 * @[Status:GREEN]
 * @[Purpose]: Prove Edge meaning is read from its canonical prompt instead of CLI-owned text.
 * @[Brief]: SETUP a valid prompt root and sentinel content; BEHAVIOR prepare designEdgeSkeleton;
 *           VERIFY the fake runtime input; CLEANUP reset the fake capture.
 * @[Expect]: Capture names CaTDD_methodPrompt4Cat-Edge.md and contains its current sentinel.
 */

/**
 * @[TC]: TC-DELEGATE-002
 * @[Name]: verifyFuncCommandDelegation_byPreparedStep_expectInvocationEvidence
 * @[US]: US-INVENTOR-01
 * @[AC]: AC-02
 * @[Category:Typical]
 * @[Priority]: P0
 * @[Status:PLANNED]
 * @[Purpose]: Prove designFuncTestsSkeleton executes through its portable command asset.
 * @[Brief]: SETUP valid command content; BEHAVIOR prepare and execute one fake-runtime step;
 *           VERIFY instruction path and event; CLEANUP reset evidence.
 * @[Expect]: Instruction names UT_designFuncTestsSkeleton.md and records command-invocation.
 */

/**
 * @[TC]: TC-DELEGATE-003
 * @[Name]: verifyRunInputProvenance_byResolvedAssets_expectNoInlineFallback
 * @[US]: US-INVENTOR-01
 * @[AC]: AC-03
 * @[Category:Typical]
 * @[Priority]: P0
 * @[Status:PLANNED]
 * @[Purpose]: Prove generic runtime content comes only from resolved fixture assets.
 * @[Brief]: SETUP unique prompt and command sentinels; BEHAVIOR build the generic run plan;
 *           VERIFY captured instruction/context; CLEANUP dispose the asset session.
 * @[Expect]: Captured content equals fixture content and no CLI fallback semantic text appears.
 */

/**
 * @[TC]: TC-DELEGATE-004
 * @[Name]: verifyDelegationOrder_byPromptReadsBeforeCommand_expectMonotonicEvidence
 * @[US]: US-INVENTOR-01
 * @[AC]: AC-04
 * @[Category:Typical]
 * @[Priority]: P0
 * @[Status:PLANNED]
 * @[Purpose]: Prove all required prompt reads precede the command invocation.
 * @[Brief]: SETUP a multi-prompt step; BEHAVIOR execute it through the fake runtime;
 *           VERIFY event sequence ordering; CLEANUP clear the evidence collector.
 * @[Expect]: Sequences increase monotonically and every prompt-read precedes command-invocation.
 */
//======>END OF UNIT TESTING DESIGN================================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF UNIT TESTING IMPLEMENTATION======================================================

test(
	"TC-DELEGATE-001 verifyEdgePromptResolution_byValidInvocation_expectCurrentContentCapture",
	async () => {
		//===>>> SETUP <<<===
		const workspaceRoot = "/workspace";
		const methodPromptsRoot = path.join(workspaceRoot, "methodPrompts");
		const slashCommandsRoot = path.join(workspaceRoot, "slashCommands");
		const edgePromptName = "CaTDD_methodPrompt4Cat-Edge.md";
		const edgePromptPath = path.join(methodPromptsRoot, edgePromptName);
		const edgePromptPublicPath = `methodPrompts/${edgePromptName}`;
		const edgePromptSentinel = "EDGE_PROMPT_CURRENT_CONTENT_SENTINEL";
		const slashCommandPath = path.join(
			slashCommandsRoot,
			"commands/P0-FuncTestsFlow/UT_designEdgeSkeleton.md",
		);
		const fakeAssetFileSystem = new FakeAssetFileSystem();
		const fakeRuntimeAdapter = new FakeRuntimeAdapter();
		const delegationEvents: unknown[] = [];
		const evidenceCollector = {
			record(kind: string, assetName: string, assetPath: string) {
				const event = {
					sequence: delegationEvents.length + 1,
					kind,
					assetName,
					path: assetPath,
				};
				delegationEvents.push(event);
				return event;
			},
			snapshot() {
				return { events: [...delegationEvents] };
			},
		};
		let assetSession: { dispose(): void } | undefined;
		let implementationError: unknown;
		let capturedEdgeContext: unknown;

		fakeAssetFileSystem.addDirectory(methodPromptsRoot);
		fakeAssetFileSystem.addDirectory(slashCommandsRoot);
		fakeAssetFileSystem.addDirectory(path.join(slashCommandsRoot, "commands"));
		fakeAssetFileSystem.addDirectory(path.join(slashCommandsRoot, "commands/P0-FuncTestsFlow"));
		fakeAssetFileSystem.addFile(edgePromptPath, edgePromptSentinel);
		fakeAssetFileSystem.addFile(
			path.join(methodPromptsRoot, "CaTDD_methodPrompt-testStructure.md"),
			"TEST_STRUCTURE_CURRENT_CONTENT_SENTINEL",
		);
		fakeAssetFileSystem.addFile(
			path.join(methodPromptsRoot, "CaTDD_methodPrompt-workflow.md"),
			"WORKFLOW_CURRENT_CONTENT_SENTINEL",
		);
		fakeAssetFileSystem.addFile(slashCommandPath, "# UT_designEdgeSkeleton current content");

		try {
			//===>>> BEHAVIOR <<<===
			try {
				const { resolveBehavior } = require("../src/catdd/behaviorRegistry.ts");
				const { openAssetSession } = require("../src/catdd/invocationAssetSession.ts");
				const { resolveMethodPrompts } = require("../src/catdd/methodPromptResolver.ts");
				const { planCatddRun } = require("../src/catdd/planner.ts");
				const { resolveSlashCommands } = require("../src/catdd/slashCommandResolver.ts");
				const { buildAgentRunPlan } = require("../src/catdd/agentRunPlanBuilder.ts");
				assetSession = await Promise.resolve(
					openAssetSession({
						workspaceRoot,
						workingDirectory: workspaceRoot,
						methodPromptsRoot,
						slashCommandsRoot,
						assetFileSystem: fakeAssetFileSystem,
					}),
				);
				const invocation = {
					goal: "Design the Edge category skeleton",
					behaviorName: "designEdgeSkeleton",
					references: [],
					extraPrompts: [],
					diagnostics: {
						diagMethodPrompts: false,
						diagSlashCommands: false,
					},
					target: { kind: "test-file", file: "tests/example.ts" },
				};
				const resolvedBehavior = await Promise.resolve(resolveBehavior(invocation));
				const plannedRun = await Promise.resolve(planCatddRun(invocation));
				const resolvedSlashCommands = await resolveSlashCommands(resolvedBehavior, assetSession);
				const resolvedMethodPrompts = await resolveMethodPrompts(
					plannedRun,
					assetSession,
					evidenceCollector,
				);
				const resolvedRun = {
					...plannedRun,
					steps: plannedRun.steps.map((step: unknown, index: number) => ({
						...(step as object),
						invocation,
						target: invocation.target,
						slashCommand: resolvedSlashCommands[index],
						methodPrompts: resolvedMethodPrompts,
					})),
				};
				const runPlan = buildAgentRunPlan(resolvedRun);

				await fakeRuntimeAdapter.prepare(runPlan.steps[0], { invocationId: "invocation-1" });
				const edgeContext = fakeRuntimeAdapter
					.lastPreparedStep()
					?.input.context.find((asset: { name: string }) => asset.name === edgePromptName);
				capturedEdgeContext = edgeContext === undefined
					? undefined
					: {
						name: edgeContext.name,
						path: edgeContext.path,
						content: edgeContext.content,
						role: edgeContext.role,
					};
			} catch (error) {
				implementationError = error;
			}

			//===>>> VERIFY <<<===
			VERIFY_KEYPOINT_noImplementationError(implementationError);
			VERIFY_KEYPOINT_edgePromptCapture(capturedEdgeContext, {
				name: edgePromptName,
				path: edgePromptPublicPath,
				content: edgePromptSentinel,
				role: "context",
			});
		} finally {
			//===>>> CLEANUP <<<===
			assetSession?.dispose();
			delegationEvents.length = 0;
			fakeRuntimeAdapter.reset();
			fakeAssetFileSystem.reset();
		}
	},
);

test(
	"TC-DELEGATE-001-SYMLINK verifyEdgePromptResolution_bySymlinkedWorkspace_expectWorkspaceRelativePath",
	async () => {
		const workspaceRoot = "/workspace-link";
		const realWorkspaceRoot = "/real/workspace";
		const methodPromptsRoot = path.join(realWorkspaceRoot, "methodPrompts");
		const slashCommandsRoot = path.join(realWorkspaceRoot, "slashCommands");
		const edgePromptName = "CaTDD_methodPrompt4Cat-Edge.md";
		const edgePromptPath = path.join(methodPromptsRoot, edgePromptName);
		const edgePromptSentinel = "EDGE_PROMPT_CURRENT_CONTENT_SENTINEL";
		const fakeAssetFileSystem = new FakeAssetFileSystem();
		const evidenceCollector = {
			record() {
				return { kind: "prompt-read", path: "ignored" };
			},
			snapshot() {
				return { events: [] };
			},
		};
		const openAssetSession = require("../src/catdd/invocationAssetSession.ts").openAssetSession;
		const { resolveMethodPrompts } = require("../src/catdd/methodPromptResolver.ts");
		const { planCatddRun } = require("../src/catdd/planner.ts");
		fakeAssetFileSystem.addSymlink(workspaceRoot, realWorkspaceRoot);
		fakeAssetFileSystem.addDirectory(realWorkspaceRoot);
		fakeAssetFileSystem.addDirectory(methodPromptsRoot);
		fakeAssetFileSystem.addDirectory(slashCommandsRoot);
		fakeAssetFileSystem.addFile(edgePromptPath, edgePromptSentinel);
		fakeAssetFileSystem.addFile(
			path.join(methodPromptsRoot, "CaTDD_methodPrompt-testStructure.md"),
			"TEST_STRUCTURE_CURRENT_CONTENT_SENTINEL",
		);
		fakeAssetFileSystem.addFile(
			path.join(methodPromptsRoot, "CaTDD_methodPrompt-workflow.md"),
			"WORKFLOW_CURRENT_CONTENT_SENTINEL",
		);

		const assetSession = await openAssetSession({
			workspaceRoot,
			methodPromptsRoot: path.join(workspaceRoot, "methodPrompts"),
			slashCommandsRoot: path.join(workspaceRoot, "slashCommands"),
			assetFileSystem: fakeAssetFileSystem,
		});

		const plan = planCatddRun({
			goal: "Design the Edge category skeleton",
			behaviorName: "designEdgeSkeleton",
			target: { kind: "test-file", file: "tests/example.ts" },
		});
		const prompts = await resolveMethodPrompts(plan, assetSession, evidenceCollector);
		const edgePrompt = prompts.find((prompt) => prompt.name === edgePromptName);

		assert.deepEqual(edgePrompt && edgePrompt.path, `methodPrompts/${edgePromptName}`);
		assetSession.dispose();
		fakeAssetFileSystem.reset();
	},
);
//======>END OF UNIT TESTING IMPLEMENTATION========================================================

///////////////////////////////////////////////////////////////////////////////////////////////////
//======>BEGIN OF TODO/IMPLEMENTATION TRACKING SECTION============================================
// GREEN [@AC-01,US-INVENTOR-01] TC-DELEGATE-001 - current Edge prompt captured
// TODO [@AC-02,US-INVENTOR-01] TC-DELEGATE-002 - PLANNED
// TODO [@AC-03,US-INVENTOR-01] TC-DELEGATE-003 - PLANNED
// TODO [@AC-04,US-INVENTOR-01] TC-DELEGATE-004 - PLANNED
//======>END OF TODO/IMPLEMENTATION TRACKING SECTION===============================================
