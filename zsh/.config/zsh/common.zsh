export COLORTERM=truecolor

path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$HOME/.bun/bin"
  "$HOME/.deno/bin"
  "$HOME/.zvm/bin"
  "$HOME/.zvm/self"
  "$HOME/opt/bin"
  $path
)
typeset -U path PATH

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt append_history share_history hist_ignore_dups hist_ignore_all_dups hist_reduce_blanks hist_verify

bindkey -e
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey "^[[C" forward-char
bindkey "^[[D" backward-char

setopt combining_chars menu_complete auto_menu chase_links complete_in_word always_to_end extended_glob interactive_comments auto_cd
unsetopt beep

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=* l:|=*'
zstyle ':completion:*' match-hidden-files off
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' select-prompt ''
zstyle ':completion:*' file-list all
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
fi

if (( $+commands[try] )); then
  eval "$(try init ~/Work/tries)"
fi

export ZVM_INSTALL="$HOME/.zvm"
if [ -s "$ZVM_INSTALL/init.zsh" ]; then
  source "$ZVM_INSTALL/init.zsh"
fi

alias tmux='tmux -u'

# eza (https://eza.rocks/)
alias ls='eza -lh --group-directories-first --icons=auto --git'
alias lsa='ls -a'
alias ll='ls'
alias la='lsa'
alias lt='eza --tree --group-directories-first --icons=auto --git'

# Fuzzy find (https://junegunn.github.io/fzf/)
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias eff='$EDITOR "$(ff)"'

