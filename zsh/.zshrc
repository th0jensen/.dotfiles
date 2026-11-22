zsh_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
if [[ -r "$zsh_config_dir/common.zsh" ]]; then
  source "$zsh_config_dir/common.zsh"
fi

case "$OSTYPE" in
  linux*)
    [[ -r "$zsh_config_dir/linux.zsh" ]] && source "$zsh_config_dir/linux.zsh"
    ;;
  darwin*)
    [[ -r "$zsh_config_dir/macos.zsh" ]] && source "$zsh_config_dir/macos.zsh"
    ;;
esac

# bun completions
[ -s "/Users/thomas/.bun/_bun" ] && source "/Users/thomas/.bun/_bun"

# >>> termium >>>
case ":$PATH:" in *:'/home/thomas/.local/bin':*) ;; *) export PATH='/home/thomas/.local/bin':"$PATH" ;; esac
# <<< termium <<<

# Register Rex prompt hooks after the platform's ZLE plugins.
if [[ -n $REX_BLOCK ]]; then
  autoload -Uz add-zle-hook-widget
  _rex_prompt_start() { printf '\e]7501;id=zsh-zle:state=idle\a' > /dev/tty; }
  _rex_prompt_finish() { printf '\e]7501;id=zsh-zle:state=clear\a' > /dev/tty; }
  add-zle-hook-widget line-init _rex_prompt_start
  add-zle-hook-widget line-finish _rex_prompt_finish
fi
