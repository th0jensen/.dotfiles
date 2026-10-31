# Agent Instructions

These instructions apply to all models working in this repository and any task run from it.

## Use Rex skill

- Activate and follow the `rex` skill for any terminal, pane, tab, session, deployment, or command orchestration work.
- Do not script the Rex app directly. Use the `rex` CLI and documented Rex APIs.

## Search efficiently

- Scope `grep`, `rg`, and `find` as narrowly as possible (specific paths, file types, extensions, and ignored directories) to avoid long-running searches.
- Prefer targeted searches over repository-wide scans.

## Run commands through rerp

- Use `rerp` for nearly all command execution (grep, builds, tests, deploys, servers, etc.). Avoid direct terminal execution except for trivial/meta tasks or when rerp is unavailable.
- Usage: prefix the command with `rerp`:
  - `rerp grep -R "foo" .` (floating by default)
  - `rerp cargo run -- --` ...
- Defaults: floating panes (tests/quick commands).
- Tiled panes for deploy/run/handoff:
  - `rerp --tiled cargo run` (below the agent)
  - `rerp --right --handoff ...` (beside the agent, e.g. PR in terminal browser)
- Inspect output with `rex capture` when a pane stays open.

## Commit authorship / co-authors

When creating git commits, include co-author trailers naming both the model and the harness with version numbers:

```
Co-authored-by: Beam (Beam-1.0-501B-A23B)
Co-authored-by: Factory Droid 1.1.0 <138933559+factory-droid[bot]@users.noreply.github.com>
```

- Always include the harness git email above so GitHub shows the Droid icon.
- Replace the model line with the actual model name and version in use.
- Obtain the harness version from `droid --version`.
- Use the existing configured git identity for the author/committer; do not override it.
