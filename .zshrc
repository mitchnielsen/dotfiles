export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:$HOME/bin"
export PATH="$HOME/.vimpkg/bin:$PATH"
export PATH="$HOME/Library/Python/3.7/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/opt/postgresql@11/bin:$PATH"
export PATH="/usr/local/opt/node@12/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig:$PKG_CONFIG_PATH"
export ZSH="$HOME/.oh-my-zsh"
export FZF_BASE=$(which fzf)
export KEYTIMEOUT=1 # Disable lag when using vi-mode
export EDITOR=$(which nvim)
export NNN_USE_EDITOR=1
export NNN_TRASH=1
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""' # include hidden files
export XDG_CONFIG_HOME="$HOME/.config"
export GOPATH=$HOME/go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export BAT_THEME="base16"

# ZSH sourcing and initialization
plugins=(
  fzf
  vi-mode
)

source $ZSH/oh-my-zsh.sh
source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit;
else
  compinit -C;
fi

autoload -U promptinit; promptinit
export ZSH_THEME=""
zstyle :prompt:pure:git:stash show yes
prompt pure

source ~/.fzf.zsh
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Stern
source <(stern --completion=zsh)

# kubectl
source <(kubectl completion zsh)

# Gcloud
source "$HOME/google-cloud-sdk/path.zsh.inc"
source "$HOME/google-cloud-sdk/completion.zsh.inc"

# zsh-history-substring-search
bindkey -e
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

# Take notes
function note { nvim ~/notes.md }

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
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias h='cd ~ && clear'
alias c='clear'
alias v='nvim'
alias f='nnn'
alias k='kubectl'
alias kk='k9s'
alias watch='watch --color'
# https://docs.gitlab.com/ee/development/documentation/#local-linting
alias valee="vale --glob='*.{md}' doc"
alias markdownlintt="markdownlint -c .markdownlint.json 'doc/**/*.md'"
alias tf='terraform'
alias stopPG='sudo -u postgres pg_ctl -D /Library/PostgreSQL/11/data stop'
alias startPG='/usr/local/opt/postgresql@11/bin/pg_ctl -D /Users/mitchellnielsen/code/gitlab-development-kit/postgresql/data -l logfile start'
alias cat='bat'
alias rg="rg --hidden --glob '!.git'"
alias randompw='openssl rand -base64 18'
alias tks='tmux kill-session -t'
alias ht='helm template test . -f test.values.yaml --set certmanager-issuer.email=no@no.com | less'
alias hk='helm upgrade --install --set certmanager-issuer.email=no@no.com gitlab . -n default -f test.values.yaml -f examples/kind/values-base.yaml -f examples/kind/values-ssl.yaml --set global.hosts.domain=$(ipconfig getifaddr en0).nip.io'
