# ===================
# Environment variables
# ===================

# Shell and editor
export EDITOR=$(which nvim)
export KEYTIMEOUT=1 # Disable lag when using vi-mode

# Utilities
export XDG_CONFIG_HOME="$HOME/.config"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/.ripgreprc"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export K9S_CONFIG_DIR="$HOME/.config/k9s"
export FZF_DEFAULT_COMMAND="rg --ignore-file=${HOME}/.config/ripgrep/.ignore"
export FZF_DEFAULT_OPTS=""
export BAT_THEME="ansi"
export MANPAGER='nvim +Man!'

# For building dependencies
export LDFLAGS="-L/opt/homebrew/opt/openssl/lib -L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl/include -I/opt/homebrew/opt/libpq/include"

# Path entries
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=white,underline"

# Work-specific settings
if [ ! -f "${HOME}/.personal_device_marker" ]; then
  # mcp-router
  export MCPR_TOKEN="$(cat ${HOME}/secret/mcpr-token.txt)"

  # Claude
  export CLAUDE_CONFIG_DIR="$HOME/.config/claude"
  export ANTHROPIC_API_KEY=$(cat "${HOME}/secret/anthropic-api-key.txt")
  export CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1
  export ENABLE_LSP_TOOL=1 # https://karanbansal.in/blog/claude-code-lsp/

  # Docker
  export DOCKER_HOST="unix:///${HOME}/.docker/run/docker.sock"
  export DOCKER_DEFAULT_PLATFORM=linux/amd64

  # MCP servers
  export PAGERDUTY_TOKEN="$(cat ${HOME}/secret/pagerduty-token.txt)"
  export PAGERDUTY_API_KEY="$(cat ${HOME}/secret/pagerduty-token.txt)"
  export LINEAR_API_KEY="$(cat ${HOME}/secret/linear-api-key.txt)"
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

source <(fzf --zsh)

eval "$(direnv hook zsh)"
eval "$(mise activate zsh)"

# Lazy-load thefuck: only initialize when first called
fuck() {
  unfunction fuck
  eval "$(thefuck --alias)"
  fuck "$@"
}

# Load compinit early with -C (skip security checks) so gcloud doesn't re-init
autoload -Uz compinit && compinit -C -d "${ZDOTDIR:-$HOME}/.zcompdump"

# https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke:
#   gcloud components install gke-gcloud-auth-plugin
if [ -d "$HOME/.local/share/mise/installs/gcloud/latest" ]; then
  source "$HOME/.local/share/mise/installs/gcloud/latest/completion.zsh.inc" # enable shell command completion for gcloud.
  source "$HOME/.local/share/mise/installs/gcloud/latest/path.zsh.inc" # add the Google Cloud SDK command line tools to your $PATH.
  export USE_GKE_GCLOUD_AUTH_PLUGIN=True
  export GCLOUD_SOURCED=True
fi

# Load completions for mise-managed tools, then map aliases
source <(kubectl completion zsh)
source <(docker completion zsh)
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

eval "$(starship init zsh)"
