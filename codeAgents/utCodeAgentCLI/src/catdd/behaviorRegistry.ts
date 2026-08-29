export type BehaviorRegistryModule = never;

declare const module: { exports: Record<string, unknown> };

type TargetSelector = {
	kind: "test-case" | "test-file" | "test-files";
};

type CatddInvocation = {
	behaviorName: string;
	target: TargetSelector;
};

type ResolvedBehavior = {
	requested: string;
	canonicalName: string;
	mode: "design";
	commandNames: string[];
	requiredTargetKinds: TargetSelector["kind"][];
	writesFiles: boolean;
};

const BEHAVIORS: Record<string, Omit<ResolvedBehavior, "requested">> = {
	designEdgeSkeleton: {
		canonicalName: "designEdgeSkeleton",
		mode: "design",
		commandNames: ["UT_designEdgeSkeleton.md"],
		requiredTargetKinds: ["test-file"],
		writesFiles: true,
	},
};

function resolveBehavior(invocation: CatddInvocation): ResolvedBehavior {
	const behavior = BEHAVIORS[invocation.behaviorName];
	if (behavior === undefined) {
		throw new Error(`Unsupported behavior: ${invocation.behaviorName}`);
	}
	if (!behavior.requiredTargetKinds.includes(invocation.target.kind)) {
		throw new Error(`Behavior ${invocation.behaviorName} does not support target ${invocation.target.kind}`);
	}

	return { requested: invocation.behaviorName, ...behavior };
}

module.exports = { resolveBehavior };