# Smart cd (https://github.com/ajeetdsouza/zoxide)
alias cd="zd"
zd() {
  if [[ $# -eq 0 ]]; then
    builtin cd ~ && return
  elif [[ -d $1 ]]; then
    builtin cd "$1"
  else
    z "$@" && printf "%s " "->" && pwd || echo "Error: Directory not found"
  fi
}

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
alias c='opencode'
alias cx='printf "\033[2J\033[3J\033[H" && claude --allow-dangerously-skip-permissions'
alias d='docker'
alias lzd='lazydocker'
alias r='rails'
alias v='vim'
alias t='tmux attach || tmux new -s Work'
n() { if [[ $# -eq 0 ]]; then nvim .; else nvim "$@"; fi; }

# Git
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'

# SSH port forwarding
fip() {
  (( $# < 2 )) && echo "Usage: fip <host> <port1> [port2] ..." && return 1
  local host="$1"
  shift
  for port in "$@"; do
    ssh -f -N -L "$port:localhost:$port" "$host" && echo "Forwarding localhost:$port -> $host:$port"
  done
}

dip() {
  (( $# == 0 )) && echo "Usage: dip <port1> [port2] ..." && return 1
  for port in "$@"; do
    pkill -f "ssh.*-L $port:localhost:$port" && echo "Stopped forwarding port $port" || echo "No forwarding on port $port"
  done
}

lip() {
  pgrep -af "ssh.*-L [0-9]+:localhost:[0-9]+" || echo "No active forwards"
}

# Create a Tmux Dev Layout with editor, ai, and terminal
# Usage: tdl <c|cx|codex|other_ai> [<second_ai>]
tdl() {
  [[ -z $1 ]] && { echo "Usage: tdl <c|cx|codex|other_ai> [<second_ai>]"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdl."; return 1; }

  local current_dir="${PWD}"
  local editor_pane ai_pane ai2_pane
  local ai="$1"
  local ai2="$2"

  # Use TMUX_PANE for the pane we're running in (stable even if active window changes)
  editor_pane="$TMUX_PANE"

  # Name the current window after the base directory name
  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"

  # Split window vertically - top 85%, bottom 15% (target editor pane explicitly)
  tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"

  # Split editor pane horizontally - AI on right 30% (capture new pane ID directly)
  ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

  # If second AI provided, split the AI pane vertically
  if [[ -n $ai2 ]]; then
    ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux send-keys -t "$ai2_pane" "$ai2" C-m
  fi

  # Run ai in the right pane
  tmux send-keys -t "$ai_pane" "$ai" C-m

  # Run nvim in the left pane
  tmux send-keys -t "$editor_pane" "$EDITOR ." C-m

  # Select the nvim pane for focus
  tmux select-pane -t "$editor_pane"
}

# Create multiple tdl windows with one per subdirectory in the current directory
# Usage: tdlm <c|cx|codex|other_ai> [<second_ai>]
tdlm() {
  [[ -z $1 ]] && { echo "Usage: tdlm <c|cx|codex|other_ai> [<second_ai>]"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdlm."; return 1; }

  local ai="$1"
  local ai2="$2"
  local base_dir="$PWD"
  local first=true

  # Rename the session to the current directory name (replace dots/colons which tmux disallows)
  tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"

  for dir in "$base_dir"/*/; do
    [[ -d $dir ]] || continue
    local dirpath="${dir%/}"

    if $first; then
      # Reuse the current window for the first project
      tmux send-keys -t "$TMUX_PANE" "cd '$dirpath' && tdl $ai $ai2" C-m
      first=false
    else
      local pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
      tmux send-keys -t "$pane_id" "tdl $ai $ai2" C-m
    fi
  done
}

# Create a multi-pane swarm layout with the same command started in each pane (great for AI)
# Usage: tsl <pane_count> <command>
tsl() {
  [[ -z $1 || -z $2 ]] && { echo "Usage: tsl <pane_count> <command>"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tsl."; return 1; }

  local count="$1"
  local cmd="$2"
  local current_dir="${PWD}"
  local -a panes

  tmux rename-window -t "$TMUX_PANE" "$(basename "$current_dir")"

  panes+=("$TMUX_PANE")

  while (( ${#panes[@]} < count )); do
    local new_pane
    local split_target="${panes[-1]}"
    new_pane=$(tmux split-window -h -t "$split_target" -c "$current_dir" -P -F '#{pane_id}')
    panes+=("$new_pane")
    tmux select-layout -t "${panes[0]}" tiled
  done

  for pane in "${panes[@]}"; do
    tmux send-keys -t "$pane" "$cmd" C-m
  done

  tmux select-pane -t "${panes[0]}"
}

# Create a new worktree and branch from within current git directory.
ga() {
  if [[ -z "$1" ]]; then
    echo "Usage: ga [branch name]"
    return 1
  fi

  local branch="$1"
  local base="$(basename "$PWD")"
  local path="../${base}--${branch}"

  git worktree add -b "$branch" "$path"
  mise trust "$path"
  cd "$path"
}

# Remove worktree and branch from within active worktree directory.
gd() {
  if gum confirm "Remove worktree and branch?"; then
    local cwd base branch root worktree

    cwd="$(pwd)"
    worktree="$(basename "$cwd")"

    # split on first `--`
    root="${worktree%%--*}"
    branch="${worktree#*--}"

    # Protect against accidentally nuking a non-worktree directory
    if [[ "$root" != "$worktree" ]]; then
      cd "../$root"
      git worktree remove "$cwd" --force || return 1
      git branch -D "$branch"
    fi
  fi
}

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

# Transcode a video to a good-balance 1080p that's great for sharing online
transcode-video-1080p() {
  ffmpeg -i "$1" -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy "${1%.*}-1080p.mp4"
}

# Transcode a video to a good-balance 4K that's great for sharing online
transcode-video-4K() {
  ffmpeg -i "$1" -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 192k "${1%.*}-optimized.mp4"
}

# Transcode any image to JPG image that's great for shrinking wallpapers
img2jpg() {
  img="$1"
  shift

  magick "$img" "$@" -quality 95 -strip "${img%.*}-converted.jpg"
}

# Transcode any image to a small JPG (max 1080px wide) that's great for sharing online
img2jpg-small() {
  img="$1"
  shift

  magick "$img" "$@" -resize 1080x\> -quality 95 -strip "${img%.*}-small.jpg"
}

# Transcode any image to a medium JPG (max 1800px wide) that's great for sharing online
img2jpg-medium() {
  img="$1"
  shift

  magick "$img" "$@" -resize 1800x\> -quality 95 -strip "${img%.*}-medium.jpg"
}

# Transcode any image to compressed-but-lossless PNG
img2png() {
  img="$1"
  shift

  magick "$img" "$@" -strip -define png:compression-filter=5 \
    -define png:compression-level=9 \
    -define png:compression-strategy=1 \
    -define png:exclude-chunk=all \
    "${img%.*}-optimized.png"
}

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}
