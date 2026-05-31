# utCodeAgentCLI — UserStory 状态

每个验收标准的实时追踪。对实现验证通过后标记 `[x]`。

---

## US-USER-01 — 解析并验证 CLI 参数
- [ ] AC-01  缺少 `--goal` → exit 1, stderr 指明
- [ ] AC-02  `--goalStory` + `--goalStoryFile` 同时使用 → exit 1, 冲突
- [ ] AC-03  `--behave "nonexistent"` → exit 1, 列出有效值
- [ ] AC-04  文件路径参数指向不存在的文件 → exit 1, 指明路径
- [ ] AC-05  所有参数有效 → exit 0, 继续执行

## US-USER-02 — 设计 CaTDD 测试 skeleton
- [ ] AC-01  Story + source + 空 target → 文件获得全部 4 个 P0 category 的 US/AC/TC
- [ ] AC-02  单 category 设计 → 文件仅获得该 category 的 skeleton
- [ ] AC-03  有 source 但无 story → skeleton 生成, @[US] 占位符, stderr 警告

## US-USER-03 — 审查设计 skeleton（所有层级）
- [ ] AC-01  有 skeleton TC → reviewFuncTestsSkeleton 报告各 P0 category/status 数量
- [ ] AC-02  文件为 EMPTY → "0 个 skeleton", exit 0
- [ ] AC-03  有 P1 design skeleton → reviewDesignTestsSkeleton 报告各 P1 category/status 数量
- [ ] AC-04  有 P2 quality skeleton → reviewQualityTestsSkeleton 报告各 P2 category/status 数量

## US-USER-04 — 选择下一个要实现的测试用例
- [ ] AC-01  有 PLANNED TC → CaTDD 优先级下首个 PLANNED TC-ID
- [ ] AC-02  TC-01 RED, TC-02/03 PLANNED → 选择 TC-02, 跳过 RED
- [ ] AC-03  所有 TC 为 RED 或 GREEN → "全部已实现", exit 0

## US-USER-05 — 实现一个可执行测试用例（RED）
- [ ] AC-01  TC-04 PLANNED + 有效 skeleton → 测试代码已写, status → RED
- [ ] AC-02  TC-04 已为 RED → exit 1, "已实现", 无修改
- [ ] AC-03  --target 是整个文件非单个 TC → exit 1, 不匹配
- [ ] AC-04  TC-04 skeleton 缺少 @[Category] → exit 1, 完整性失败, 无修改

## US-USER-06 — 实现文件中所有测试用例
- [ ] AC-01  混合 PLANNED/RED TC → 按 CaTDD 优先级实现, 摘要报告
- [ ] AC-02  TC-02 中途失败 → 保留 PLANNED, 继续, 摘要统计失败数

## US-USER-07 — 批量 skeleton 设计（多文件）
- [ ] AC-01  多个 --target 文件 + 共享 source → 每个文件获得 skeleton, 按文件报告

## US-USER-08 — 一步完成设计与实现
- [ ] AC-01  Story + source + 空 target → skeleton 设计后所有 TC → FULLY_RED

## US-USER-09 — 审查已实现的测试用例
- [ ] AC-01  TC-04 RED 且保留 skeleton → stdout: 保留情况 + 测试质量
- [ ] AC-02  TC-04 PLANNED（未实现）→ "尚未实现", exit 0
- [ ] AC-03  --target 是整个文件非单个 TC → exit 1, 不匹配

## US-USER-10 — 审查文件中所有已实现的测试用例
- [ ] AC-01  混合 RED/PLANNED TC → RED TC 逐个审查, PLANNED 跳过, 摘要
- [ ] AC-02  无 RED TC（全部 PLANNED）→ "0 个已实现 TC", exit 0

## US-INVENTOR-01 — 将所有 CaTDD 语义委托给 methodPrompts
- [ ] AC-01  CLI 需要 Edge category 含义 → 从 methodPrompts/ 读取, 缺失则退出
- [ ] AC-02  --behave designFuncTestsSkeleton → 调用 slashCommands/, 无内联逻辑
- [ ] AC-03  CLI 修改测试文件并产生 CaTDD 内容 → 来自委托层, 绝不硬编码

## US-INVENTOR-02 — 生成机器可读的执行 trace
- [ ] AC-01  有效调用成功 → trace 工件: invocation, resolution, output
- [ ] AC-02  有效调用执行中失败 → trace 记录失败点 + 已完成 step
- [ ] AC-03  Trace 工件被 JSON/YAML 解析 → 有效, 字段符合 schema

## US-INVENTOR-03 — 方法解析过程的可诊断可见性
- [ ] AC-01  --diagMethodPrompts → 列出 prompt 路径与 category
- [ ] AC-02  --diagSlashCommands → 列出命令名与路径

## US-DEV-01 — 所有失败状态都有可操作的错误信息
- [ ] AC-01  --behave 拼写错误 → stderr 给出建议 + 列出有效值
- [ ] AC-02  --inputFile 指向缺失文件 → stderr 指明路径 + 参数名
- [ ] AC-03  TC target + skeleton 设计 behavior → stderr 解释原因 + 给出建议

## US-DEV-02 — 可配置的日志与诊断输出
- [ ] AC-01  --log-level error → stderr 仅 error, stdout 不受影响
- [ ] AC-02  --log-level debug → stderr 展示状态转换

## US-DEV-03 — 交互式逐命令确认
- [ ] AC-01  交互模式 → 每个 slash command 前提示 [y/n/s/a]
- [ ] AC-02  用户输入 "a"（中止）→ 无后续命令, exit 1, trace 记录跳过

## US-DEV-04 — 运行时 adapter 接口
- [ ] AC-01  Adapter 实现 CliRuntimeAdapter → 调用 invoke() 含完整上下文
- [ ] AC-02  无自定义 adapter → 内置默认 adapter 直接执行
