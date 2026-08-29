export type FakeAssetFileSystemTestModule = never;

declare function require(moduleName: string): any;

const path = require("node:path");
const { TextEncoder } = require("node:util");

type FakeAssetEntry =
	| { kind: "directory" }
	| { kind: "file"; content: Uint8Array };

class FakeAssetFileSystem {
	private readonly entries = new Map<string, FakeAssetEntry>();
	private readonly symlinks = new Map<string, string>();

	addDirectory(assetPath: string): void {
		this.entries.set(path.resolve(assetPath), { kind: "directory" });
	}

	addFile(assetPath: string, content: string): void {
		this.entries.set(path.resolve(assetPath), {
			kind: "file",
			content: new TextEncoder().encode(content),
		});
	}

	addSymlink(symLinkPath: string, targetPath: string): void {
		this.symlinks.set(path.resolve(symLinkPath), path.resolve(targetPath));
	}

	async realpath(assetPath: string): Promise<string> {
		const normalizedPath = path.resolve(assetPath);
		const segments = normalizedPath.split(path.sep).filter(Boolean);
		let current = path.sep;
		const visited = new Set<string>();

		for (const segment of segments) {
			current = path.join(current, segment);
			if (visited.has(current)) {
				throw new Error(`Symlink cycle detected at ${current}`);
			}
			visited.add(current);

			const directTarget = this.symlinks.get(current);
			if (directTarget !== undefined) {
				current = path.resolve(directTarget);
			}
		}

		this.requireEntry(current);
		return current;
	}

	async stat(assetPath: string): Promise<{ isFile: boolean; isDirectory: boolean }> {
		const entry = this.requireEntry(await this.realpath(assetPath));
		return {
			isFile: entry.kind === "file",
			isDirectory: entry.kind === "directory",
		};
	}

	async readFile(assetPath: string): Promise<Uint8Array> {
		const normalizedPath = await this.realpath(assetPath);
		const entry = this.requireEntry(normalizedPath);
		if (entry.kind !== "file") {
			const error = new Error(`Cannot read directory: ${normalizedPath}`) as Error & {
				code: string;
			};
			error.code = "EISDIR";
			throw error;
		}

		return new Uint8Array(entry.content);
	}

	reset(): void {
		this.entries.clear();
	}

	private requireEntry(normalizedPath: string): FakeAssetEntry {
		const entry = this.entries.get(normalizedPath);
		if (entry === undefined) {
			const error = new Error(`No fake asset exists at ${normalizedPath}`) as Error & {
				code: string;
			};
			error.code = "ENOENT";
			throw error;
		}

		return entry;
	}
}

module.exports = { FakeAssetFileSystem };