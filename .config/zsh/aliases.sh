#!/usr/bin/env bash

# Tools, shortened
alias ls='eza --icons=automatic'
alias ll='ls -lahL'
alias d='docker'
alias dc='docker compose'
alias cat='bat'
alias k='kubectl'
alias v='nvim'
alias cl='claude'
alias clp='claude -p'
alias tf='terraform'
alias lg='lazygit'

# Commands, shortened
alias dr='docker run --rm -it'
alias dr-amd='dr --platform=linux/amd64'
alias de='docker exec -it'
alias gwr='source ~/bin/git-worktree-remove'
alias v-changed='nvim $(git dm --name-only)'
alias v-conflicts='nvim $(git diff --name-only --diff-filter=U)'
alias kk='k9s --kubeconfig=$HOME/.kube/contexts/$(ls $HOME/.kube/contexts | fzf)'
alias randomstring='openssl rand -base64 18'
alias cdd='cd $(find ~/code -maxdepth 4 -type d | sort -u | fzf)'
alias note='(cd /Users/mitch/code/github.com/mitchnielsen/notes && nvim .)'
alias rg='rg --ignore-file=$HOME/.config/ripgrep/.ignore'
alias python-venv='if [ ! -f ./.venv/bin/activate ]; then echo Creating virtualenv...; uv venv --python=3.13; fi; source .venv/bin/activate'
