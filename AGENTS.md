# Agent Instructions

These instructions apply to all models working in this repository and any task run from it.

## Use Rex skill

- Activate and follow the `rex` skill for any terminal, pane, tab, session, deployment, or command orchestration work.
- Do not script the Rex app directly. Use the `rex` CLI and documented Rex APIs.

## Run commands through rerp

- Prefer the `rerp` skill/script for all commands (`grep`, `cargo run`, builds, tests, deploys, servers).
- Usage: prefix the command with `rerp`:
  - `rerp grep -R "foo" .`
  - `rerp cargo run`
- Use `rerp --float ...` for floating panes and `rerp --tiled ...` (default) for tiled panes.
- Inspect output with `rex capture` when a pane stays open.

## Commit authorship / co-authors

When creating git commits, include co-author trailers naming both the model and the harness with version numbers:

```
Co-authored-by: Beam (Beam-1.0-501B-A23B)
Co-authored-by: Factory Droid 1.1.0
```

- Replace the model line with the actual model name and version in use.
- Obtain the harness version from `droid --version`.
- Use the existing configured git identity for the author/committer; do not override it.
