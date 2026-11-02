---
name: rerp
description: Required. Use rerp for every command. Default floating; tiled only for long-running/handoff. Prefix any command with rerp.
---

# rerp
Rerp is not optional. Every command uses rerp.

Prefix command: `rerp CMD...`
- Required for all commands.
- Default: floating pane. Ephemeral tasks close on completion.
- Tiled below: `rerp --tiled CMD` (long-running/deploy/run only)
- Tiled beside: `rerp --right --handoff CMD` (PR/browser)
- Long-running: add `--keep-open`.
- Capture if still open: `rex capture -s "$REX_SESSION" -b BLOCK --trim`
- Close: `rex block close ...`
