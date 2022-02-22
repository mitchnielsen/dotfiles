#!/usr/bin/env bash

# FZF
if [ ! -d '~/.fzf' ]; then (git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install); fi

# asdf
if [ ! -d '~/.asdf' ]; then git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0; fi
source "$HOME/.asdf/asdf.sh"

function asdf-install () {
  asdf plugin add $1
  asdf install $1 $2
  asdf global $1 $2
}

asdf-install awscli latest
asdf-install bat latest
asdf-install cfssl latest
asdf-install direnv latest
asdf-install dive latest
asdf-install helm '3.8.0'
asdf-install cfssl latest
asdf-install direnv latest
asdf-install dive latest
asdf-install fx latest
asdf-install helm '3.8.0'
asdf-install jq latest
asdf-install kubectl '1.23.3'
asdf-install k9s '0.25.18'
asdf-install kind '0.11.1'
asdf-install kubectx '0.9.4'
asdf-install kustomize '4.5.2'
asdf-install golang '1.16.14'
asdf-install dive '0.10.0'
asdf-install helm '3.8.0'
asdf-install dyff '1.4.5'
asdf-install ruby '2.7.5'
asdf-install stern latest
asdf-install yq latest

asdf reshim

# oh-my-zsh
if [ ! -d "~/.oh-my-zsh" ]; then sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; fi
if [ ! -d "~/.zsh/zsh-syntax-highlighting" ]; then git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting/; fi
if [ ! -d "~/.zsh/zsh-autosuggestions" ]; then git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions/; fi
if [ ! -d "~/.zsh/zsh-history-substring-search" ]; then git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.zsh/zsh-history-substring-search/; fi

# pure prompt
if [ ! -d "~/.zsh/pure" ]; then git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"; fi

## TMUX's TPM
if [ ! -d "~/.tmux/plugins/tpm" ]; then git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; fi

# Tmux's config (https://github.com/tmux/tmux/issues/142)
[ -f ~/.tmux.conf ] && rm ~/.tmux.conf
ln -s ~/dotfiles/guest/.config/tmux/.tmux.conf ~/.tmux.conf

# dotfiles
mkdir -p "$HOME/.config"
(cd "$HOME/dotfiles/guest" && stow -v --target="$HOME/.config" .config)
rm "$HOME/.zshrc" || true
ln -s "$HOME/dotfiles/guest/.zshrc" "$HOME/.zshrc"

# neovim
nvim --headless +"lua require'pluginList'; require'packer'.sync()" +15sleep +qa
mkdir -p "$HOME/go"
GOPATH="$HOME/go" nvim --headless +GoInstallBinaries +qa
