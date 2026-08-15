export DOTFILES_PLATFORM=linux

export EDITOR=hx
export VISUAL=hx
export TERM="xterm-ghostty"

path=(
  "$HOME/.local/share/pnpm/bin"
  "$HOME/.local/share/pi-node/node-v22.23.1-linux-x64/bin"
  $path
)
typeset -U path PATH

export ZSH="/usr/share/oh-my-zsh"
DISABLE_MAGIC_FUNCTIONS="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
[[ -z "${plugins[*]}" ]] && plugins=(git fzf extract)
[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

export HISTCONTROL=ignoreboth
export HISTORY_IGNORE="(\&|[bf]g|c|clear|history|exit|q|pwd|* --help)"
export LESS_TERMCAP_md="$(tput bold 2> /dev/null; tput setaf 2 2> /dev/null)"
export LESS_TERMCAP_me="$(tput sgr0 2> /dev/null)"
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

alias make="make -j$(nproc)"
alias ninja="ninja -j$(nproc)"
alias n="ninja"
alias c="clear"
alias rmpkg="sudo pacman -Rsn"
alias cleanch="sudo pacman -Scc"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias update="sudo pacman -Syu"
alias cleanup="sudo pacman -Rsn $(pacman -Qtdq)"
alias apt="man pacman"
alias apt-get="man pacman"
alias please="sudo"
alias tb="nc termbin.com 9999"
alias jctl="journalctl -p 3 -xb"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
[[ -r /usr/share/doc/pkgfile/command-not-found.zsh ]] && \
  source /usr/share/doc/pkgfile/command-not-found.zsh

export FZF_BASE=/usr/share/fzf

# Write iso file to sd card
iso2sd() {
  if (( $# < 1 )); then
    echo "Usage: iso2sd <input_file> [output_device]"
    echo "Example: iso2sd ~/Downloads/ubuntu-25.04-desktop-amd64.iso /dev/sda"
    return 1
  fi

  local iso="$1"
  local drive="$2"

  if [[ -z $drive ]]; then
    echo "No drive selected"
    return 1
  fi

  sudo dd bs=4M status=progress oflag=sync if="$iso" of="$drive"
  sudo eject "$drive"
}

# Format an entire drive for a single partition using exFAT
format-drive() {
  if (( $# != 2 )); then
    echo "Usage: format-drive <device> <name>"
    echo "Example: format-drive /dev/sda 'My Stuff'"
    echo -e "\nAvailable drives:"
    lsblk -d -o NAME -n | awk '{print "/dev/"$1}'
  else
    echo "WARNING: This will completely erase all data on $1 and label it '$2'."
    read -rp "Are you sure you want to continue? (y/N): " confirm

    if [[ $confirm =~ ^[Yy]$ ]]; then
      sudo wipefs -a "$1"
      sudo dd if=/dev/zero of="$1" bs=1M count=100 status=progress
      sudo parted -s "$1" mklabel gpt
      sudo parted -s "$1" mkpart primary 1MiB 100%
      sudo parted -s "$1" set 1 msftdata on

      partition="$([[ $1 == *"nvme"* ]] && echo "${1}p1" || echo "${1}1")"
      sudo partprobe "$1" || true
      sudo udevadm settle || true

      sudo mkfs.exfat -n "$2" "$partition"

      echo "Drive $1 formatted as exFAT and labeled '$2'."
    fi
  fi
}
