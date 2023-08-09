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
export PATH=$PATH:$GOPATH/bin

# Utilities
export FZF_DEFAULT_COMMAND='rg --color=always --no-ignore --hidden --glob "!.git/*" --smart-case --line-number'
export XDG_CONFIG_HOME="$HOME/.config"
export BAT_THEME="Nord" # bat --list-themes
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"

# Kubernetes
# Disable default connection to cluster
# - reconnect with `kon`
# - disconnect with `koff`
unset KUBECONFIG

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

eval "$(rtx activate --quiet -s zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Gcloud (https://cloud.google.com/sdk/docs/install)
if [ -d ~/google-cloud-sdk ]; then
  source ~/google-cloud-sdk/path.zsh.inc
  source ~/google-cloud-sdk/completion.zsh.inc
  # https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
  # gcloud components install gke-gcloud-auth-plugin
  export USE_GKE_GCLOUD_AUTH_PLUGIN=True
fi

# Hook direnv into your shell.
# Slow
# eval "$(direnv hook zsh)"

# kubectl completion
# Slow
# source <(kubectl completion zsh)

# Switch kubernetes contexts
source ~/.kubech/kubech

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

function gwr() {
  local branch_name=$(basename "${PWD}")
  cd ../master || cd ../main
  git worktree remove "${branch_name}"
}

function koff() {
  kubechu
  source "$HOME/.config/zsh/.zshrc"
}

function kon() {
  koff > /dev/null

  CLUSTER=$(yq '.contexts[].name' ~/.kube/config | fzf)
  kubechc "${CLUSTER}" > /dev/null

  kubens
  NAMESPACE=$(kubens --current)

  export PS1="
[cluster: %F{green}${CLUSTER}:${NAMESPACE}]$PS1"
}

function digg() {
  dig $1 +nocmd +multiline +noall +answer
}

function image-size() {
  skopeo inspect docker://$1 | jq '[.LayersData[].Size] | add'
}

function gcloud-inventory() {
  gcloud asset search-all-resources --scope=projects/mnielsen-2e27a441 | grep assetType | sort | uniq -c | sort -nr
}

# ===================
# Aliases
# ===================

alias t='tree -C -a -I .git'
alias d='docker'
alias dr='docker run --platform=linux/amd64 --rm -it'
alias de='docker exec -it'
alias docker-start='colima start --cpu 4 --memory 16 --disk 40 --profile docker'
alias docker-ip='colima list --profile=docker --json | jq -r .address'
alias docker-stop='colima stop docker'
alias kubernetes-start='docker-start --kubernetes --profile k8s'
alias g='git'
alias v='nvim'
alias v-changed='nvim $(git dm --name-only)'
alias k='kubectl'
alias kk='k9s --crumbsless --headless --logoless'
# https://docs.gitlab.com/ee/development/documentation/#local-linting
alias vale-docker='dr -v $PWD:/test -w /test registry.gitlab.com/gitlab-org/gitlab-docs/lint-markdown:alpine-3.15-vale-2.15.5-markdownlint-0.31.1 vale --minAlertLevel error doc'
alias markdownlint-docker='dr -v $PWD:/test -w /test registry.gitlab.com/gitlab-org/gitlab-docs/lint-markdown:alpine-3.15-vale-2.15.5-markdownlint-0.31.1 markdownlint --config .markdownlint.yml "doc/**/*.md"'
alias cat='bat'
alias randompw='openssl rand -base64 18'
alias ht='helm template test . -f build/test.values.yaml --set certmanager-issuer.email=no@no.com'
alias htd='ht --debug'
alias hk='helm upgrade --install --set certmanager-issuer.email=no@no.com gitlab . -n default -f examples/kind/values-base.yaml -f examples/kind/values-ssl.yaml -f build/test.values.yaml --set global.hosts.domain=$(ipconfig getifaddr en0).nip.io'
alias cdd='cd $(rg --hidden --files --null --maxdepth 4 ~/code | xargs -0 dirname | sort -u | fzf)'
alias cdo='cd ~/code/gitlab-org/cloud-native/gitlab-operator/master'
alias cdc='cd ~/code/gitlab-org/charts/gitlab/master'
alias cdcng='cd ~/code/gitlab-org/build/cng/master'
alias note='(cd /Users/mnielsen/Library/Mobile\ Documents/com~apple~CloudDocs/Obsidian/Notes && nvim Home.md)'
alias rg='rg --column --line-number --no-heading --smart-case --hidden --no-ignore --glob "!.git/*"'

# format is op://vault-name/item-name/[section-name/]field-name
alias op-gl='op --account gitlab.1password.com'
alias aws-sandbox="op-gl run --env-file=$HOME/.config/op/aws-sandbox-env -- aws"
alias eksctl-sandbox="op-gl run --env-file=$HOME/.config/op/aws-sandbox-env -- eksctl"
alias glab="op-gl run --env-file=$HOME/.config/op/gitlab-pat -- glab"

# ===================
# Prompt settings
# ===================

function git_prompt() {
  BRANCH=$(git branch --show-current 2> /dev/null)

  if [ ! -z $BRANCH ]; then
    echo -n "%F{magenta}[branch: $BRANCH]"

    if [ ! -z "$(git status --short)" ]; then
      echo " %F{yellow}[✗]"
    fi
  fi
}

STATUS="%(?.%F{green}$.%F{red}%?)%f"
DIR="%~"
PS1="
%F{blue}${DIR} \$(git_prompt)
${STATUS} %F{reset}"
setopt promptsubst

# ZSH helpers
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Prompt
source "${XDG_CONFIG_HOME}/zsh/prompt.sh"
