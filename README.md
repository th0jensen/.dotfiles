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

Restow a package after changing files:

```sh
stow -Rv PACKAGE
```

Remove a package's symlinks:

```sh
stow -Dv PACKAGE
```
