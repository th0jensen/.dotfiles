---
name: rerp
description: Runs long-running tasks and user-visible handoffs in Rex panes. Optional for shorter tasks with useful output; do not use for commands with no or minimal output. Floating panes start minimized; tiled panes are for long-running/user-visible tasks and handoffs.
---

# rerp
Use rerp mainly for long-running tasks and user-visible handoffs, not every command.

Prefix command: `rerp CMD...`
- Run commands with no or minimal output directly, without rerp (for example, `mkdir`, `git status --short`, or a quick file lookup).
- Shorter tasks with useful output may use rerp when a separate pane helps; otherwise run them directly.
- Floating panes start minimized (default). Ephemeral tasks close on completion.
- Floating panes, including bare `rerp` interactive shells, are minimized immediately after creation using Rex's `session.set_layer_state` API; their commands keep running.
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
