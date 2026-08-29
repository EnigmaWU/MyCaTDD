export type FakeRuntimeAdapterTestModule = never;

type PreparedStep = {
	stepId: string;
	input: {
		id: string;
		context: Array<{
			name: string;
			path: string;
			content: string;
			role: "instruction" | "context";
		}>;
	};
};

class FakeRuntimeAdapter {
	private readonly preparedSteps: PreparedStep[] = [];

	async prepare(step: PreparedStep["input"], _context: unknown): Promise<PreparedStep> {
		const preparedStep = { stepId: step.id, input: step };
		this.preparedSteps.push(preparedStep);
		return preparedStep;
	}

	lastPreparedStep(): PreparedStep | undefined {
		return this.preparedSteps.at(-1);
	}

	reset(): void {
		this.preparedSteps.length = 0;
	}
}

module.exports = { FakeRuntimeAdapter };