export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin"
export PATH="$HOME/.vimpkg/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export KEYTIMEOUT=1 # Disable lag when using vi-mode
export EDITOR=$(which nvim)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden --follow --glob "!.git/*"'
export XDG_CONFIG_HOME="$HOME/.config"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export BAT_THEME="gruvbox-dark" # bat --list-themes
export PURE_PROMPT_SYMBOL="$"

# ZSH sourcing and initialization
plugins=(
  fzf
  vi-mode
)

source $ZSH/oh-my-zsh.sh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
export ZSH_THEME=""
zstyle :prompt:pure:git:stash show yes
prompt pure

[[ -r "$HOME/.asdf/asdf.sh" ]] && source "$HOME/.asdf/asdf.sh"
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# Gcloud (https://cloud.google.com/sdk/docs/install)
if [[ -d "$HOME/google-cloud-sdk" ]]; then
  source "$HOME/google-cloud-sdk/path.zsh.inc"
  source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

eval "$(direnv hook zsh)"

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit;
else
  compinit -C;
fi

# zsh-history-substring-search
bindkey -v
bindkey \^u backward-kill-line

set histignorespace # ignore command in history if it starts with space
unsetopt share_history # don't share history between sessions

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

# Function to delete feature branch and update trunk
function gitDone {
  git checkout master
  FEATURE_BRANCH=$(git rev-parse --abbrev-ref @{-1})
  echo "Feature branch was ${FEATURE_BRANCH//heads\/}, deleting and pulling master..."
  git branch -D ${FEATURE_BRANCH//heads\/}
  git pull origin master
}

# Function to decode base64-encoded values
function decode {
  result=$(echo ${1} | base64 -D -)
  printf '\nResult is: %s\nResult copied to clipboard.\n' ${result}
}

# Check running ports
function port { lsof -i :$1 }

# SSH to gcloud instance
function gssh {
  gcloud beta compute ssh --zone "us-east1-b" --project "cloud-native-182609" "$1"
}

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

# Aliases
alias t='tree -C -a -I .git'
alias d='docker'
alias dr='docker run --rm -it'
alias de='docker exec -it'
alias g='git'
alias gs='git status'
alias gc='git commit'
alias gd='git diff'
alias gl='git log --all --graph --decorate --oneline --simplify-by-decoration'
alias gpom='git pull origin master'
alias gpof='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias gitRefreshTags="git remote update origin --prune"
alias gitFilesChanged='git diff --name-only $(git merge-base origin/master HEAD)'
alias gwa='git worktree add'
alias gwp='git worktree prune'
alias v='nvim'
alias k='kubectl'
# https://docs.gitlab.com/ee/development/documentation/#local-linting
alias valee="vale --glob='*.{md}' doc"
alias markdownlintt="markdownlint -c .markdownlint.json 'doc/**/*.md'"
alias cat='bat'
alias rg="rg --hidden --glob '!.git/*'"
alias randompw='openssl rand -base64 18'
alias ht='helm template test . -f build/test.values.yaml --set certmanager-issuer.email=no@no.com | less'
alias htd='helm template test . -f build/test.values.yaml --set certmanager-issuer.email=no@no.com --debug | less'
alias hk='helm upgrade --install --set certmanager-issuer.email=no@no.com gitlab . -n default -f examples/kind/values-base.yaml -f examples/kind/values-ssl.yaml -f build/test.values.yaml --set global.hosts.domain=$(hostname -i).nip.io'
alias cdd='cd $(rg --hidden --files --null ~/code/gitlab-org | xargs -0 dirname | sort -u | fzf)'
alias cdo='cd ~/code/gitlab-org/cloud-native/gitlab-operator'
alias cdc='cd ~/code/gitlab-org/charts/gitlab'
