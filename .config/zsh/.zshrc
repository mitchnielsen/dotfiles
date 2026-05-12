# ===================
# Environment variables
# ===================

# Shell and editor
export EDITOR=$(which nvim)
export KEYTIMEOUT=1 # Disable lag when using vi-mode

# Utilities
export XDG_CONFIG_HOME="$HOME/.config"
export CODEX_HOME="$XDG_CONFIG_HOME/codex"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/.ripgreprc"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export K9S_CONFIG_DIR="$HOME/.config/k9s"
export FZF_DEFAULT_COMMAND="rg --ignore-file=${HOME}/.config/ripgrep/.ignore"
# clarity theme for fzf — palette follows macOS appearance at shell startup.
# Helper paints explicit hex (not -1 / ANSI slots) because tmux caches its
# resolved default-bg at server startup, so popups won't track an appearance
# change without an explicit fzf bg.
source "${HOME}/dotfiles/bin/fzf-clarity-opts"
export BAT_THEME="ansi"
export MANPAGER='nvim +Man!'

# For building dependencies
export LDFLAGS="-L/opt/homebrew/opt/openssl/lib -L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl/include -I/opt/homebrew/opt/libpq/include"

# Path entries
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
source "/opt/homebrew/share/google-cloud-sdk/path.zsh.inc"

# zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=white,underline"

# Work-specific settings
if [ ! -f "${HOME}/.personal_device_marker" ]; then
  # Claude
  export CLAUDE_CONFIG_DIR="$HOME/.config/claude"
  export CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1
  export ENABLE_LSP_TOOL=1 # https://karanbansal.in/blog/claude-code-lsp/
  # export CLAUDE_CODE_DISABLE_TERMINAL_TITLE=1

  # Docker
  export DOCKER_HOST="unix://${HOME}/.docker/run/docker.sock"
  export DOCKER_DEFAULT_PLATFORM=linux/amd64

  # 1Password environment variables (refresh with `op-env-refresh`)
  if [ -d "${HOME}/.config/op-env" ]; then
    set -a
    for _openv in "${HOME}"/.config/op-env/*.env(N); do
      source "$_openv"
    done
    unset _openv
    set +a
  fi
fi

# ===================
# Settings
# ===================

setopt histignorespace # ignore command in history if it starts with space
setopt hist_ignore_dups # dont save duplicate entries in history
unsetopt completealiases # let zsh expand aliases before completing
setopt hist_verify # ask for verification when recalling from history
unsetopt share_history # don't share history between sessions
unsetopt beep # never beep

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

# FZF widgets
bindkey '^T' fzf-file-widget
bindkey '^G' fzf-cd-widget

# Use emacs-like shortcuts with vi-mode
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# ===================
# Sources
# ===================

source "${HOME}/.config/zsh/functions.sh"
source "${HOME}/.config/zsh/aliases.sh"

# Cache subprocess shell-init output. Each generator forks a process and pays
# import/parse cost; caching turns ~hundreds of ms (cold) into a few file reads.
# Cache invalidates when the source binary is newer than the cached file.
# Run `zsh-init-cache-clear` to force regeneration.
ZSH_INIT_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/init"
ZSH_INIT_CACHE_MAX_AGE_SECONDS=86400
[[ -d $ZSH_INIT_CACHE_DIR ]] || mkdir -p "$ZSH_INIT_CACHE_DIR"
zmodload zsh/stat zsh/datetime

# _cached_eval <name> <binary-to-stat> <command...>
# Regenerates when: cache missing/empty, source binary newer, or cache >24h old.
_cached_eval() {
  local name=$1 bin=$2; shift 2
  local cache="$ZSH_INIT_CACHE_DIR/$name.zsh"
  local stale=0
  if [[ ! -s $cache || $bin -nt $cache ]]; then
    stale=1
  else
    local mtime=$(zstat -L +mtime -- "$cache" 2>/dev/null)
    (( EPOCHSECONDS - mtime > ZSH_INIT_CACHE_MAX_AGE_SECONDS )) && stale=1
  fi
  (( stale )) && "$@" > "$cache"
  source "$cache"
}

zsh-init-cache-clear() { rm -f "$ZSH_INIT_CACHE_DIR"/*.zsh; print "cleared $ZSH_INIT_CACHE_DIR"; }

_cached_eval fzf     /opt/homebrew/bin/fzf      fzf --zsh
_cached_eval direnv  /opt/homebrew/bin/direnv   direnv hook zsh
_cached_eval mise    /opt/homebrew/bin/mise     mise activate zsh
_cached_eval wt      /opt/homebrew/bin/wt       wt config shell init zsh

# Lazy thefuck: defining the alias requires running a Python interpreter, which
# is the heaviest single eval in this file. Defer it until first use.
fuck() {
  unfunction fuck
  eval "$(thefuck --alias)"
  fuck "$@"
}

# Load compinit early with -C (skip security checks) so gcloud doesn't re-init
autoload -Uz compinit && compinit -C -d "${ZDOTDIR:-$HOME}/.zcompdump"

# Lazy gcloud completion: heavy source file, only needed on first `gcloud <tab>`.
# https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke:
#   gcloud components install gke-gcloud-auth-plugin
_load_gcloud_completion() {
  unfunction _load_gcloud_completion gcloud 2>/dev/null
  source "/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc"
}
gcloud() { _load_gcloud_completion; gcloud "$@"; }
# Trigger load on first completion attempt as well.
compdef _load_gcloud_completion gcloud
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export GCLOUD_SOURCED=True

# Load completions, then map aliases
# source <(kubectl completion zsh)
# source <(docker completion zsh)
compdef g=git
compdef k=kubectl
compdef d=docker

# ===================
# Prompt settings
# ===================

# ZSH helpers
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# disable cursor style changes, just use the block
ZVM_CURSOR_STYLE_ENABLED=false
source /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source /opt/homebrew/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh
zstyle ':fzf-tab:*' use-fzf-default-opts yes

setopt HIST_IGNORE_ALL_DUPS # history substring search: ignore dups

typeset -A ZSH_HIGHLIGHT_STYLES
# To differentiate aliases from other command types
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
# To have paths colored instead of underlined
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
# To disable highlighting of globbing expressions
ZSH_HIGHLIGHT_STYLES[globbing]='none'

_cached_eval starship /opt/homebrew/bin/starship starship init zsh
