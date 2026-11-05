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
