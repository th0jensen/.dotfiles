---
name: rerp
description: Required. Use rerp for every command. Default floating for short running tasks; tiled only for long-running/user-visible (tests, compilation) and handoffs. Prefix any command with rerp.
---

# rerp
Rerp is not optional. Every command uses rerp.

Prefix command: `rerp CMD...`
- Required for all commands.
- Short running tasks: floating pane (default). Ephemeral tasks close on completion.
- Long running tasks meant to be seen by the user (test results, compilation, etc.): tiled pane.
  - `rerp --tiled cargo test` (below the agent)
  - `rerp --tiled cargo build` (below the agent)
- Tiled beside: `rerp --right --handoff CMD` (PR/browser)
- Tiled is exclusively for long-running/handoff info.
- Tiled launches do not block by default; they return immediately. Add `--wait` when output is needed.
- Tiled tabs persist after the command finishes. rerp prints `rerp: tiled pane block=BLOCK`.
- Manage tiled tabs: capture with `rex capture -s "$REX_SESSION" -b BLOCK --trim`; close finished ones with `rex block close -s "$REX_SESSION" BLOCK`.
- Only interact with blocks/tabs created by the current rerp invocation; do not close unrelated blocks.
- Keep the window clean: close tiled tabs once their output is no longer needed; avoid stale or duplicate tabs. Do not tile short commands.
