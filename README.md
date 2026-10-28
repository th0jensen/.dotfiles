# dotfiles

Personal macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

This repo is organized as stow packages. Current packages:

- `btop`
- `cargo`
- `fastfetch`
- `ghostty`
- `git`
- `helix`
- `nushell`
- `powershell`
- `skhd`
- `starship`
- `tmux`
- `yabai`
- `zed`

Each top-level directory contains the files that should be symlinked into `$HOME`.

## Requirements

Install GNU Stow first.

On macOS with Homebrew:

```sh
brew install stow
```

## Usage

Run commands from this repository:

```sh
cd ~/.dotfiles
```

### Apply all packages

In `zsh`:

```sh
stow -v */
```

In `nu`:

```nu
stow -v ...(*)
```

### Apply one package

Replace `PACKAGE` with a top-level directory such as `ghostty`, `nushell`, or `tmux`.

In `zsh`:

```sh
stow -v PACKAGE
```

## Restow or remove

Restow a package after adding, removing, or moving files:

```sh
stow -Rv PACKAGE
```

Remove a package's symlinks:

```sh
stow -Dv PACKAGE
```

Edits to existing files are available through their symlinks immediately. The
application may still need to reload its configuration.

## Ghostty

The `ghostty` package links `~/.config/ghostty/config` to this repository.
After stowing or editing the config, press `Cmd+Shift+,` in Ghostty to reload it.
Changes to `macos-titlebar-style` only apply to new windows, so open a new window
with `Cmd+N` after reloading.

To check for config errors and inspect the settings Ghostty loads:

```sh
ghostty +validate-config
ghostty +show-config
```

On macOS, Ghostty also loads configuration from
`~/Library/Application Support/com.mitchellh.ghostty/`. Settings there can override
the config in `~/.config/ghostty/`. See the
[Ghostty configuration documentation](https://ghostty.org/docs/config) for the
load order and reload behavior.
