export DOTFILES_PLATFORM=macos

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export EDITOR="zed"

export CPATH="/opt/homebrew/include:$CPATH"
export LIBRARY_PATH="$HOME/CEdev/include:/opt/homebrew/lib:$LIBRARY_PATH"

path=(
  "$HOME/CEdev/bin"
  "$HOME/go/bin"
  "$HOME/.spicetify"
  "$HOME/.opencode/bin"
  "$HOME/.grok/bin"
  $path
)
typeset -U path PATH

# Zig
#export PATH="$HOME/Developer/zig:$PATH"

# grok installer
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C

[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env
[ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env"

if (( $+commands[fzf] )); then
  [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
  [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
fi
