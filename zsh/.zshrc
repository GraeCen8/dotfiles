# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zsh + Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git colored-man-pages command-not-found sudo extract zsh-autosuggestions zsh-completions fzf-tab zsh-syntax-highlighting)

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=32768
SAVEHIST=$HISTSIZE
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INTERACTIVE_COMMENTS

# Load Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# Prompt
[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# Better completion UX
zstyle ':completion:*' menu select
zstyle ':completion:*:*:commands' ignored-patterns 'omarchy-*'

# fzf
if [[ -r /usr/share/fzf/completion.zsh ]]; then
  source /usr/share/fzf/completion.zsh
fi
if [[ -r /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --no-cmd)"
fi

# File system
if command -v eza >/dev/null 2>&1; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias ll='eza -lh --group-directories-first --icons=auto'
  alias la='eza -a --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
  alias tree='eza --tree --level=2 --long --icons --git'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi

if command -v rg >/dev/null 2>&1; then
  alias grep='rg'
fi

if command -v fd >/dev/null 2>&1; then
  alias find='fd'
fi

v() {
  "${EDITOR:-nvim}" "$@"
}

ff() {
  if [[ "${TERM:-}" == xterm-kitty ]] && command -v kitty >/dev/null 2>&1; then
    fzf --preview 'case $(file --mime-type -b {}) in image/*) kitty icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {} ;; *) bat --style=numbers --color=always {} ;; esac'
  else
    fzf --preview 'bat --style=numbers --color=always {}'
  fi
}

eff() {
  "${EDITOR:-nvim}" "$(ff)"
}

sff() {
  if (( $# == 0 )); then
    print -r -- 'Usage: sff <destination> (e.g. sff host:/tmp/)'
    return 1
  fi
  local file
  file=$(command find . -type f -printf '%T@\t%p\n' | sort -rn | cut -f2- | ff) && [[ -n $file ]] && scp "$file" "$1"
}

# zoxide wrappers
z() { __zoxide_z "$@"; }
zi() { __zoxide_zi "$@"; }
zd() {
  if (( $# == 0 )); then
    builtin cd ~ || return
  elif [[ -d $1 ]]; then
    builtin cd "$1" || return
  else
    if ! z "$@"; then
      print -r -- 'Error: Directory not found'
      return 1
    fi
    printf '\U000F17A9 '
    pwd
  fi
}
cd() { zd "$@"; }

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
alias c='opencode'
alias cx='printf "\033[2J\033[3J\033[H" && claude --permission-mode bypassPermissions'
alias d='docker'
alias r='rails'
alias t='tmux attach || tmux new -s Work'
alias ic='tdl c'
alias ix='tdl cx'
alias icx='tdl c cx'
alias vim='nvim'

# Git
alias g='git'
alias gst='git status -sb'
alias gl='git log --oneline --graph --decorate --all'
alias gco='git switch'
alias gsw='git switch'
alias gp='git pull --rebase'
alias gpush='git push'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
alias lg='lazygit'

# Editor helper
n() {
  if [[ $# -eq 0 ]]; then
    command nvim .
  else
    command nvim "$@"
  fi
}

open() {
  xdg-open "$@" >/dev/null 2>&1 &
}

compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress='tar -xzf'

# SSH Port Forwarding Functions
fip() {
  (( $# < 2 )) && print -r -- 'Usage: fip <host> <port1> [port2] ...' && return 1
  local host="$1"
  shift
  for port in "$@"; do
    ssh -f -N -L "$port:localhost:$port" "$host" && print -r -- "Forwarding localhost:$port -> $host:$port"
  done
}

dip() {
  (( $# == 0 )) && print -r -- 'Usage: dip <port1> [port2] ...' && return 1
  for port in "$@"; do
    pkill -f "ssh.*-L $port:localhost:$port" && print -r -- "Stopped forwarding port $port" || print -r -- "No forwarding on port $port"
  done
}

lip() {
  pgrep -af "ssh.*-L [0-9]+:localhost:[0-9]+" || print -r -- 'No active forwards'
}

# Drive helpers
iso2sd() {
  if (( $# < 1 )); then
    print -r -- 'Usage: iso2sd <input_file> [output_device]'
    print -r -- 'Example: iso2sd ~/Downloads/ubuntu-25.04-desktop-amd64.iso /dev/sda'
    print -r -- ''
    print -r -- 'Available SD drives:'
    lsblk -dpno NAME | command grep -E '/dev/sd' || true
    return 1
  fi

  local iso="$1"
  local drive="$2"

  if [[ -z $drive ]]; then
    local available_sds
    available_sds=$(lsblk -dpno NAME | command grep -E '/dev/sd')

    if [[ -z $available_sds ]]; then
      print -r -- 'No SD drives found and no drive specified'
      return 1
    fi

    drive=$(omarchy-drive-select "$available_sds")

    if [[ -z $drive ]]; then
      print -r -- 'No drive selected'
      return 1
    fi
  fi

  sudo dd bs=4M status=progress oflag=sync if="$iso" of="$drive"
  sudo eject "$drive"
}

format-drive() {
  if (( $# != 2 )); then
    print -r -- 'Usage: format-drive <device> <name>'
    print -r -- "Example: format-drive /dev/sda 'My Stuff'"
    print -r -- ''
    print -r -- 'Available drives:'
    lsblk -d -o NAME -n | awk '{print "/dev/"$1}'
    return 1
  fi

  print -r -- "WARNING: This will completely erase all data on $1 and label it '$2'."
  printf 'Are you sure you want to continue? (y/N): '
  local confirm
  read -r confirm

  if [[ $confirm == [Yy]* ]]; then
    sudo wipefs -a "$1"
    sudo dd if=/dev/zero of="$1" bs=1M count=100 status=progress
    sudo parted -s "$1" mklabel gpt
    sudo parted -s "$1" mkpart primary 1MiB 100%
    sudo parted -s "$1" set 1 msftdata on

    local partition
    partition="$([[ $1 == *nvme* ]] && print -r -- "${1}p1" || print -r -- "${1}1")"
    sudo partprobe "$1" || true
    sudo udevadm settle || true

    sudo mkfs.exfat -n "$2" "$partition"

    print -r -- "Drive $1 formatted as exFAT and labeled '$2'."
  fi
}

# Tmux helpers
# Create a Tmux Dev Layout with editor, ai, and terminal
# Usage: tdl <c|cx|codex|other_ai> [<second_ai>]
tdl() {
  [[ -z $1 ]] && { print -r -- 'Usage: tdl <c|cx|codex|other_ai> [<second_ai>]' ; return 1; }
  [[ -z $TMUX ]] && { print -r -- 'You must start tmux to use tdl.'; return 1; }

  local current_dir="$PWD"
  local editor_pane ai_pane ai2_pane
  local ai="$1"
  local ai2="$2"

  editor_pane="$TMUX_PANE"
  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"
  tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"
  ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

  if [[ -n $ai2 ]]; then
    ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux send-keys -t "$ai2_pane" "$ai2" C-m
  fi

  tmux send-keys -t "$ai_pane" "$ai" C-m
  tmux send-keys -t "$editor_pane" "$EDITOR ." C-m
  tmux select-pane -t "$editor_pane"
}

# Create multiple tdl windows with one per subdirectory in the current directory
# Usage: tdlm <c|cx|codex|other_ai> [<second_ai>]
tdlm() {
  [[ -z $1 ]] && { print -r -- 'Usage: tdlm <c|cx|codex|other_ai> [<second_ai>]' ; return 1; }
  [[ -z $TMUX ]] && { print -r -- 'You must start tmux to use tdlm.'; return 1; }

  local ai="$1"
  local ai2="$2"
  local base_dir="$PWD"
  local first=true

  tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"

  for dir in "$base_dir"/*/; do
    [[ -d $dir ]] || continue
    local dirpath="${dir%/}"

    if $first; then
      tmux send-keys -t "$TMUX_PANE" "cd '$dirpath' && tdl $ai $ai2" C-m
      first=false
    else
      local pane_id
      pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
      tmux send-keys -t "$pane_id" "tdl $ai $ai2" C-m
    fi
  done
}

# Create a multi-pane swarm layout with the same command started in each pane (great for AI)
# Usage: tsl <pane_count> <command>
tsl() {
  [[ -z $1 || -z $2 ]] && { print -r -- 'Usage: tsl <pane_count> <command>' ; return 1; }
  [[ -z $TMUX ]] && { print -r -- 'You must start tmux to use tsl.'; return 1; }

  local count="$1"
  local cmd="$2"
  local current_dir="$PWD"
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

# Transcoding helpers have moved to omarchy-transcode.
transcode-video-1080p() { omarchy-transcode "$1" mp4 1080p; }
transcode-video-4K() { omarchy-transcode "$1" mp4 4k; }
transcode-video-gif() { omarchy-transcode "$1" gif 1080p; }
img2jpg() { omarchy-transcode "$1" jpg high; }
img2jpg-small() { omarchy-transcode "$1" jpg low; }
img2jpg-medium() { omarchy-transcode "$1" jpg medium; }
img2jpg-large() { omarchy-transcode "$1" jpg high; }
img2png() { omarchy-transcode "$1" png high; }

# omarchy completion
_omarchy() {
  local cur prefix omarchy_path bin_dir file basename rest next
  local -a candidates
  local -A seen

  cur=${words[CURRENT]}

  omarchy_path=$(command -v omarchy 2>/dev/null) || return 0
  bin_dir=${omarchy_path:h}
  [[ -d $bin_dir ]] || return 0

  prefix=omarchy
  local i part
  for (( i = 2; i < CURRENT; i++ )); do
    part=${words[i]}
    [[ -z $part || $part == -* ]] && continue
    prefix+="-$part"
  done

  setopt local_options null_glob
  for file in "$bin_dir/$prefix"-*; do
    [[ -f $file && -x $file ]] || continue
    basename=${file:t}
    rest=${basename#${prefix}-}
    next=${rest%%-*}
    if [[ -n $next && -z ${seen[$next]-} ]]; then
      seen[$next]=1
      candidates+=("$next")
    fi
  done

  if (( CURRENT == 2 )); then
    candidates+=(commands)
  fi

  if [[ ${words[2]-} == commands ]] && (( CURRENT >= 3 )); then
    candidates+=(--all --json --markdown --check)
  fi

  if (( ${#candidates} == 0 )) && [[ -x $bin_dir/$prefix ]]; then
    local args enum
    args=$(command grep -m 1 '^# omarchy:args=<' "$bin_dir/$prefix" 2>/dev/null)
    enum=${args#*<}
    enum=${enum%%>*}

    if [[ $enum == *'|'* && $enum != *' '* ]]; then
      candidates=(${(s:|:)enum})
    fi
  fi

  (( ${#candidates} )) && compadd -- "${candidates[@]}"
}

compdef _omarchy omarchy

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/dotfiles/zsh/.p10k.zsh ]] || source ~/dotfiles/zsh/.p10k.zsh
