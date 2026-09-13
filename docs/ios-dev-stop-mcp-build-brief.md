# Agent brief: ios-dev plugin — cancel MCP builds on Cursor Stop

| Field | Value |
| --- | --- |
| Parent | [development.md](development.md) |
| Audience | Agent working in the **ios-dev Cursor plugin** repository (not Drukarnik host) |
| Goal | Pressing **Stop** during `build_sim` / `test_sim` / `build_run_sim` must end the underlying `xcodebuild` cleanly and release `XCBuildData/build.db` for the host `projectPath`. |

## Problem (observed on host)

1. User presses **Stop** in Cursor while XcodeBuildMCP is building.
2. Agent turn stops, but `xcodebuild` for the host project often keeps running or is killed in a bad state.
3. Next Xcode Canvas preview or build fails with `database is locked`, `unable to attach DB`, or `invalid reuse after initialization failure`.
4. Root cause: `hooks/agent-session-lifecycle.sh` on `stop` / `sessionEnd` only terminates PIDs recorded from **Shell** skill scripts (`should_track`). **MCP build tools are not tracked** (stated in `rules/ios-workflow.mdc`: “MCP build/test is not tracked”).

## Requirements

| ID | Requirement |
| --- | --- |
| R1 | On Cursor `stop` (status `aborted`, `error`, or `completed`) and `sessionEnd`, terminate **in-flight XcodeBuildMCP builds started in that conversation** for the host project. |
| R2 | Scope **must** match existing `simulator-hygiene.sh kill-xcodebuild`: only processes whose command line includes the resolved `projectPath` / project name from the host’s `.xcodebuildmcp/config.yaml` (or XcodeBuildMCP session defaults `projectPath`). **Must not** kill unrelated projects’ `xcodebuild`. |
| R3 | Termination **must** be graceful then forceful: SIGTERM, short wait, SIGKILL on survivors; include child PIDs (same tree walk as `simulator-hygiene.sh` `workload_python` kill mode). |
| R4 | **Must not** require host repos to add `.cursor/hooks` or patch `~/.cursor/plugins/...` locally. Fix lives entirely in the plugin. |
| R5 | **Must not** use Shell `xcodebuild` / `xcrun` / `simctl` from the **agent** in host projects; the hook may use `ps`/`kill`/`pgrep`/`python3` only (same as existing lifecycle hook). |
| R6 | Document behavior in `rules/ios-workflow.mdc` (replace “MCP build/test is not tracked” with accurate lifecycle: tracked MCP runs + stop cleanup). |

## Suggested implementation (plugin repo)

1. **Track MCP builds per conversation**
   - Add hook handlers `beforeMCPExecution` / `afterMCPExecution` (or `postToolUse` with matcher for XcodeBuildMCP tools) in `hooks/hooks.json`.
   - Matcher: tools named like `build_sim`, `test_sim`, `build_run_sim`, `clean`, or namespace `plugin-ios-dev-XcodeBuildMCP`.
   - On start: append to the same registry as lifecycle (`~/.cursor/ios-dev/shell-registry/<conversation_id>.jsonl`) with `phase: mcp_started`, `tool`, `projectPath` from session if available in payload.
   - On success/failure: `phase: mcp_finished`.

2. **Resolve project path on stop**
   - Prefer `projectPath` stored at MCP start from tool arguments or last known `session_show_defaults` snapshot if the hook receives it.
   - Fallback: read host cwd from stop payload if present; locate `.xcodebuildmcp/config.yaml` upward and resolve `projectPath` like `simulator-hygiene.sh` `read_project_path`.

3. **On `stop` / `sessionEnd`**
   - After existing `force_stop_session_processes`, if any `mcp_started` without matching `mcp_finished` for this conversation, call shared Python/bash helper (refactor kill logic from `skills/ios-simulator-browser/scripts/simulator-hygiene.sh` into a small module imported by both hygiene script and lifecycle hook — **avoid duplication**).
   - Log `agent_message` JSON when kills occur (same pattern as current hook).

4. **Optional (if XcodeBuildMCP supports it)**
   - Investigate MCP cancellation API (abort in-flight tool). If available, invoke on Stop **before** process kill. Process kill remains required as backstop.

5. **Tests / verification**
   - Manual: start `build_sim` on a host project, press Stop within 30s, run `simulator-hygiene.sh status` — `xcodebuild_count` for project should be 0; immediate second `build_sim` should succeed without DerivedData delete.
   - Do not add Drukarnik-specific paths to the plugin.

## Files likely touched (plugin repo)

| Path | Change |
| --- | --- |
| `hooks/hooks.json` | Register MCP tracking + extend stop/sessionEnd |
| `hooks/agent-session-lifecycle.sh` | MCP registry + kill in-flight project xcodebuild |
| `skills/ios-simulator-browser/scripts/simulator-hygiene.sh` | Extract shared kill helper (optional refactor) |
| `rules/ios-workflow.mdc` | Document Stop + MCP lifecycle |

## Out of scope

- Host-project `.cursor/hooks.json`
- Editing installed plugin under `~/.cursor/plugins/cache/...` on a developer machine
- Disabling Xcode Canvas auto-refresh (host UX only)

## Copy-paste prompt for plugin-repo agent

```
Fix ios-dev so Cursor Stop aborts in-flight XcodeBuildMCP builds without leaving build.db locked.

Read docs/ios-dev-stop-mcp-build-brief.md equivalent in the issue/PR, or:

1. Today agent-session-lifecycle.sh stop/sessionEnd only kills shell PIDs from skill scripts; build_sim via MCP is untracked.
2. Extend plugin hooks to track XcodeBuildMCP build_sim/test_sim/build_run_sim per conversation_id and on stop/sessionEnd kill only that host project's xcodebuild tree (same matching as simulator-hygiene.sh kill-xcodebuild).
3. Reuse or share kill logic with simulator-hygiene.sh; no host .cursor hooks.
4. Update ios-workflow.mdc documentation.
5. Verify: Stop during build_sim → no project xcodebuild → next build_sim succeeds without DerivedData wipe.
```
