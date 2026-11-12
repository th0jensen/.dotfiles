---
name: rerp
description: Runs web servers, builds, tests, long-running tasks, and user-visible handoffs in reusable Rex panes. Use for these tasks instead of invisible background processes.
---

# rerp

Run web servers, builds, tests, and other long-running or user-visible tasks in rerp panes. Run quick commands with little output directly.

Reuse an idle rerp pane you created before opening another. Otherwise run bare `rerp` to open a minimized floating shell and save its block ID. Do not create tiled panes; if the user tiles or otherwise changes a rerp pane, preserve their changes and keep using it.

Before sending a command, use `rex capture -s "$REX_SESSION" -b BLOCK --trim` to confirm the pane is at a shell prompt. Run the command with `rex send -s "$REX_SESSION" -b BLOCK 'COMMAND'` and `rex send-key -s "$REX_SESSION" -b BLOCK enter`; capture the pane to check its output. For builds and tests, also capture the exit status, for example by appending `; printf '\n__RERP_EXIT__=%s\n' "$?"` to the command. Use another pane if the first is busy. Do not use `rerp COMMAND`: it closes its pane after completion or 60 seconds, so it cannot be reused and stops long-running work.

Close your unused or inactive panes with `rex block close -s "$REX_SESSION" BLOCK` when they are no longer needed, including on errors. Leave active servers and other processes the user still needs running. Never close unrelated panes.
