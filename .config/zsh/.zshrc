# ===================
# Environment variables
# ===================

# Shell and editor
export EDITOR=$(which nvim)
export KEYTIMEOUT=1 # Disable lag when using vi-mode

# Custom scripts
export PATH=$PATH:$HOME/bin

# Golang
export GOPATH=$HOME/go
unset GOROOT
export PATH=$PATH:$GOPATH/bin

# Utilities
export FZF_DEFAULT_COMMAND="rg --color=always --no-ignore --hidden --glob '!.git/*' --smart-case --line-number"
export FZF_DEFAULT_OPTS=""
export XDG_CONFIG_HOME="$HOME/.config"
export K9S_CONFIG_DIR="$HOME/.config/k9s"
export BAT_THEME="OneHalfDark" # bat --list-themes
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby@3.1/bin:$PATH"
export PATH="$HOME/.rd/bin:$PATH"

# Docker
export DOCKER_DEFAULT_PLATFORM=linux/amd64
export DOCKER_HOST="unix://$HOME/.rd/docker.sock"

# zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=white,underline"

# ===================
# Settings
# ===================

set histignorespace # ignore command in history if it starts with space
unsetopt share_history # don't share history between sessions
setopt completealiases # perform completions and then expand aliases

# ===================
# Bindings
# ===================

# vi mode
bindkey -v

# Jump forward/backward by one word using ALT + L/R
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# Delete backward by one word or letter using ALT + BCKSP
bindkey '^[^?' backward-kill-word

# Use emacs-like shortcuts with vi-mode
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# ===================
# Sources
# ===================

if command -v fzf &> /dev/null; then
  source <(fzf --zsh)
fi

# https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke:
#   gcloud components install gke-gcloud-auth-plugin
if [ -d "/opt/homebrew/share/google-cloud-sdk" ]; then
  source /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc
  source /opt/homebrew/share/google-cloud-sdk/path.zsh.inc
  export USE_GKE_GCLOUD_AUTH_PLUGIN=True
fi

# Hook direnv into your shell.
# Slow
eval "$(direnv hook zsh)"

# For managing tool version
eval "$(mise activate zsh)"

autoload -U compinit && compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit;
else
  compinit -C;
fi

# ===================
# Functions
# ===================

# Function to work quickly with Tmux sessions
function tm {
  if [ -z "$1" ]; then
    session_name=$(tmux ls -F "#{session_name}" | fzf)
  else
    session_name=$1
  fi

  if ! tmux has-session "${session_name}"; then
    tmux new-session -s "${session_name}"
  fi

  tmux attach -t "${session_name}"
}

# Function to decode base64-encoded values
function decode { echo ${1} | base64 --decode - }

# Check running ports
function port { lsof -i :$1 }

function dns-flush {
  dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}

# Adds a git worktree using the project and branch name
function gwa() {
  local branch_name="${1}"
  local branch_name_escaped="$(echo $branch_name | sed 's;\/;-;g')"
  local location="../${branch_name_escaped}"

  local args=""
  if [ $(git branch --all | grep "remotes/origin/${branch_name}" | wc -l) -eq 0 ]; then
    echo 'Branch does not exist on remote. Checking out a new branch...'
    args="-b"
  fi

  git worktree add ${location} ${args} ${branch_name}
  cd "${location}"
}

# git worktree remove: changes back to the
# default branch directory and removes the PR
# branch directory.
function gwr() {
  local branch_name=$(basename "${PWD}")
  local default_branch_name=$(git default-branch)
  cd ../${default_branch_name}
  git worktree remove "${branch_name}"
  git branch -D "${branch_name}"
}

function koff() {
  unset KUBECONFIG
}

function kon() {
  context=$(ls $HOME/.kube/contexts | fzf)
  export KUBECONFIG=$HOME/.kube/contexts/$context
}

function kcomplete() {
  source <(kubectl completion zsh)
}

function kdelete() {
  contexts=$(ls ~/.kube/contexts | sort)
  context=$(printf "${contexts}\nquit" \
    | fzf --header='Select context to delete')

  if [ "${context}" = "quit" ]; then
    echo 'No context selected, exiting...'
    return
  fi

  echo "deleting $context"
  rm ~/.kube/contexts/$context
}

function krename() {
  context=$(kubectl config current-context)
  read new_name\?"New name for ${context}: "

  echo "renaming $context"
  kubectl config rename-context ${context} ${new_name}
  mv ~/.kube/contexts/${context} ~/.kube/contexts/${new_name}
}

function digg() {
  dig $1 +nocmd +multiline +noall +answer
}

function image-size() {
  compressed=$(skopeo inspect \
    --override-arch=amd64 \
    --override-os=linux \
    docker://$1 \
    | jq '[.LayersData[].Size] | add' \
    | numfmt --to=iec-i --suffix=B --format="%9.2f")

  docker pull $1
  uncompressed=$(docker inspect \
    $1 \
    | jq '.[].Size' \
    | numfmt --to=iec-i --suffix=B --format="%9.2f")

  printf "uncompressed: %s\ncompressed: %s\n" "${uncompressed}" "${compressed}"
}

function ql() {
  qlmanage -p "$@"
}

# ===================
# Aliases
# ===================

alias ll='ls -lahL'
alias t='tree -C -a -I .git'
alias d='docker'
alias dc='docker compose'
alias dr='docker run --rm -it'
alias dr-amd='dr --platform=linux/amd64'
alias de='docker exec -it'
alias g='git'
alias v='nvim'
alias v-changed='nvim $(git dm --name-only)'
alias k='kubectl'
alias kk='k9s --kubeconfig=$HOME/.kube/contexts/$(ls $HOME/.kube/contexts | fzf)'
alias cat='bat'
alias randompw='openssl rand -base64 18'
alias cdd='cd $(find ~/code -maxdepth 4 -type d | sort -u | fzf)'
alias note='(cd /Users/mnielsen/Library/Mobile\ Documents/com~apple~CloudDocs/Obsidian/Notes && nvim .)'
alias rg='rg --column --line-number --no-heading --smart-case --hidden --no-ignore --glob "!.git/*"'
alias code='codium'
alias tf='terraform'

# Python
alias python='python3'
alias python-venv='if [ ! -f ./.venv/bin/activate ]; then echo Creating virtualenv...; uv venv --python=3.11; fi; source .venv/bin/activate'
alias pip='uv pip'

# ===================
# Prompt settings
# ===================

# ZSH helpers
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

setopt HIST_IGNORE_ALL_DUPS # history substring search: ignore dups

zstyle ':completion:*:descriptions' format '%F{blue}%d%f'
# Declare the variable
typeset -A ZSH_HIGHLIGHT_STYLES
# To differentiate aliases from other command types
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
# To have paths colored instead of underlined
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
# To disable highlighting of globbing expressions
ZSH_HIGHLIGHT_STYLES[globbing]='none'

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"
