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
export BAT_THEME="Nord"
export MANPAGER='nvim +Man!'

# For building dependencies
export LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix libpq)/lib"
export CPPFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix libpq)/include"

# Claude
export ANTHROPIC_API_KEY=$(cat "${HOME}/secret/anthropic-api-key.txt")
export CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1
export DISABLE_AUTOUPDATER=1 # update via homebrew

# Codex
export CODEX_HOME="${HOME}/.config/codex"

# Path entries
export PATH=$PATH:$HOME/bin
export PATH="$HOME/.rd/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby@3.1/bin:$PATH"

# Docker
export DOCKER_DEFAULT_PLATFORM=linux/amd64
export DOCKER_HOST="unix://$HOME/.rd/docker.sock"

# zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=white,underline"

# Claude
export CLAUDE_CONFIG_DIR="$HOME/.config/claude"

# ===================
# Settings
# ===================

set histignorespace # ignore command in history if it starts with space
unsetopt share_history # don't share history between sessions
setopt hist_ignore_dups # dont save duplicate entries in history
unsetopt beep # never beep
setopt completealiases # perform completions and then expand aliases
setopt hist_verify # ask for verification when recalling from history

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
bindkey '^F' fzf-file-widget
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

# https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke:
#   gcloud components install gke-gcloud-auth-plugin
if [ -d "$HOME/.local/share/mise/installs/gcloud/latest" ]; then
  source "$HOME/.local/share/mise/installs/gcloud/latest/completion.zsh.inc" # enable shell command completion for gcloud.
  source "$HOME/.local/share/mise/installs/gcloud/latest/path.zsh.inc" # add the Google Cloud SDK command line tools to your $PATH.
  export USE_GKE_GCLOUD_AUTH_PLUGIN=True
fi

# https://gist.github.com/ctechols/ca1035271ad134841284
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit;
else
  compinit -C;
fi;

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

typeset -A ZSH_HIGHLIGHT_STYLES
# To differentiate aliases from other command types
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
# To have paths colored instead of underlined
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
# To disable highlighting of globbing expressions
ZSH_HIGHLIGHT_STYLES[globbing]='none'

eval "$(starship init zsh)"
