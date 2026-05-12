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

# Caching helper + lazy-loaded integrations (fzf, direnv, mise, wt, thefuck,
# gcloud). See lazy.sh for details. Exposes `_cached_eval` for the starship
# init below, which must run after the syntax-highlighting plugins.
source "${HOME}/.config/zsh/lazy.sh"

# Load compinit early with -C (skip security checks) so gcloud doesn't re-init
autoload -Uz compinit && compinit -C -d "${ZDOTDIR:-$HOME}/.zcompdump"

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export GCLOUD_SOURCED=True

# Load completions, then map aliases
# source <(kubectl completion zsh)
# source <(docker completion zsh)
compdef g=git
compdef k=kubectl
compdef d=docker
compdef _load_gcloud_completion gcloud

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
