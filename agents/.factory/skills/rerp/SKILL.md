---
name: rerp
description: Run commands in ephemeral Rex panes. Default floating; tiled for deploy/run/handoff. Prefix any command with rerp.
---

# rerp
Prefix command: `rerp CMD...`
- Default: floating pane.
- Tiled below: `rerp --tiled CMD` (deploy/run)
- Tiled beside: `rerp --right --handoff CMD` (PR/browser)
- Tests/quick: default.
- Capture if still open: `rex capture -s "$REX_SESSION" -b BLOCK --trim`
- Close: `rex block close ...`
