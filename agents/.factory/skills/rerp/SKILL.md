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
- Long-running: add `--keep-open`.
- Capture if still open: `rex capture -s "$REX_SESSION" -b BLOCK --trim`
- Close: `rex block close ...`
