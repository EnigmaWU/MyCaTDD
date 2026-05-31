# utCodeAgentCLI 需求 —— DEVELOPER

> 主索引、状态模型与快速参考 AC 清单：[README_UserStory_ZH.md](README_UserStory_ZH.md)

**作为** DEVELOPER："我构建、测试和扩展 CLI。我需要清晰的契约、诊断能力和 adapter 边界。"

---

### US-DEV-01 [P0] — 所有失败状态都有可操作的错误信息

**作为** DEVELOPER，**我希望** 每条错误信息都指明问题、标识受影响的参数并建议纠正方法，**以便** 无需阅读 CLI 源码即可调试调用问题。

#### AC-01：无法识别的参数值给出纠正建议
- **Given** CLI 调用使用 `--behave "deisgnAllSkeleton"`（拼写错误）
- **When** 验证失败
- **Then** stderr 包含 `"deisgnAllSkeleton"` 未被识别
- **And** stderr 包含建议：`"您是否想输入 'designAllSkeleton'？"`（最佳匹配）
- **And** stderr 包含完整有效值列表

#### AC-02：文件缺失错误包含精确路径
- **Given** `--inputFile nonexistent/path.h`
- **When** 验证失败
- **Then** stderr 包含完整解析路径 `nonexistent/path.h`
- **And** stderr 指明参数名称（`--inputFile`）

#### AC-03：Target/behavior 不匹配时解释原因并建议替代方案
- **Given** `--target tests/auth_test.cpp::TC-03 --behave designAllSkeleton`
- **When** 验证检测到不匹配
- **Then** stderr 解释：skeleton 设计需要文件级 `--target`，而非 TC 级 target
- **And** stderr 建议 skeleton 设计有效的 `--target` 形式，或 TC 级 target 有效的 `--behave` 值

---

### US-DEV-02 [P1] — 可配置的日志与诊断输出

**作为** DEVELOPER，**我希望** `--log-level` 控制输出详细程度，**以便** 生产环境静默运行，调试时详细输出。

#### AC-01：--log-level error 抑制非错误输出
- **Given** 任意带 `--log-level error` 的有效调用
- **When** CLI 成功执行
- **Then** stderr 仅出现 error 级别消息
- **And** stdout 不受影响（行为输出仍然正常）

#### AC-02：--log-level debug 揭示内部分辨过程
- **Given** 任意带 `--log-level debug` 的有效调用
- **When** CLI 执行
- **Then** stderr 包含状态转换：参数解析、behavior 解析、slash-command 选择、文件写入

---

### US-DEV-03 [P1] — 交互式逐命令确认

**作为** DEVELOPER，**我希望** 在每个 slash command 执行前预览它，**以便** 可以在多 step 调用中批准、跳过或中止，避免盲执行。

#### AC-01：每个 slash command 执行前提示确认
- **Given** 带 `--interactive-slash-commands` 的 `designAndImplTest` 调用
- **When** CLI 解析出一个 slash command（如 `UT_designFuncTestsSkeleton`）
- **Then** stdout 提示："在 tests/auth_api_test.cpp 上执行 UT_designFuncTestsSkeleton？[y/n/s(kip)/a(bort)]"
- **And** CLI 等待用户输入后才继续

#### AC-02：中止停止所有后续执行
- **Given** 一个交互式会话有多个待执行 slash command
- **When** 用户在任意提示输入 "a"（中止）
- **Then** 不再执行任何后续 slash command
- **And** CLI 以退出码 1 退出
- **And** trace 记录哪些命令被跳过

---

### US-DEV-04 [P2] — 运行时 adapter 接口

**作为** DEVELOPER，**我希望** CLI 的 slash-command 执行后端可通过文档化的 adapter 接口替换，**以便** `utCodeAgentCLI` 可在 Copilot-native、OpenCode 或自定义 agent runtime 上运行，无需重写 CLI 核心。

#### AC-01：Adapter 符合定义的接口
- **Given** 一个实现了 `CliRuntimeAdapter` 接口的 runtime adapter
- **When** CLI 需要调用 slash command
- **Then** 它调用 adapter 的 `invoke(slashCommand, context)` 方法
- **And** adapter 接收已解析的命令路径、target、source 和 goal 上下文
- **And** CLI 不假定任何特定 runtime（TypeScript、Python、shell）

#### AC-02：提供默认 adapter
- **Given** 未配置自定义 adapter
- **When** CLI 运行
- **Then** 内置默认 adapter 直接执行 slash command
