# ===================
# Environment variables
# ===================

# Shell and editor
export EDITOR=$(which nvim)
export KEYTIMEOUT=1 # Disable lag when using vi-mode

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Utilities
export FZF_DEFAULT_COMMAND='rg --color=always --files --no-ignore-vcs --hidden --follow --glob "!.git/*" --smart-case --line-number'
export XDG_CONFIG_HOME="$HOME/.config"
export BAT_THEME="Nord" # bat --list-themes
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# ===================
# ZSH plugins
# ===================

plugins=(
  fzf
  vi-mode
)
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# ===================
# Settings
# ===================

set histignorespace # ignore command in history if it starts with space
unsetopt share_history # don't share history between sessions

# ===================
# Bindings
# ===================

# Jump forward/backward by one word using ALT + L/R
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# ===================
# Sources
# ===================

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.zsh/you-should-use/you-should-use.plugin.zsh

[[ -f "$HOME/.asdf/asdf.sh" ]] && source "$HOME/.asdf/asdf.sh"
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# Gcloud (https://cloud.google.com/sdk/docs/install)
if [[ -d "$HOME/google-cloud-sdk" ]]; then
  source "$HOME/google-cloud-sdk/path.zsh.inc"
  source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# Hook direnv into your shell.
eval "$(direnv hook zsh)"

# kubectl completion
source <(kubectl completion zsh)

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit;
else
  compinit -C;
fi

# ===================
# Functions
# ===================

# A shortcut for asdf managed direnv.
direnv() { asdf exec direnv "$@"; }

# Function to list Helm release Ci info
function helm-ls-ci { helm ls | awk '/^gke-/{print $1}'| xargs -I'{}' sh -c "helm get values {} | yq r - .ci" }

# Function to get CI pipeline URL and copy it to clipboard
function helm-ci-url { helm get values $1 | yq r - ci.pipeline.url | pbcopy }

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

# Test Omnibus changes
# Dockerfile in ~/code/gitlab-org/omnibus-local-image
function testOmnibus {
  docker run -it --name=omnibus-local -p 80:80 \
    -v $(PWD)/files/gitlab-ctl-commands:/opt/gitlab/embedded/service/omnibus-ctl \
    -v $(PWD)/files/gitlab-ctl-commands-ee:/opt/gitlab/embedded/service/omnibus-ctl-ee \
    omnibus:local
}

function stopOmnibus {
  docker stop omnibus-local
  docker rm omnibus-local
}

# Adds a git worktree using the project and branch name
function gwa() {
  local branch_name="${1}"
  local location="../${branch_name}"

  local args=""
  if [ $(git branch --all | grep "remotes/origin/${branch_name}" | wc -l) -eq 0 ]; then
    echo 'Branch does not exist on remote. Checking out a new branch...'
    args="-b"
  fi

  git worktree add ${location} ${args} ${branch_name}
  cd "${location}"
}

function gwr() {
  local branch_name=$(basename "${PWD}")
  cd ../master
  git worktree remove "${branch_name}"
}

# https://docs.gitlab.com/ee/user/project/push_options.html
function gpsc() {
  local remote=origin

  if git remote get-url $remote | grep gitlab.com >/dev/null; then
    git push --set-upstream $remote "$(git_current_branch)" \
      -o merge_request.create \
      -o "merge_request.target=master" \
      -o "merge_request.assign=mnielsen" \
      -o "merge_request.label=group::distribution" \
      -o "merge_request.label=section::enablement" \
      -o "merge_request.label=devops::enablement"
  else
    git push --set-upstream $remote "$(git_current_branch)"
  fi
}

# ===================
# Aliases
# ===================

alias t='tree -C -a -I .git'
alias d='docker'
alias dr='docker run --rm -it'
alias de='docker exec -it'
alias docker-start='colima start --cpu 4 --memory 16 --disk 40 --profile docker'
alias kubernetes-start='docker-start --kubernetes --profile k8s'
alias g='git'
alias gs='git status'
alias gc='git commit'
alias gd='git diff'
alias gds='git diff --staged'
alias gdm='git diff --name-only $(git merge-base HEAD master)'
alias gl='git log --all --graph --decorate --oneline --simplify-by-decoration'
alias gpl='git pull origin $(git_current_branch)'
alias gplm='git fetch origin && git pull origin master'
alias gf='git fetch --all'
alias gps='git push origin $(git_current_branch)'
alias gwp='git worktree prune'
alias v='nvim'
alias k='kubectl'
alias kk='k9s --crumbsless --headless --logoless'
# https://docs.gitlab.com/ee/development/documentation/#local-linting
alias vale='dr -v $PWD:/test -w /test registry.gitlab.com/gitlab-org/gitlab-docs/lint-markdown:alpine-3.15-vale-2.15.5-markdownlint-0.31.1 vale --minAlertLevel error doc'
alias markdownlint='dr -v $PWD:/test -w /test registry.gitlab.com/gitlab-org/gitlab-docs/lint-markdown:alpine-3.15-vale-2.15.5-markdownlint-0.31.1 markdownlint --config .markdownlint.yml "doc/**/*.md"'
alias cat='bat'
alias randompw='openssl rand -base64 18'
alias ht='helm template test . -f build/test.values.yaml --set certmanager-issuer.email=no@no.com'
alias htd='ht --debug'
alias hk='helm upgrade --install --set certmanager-issuer.email=no@no.com gitlab . -n default -f examples/kind/values-base.yaml -f examples/kind/values-ssl.yaml -f build/test.values.yaml --set global.hosts.domain=192.168.33.10.nip.io'
alias cdd='cd $(rg --hidden --files --null --maxdepth 4 ~/code | xargs -0 dirname | sort -u | fzf)'
alias cdo='cd ~/code/gitlab-org/cloud-native/gitlab-operator'
alias cdc='cd ~/code/gitlab-org/charts/gitlab'
alias note='(cd /Users/mnielsen/Library/Mobile Documents/com~apple~CloudDocs && nvim Dashboard.md)'

# ===================
# Cursor settings
# ===================

# Change cursor with support for inside/outside tmux
# https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim
# https://superuser.com/questions/685005/tmux-in-zsh-with-vi-mode-toggle-cursor-shape-between-normal-and-insert-mode
_fix_cursor() { echo -ne '\e[5 q' }
precmd_functions+=(_fix_cursor)

# ===================
# Starship prompt
# ===================
eval "$(starship init zsh)"
