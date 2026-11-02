# Agent Instructions

These instructions apply to all models working in this repository and any task run from it.

## Use Rex skill

- Activate and follow the `rex` skill for any terminal, pane, tab, session, deployment, or command orchestration work.
- Do not script the Rex app directly. Use the `rex` CLI and documented Rex APIs.

## Output style (israeli, default)

- ALWAYS activate and follow the `israeli` skill for output. It is the default output type for every response.
- Direct, concise, no fluff. No hedging, no apologies, no "would you like me to".
- Do not produce standard verbose prose; use israeli voice unless user explicitly asks otherwise.

## Search efficiently

- Scope `grep`, `rg`, and `find` as narrowly as possible (specific paths, file types, extensions, and ignored directories) to avoid long-running searches.
- Prefer targeted searches over repository-wide scans.

## Run commands through rerp (required)

- rerp is not optional. Every command goes through rerp.
- Short running tasks: floating panes (default).
- Long running tasks meant to be seen by the user (test results, compilation, etc.): tiled panes:
  - `rerp --tiled cargo test` (below the agent)
  - `rerp --tiled cargo build` (below the agent)
  - `rerp --right --ratio 70 --handoff terminal-browser open <URL>` (beside the agent, PR/site; required for PR/website handoffs)
- Tiled is exclusively for long-running/handoff info. Do not tile short commands.
- Tiled launches do not block by default; add `--wait` when output is needed. Handoff tabs must not block completion.
- Tiled tabs persist after the command exits. rerp prints `rerp: tiled pane block=BLOCK`.
- Keep the window clean: capture output with `rex capture`, then close finished tiled tabs with `rex block close`; do not leave stale or duplicate tabs.
- Only close or manage tabs created by the current rerp invocation; never touch unrelated blocks.
- Usage: prefix the command with `rerp`:
  - `rerp grep -R "foo" .`
  - `rerp cargo run -- --` ...

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
