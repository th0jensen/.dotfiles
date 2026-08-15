zsh_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
if [[ -r "$zsh_config_dir/common.zsh" ]]; then
  source "$zsh_config_dir/common.zsh"
fi

case "$(uname -s)" in
  Linux)
    [[ -r "$zsh_config_dir/linux.zsh" ]] && source "$zsh_config_dir/linux.zsh"
    ;;
  Darwin)
    [[ -r "$zsh_config_dir/macos.zsh" ]] && source "$zsh_config_dir/macos.zsh"
    ;;
esac
