# File system
alias ls "eza -lh --group-directories-first --icons=auto"
alias la "eza -a --group-directories-first --icons=auto"
alias lsa "ls -a"
alias lt "eza --tree --level=2 --long --icons --git"
alias lta "lt -a"
alias tree "eza --tree --level=2 --long --icons --git"
alias cat "bat --paging=never"
alias grep rg
alias find fd

# Directories
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."

# Tools
alias c opencode
alias cx 'printf "\033[2J\033[3J\033[H" && claude --permission-mode bypassPermissions'
alias d docker
alias r rails
alias i "tdl c"
alias vim="nvim"

# Git
alias g git
alias gst "git status -sb"
alias gl "git log --oneline --graph --decorate --all"
alias gco "git switch"
alias gsw "git switch"
alias gp "git pull --rebase"
alias gpush "git push"
alias gcm "git commit -m"
alias gcam "git commit -a -m"
alias gcad "git commit -a --amend"
alias lg lazygit

# nix helpers
alias hmr "nix run ~/nix#hm.grae.activationPackage"
