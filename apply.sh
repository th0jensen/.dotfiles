#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v stow >/dev/null 2>&1; then
  echo "Missing required command: stow" >&2
  echo "Install GNU Stow first, then rerun this script." >&2
  exit 1
fi

# Map each dotfiles package to the command or app that should be installed.
is_installed() {
  local package="$1"
  case "$package" in
    agents) return 0 ;;
    helix) command -v hx >/dev/null 2>&1 ;;
    nushell) command -v nu >/dev/null 2>&1 ;;
    powershell) command -v pwsh >/dev/null 2>&1 ;;
    ghostty) [[ -d /Applications/Ghostty.app ]] || command -v ghostty >/dev/null 2>&1 ;;
    zed) command -v zed >/dev/null 2>&1 || ls /Applications 2>/dev/null | grep -qi '^Zed' ;;
    *) command -v "$package" >/dev/null 2>&1 ;;
  esac
}

missing=()
for dir in */; do
  package="${dir%/}"
  [[ "$package" == ".git" ]] && continue
  if ! is_installed "$package"; then
    missing+=("$package")
  fi
done

if (( ${#missing[@]} > 0 )); then
  echo "Aborting: the following packages are not installed:" >&2
  printf '  - %s\n' "${missing[@]}" >&2
  exit 1
fi

for dir in */; do
  package="${dir%/}"
  [[ "$package" == ".git" ]] && continue
  echo "Stowing $package (adopting existing files)..."
  stow -Rv --adopt --ignore='\.DS_Store' --ignore='output-styles' "$package"
done

echo "Syncing output styles..."
mkdir -p "$HOME/.factory/output-styles"
find . -path '*/.factory/output-styles/*.md' -print0 | while IFS= read -r -d '' f; do
  cp "$f" "$HOME/.factory/output-styles/$(basename "$f")"
done

echo "Dotfiles applied."
