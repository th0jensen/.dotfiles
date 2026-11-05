export DOTFILES_PLATFORM=macos

if [[ -x /opt/homebrew/bin/brew ]]; then
  homebrew_prefix=/opt/homebrew
elif [[ -x /usr/local/bin/brew ]]; then
  homebrew_prefix=/usr/local
fi

if [[ -n $homebrew_prefix ]]; then
  # Reuse inherited shellenv exports, but keep Homebrew's PATH precedence.
  if [[ $HOMEBREW_PREFIX != "$homebrew_prefix" ||
        -z $HOMEBREW_CELLAR || -z $HOMEBREW_REPOSITORY ||
        $INFOPATH != "$homebrew_prefix/share/info:"* ||
        ( -n $MANPATH && $MANPATH != :* ) ]]; then
    eval "$("$homebrew_prefix/bin/brew" shellenv)"
  fi
  path=("$homebrew_prefix/bin" "$homebrew_prefix/sbin" $path)
fi
unset homebrew_prefix

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
