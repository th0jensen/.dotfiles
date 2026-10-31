---
name: rerp
description: Run any command in an ephemeral Rex pane (floating or tiled) using rerp, instead of executing it directly in the agent terminal.
---

# rerp: ephemeral Rex panes

`rerp` prefixes a command exactly like running it directly:

```sh
rerp grep -R "foo" .
rerp cargo run
```

## When to use
- Prefer `rerp` for every command that produces output, builds, tests, deploys, or runs long-lived processes.
- It keeps the agent's own terminal clean and leaves evidence in a Rex pane.
- Default is a floating pane. Use floating for tests and quick commands.
- Use tiled panes for deploy/run/handoff terminals:
  - cargo run and dev servers: `rerp --tiled cargo run` (below the agent)
  - PR handoff / terminal browser: `rerp --right --handoff ...` (beside the agent)

## Options
- `--float` / `--floating`: floating pane (default)
- `--tiled` / `--tile` / `--deploy`: tiled pane below the agent
- `--right` / `--beside` / `--handoff`: tiled pane beside the agent
- `--keep-open`: keep the pane open even after the command exits.
- `--label TEXT`: label the pane.
- `--timeout SEC`: wait at most SEC seconds before leaving the pane running (default 5).

## Inspecting output
- Quick commands print captured output to stdout and close the pane.
- Longer or still-running commands leave the pane open; inspect with:
  `rex capture -s "$REX_SESSION" -b BLOCK --trim`

## Floating panes
Floating panes are created via `session.new_layer`. Close them with `session.close_layer` or `rex block close`.
EOF
