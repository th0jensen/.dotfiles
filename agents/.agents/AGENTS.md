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
- Once the directory or scope is already known, do not run `find /`, `grep /`, or other root-wide scans; search the known path directly.

## Use rerp for long-running tasks and handoffs

- Run web servers, compilation, test runs, and other long-running or user-visible tasks in a rerp pane, not as invisible background processes. Run quick commands with little output directly.
- Follow the `rerp` skill. Create floating panes and reuse your existing rerp panes whenever they are idle instead of opening duplicates.
- If the user tiles or otherwise changes a rerp pane, preserve their changes and keep using that pane.
- Close your unused or inactive panes when they are no longer needed. Leave active servers and other processes that the user still needs running, and never close unrelated panes.

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
