export type InvocationAssetSessionModule = never;

declare function require(moduleName: string): any;
declare const module: { exports: Record<string, unknown> };

const path = require("node:path");
const { TextDecoder } = require("node:util");

type AssetKind = "method-prompt" | "slash-command";

type AssetReadRequest = {
	kind: AssetKind;
	name: string;
	relativePath: string;
};

type ResolvedAssetContent = {
	path: string;
	canonicalPath: string;
	content: string;
};

type AssetFileSystem = {
	realpath(assetPath: string): Promise<string>;
	stat(assetPath: string): Promise<{ isFile: boolean; isDirectory: boolean }>;
	readFile(assetPath: string): Promise<Uint8Array>;
};

type CliExecutionContext = {
	workspaceRoot: string;
	methodPromptsRoot: string;
	slashCommandsRoot: string;
	assetFileSystem: AssetFileSystem;
};

function isContained(rootPath: string, candidatePath: string): boolean {
	const relativePath = path.relative(rootPath, candidatePath);
	return relativePath === "" || (
		relativePath !== ".."
		&& !relativePath.startsWith(`..${path.sep}`)
		&& !path.isAbsolute(relativePath)
	);
}

function normalizePublicPath(assetPath: string): string {
	return assetPath.split(path.sep).join("/");
}

function toPublicPath(
	canonicalPath: string,
	workspaceCanonicalPath: string,
	rootCanonicalPath: string,
	kind: AssetKind,
): string {
	if (isContained(workspaceCanonicalPath, canonicalPath)) {
		return normalizePublicPath(path.relative(workspaceCanonicalPath, canonicalPath));
	}

	const rootLabel = kind === "method-prompt" ? "<methodPromptsRoot>" : "<slashCommandsRoot>";
	return `${rootLabel}/${normalizePublicPath(path.relative(rootCanonicalPath, canonicalPath))}`;
}

function openAssetSession(context: CliExecutionContext) {
	const cache = new Map<string, ResolvedAssetContent>();
	let disposed = false;

	return {
		async read(request: AssetReadRequest): Promise<ResolvedAssetContent> {
			if (disposed) {
				throw new Error("Invocation asset session is disposed");
			}

			const workspaceCanonicalPath = await context.assetFileSystem.realpath(context.workspaceRoot)
				.catch(() => path.resolve(context.workspaceRoot));
			const configuredRoot = request.kind === "method-prompt"
				? context.methodPromptsRoot
				: context.slashCommandsRoot;
			const rootCanonicalPath = await context.assetFileSystem.realpath(configuredRoot);
			const rootStats = await context.assetFileSystem.stat(rootCanonicalPath);
			if (!rootStats.isDirectory) {
				throw new Error(`Asset root is not a directory: ${configuredRoot}`);
			}

			const candidatePath = path.resolve(configuredRoot, request.relativePath);
			const canonicalPath = await context.assetFileSystem.realpath(candidatePath);
			if (!isContained(rootCanonicalPath, canonicalPath)) {
				throw new Error(`Asset resolves outside configured root: ${request.name}`);
			}

			const cached = cache.get(canonicalPath);
			if (cached !== undefined) {
				return cached;
			}

			const assetStats = await context.assetFileSystem.stat(canonicalPath);
			if (!assetStats.isFile) {
				throw new Error(`Asset is not a file: ${request.name}`);
			}

			const bytes = await context.assetFileSystem.readFile(canonicalPath);
			if (bytes.byteLength === 0) {
				throw new Error(`Asset is empty: ${request.name}`);
			}

			const resolved = {
				path: toPublicPath(canonicalPath, workspaceCanonicalPath, rootCanonicalPath, request.kind),
				canonicalPath,
				content: new TextDecoder().decode(bytes),
			};
			cache.set(canonicalPath, resolved);
			return resolved;
		},
		dispose(): void {
			cache.clear();
			disposed = true;
		},
	};
}

module.exports = { openAssetSession };